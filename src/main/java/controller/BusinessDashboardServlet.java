package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
<<<<<<< HEAD

import model.Restaurant;
import model.Review;
import model.User;
import service.RestaurantService;
import service.ReviewService;
import service.ReservationService;

@WebServlet("/business/dashboard")
public class BusinessDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private ReviewService reviewService = new ReviewService();
    private ReservationService reservationService = new ReservationService();

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

=======
import java.io.IOException;
import java.util.List;
import model.User;
import model.Restaurant;
import model.Review;
import service.RestaurantService;
import service.ReviewService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/dashboard")
public class BusinessDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        SqlSession sqlSession = null;
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
        try {
            // 사업자의 음식점 목록 가져오기
            List<Restaurant> myRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            
            // 통계 데이터 계산
            int restaurantCount = myRestaurants.size();
            int totalReviews = 0;
            int totalReservations = 0;
            double totalRating = 0.0;
            
            for (Restaurant restaurant : myRestaurants) {
                totalReviews += restaurant.getReviewCount();
                totalRating += restaurant.getRating() * restaurant.getReviewCount();
            }
            
<<<<<<< HEAD
            double averageRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;
            
            // 최근 리뷰 가져오기 (최대 5개)
            List<Review> recentReviews = reviewService.getRecentReviewsByOwnerId(user.getId(), 5);
=======
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            
            // 비즈니스 사용자의 음식점 목록 가져오기
            RestaurantService restaurantService = new RestaurantService();
            List<Restaurant> myRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            
            // 비즈니스 대시보드 데이터 생성
            BusinessDashboardData dashboardData = createBusinessDashboardData(myRestaurants);
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("myRestaurants", myRestaurants);
            
            // 최근 리뷰 가져오기
            ReviewService reviewService = new ReviewService();
            List<Review> recentReviews = reviewService.getRecentReviewsByOwnerId(user.getId(), 5);
            request.setAttribute("recentReviews", recentReviews);
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
            
            // 데이터를 JSP로 전달
            request.setAttribute("myRestaurants", myRestaurants);
            request.setAttribute("restaurantCount", restaurantCount);
            request.setAttribute("reviewCount", totalReviews);
            request.setAttribute("averageRating", String.format("%.1f", averageRating));
            request.setAttribute("reservationCount", totalReservations);
            request.setAttribute("recentReviews", recentReviews);
            
            // 비즈니스 대시보드 페이지로 포워딩
            request.getRequestDispatcher("/WEB-INF/views/business-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
<<<<<<< HEAD
            request.setAttribute("errorMessage", "대시보드 데이터를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-dashboard.jsp").forward(request, response);
        }
    }
}
=======
            request.setAttribute("errorMessage", "대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
    
    private BusinessDashboardData createBusinessDashboardData(List<Restaurant> myRestaurants) {
        BusinessDashboardData data = new BusinessDashboardData();
        
        // 비즈니스 통계 데이터 계산
        int totalRestaurants = myRestaurants.size();
        int totalReviews = 0;
        double totalRating = 0.0;
        int totalReservations = 0;
        
        for (Restaurant restaurant : myRestaurants) {
            totalReviews += restaurant.getReviewCount();
            totalRating += restaurant.getRating() * restaurant.getReviewCount();
            // 예약 수는 추후 구현
        }
        
        double averageRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;
        
        data.setTotalRestaurants(totalRestaurants);
        data.setTotalReviews(totalReviews);
        data.setAverageRating(Math.round(averageRating * 10.0) / 10.0);
        data.setTotalReservations(totalReservations);
        
        return data;
    }
    
    // 비즈니스 대시보드 데이터 클래스
    public static class BusinessDashboardData {
        private int totalRestaurants;
        private int totalReservations;
        private int totalReviews;
        private double averageRating;
        
        // Getters and Setters
        public int getTotalRestaurants() { return totalRestaurants; }
        public void setTotalRestaurants(int totalRestaurants) { this.totalRestaurants = totalRestaurants; }
        public int getTotalReservations() { return totalReservations; }
        public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }
        public int getTotalReviews() { return totalReviews; }
        public void setTotalReviews(int totalReviews) { this.totalReviews = totalReviews; }
        public double getAverageRating() { return averageRating; }
        public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
    }
}
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
