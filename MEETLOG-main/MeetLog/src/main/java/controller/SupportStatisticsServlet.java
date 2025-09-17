package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/support-statistics")
public class SupportStatisticsServlet extends HttpServlet {
    
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
            
            // 고객 지원 통계 데이터
            SupportStatisticsData statisticsData = createSupportStatisticsData();
            request.setAttribute("statisticsData", statisticsData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-support-statistics.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 지원 통계를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private SupportStatisticsData createSupportStatisticsData() {
        SupportStatisticsData data = new SupportStatisticsData();
        
        // 전체 통계
        data.setTotalInquiries(1500);
        data.setResolvedInquiries(1350);
        data.setPendingInquiries(150);
        data.setAverageResolutionTime(4.2);
        data.setCustomerSatisfaction(4.5);
        
        // 월별 문의 현황
        List<MonthlyInquiry> monthlyInquiries = new ArrayList<>();
        
        MonthlyInquiry month1 = new MonthlyInquiry();
        month1.setMonth("2025-07");
        month1.setInquiries(120);
        month1.setResolved(110);
        month1.setPending(10);
        monthlyInquiries.add(month1);
        
        MonthlyInquiry month2 = new MonthlyInquiry();
        month2.setMonth("2025-08");
        month2.setInquiries(140);
        month2.setResolved(125);
        month2.setPending(15);
        monthlyInquiries.add(month2);
        
        MonthlyInquiry month3 = new MonthlyInquiry();
        month3.setMonth("2025-09");
        month3.setInquiries(160);
        month3.setResolved(145);
        month3.setPending(15);
        monthlyInquiries.add(month3);
        
        data.setMonthlyInquiries(monthlyInquiries);
        
        // 응답 시간 통계
        ResponseTimeStats responseTimeStats = new ResponseTimeStats();
        responseTimeStats.setAverageResponseTime(2.5);
        responseTimeStats.setFastestResponseTime(0.5);
        responseTimeStats.setSlowestResponseTime(8.0);
        responseTimeStats.setWithin24Hours(85.0);
        responseTimeStats.setWithin48Hours(95.0);
        data.setResponseTimeStats(responseTimeStats);
        
        // 고객 만족도 통계
        SatisfactionStats satisfactionStats = new SatisfactionStats();
        satisfactionStats.setVerySatisfied(60);
        satisfactionStats.setSatisfied(30);
        satisfactionStats.setNeutral(8);
        satisfactionStats.setDissatisfied(2);
        satisfactionStats.setVeryDissatisfied(0);
        data.setSatisfactionStats(satisfactionStats);
        
        return data;
    }
    
    // 고객 지원 통계 데이터 클래스
    public static class SupportStatisticsData {
        private int totalInquiries;
        private int resolvedInquiries;
        private int pendingInquiries;
        private double averageResolutionTime;
        private double customerSatisfaction;
        private List<MonthlyInquiry> monthlyInquiries;
        private ResponseTimeStats responseTimeStats;
        private SatisfactionStats satisfactionStats;
        
        // Getters and Setters
        public int getTotalInquiries() { return totalInquiries; }
        public void setTotalInquiries(int totalInquiries) { this.totalInquiries = totalInquiries; }
        public int getResolvedInquiries() { return resolvedInquiries; }
        public void setResolvedInquiries(int resolvedInquiries) { this.resolvedInquiries = resolvedInquiries; }
        public int getPendingInquiries() { return pendingInquiries; }
        public void setPendingInquiries(int pendingInquiries) { this.pendingInquiries = pendingInquiries; }
        public double getAverageResolutionTime() { return averageResolutionTime; }
        public void setAverageResolutionTime(double averageResolutionTime) { this.averageResolutionTime = averageResolutionTime; }
        public double getCustomerSatisfaction() { return customerSatisfaction; }
        public void setCustomerSatisfaction(double customerSatisfaction) { this.customerSatisfaction = customerSatisfaction; }
        public List<MonthlyInquiry> getMonthlyInquiries() { return monthlyInquiries; }
        public void setMonthlyInquiries(List<MonthlyInquiry> monthlyInquiries) { this.monthlyInquiries = monthlyInquiries; }
        public ResponseTimeStats getResponseTimeStats() { return responseTimeStats; }
        public void setResponseTimeStats(ResponseTimeStats responseTimeStats) { this.responseTimeStats = responseTimeStats; }
        public SatisfactionStats getSatisfactionStats() { return satisfactionStats; }
        public void setSatisfactionStats(SatisfactionStats satisfactionStats) { this.satisfactionStats = satisfactionStats; }
    }
    
    // 월별 문의 클래스
    public static class MonthlyInquiry {
        private String month;
        private int inquiries;
        private int resolved;
        private int pending;
        
        // Getters and Setters
        public String getMonth() { return month; }
        public void setMonth(String month) { this.month = month; }
        public int getInquiries() { return inquiries; }
        public void setInquiries(int inquiries) { this.inquiries = inquiries; }
        public int getResolved() { return resolved; }
        public void setResolved(int resolved) { this.resolved = resolved; }
        public int getPending() { return pending; }
        public void setPending(int pending) { this.pending = pending; }
    }
    
    // 응답 시간 통계 클래스
    public static class ResponseTimeStats {
        private double averageResponseTime;
        private double fastestResponseTime;
        private double slowestResponseTime;
        private double within24Hours;
        private double within48Hours;
        
        // Getters and Setters
        public double getAverageResponseTime() { return averageResponseTime; }
        public void setAverageResponseTime(double averageResponseTime) { this.averageResponseTime = averageResponseTime; }
        public double getFastestResponseTime() { return fastestResponseTime; }
        public void setFastestResponseTime(double fastestResponseTime) { this.fastestResponseTime = fastestResponseTime; }
        public double getSlowestResponseTime() { return slowestResponseTime; }
        public void setSlowestResponseTime(double slowestResponseTime) { this.slowestResponseTime = slowestResponseTime; }
        public double getWithin24Hours() { return within24Hours; }
        public void setWithin24Hours(double within24Hours) { this.within24Hours = within24Hours; }
        public double getWithin48Hours() { return within48Hours; }
        public void setWithin48Hours(double within48Hours) { this.within48Hours = within48Hours; }
    }
    
    // 만족도 통계 클래스
    public static class SatisfactionStats {
        private int verySatisfied;
        private int satisfied;
        private int neutral;
        private int dissatisfied;
        private int veryDissatisfied;
        
        // Getters and Setters
        public int getVerySatisfied() { return verySatisfied; }
        public void setVerySatisfied(int verySatisfied) { this.verySatisfied = verySatisfied; }
        public int getSatisfied() { return satisfied; }
        public void setSatisfied(int satisfied) { this.satisfied = satisfied; }
        public int getNeutral() { return neutral; }
        public void setNeutral(int neutral) { this.neutral = neutral; }
        public int getDissatisfied() { return dissatisfied; }
        public void setDissatisfied(int dissatisfied) { this.dissatisfied = dissatisfied; }
        public int getVeryDissatisfied() { return veryDissatisfied; }
        public void setVeryDissatisfied(int veryDissatisfied) { this.veryDissatisfied = veryDissatisfied; }
    }
}
