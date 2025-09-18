package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import model.User;


public class ReviewManagementServlet extends HttpServlet {
    
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
            
            // 비즈니스 사용자가 음식점과 연결되어 있는지 확인
            if (user.getRestaurantId() == null) {
                response.sendRedirect(request.getContextPath() + "/business/register");
                return;
            }
            
            List<Review> reviews = createSampleReviews();
            request.setAttribute("reviews", reviews);
            
            request.getRequestDispatcher("/WEB-INF/views/business-review-management.jsp").forward(request, response);
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
        review1.setCustomerName("김리뷰");
        review1.setRestaurantName("고미정");
        review1.setContent("정말 맛있어요! 서비스도 친절하고 분위기도 좋았습니다.");
        review1.setRating(5);
        review1.setCreatedAt("2025.09.14 20:30");
        reviews.add(review1);
        
        Review review2 = new Review();
        review2.setId(2);
        review2.setCustomerName("이고객");
        review2.setRestaurantName("고미정");
        review2.setContent("가격 대비 훌륭한 맛이었습니다. 다음에 또 방문하고 싶어요.");
        review2.setRating(4);
        review2.setCreatedAt("2025.09.13 18:45");
        reviews.add(review2);
        
        Review review3 = new Review();
        review3.setId(3);
        review3.setCustomerName("박손님");
        review3.setRestaurantName("고미정");
        review3.setContent("분위기가 정말 좋아요. 데이트하기에 완벽한 곳이었습니다.");
        review3.setRating(5);
        review3.setCreatedAt("2025.09.12 19:15");
        reviews.add(review3);
        
        return reviews;
    }
    
    public static class Review {
        private int id;
        private String customerName;
        private String restaurantName;
        private String content;
        private int rating;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
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
