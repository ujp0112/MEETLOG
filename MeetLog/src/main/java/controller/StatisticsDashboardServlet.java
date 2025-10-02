package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import util.AdminSessionUtils;


public class StatisticsDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }
            
            StatisticsData statisticsData = createStatisticsData();
            request.setAttribute("statisticsData", statisticsData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-statistics-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "통계 대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private StatisticsData createStatisticsData() {
        StatisticsData data = new StatisticsData();
        
        data.setTotalUsers(1250);
        data.setTotalRestaurants(45);
        data.setTotalReservations(3200);
        data.setTotalReviews(890);
        data.setAverageRating(4.3);
        
        List<DailyStats> dailyStats = new ArrayList<>();
        
        DailyStats day1 = new DailyStats();
        day1.setDate("2025-09-14");
        day1.setReservations(25);
        day1.setReviews(12);
        dailyStats.add(day1);
        
        data.setDailyStats(dailyStats);
        
        return data;
    }
    
    public static class StatisticsData {
        private int totalUsers;
        private int totalRestaurants;
        private int totalReservations;
        private int totalReviews;
        private double averageRating;
        private List<DailyStats> dailyStats;
        
        // Getters and Setters
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        public int getTotalRestaurants() { return totalRestaurants; }
        public void setTotalRestaurants(int totalRestaurants) { this.totalRestaurants = totalRestaurants; }
        public int getTotalReservations() { return totalReservations; }
        public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }
        public int getTotalReviews() { return totalReviews; }
        public void setTotalReviews(int totalReviews) { this.totalReviews = totalReviews; }
        public double getAverageRating() { return averageRating; }
        public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
        public List<DailyStats> getDailyStats() { return dailyStats; }
        public void setDailyStats(List<DailyStats> dailyStats) { this.dailyStats = dailyStats; }
    }
    
    public static class DailyStats {
        private String date;
        private int reservations;
        private int reviews;
        
        // Getters and Setters
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public int getReservations() { return reservations; }
        public void setReservations(int reservations) { this.reservations = reservations; }
        public int getReviews() { return reviews; }
        public void setReviews(int reviews) { this.reviews = reviews; }
    }
}
