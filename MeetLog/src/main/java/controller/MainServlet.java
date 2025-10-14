package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Column;
import model.Restaurant;
import model.RestaurantRecommendation;
import model.Review; // Review 모델 임포트
import model.User;
import service.ColumnService;
import service.RecommendationService;
import service.RestaurantService;
import service.ReviewService;
import util.StringUtil;

public class MainServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RestaurantService restaurantService = new RestaurantService();
    private final ReviewService reviewService = new ReviewService();
    private final ColumnService columnService = new ColumnService();
    private final RecommendationService recommendationService = new RecommendationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. 맛집 랭킹 조회
            Map<String, Object> params = new HashMap<>();
            params.put("sortBy", "rating");
            params.put("limit", 10);
            params.put("offset", 0);
            List<Restaurant> topRestaurants = restaurantService.getPaginatedRestaurants(params);
            
            // 2. 생생한 최신 리뷰 조회
            int reviewLimit = 10;
            List<Review> recentReviews = reviewService.getRecentReviews(reviewLimit);
            
            // 3. 최신 칼럼 조회 (기존과 동일)
            List<Column> topColumns = columnService.getTopColumns(3);
            for (Column column : topColumns) {
                String summary = StringUtil.stripHtmlAndTruncate(column.getContent(), 80);
                column.setSummary(summary);
            }

            // 4. 개인화 추천
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            List<RestaurantRecommendation> personalizedRecommendations = new ArrayList<>();

            if (user != null) {
                try {
                    // 로그인한 사용자에게 하이브리드 추천 제공
                    personalizedRecommendations = recommendationService.getHybridRecommendations(user.getId(), 6);
                    System.out.println("사용자 " + user.getId() + "에게 추천 " + personalizedRecommendations.size() + "개 생성");
                } catch (Exception e) {
                    System.err.println("추천 생성 중 오류: " + e.getMessage());
                    e.printStackTrace();
                    // 오류 발생 시 인기 맛집으로 폴백
                    personalizedRecommendations = recommendationService.getFallbackRecommendations(6);
                }
            } else {
                // 로그인하지 않은 사용자에게 인기 맛집 추천
                try {
                    personalizedRecommendations = recommendationService.getFallbackRecommendations(6);
                    System.out.println("비로그인 사용자에게 인기 맛집 " + personalizedRecommendations.size() + "개 추천");
                } catch (Exception e) {
                    System.err.println("인기 맛집 조회 중 오류: " + e.getMessage());
                    e.printStackTrace();
                }
            }

            // JSP로 데이터 전달
            request.setAttribute("topRankedRestaurants", topRestaurants);
            request.setAttribute("recentReviews", recentReviews);
            request.setAttribute("latestColumns", topColumns);
            request.setAttribute("personalizedRecommendations", personalizedRecommendations);
            request.setAttribute("user", user);
            
            request.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "메인 페이지 로딩 중 오류가 발생했습니다.");
                request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
            }
        }
    }
}