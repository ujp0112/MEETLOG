package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import util.AdminSessionUtils;


public class RevenueAnalysisServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }
            
            RevenueData revenueData = createRevenueData();
            request.setAttribute("revenueData", revenueData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-revenue-analysis.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "매출 분석을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private RevenueData createRevenueData() {
        RevenueData data = new RevenueData();
        
        data.setTotalRevenue(100000000);
        data.setMonthlyRevenue(85000000);
        data.setDailyRevenue(2800000);
        data.setGrowthRate(15.5);
        
        List<MonthlyRevenue> monthlyRevenues = new ArrayList<>();
        
        MonthlyRevenue month1 = new MonthlyRevenue();
        month1.setMonth("2025-08");
        month1.setRevenue(75000000);
        monthlyRevenues.add(month1);
        
        MonthlyRevenue month2 = new MonthlyRevenue();
        month2.setMonth("2025-09");
        month2.setRevenue(85000000);
        monthlyRevenues.add(month2);
        
        data.setMonthlyRevenues(monthlyRevenues);
        
        return data;
    }
    
    public static class RevenueData {
        private long totalRevenue;
        private long monthlyRevenue;
        private long dailyRevenue;
        private double growthRate;
        private List<MonthlyRevenue> monthlyRevenues;
        
        // Getters and Setters
        public long getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(long totalRevenue) { this.totalRevenue = totalRevenue; }
        public long getMonthlyRevenue() { return monthlyRevenue; }
        public void setMonthlyRevenue(long monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }
        public long getDailyRevenue() { return dailyRevenue; }
        public void setDailyRevenue(long dailyRevenue) { this.dailyRevenue = dailyRevenue; }
        public double getGrowthRate() { return growthRate; }
        public void setGrowthRate(double growthRate) { this.growthRate = growthRate; }
        public List<MonthlyRevenue> getMonthlyRevenues() { return monthlyRevenues; }
        public void setMonthlyRevenues(List<MonthlyRevenue> monthlyRevenues) { this.monthlyRevenues = monthlyRevenues; }
    }
    
    public static class MonthlyRevenue {
        private String month;
        private long revenue;
        
        // Getters and Setters
        public String getMonth() { return month; }
        public void setMonth(String month) { this.month = month; }
        public long getRevenue() { return revenue; }
        public void setRevenue(long revenue) { this.revenue = revenue; }
    }
}
