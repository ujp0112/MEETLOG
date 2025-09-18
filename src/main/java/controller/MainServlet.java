package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
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

@WebServlet("/main")
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
                topRestaurants = restaurantService.getTopRestaurants(10);
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
            
            if (user != null) {
                String cacheKey = "personalizedRecommendations_" + user.getId();
                personalizedRecommendations = (List<RestaurantRecommendation>) application.getAttribute(cacheKey);
                Long lastUpdatePersonalized = (Long) application.getAttribute(cacheKey + "_time");
                
                if (personalizedRecommendations == null || lastUpdatePersonalized == null || 
                    (currentTime - lastUpdatePersonalized > 30 * 60 * 1000)) {
                    try {
                        // 사용자 취향 분석 (백그라운드에서 실행)
                        recommendationService.analyzeUserPreferences(user.getId());
                        
                        // 개인화 추천 실행
                        personalizedRecommendations = recommendationService.getHybridRecommendations(user.getId(), 6);
                        application.setAttribute(cacheKey, personalizedRecommendations);
                        application.setAttribute(cacheKey + "_time", currentTime);
                    } catch (Exception e) {
                        e.printStackTrace();
                        // 추천 실패 시 인기 맛집으로 대체
                        personalizedRecommendations = recommendationService.getFallbackRecommendations(6);
                    }
                }
            }

            // JSP로 데이터 전달 (JSP에서 사용할 이름과 정확히 일치시킴)
            request.setAttribute("topRankedRestaurants", topRestaurants);
            request.setAttribute("hotReviews", recentReviews);
            request.setAttribute("latestColumns", topColumns);
            request.setAttribute("personalizedRecommendations", personalizedRecommendations);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메인 페이지 로딩 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}