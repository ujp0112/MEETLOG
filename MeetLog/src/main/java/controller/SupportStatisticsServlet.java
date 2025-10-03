package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.Duration;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import service.InquiryService;
import model.Inquiry;
import util.AdminSessionUtils;


public class SupportStatisticsServlet extends HttpServlet {

    private final InquiryService inquiryService = new InquiryService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }
            
            // 고객 지원 통계 데이터
            SupportStatisticsData statisticsData = createSupportStatisticsData();
            request.setAttribute("statisticsData", statisticsData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-support-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 지원 통계를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private SupportStatisticsData createSupportStatisticsData() {
        SupportStatisticsData data = new SupportStatisticsData();

        List<Inquiry> inquiries = inquiryService.getAllInquiries();
        int total = inquiries != null ? inquiries.size() : 0;
        int resolved = inquiryService.getInquiryCountByStatus("RESOLVED");
        int pending = inquiryService.getInquiryCountByStatus("PENDING");
        int inProgress = inquiryService.getInquiryCountByStatus("IN_PROGRESS");

        data.setTotalInquiries(total);
        data.setResolvedInquiries(resolved);
        data.setPendingInquiries(pending + inProgress);

        List<Double> responseHours = new ArrayList<>();
        if (inquiries != null) {
            inquiries.stream()
                    .filter(inquiry -> inquiry.getReply() != null && inquiry.getCreatedAt() != null && inquiry.getUpdatedAt() != null)
                    .forEach(inquiry -> {
                        double hours = Duration
                                .between(inquiry.getCreatedAt().toLocalDateTime(), inquiry.getUpdatedAt().toLocalDateTime())
                                .toMinutes() / 60.0;
                        responseHours.add(hours);
                    });
        }

        double averageResolution = responseHours.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
        double fastest = responseHours.stream().mapToDouble(Double::doubleValue).min().orElse(0.0);
        double slowest = responseHours.stream().mapToDouble(Double::doubleValue).max().orElse(0.0);
        double within24 = responseHours.isEmpty() ? 0.0 : responseHours.stream().filter(value -> value <= 24.0).count() * 100.0 / responseHours.size();
        double within48 = responseHours.isEmpty() ? 0.0 : responseHours.stream().filter(value -> value <= 48.0).count() * 100.0 / responseHours.size();

        data.setAverageResolutionTime(Math.round(averageResolution * 10.0) / 10.0);
        data.setCustomerSatisfaction(0.0);

        Map<String, MonthlyInquiry> monthlyMap = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        if (inquiries != null) {
            for (Inquiry inquiry : inquiries) {
                if (inquiry.getCreatedAt() == null) {
                    continue;
                }
                String month = inquiry.getCreatedAt().toLocalDateTime().format(formatter);
                MonthlyInquiry monthly = monthlyMap.computeIfAbsent(month, key -> {
                    MonthlyInquiry item = new MonthlyInquiry();
                    item.setMonth(key);
                    item.setInquiries(0);
                    item.setResolved(0);
                    item.setPending(0);
                    return item;
                });
                monthly.setInquiries(monthly.getInquiries() + 1);
                if ("RESOLVED".equalsIgnoreCase(inquiry.getStatus())) {
                    monthly.setResolved(monthly.getResolved() + 1);
                } else {
                    monthly.setPending(monthly.getPending() + 1);
                }
            }
        }
        List<MonthlyInquiry> monthlyInquiries = new ArrayList<>(monthlyMap.values());
        monthlyInquiries.sort(Comparator.comparing(MonthlyInquiry::getMonth).reversed());
        data.setMonthlyInquiries(monthlyInquiries);

        ResponseTimeStats responseStats = new ResponseTimeStats();
        responseStats.setAverageResponseTime(Math.round(averageResolution * 10.0) / 10.0);
        responseStats.setFastestResponseTime(Math.round(fastest * 10.0) / 10.0);
        responseStats.setSlowestResponseTime(Math.round(slowest * 10.0) / 10.0);
        responseStats.setWithin24Hours(Math.round(within24 * 10.0) / 10.0);
        responseStats.setWithin48Hours(Math.round(within48 * 10.0) / 10.0);
        data.setResponseTimeStats(responseStats);

        SatisfactionStats satisfactionStats = new SatisfactionStats();
        satisfactionStats.setVerySatisfied(0);
        satisfactionStats.setSatisfied(resolved);
        satisfactionStats.setNeutral(inProgress);
        satisfactionStats.setDissatisfied(pending);
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
