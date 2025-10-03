package dto;

import java.util.List;

public class SupportDashboardData {
    private int totalInquiries;
    private int pendingInquiries;
    private int resolvedInquiries;
    private double averageResponseTime;
    private double customerSatisfaction;
    private List<InquiryCategoryStats> inquiryCategories;
    private List<RecentInquiry> recentInquiries;
    private List<SatisfactionStat> satisfactionStats;

    public SupportDashboardData() {}

    public int getTotalInquiries() {
        return totalInquiries;
    }

    public void setTotalInquiries(int totalInquiries) {
        this.totalInquiries = totalInquiries;
    }

    public int getPendingInquiries() {
        return pendingInquiries;
    }

    public void setPendingInquiries(int pendingInquiries) {
        this.pendingInquiries = pendingInquiries;
    }

    public int getResolvedInquiries() {
        return resolvedInquiries;
    }

    public void setResolvedInquiries(int resolvedInquiries) {
        this.resolvedInquiries = resolvedInquiries;
    }

    public double getAverageResponseTime() {
        return averageResponseTime;
    }

    public void setAverageResponseTime(double averageResponseTime) {
        this.averageResponseTime = averageResponseTime;
    }

    public double getCustomerSatisfaction() {
        return customerSatisfaction;
    }

    public void setCustomerSatisfaction(double customerSatisfaction) {
        this.customerSatisfaction = customerSatisfaction;
    }

    public List<InquiryCategoryStats> getInquiryCategories() {
        return inquiryCategories;
    }

    public void setInquiryCategories(List<InquiryCategoryStats> inquiryCategories) {
        this.inquiryCategories = inquiryCategories;
    }

    public List<RecentInquiry> getRecentInquiries() {
        return recentInquiries;
    }

    public void setRecentInquiries(List<RecentInquiry> recentInquiries) {
        this.recentInquiries = recentInquiries;
    }

    public List<SatisfactionStat> getSatisfactionStats() {
        return satisfactionStats;
    }

    public void setSatisfactionStats(List<SatisfactionStat> satisfactionStats) {
        this.satisfactionStats = satisfactionStats;
    }
}
