package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import model.Restaurant;
import model.Review;
import service.RestaurantService;
import service.ReviewService;
import service.ReviewCommentService;
import util.MyBatisSqlSessionFactory;

@WebServlet("/business/review-management")
public class BusinessReviewManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            
            // 비즈니스 사용자의 음식점 목록 가져오기
            RestaurantService restaurantService = new RestaurantService();
            List<Restaurant> myRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            
                   // 최근 리뷰 가져오기
                   ReviewService reviewService = new ReviewService();
                   List<Review> reviews = reviewService.getRecentReviewsByOwnerId(user.getId(), 20);
                   
                   // 리뷰 통계 가져오기 (임시로 주석 처리)
                   // ReviewStatisticsService statisticsService = new ReviewStatisticsService();
                   // model.ReviewStatistics statistics = statisticsService.getReviewStatisticsByOwnerId(user.getId());
                   
                   // 각 리뷰의 답글 가져오기 (임시로 주석 처리)
                   // ReviewCommentService commentService = new ReviewCommentService();
                   // for (Review review : reviews) {
                   //     List<model.ReviewComment> comments = commentService.getCommentsByReviewId(review.getId());
                   //     review.setComments(comments);
                   // }
                   
                   request.setAttribute("myRestaurants", myRestaurants);
                   request.setAttribute("reviews", reviews);
                   // request.setAttribute("statistics", statistics);
            request.getRequestDispatcher("/WEB-INF/views/business/review-management-v2.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 관리 페이지를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}