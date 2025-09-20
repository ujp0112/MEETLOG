package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Restaurant;
import model.Review;
import model.User;
import service.RestaurantService;
import service.ReviewService;

@WebServlet("/business/dashboard")
public class BusinessDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"BUSINESS".equals(user.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }

        try {
            // 사업자의 음식점 목록 조회
            List<Restaurant> myRestaurants = restaurantService.findByOwnerId(user.getId());
            
            // 통계 데이터 계산
            int restaurantCount = myRestaurants.size();
            int reviewCount = 0;
            double averageRating = 0.0;
            
            // 각 음식점의 리뷰 수와 평점 계산
            for (Restaurant restaurant : myRestaurants) {
                List<Review> reviews = reviewService.getReviewsByRestaurantId(restaurant.getId());
                reviewCount += reviews.size();
                
                if (!reviews.isEmpty()) {
                    double totalRating = 0.0;
                    for (Review review : reviews) {
                        totalRating += review.getRating();
                    }
                    averageRating += totalRating / reviews.size();
                }
            }
            
            if (restaurantCount > 0) {
                averageRating = averageRating / restaurantCount;
            }
            
            // 최근 리뷰 조회 (최대 5개)
            List<Review> recentReviews = reviewService.getRecentReviewsByOwnerId(user.getId(), 5);
            
            // 요청 속성 설정
            request.setAttribute("myRestaurants", myRestaurants);
            request.setAttribute("restaurantCount", restaurantCount);
            request.setAttribute("reviewCount", reviewCount);
            request.setAttribute("averageRating", String.format("%.1f", averageRating));
            request.setAttribute("recentReviews", recentReviews);
            
            // JSP로 포워드
            request.getRequestDispatcher("/WEB-INF/views/business-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "대시보드 로딩 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST 요청도 GET과 동일하게 처리
        doGet(request, response);
    }
}