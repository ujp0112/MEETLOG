package com.meetlog.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 관리자 대시보드 통계 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminDashboardDto {
    // 전체 통계
    private Long totalUsers;
    private Long totalRestaurants;
    private Long totalReservations;
    private Long totalReviews;
    private Long totalCourses;
    private BigDecimal totalRevenue;

    // 증가율 (전월 대비)
    private Double userGrowthRate;
    private Double restaurantGrowthRate;
    private Double reservationGrowthRate;
    private Double revenueGrowthRate;

    // 오늘 통계
    private Long todayNewUsers;
    private Long todayReservations;
    private Long todayReviews;
    private BigDecimal todayRevenue;

    // 이번 달 통계
    private Long monthlyNewUsers;
    private Long monthlyReservations;
    private Long monthlyReviews;
    private BigDecimal monthlyRevenue;

    // 사용자 유형별 통계
    private Long normalUsers;
    private Long businessUsers;
    private Long adminUsers;

    // 예약 상태별 통계
    private Long pendingReservations;
    private Long confirmedReservations;
    private Long completedReservations;
    private Long cancelledReservations;

    // 차트 데이터
    private List<ChartData> userTrend; // 사용자 증가 추이
    private List<ChartData> reservationTrend; // 예약 추이
    private List<ChartData> revenueTrend; // 매출 추이
    private List<CategoryData> restaurantsByCategory; // 카테고리별 레스토랑 수
    private List<RatingData> reviewRatingDistribution; // 평점 분포

    // 최근 활동
    private List<RecentActivity> recentActivities;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ChartData {
        private LocalDate date;
        private String label; // "2025-01", "월요일" 등
        private Long value;
        private BigDecimal amount; // 금액용
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CategoryData {
        private String category;
        private Long count;
        private Double percentage;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RatingData {
        private Integer rating;
        private Long count;
        private Double percentage;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RecentActivity {
        private String type; // USER_REGISTER, RESERVATION, REVIEW, etc.
        private String description;
        private LocalDate timestamp;
        private Long userId;
        private String userName;
    }
}
