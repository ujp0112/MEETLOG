package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import util.AdminSessionUtils;


public class BranchStatisticsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }
            
            // 지점 통계 데이터
            BranchStatisticsData statisticsData = createBranchStatisticsData();
            request.setAttribute("statisticsData", statisticsData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-branch-statistics.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "지점 통계를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private BranchStatisticsData createBranchStatisticsData() {
        BranchStatisticsData data = new BranchStatisticsData();
        
        // 전체 통계
        data.setTotalBranches(3);
        data.setActiveBranches(2);
        data.setTotalEmployees(27);
        data.setTotalRevenue(85000000);
        data.setAverageRevenuePerBranch(42500000);
        
        // 지점별 성과
        List<BranchPerformance> branchPerformances = new ArrayList<>();
        
        BranchPerformance branch1 = new BranchPerformance();
        branch1.setBranchName("강남점");
        branch1.setRevenue(50000000);
        branch1.setEmployeeCount(15);
        branch1.setCustomerCount(1200);
        branch1.setReservationCount(350);
        branch1.setRating(4.5);
        branchPerformances.add(branch1);

        BranchPerformance branch2 = new BranchPerformance();
        branch2.setBranchName("홍대점");
        branch2.setRevenue(35000000);
        branch2.setEmployeeCount(12);
        branch2.setCustomerCount(800);
        branch2.setReservationCount(220);
        branch2.setRating(4.2);
        branchPerformances.add(branch2);
        
        data.setBranchPerformances(branchPerformances);
        
        return data;
    }
    
    // 지점 통계 데이터 클래스
    public static class BranchStatisticsData {
        private int totalBranches;
        private int activeBranches;
        private int totalEmployees;
        private int totalRevenue;
        private int averageRevenuePerBranch;
        private List<BranchPerformance> branchPerformances;
        
        // Getters and Setters
        public int getTotalBranches() { return totalBranches; }
        public void setTotalBranches(int totalBranches) { this.totalBranches = totalBranches; }
        public int getActiveBranches() { return activeBranches; }
        public void setActiveBranches(int activeBranches) { this.activeBranches = activeBranches; }
        public int getTotalEmployees() { return totalEmployees; }
        public void setTotalEmployees(int totalEmployees) { this.totalEmployees = totalEmployees; }
        public int getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(int totalRevenue) { this.totalRevenue = totalRevenue; }
        public int getAverageRevenuePerBranch() { return averageRevenuePerBranch; }
        public void setAverageRevenuePerBranch(int averageRevenuePerBranch) { this.averageRevenuePerBranch = averageRevenuePerBranch; }
        public List<BranchPerformance> getBranchPerformances() { return branchPerformances; }
        public void setBranchPerformances(List<BranchPerformance> branchPerformances) { this.branchPerformances = branchPerformances; }
    }
    
    // 지점 성과 클래스
    public static class BranchPerformance {
        private String branchName;
        private int revenue;
        private int employeeCount;
        private int customerCount;
        private int reservationCount;
        private double rating;

        // Getters and Setters
        public String getBranchName() { return branchName; }
        public void setBranchName(String branchName) { this.branchName = branchName; }
        public int getRevenue() { return revenue; }
        public void setRevenue(int revenue) { this.revenue = revenue; }
        public int getEmployeeCount() { return employeeCount; }
        public void setEmployeeCount(int employeeCount) { this.employeeCount = employeeCount; }
        public int getCustomerCount() { return customerCount; }
        public void setCustomerCount(int customerCount) { this.customerCount = customerCount; }
        public int getReservationCount() { return reservationCount; }
        public void setReservationCount(int reservationCount) { this.reservationCount = reservationCount; }
        public double getRating() { return rating; }
        public void setRating(double rating) { this.rating = rating; }
    }
}
