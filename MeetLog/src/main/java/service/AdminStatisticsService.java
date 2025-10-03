package service;

import dao.AdminStatisticsDAO;
import dto.*;

import java.util.List;

public class AdminStatisticsService {

    private final AdminStatisticsDAO dao = new AdminStatisticsDAO();

    /**
     * Support Dashboard 데이터 조회
     */
    public SupportDashboardData getSupportDashboardData() {
        SupportDashboardData data = new SupportDashboardData();

        // 기본 통계
        data.setTotalInquiries(dao.getTotalInquiryCount());

        int pending = dao.getInquiryCountByStatus("PENDING");
        int inProgress = dao.getInquiryCountByStatus("IN_PROGRESS");
        data.setPendingInquiries(pending + inProgress);

        data.setResolvedInquiries(dao.getInquiryCountByStatus("RESOLVED"));

        // 평균 응답 시간 (소수점 1자리)
        double avgResponseTime = dao.getAverageResponseTime();
        data.setAverageResponseTime(Math.round(avgResponseTime * 10.0) / 10.0);

        // 고객 만족도 (소수점 1자리)
        double avgSatisfaction = dao.getAverageSatisfaction();
        data.setCustomerSatisfaction(Math.round(avgSatisfaction * 10.0) / 10.0);

        // 카테고리별 통계
        data.setInquiryCategories(dao.getInquiryCategoryStats());

        // 최근 문의 (10건)
        data.setRecentInquiries(dao.getRecentInquiries(10));

        // 만족도 통계
        List<SatisfactionStat> satisfactionStats = dao.getSatisfactionStats();
        System.out.println("DEBUG: 만족도 통계 개수 = " + (satisfactionStats != null ? satisfactionStats.size() : "null"));
        if (satisfactionStats != null && !satisfactionStats.isEmpty()) {
            for (SatisfactionStat stat : satisfactionStats) {
                System.out.println("DEBUG: rating=" + stat.getRating() + ", count=" + stat.getCount() + ", percentage=" + stat.getPercentage());
            }
        }
        data.setSatisfactionStats(satisfactionStats);

        return data;
    }

    /**
     * 월별 통계 조회 (최근 N개월)
     */
    public List<MonthlyStatistics> getMonthlyStatistics(int months) {
        return dao.getMonthlyStatistics(months);
    }

    /**
     * 최근 월 통계 조회
     */
    public MonthlyStatistics getLatestMonthlyStatistics() {
        return dao.getLatestMonthlyStatistics();
    }

    /**
     * 카테고리별 통계 조회
     * @param yearMonth YYYY-MM 형식 (null이면 최근 월)
     * @param limit 조회 제한 (null이면 전체)
     */
    public List<CategoryStatistics> getCategoryStatistics(String yearMonth, Integer limit) {
        if (yearMonth == null) {
            MonthlyStatistics latest = dao.getLatestMonthlyStatistics();
            yearMonth = latest != null ? latest.getYearMonth() : getCurrentYearMonth();
        }
        return dao.getCategoryStatistics(yearMonth, limit);
    }

    /**
     * 지역별 통계 조회
     */
    public List<RegionalStatistics> getRegionalStatistics(String yearMonth, Integer limit) {
        if (yearMonth == null) {
            MonthlyStatistics latest = dao.getLatestMonthlyStatistics();
            yearMonth = latest != null ? latest.getYearMonth() : getCurrentYearMonth();
        }
        return dao.getRegionalStatistics(yearMonth, limit);
    }

    /**
     * 오늘 활동 통계
     */
    public DailyActivityStats getTodayActivityStats() {
        return dao.getTodayActivityStats();
    }

    /**
     * 최근 N일 활동 통계
     */
    public List<DailyActivityStats> getRecentActivityStats(int days) {
        return dao.getRecentActivityStats(days);
    }

    /**
     * 이번주 인기 맛집 TOP N
     */
    public List<RestaurantPopularity> getTopRestaurantsThisWeek(int limit) {
        return dao.getTopRestaurantsThisWeek(limit);
    }

    /**
     * 지점별 성과 조회
     */
    public List<BranchPerformance> getBranchPerformance(String yearMonth) {
        if (yearMonth == null) {
            yearMonth = getCurrentYearMonth();
        }
        return dao.getBranchPerformance(yearMonth);
    }

    /**
     * 지점 종합 통계
     */
    public int getTotalBranchCount() {
        return dao.getTotalBranchCount();
    }

    public int getTotalEmployeeCount(String yearMonth) {
        if (yearMonth == null) {
            yearMonth = getCurrentYearMonth();
        }
        return dao.getTotalEmployeeCount(yearMonth);
    }

    public double getTotalBranchRevenue(String yearMonth) {
        if (yearMonth == null) {
            yearMonth = getCurrentYearMonth();
        }
        return dao.getTotalBranchRevenue(yearMonth);
    }

    /**
     * 현재 년월 반환 (YYYY-MM 형식)
     */
    private String getCurrentYearMonth() {
        java.time.YearMonth current = java.time.YearMonth.now();
        return current.toString(); // YYYY-MM 형식
    }
}
