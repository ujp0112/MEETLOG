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
import model.ReviewInfo;
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

            // 2. 최신 리뷰 조회
            List<ReviewInfo> recentReviews = reviewService.getRecentReviewsWithInfo(3);

            // 3. 인기 칼럼 조회 및 요약 생성
            List<Column> topColumns = columnService.getTopColumns(3);
            for (Column column : topColumns) {
                String summary = StringUtil.stripHtmlAndTruncate(column.getContent(), 80); // 80자로 제한
                column.setSummary(summary);
            }

            // 4. 개인화 추천 (로그인한 사용자만)
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            // 개인화 추천 시스템은 현재 임시로 비활성화
            List<RestaurantRecommendation> personalizedRecommendations = new ArrayList<>();
            System.out.println("추천 시스템이 임시로 비활성화되었습니다.");

            // JSP로 데이터 전달
            request.setAttribute("topRankedRestaurants", topRestaurants);
            request.setAttribute("hotReviews", recentReviews);
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