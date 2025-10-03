package dao;

import dto.*;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminStatisticsDAO {

    private static final String MAPPER = "mapper.AdminStatisticsMapper";

    // ================================================
    // Support Dashboard Methods
    // ================================================

    public int getTotalInquiryCount() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTotalInquiryCount");
        }
    }

    public int getInquiryCountByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getInquiryCountByStatus", status);
        }
    }

    public double getAverageResponseTime() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getAverageResponseTime");
            return result != null ? result : 0.0;
        }
    }

    public double getAverageSatisfaction() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getAverageSatisfaction");
            return result != null ? result : 0.0;
        }
    }

    public List<InquiryCategoryStats> getInquiryCategoryStats() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getInquiryCategoryStats");
        }
    }

    public List<RecentInquiry> getRecentInquiries(int limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getRecentInquiries", limit);
        }
    }

    public List<SatisfactionStat> getSatisfactionStats() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getSatisfactionStats");
        }
    }

    // ================================================
    // Statistics Dashboard Methods
    // ================================================

    public int getTotalUserCount() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTotalUserCount");
        }
    }

    public int getTotalRestaurantCount() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTotalRestaurantCount");
        }
    }

    public int getTotalReservationCount() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTotalReservationCount");
        }
    }

    public int getTotalReviewCount() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTotalReviewCount");
        }
    }

    public double getAverageRestaurantRating() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getAverageRestaurantRating");
            return result != null ? result : 0.0;
        }
    }

    public double getUserGrowthRate() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getUserGrowthRate");
            return result != null ? result : 0.0;
        }
    }

    public double getRestaurantGrowthRate() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getRestaurantGrowthRate");
            return result != null ? result : 0.0;
        }
    }

    public double getReservationGrowthRate() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getReservationGrowthRate");
            return result != null ? result : 0.0;
        }
    }

    public double getRevenueGrowthRate() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getRevenueGrowthRate");
            return result != null ? result : 0.0;
        }
    }

    // ================================================
    // Monthly Statistics Methods
    // ================================================

    public List<MonthlyStatistics> getMonthlyStatistics(int months) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getMonthlyStatistics", months);
        }
    }

    public MonthlyStatistics getLatestMonthlyStatistics() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getLatestMonthlyStatistics");
        }
    }

    // ================================================
    // Category Statistics Methods
    // ================================================

    public List<CategoryStatistics> getCategoryStatistics(String yearMonth, Integer limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("yearMonth", yearMonth);
            params.put("limit", limit);
            return session.selectList(MAPPER + ".getCategoryStatistics", params);
        }
    }

    // ================================================
    // Regional Statistics Methods
    // ================================================

    public List<RegionalStatistics> getRegionalStatistics(String yearMonth, Integer limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("yearMonth", yearMonth);
            params.put("limit", limit);
            return session.selectList(MAPPER + ".getRegionalStatistics", params);
        }
    }

    // ================================================
    // Daily Activity Methods
    // ================================================

    public DailyActivityStats getTodayActivityStats() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTodayActivityStats");
        }
    }

    public List<DailyActivityStats> getRecentActivityStats(int days) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getRecentActivityStats", days);
        }
    }

    // ================================================
    // Restaurant Popularity Methods
    // ================================================

    public List<RestaurantPopularity> getTopRestaurantsThisWeek(int limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getTopRestaurantsThisWeek", limit);
        }
    }

    // ================================================
    // Branch Statistics Methods
    // ================================================

    public List<BranchPerformance> getBranchPerformance(String yearMonth) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getBranchPerformance", yearMonth);
        }
    }

    public int getTotalBranchCount() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTotalBranchCount");
        }
    }

    public int getTotalEmployeeCount(String yearMonth) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer result = session.selectOne(MAPPER + ".getTotalEmployeeCount", yearMonth);
            return result != null ? result : 0;
        }
    }

    public double getTotalBranchRevenue(String yearMonth) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Double result = session.selectOne(MAPPER + ".getTotalBranchRevenue", yearMonth);
            return result != null ? result : 0.0;
        }
    }

    // 회사별 지점 통계
    public int getTotalBranchCountByCompany(int companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getTotalBranchCountByCompany", companyId);
        }
    }

    public int getActiveBranchCountByCompany(int companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getActiveBranchCountByCompany", companyId);
        }
    }

    public int getTotalEmployeeCountByCompany(String yearMonth, int companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("yearMonth", yearMonth);
            params.put("companyId", companyId);
            Integer result = session.selectOne(MAPPER + ".getTotalEmployeeCountByCompany", params);
            return result != null ? result : 0;
        }
    }

    public double getTotalBranchRevenueByCompany(String yearMonth, int companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("yearMonth", yearMonth);
            params.put("companyId", companyId);
            Double result = session.selectOne(MAPPER + ".getTotalBranchRevenueByCompany", params);
            return result != null ? result : 0.0;
        }
    }

    public List<BranchPerformance> getBranchPerformanceByCompany(String yearMonth, int companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("yearMonth", yearMonth);
            params.put("companyId", companyId);
            return session.selectList(MAPPER + ".getBranchPerformanceByCompany", params);
        }
    }
}
