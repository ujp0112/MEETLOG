package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

public class BusinessDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String userType = (String) session.getAttribute("userType");
            
            if (userId == null || !"BUSINESS".equals(userType)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // 비즈니스 대시보드 데이터
            BusinessDashboardData dashboardData = createBusinessDashboardData();
            request.setAttribute("dashboardData", dashboardData);
            
            request.getRequestDispatcher("/WEB-INF/views/business-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private BusinessDashboardData createBusinessDashboardData() {
        BusinessDashboardData data = new BusinessDashboardData();
        
        // 비즈니스 통계 데이터
        data.setRestaurantName("고미정");
        data.setTotalReservations(45);
        data.setTodayReservations(8);
        data.setTotalReviews(25);
        data.setAverageRating(4.5);
        data.setMonthlyRevenue(2500000);
        
        // 최근 예약 목록
        List<Reservation> recentReservations = new ArrayList<>();
        
        Reservation reservation1 = new Reservation();
        reservation1.setId(1);
        reservation1.setCustomerName("김고객");
        reservation1.setReservationTime("2025-09-15 19:00");
        reservation1.setPartySize(4);
        reservation1.setStatus("CONFIRMED");
        recentReservations.add(reservation1);
        
        Reservation reservation2 = new Reservation();
        reservation2.setId(2);
        reservation2.setCustomerName("이고객");
        reservation2.setReservationTime("2025-09-15 20:30");
        reservation2.setPartySize(2);
        reservation2.setStatus("PENDING");
        recentReservations.add(reservation2);
        
        data.setRecentReservations(recentReservations);
        
        // 최근 리뷰 목록
        List<Review> recentReviews = new ArrayList<>();
        
        Review review1 = new Review();
        review1.setId(1);
        review1.setCustomerName("김고객");
        review1.setRating(5);
        review1.setContent("정말 맛있었어요! 서비스도 친절하고 분위기도 좋았습니다.");
        review1.setCreatedAt("2025.09.18 20:30");
        recentReviews.add(review1);
        
        Review review2 = new Review();
        review2.setId(2);
        review2.setCustomerName("이고객");
        review2.setRating(4);
        review2.setContent("가격 대비 훌륭한 맛이었습니다. 다음에 또 방문하고 싶어요.");
        review2.setCreatedAt("2025.09.17 18:45");
        recentReviews.add(review2);
        
        data.setRecentReviews(recentReviews);
        
        return data;
    }
    
    // 비즈니스 대시보드 데이터 클래스
    public static class BusinessDashboardData {
        private String restaurantName;
        private int totalReservations;
        private int todayReservations;
        private int totalReviews;
        private double averageRating;
        private int monthlyRevenue;
        private List<Reservation> recentReservations;
        private List<Review> recentReviews;
        
        // Getters and Setters
        public String getRestaurantName() { return restaurantName; }
        public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
        public int getTotalReservations() { return totalReservations; }
        public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }
        public int getTodayReservations() { return todayReservations; }
        public void setTodayReservations(int todayReservations) { this.todayReservations = todayReservations; }
        public int getTotalReviews() { return totalReviews; }
        public void setTotalReviews(int totalReviews) { this.totalReviews = totalReviews; }
        public double getAverageRating() { return averageRating; }
        public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
        public int getMonthlyRevenue() { return monthlyRevenue; }
        public void setMonthlyRevenue(int monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }
        public List<Reservation> getRecentReservations() { return recentReservations; }
        public void setRecentReservations(List<Reservation> recentReservations) { this.recentReservations = recentReservations; }
        public List<Review> getRecentReviews() { return recentReviews; }
        public void setRecentReviews(List<Review> recentReviews) { this.recentReviews = recentReviews; }
    }
    
    // 예약 클래스
    public static class Reservation {
        private int id;
        private String customerName;
        private String reservationTime;
        private int partySize;
        private String status;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
        public String getReservationTime() { return reservationTime; }
        public void setReservationTime(String reservationTime) { this.reservationTime = reservationTime; }
        public int getPartySize() { return partySize; }
        public void setPartySize(int partySize) { this.partySize = partySize; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
    
    // 리뷰 클래스
    public static class Review {
        private int id;
        private String customerName;
        private int rating;
        private String content;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}
