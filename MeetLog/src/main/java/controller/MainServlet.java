package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap; 
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import model.Column;
import model.Restaurant;
import model.RestaurantRecommendation;
import model.ReviewInfo;
import model.User;
import service.ColumnService;
import service.RecommendationService;
import service.RestaurantService;
import service.ReviewService;
import javax.servlet.http.HttpSession;

public class MainServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private ReviewService reviewService = new ReviewService();
    private ColumnService columnService = new ColumnService();
    private RecommendationService recommendationService = new RecommendationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ServletContext application = getServletContext();
            long currentTime = System.currentTimeMillis();

         // 1. 맛집 랭킹 (5분 캐시)
            List<Restaurant> topRestaurants = (List<Restaurant>) application.getAttribute("topRankedRestaurants");
            Long lastUpdateTopRestaurants = (Long) application.getAttribute("lastUpdateTopRestaurants");
            if (topRestaurants == null || lastUpdateTopRestaurants == null || (currentTime - lastUpdateTopRestaurants > 5 * 60 * 1000)) {
                // [수정] 새로운 페이징/필터 메소드를 사용하도록 변경
                Map<String, Object> params = new HashMap<>();
                params.put("sortBy", "rating"); // 평점순으로 정렬
                params.put("limit", 10);        // 10개만 가져오기
                params.put("offset", 0);        // 첫 페이지부터
                topRestaurants = restaurantService.getPaginatedRestaurants(params);

                application.setAttribute("topRankedRestaurants", topRestaurants);
                application.setAttribute("lastUpdateTopRestaurants", currentTime);
            }

            // 2. 최신 리뷰 (1분 캐시)
            List<ReviewInfo> recentReviews = (List<ReviewInfo>) application.getAttribute("hotReviews");
            Long lastUpdateRecentReviews = (Long) application.getAttribute("lastUpdateRecentReviews");
            if (recentReviews == null || lastUpdateRecentReviews == null || (currentTime - lastUpdateRecentReviews > 1 * 60 * 1000)) {
                recentReviews = reviewService.getRecentReviewsWithInfo(3); // 3개만 가져오도록 수정
                application.setAttribute("hotReviews", recentReviews);
                application.setAttribute("lastUpdateRecentReviews", currentTime);
            }

            // 3. 최신 칼럼 (10분 캐시)
            List<Column> topColumns = (List<Column>) application.getAttribute("latestColumns");
            Long lastUpdateTopColumns = (Long) application.getAttribute("lastUpdateTopColumns");
            if (topColumns == null || lastUpdateTopColumns == null || (currentTime - lastUpdateTopColumns > 10 * 60 * 1000)) {
                topColumns = columnService.getTopColumns(3);
                application.setAttribute("latestColumns", topColumns);
                application.setAttribute("lastUpdateTopColumns", currentTime);
            }

            // 4. 개인화 추천 (로그인한 사용자만, 30분 캐시)
            List<RestaurantRecommendation> personalizedRecommendations = null;
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            // 개인화 추천 (임시로 비활성화)
            personalizedRecommendations = new ArrayList<>();
            System.out.println("추천 시스템이 임시로 비활성화되었습니다.");

            // JSP로 데이터 전달 (JSP에서 사용할 이름과 정확히 일치시킴)
            request.setAttribute("topRankedRestaurants", topRestaurants);
            request.setAttribute("hotReviews", recentReviews);
            request.setAttribute("latestColumns", topColumns);
            request.setAttribute("personalizedRecommendations", personalizedRecommendations);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // 응답이 이미 커밋되었는지 확인
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "메인 페이지 로딩 중 오류가 발생했습니다.");
                try {
                    request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다.");
                }
            } else {
                // 응답이 이미 커밋된 경우 에러 로그만 출력
                System.err.println("응답이 이미 커밋되어 에러 페이지로 이동할 수 없습니다: " + e.getMessage());
            }
        }
    }
}