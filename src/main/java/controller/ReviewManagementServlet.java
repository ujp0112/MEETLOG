package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class ReviewManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            
            List<Review> reviews = createSampleReviews();
            request.setAttribute("reviews", reviews);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-review-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Review> createSampleReviews() {
        List<Review> reviews = new ArrayList<>();
        
        Review review1 = new Review();
        review1.setId(1);
        review1.setUserName("김리뷰");
        review1.setRestaurantName("고미정");
        review1.setContent("정말 맛있어요!");
        review1.setRating(5);
        review1.setCreatedAt("2025-09-14");
        reviews.add(review1);
        
        return reviews;
    }
    
    public static class Review {
        private int id;
        private String userName;
        private String restaurantName;
        private String content;
        private int rating;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getRestaurantName() { return restaurantName; }
        public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}
