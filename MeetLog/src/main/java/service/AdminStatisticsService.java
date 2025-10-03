package service;

import dao.AdminStatisticsDAO;
import dto.*;

import java.util.ArrayList;
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
     * Statistics Dashboard 데이터 조회
     */
    public StatisticsDashboardData getStatisticsDashboardData() {
        StatisticsDashboardData data = new StatisticsDashboardData();

        // 기본 통계
        data.setTotalUsers(dao.getTotalUserCount());
        data.setTotalRestaurants(dao.getTotalRestaurantCount());
        data.setTotalReservations(dao.getTotalReservationCount());
        data.setTotalReviews(dao.getTotalReviewCount());
        data.setAverageRating(Math.round(dao.getAverageRestaurantRating() * 10.0) / 10.0);

        // 최근 월 통계에서 매출과 지점 정보
        MonthlyStatistics latest = dao.getLatestMonthlyStatistics();
        if (latest != null && latest.getTotalRevenue() != null) {
            data.setTotalRevenue(latest.getTotalRevenue().doubleValue());
        }

        // 지점 및 직원 수
        data.setTotalBranches(dao.getTotalBranchCount());
        String currentMonth = getCurrentYearMonth();
        data.setTotalEmployees(dao.getTotalEmployeeCount(currentMonth));

        // 성장률
        data.setUserGrowthRate(dao.getUserGrowthRate());
        data.setRestaurantGrowthRate(dao.getRestaurantGrowthRate());
        data.setReservationGrowthRate(dao.getReservationGrowthRate());
        data.setRevenueGrowthRate(dao.getRevenueGrowthRate());

        // 카테고리별 통계 (TOP 5)
        data.setPopularCategories(dao.getCategoryStatistics(currentMonth, 5));

        // 월별 성장 추이 (최근 4개월)
        data.setMonthlyGrowths(dao.getMonthlyStatistics(4));

        // 지역별 분포 (TOP 5)
        data.setRegionalDistributions(dao.getRegionalStatistics(currentMonth, 5));

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
     * Branch Statistics Dashboard 데이터 조회 (전체)
     */
    public BranchStatisticsData getBranchStatisticsData() {
        return getBranchStatisticsData(null);
    }

    /**
     * Branch Statistics Dashboard 데이터 조회 (회사별)
     */
    public BranchStatisticsData getBranchStatisticsData(Integer companyId) {
        BranchStatisticsData data = new BranchStatisticsData();

        String currentMonth = getCurrentYearMonth();

        // 기본 통계
        if (companyId != null) {
            data.setTotalBranches(dao.getTotalBranchCountByCompany(companyId));
            data.setActiveBranches(dao.getActiveBranchCountByCompany(companyId));
            data.setTotalEmployees(dao.getTotalEmployeeCountByCompany(currentMonth, companyId));
            data.setTotalRevenue(dao.getTotalBranchRevenueByCompany(currentMonth, companyId));
        } else {
            data.setTotalBranches(dao.getTotalBranchCount());
            data.setActiveBranches(dao.getTotalBranchCount());
            data.setTotalEmployees(dao.getTotalEmployeeCount(currentMonth));
            data.setTotalRevenue(dao.getTotalBranchRevenue(currentMonth));
        }

        // 평균 매출 계산
        if (data.getTotalBranches() > 0) {
            data.setAverageRevenuePerBranch(data.getTotalRevenue() / data.getTotalBranches());
        }

        // 이번 달 지점별 성과
        List<BranchPerformance> branchPerformances;
        if (companyId != null) {
            branchPerformances = dao.getBranchPerformanceByCompany(currentMonth, companyId);
        } else {
            branchPerformances = dao.getBranchPerformance(currentMonth);
        }
        data.setBranchPerformances(branchPerformances);

        // 최근 3개월 월별 데이터
        List<BranchMonthlyData> monthlyData = new ArrayList<>();
        List<MonthlyStatistics> recentMonths = dao.getMonthlyStatistics(3);

        for (MonthlyStatistics month : recentMonths) {
            String yearMonth = month.getYearMonth();
            List<BranchPerformance> branches;
            if (companyId != null) {
                branches = dao.getBranchPerformanceByCompany(yearMonth, companyId);
            } else {
                branches = dao.getBranchPerformance(yearMonth);
            }

            double totalRevenue = branches.stream()
                    .mapToDouble(b -> b.getRevenue() != null ? b.getRevenue().doubleValue() : 0.0)
                    .sum();

            BranchMonthlyData monthData = new BranchMonthlyData(yearMonth, totalRevenue);
            monthData.setBranches(branches);
            monthlyData.add(monthData);
        }
        data.setMonthlyData(monthlyData);

        return data;
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
