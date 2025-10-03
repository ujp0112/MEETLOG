package controller;

import model.Inquiry;
import service.InquiryService;
import util.AdminSessionUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class SupportDashboardServlet extends HttpServlet {

    private final InquiryService inquiryService = new InquiryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            SupportDashboardData dashboardData = createSupportDashboardData();
            request.setAttribute("dashboardData", dashboardData);

            request.getRequestDispatcher("/WEB-INF/views/admin-support-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 지원 대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    private SupportDashboardData createSupportDashboardData() {
        SupportDashboardData data = new SupportDashboardData();

        List<Inquiry> inquiries = inquiryService.getAllInquiries();
        int total = inquiries != null ? inquiries.size() : 0;
        int pending = inquiryService.getInquiryCountByStatus("PENDING");
        int inProgress = inquiryService.getInquiryCountByStatus("IN_PROGRESS");
        int resolved = inquiryService.getInquiryCountByStatus("RESOLVED");

        data.setTotalInquiries(total);
        data.setPendingInquiries(pending + inProgress);
        data.setResolvedInquiries(resolved);

        double avgHours = 0.0;
        if (inquiries != null) {
            long resolvedCount = inquiries.stream()
                    .filter(inquiry -> inquiry.getReply() != null && inquiry.getCreatedAt() != null && inquiry.getUpdatedAt() != null)
                    .count();
            if (resolvedCount > 0) {
                long totalMinutes = inquiries.stream()
                        .filter(inquiry -> inquiry.getReply() != null && inquiry.getCreatedAt() != null && inquiry.getUpdatedAt() != null)
                        .mapToLong(inquiry -> Duration
                                .between(inquiry.getCreatedAt().toLocalDateTime(), inquiry.getUpdatedAt().toLocalDateTime())
                                .toMinutes())
                        .sum();
                avgHours = totalMinutes / (double) resolvedCount / 60.0;
            }
        }
        data.setAverageResponseTime(Math.round(avgHours * 10.0) / 10.0);
        data.setCustomerSatisfaction(4.2);

        List<InquiryCategory> categories = new ArrayList<>();
        if (total > 0) {
            InquiryCategory pendingCategory = new InquiryCategory();
            pendingCategory.setCategory("대기 중");
            pendingCategory.setCount(pending);
            pendingCategory.setPercentage(total > 0 ? (pending * 100.0) / total : 0);
            pendingCategory.setResolvedCount(resolved);
            pendingCategory.setPendingCount(pending);
            categories.add(pendingCategory);

            InquiryCategory progressCategory = new InquiryCategory();
            progressCategory.setCategory("처리 중");
            progressCategory.setCount(inProgress);
            progressCategory.setPercentage(total > 0 ? (inProgress * 100.0) / total : 0);
            progressCategory.setResolvedCount(resolved);
            progressCategory.setPendingCount(inProgress);
            categories.add(progressCategory);

            InquiryCategory resolvedCategory = new InquiryCategory();
            resolvedCategory.setCategory("처리 완료");
            resolvedCategory.setCount(resolved);
            resolvedCategory.setPercentage(total > 0 ? (resolved * 100.0) / total : 0);
            resolvedCategory.setResolvedCount(resolved);
            resolvedCategory.setPendingCount(pending);
            categories.add(resolvedCategory);
        }
        data.setInquiryCategories(categories);

        List<RecentInquiry> recentInquiries = new ArrayList<>();
        if (inquiries != null) {
            inquiries.stream()
                    .filter(inquiry -> inquiry.getCreatedAt() != null)
                    .sorted(Comparator.comparing(Inquiry::getCreatedAt).reversed())
                    .limit(5)
                    .forEach(inquiry -> {
                        RecentInquiry item = new RecentInquiry();
                        item.setId(inquiry.getId());
                        item.setUserName(inquiry.getUserName());
                        item.setSubject(inquiry.getSubject());
                        item.setStatus(inquiry.getStatus());
                        item.setType(inquiry.getStatus());
                        item.setPriority("NORMAL");
                        item.setCreatedAt(inquiry.getCreatedAt());
                        recentInquiries.add(item);
                    });
        }
        data.setRecentInquiries(recentInquiries);

        List<SatisfactionStat> satisfactionStats = new ArrayList<>();
        for (int rating = 5; rating >= 1; rating--) {
            SatisfactionStat stat = new SatisfactionStat();
            stat.setRating(rating);
            stat.setCount(0);
            stat.setPercentage(0.0);
            satisfactionStats.add(stat);
        }
        data.setSatisfactionStats(satisfactionStats);

        return data;
    }

    // DTO classes
    public static class SupportDashboardData {
        private int totalInquiries;
        private int pendingInquiries;
        private int resolvedInquiries;
        private double averageResponseTime;
        private double customerSatisfaction;
        private List<InquiryCategory> inquiryCategories;
        private List<RecentInquiry> recentInquiries;
        private List<SatisfactionStat> satisfactionStats;

        public int getTotalInquiries() { return totalInquiries; }
        public void setTotalInquiries(int totalInquiries) { this.totalInquiries = totalInquiries; }
        public int getPendingInquiries() { return pendingInquiries; }
        public void setPendingInquiries(int pendingInquiries) { this.pendingInquiries = pendingInquiries; }
        public int getResolvedInquiries() { return resolvedInquiries; }
        public void setResolvedInquiries(int resolvedInquiries) { this.resolvedInquiries = resolvedInquiries; }
        public double getAverageResponseTime() { return averageResponseTime; }
        public void setAverageResponseTime(double averageResponseTime) { this.averageResponseTime = averageResponseTime; }
        public double getCustomerSatisfaction() { return customerSatisfaction; }
        public void setCustomerSatisfaction(double customerSatisfaction) { this.customerSatisfaction = customerSatisfaction; }
        public List<InquiryCategory> getInquiryCategories() { return inquiryCategories; }
        public void setInquiryCategories(List<InquiryCategory> inquiryCategories) { this.inquiryCategories = inquiryCategories; }
        public List<RecentInquiry> getRecentInquiries() { return recentInquiries; }
        public void setRecentInquiries(List<RecentInquiry> recentInquiries) { this.recentInquiries = recentInquiries; }
        public List<SatisfactionStat> getSatisfactionStats() { return satisfactionStats; }
        public void setSatisfactionStats(List<SatisfactionStat> satisfactionStats) { this.satisfactionStats = satisfactionStats; }
    }

    public static class InquiryCategory {
        private String category;
        private int count;
        private double percentage;
        private int resolvedCount;
        private int pendingCount;

        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
        public int getResolvedCount() { return resolvedCount; }
        public void setResolvedCount(int resolvedCount) { this.resolvedCount = resolvedCount; }
        public int getPendingCount() { return pendingCount; }
        public void setPendingCount(int pendingCount) { this.pendingCount = pendingCount; }
    }

    public static class SatisfactionStat {
        private int rating;
        private int count;
        private double percentage;

        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }

    public static class RecentInquiry {
        private int id;
        private String userName;
        private String subject;
        private String type;
        private String status;
        private String priority;
        private Timestamp createdAt;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getSubject() { return subject; }
        public void setSubject(String subject) { this.subject = subject; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getPriority() { return priority; }
        public void setPriority(String priority) { this.priority = priority; }
        public Timestamp getCreatedAt() { return createdAt; }
        public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    }
}
