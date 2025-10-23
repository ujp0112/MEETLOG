package com.meetlog.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 비즈니스(레스토랑 사업자) 대시보드 통계 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BusinessDashboardDto {
    private Long restaurantId;
    private String restaurantName;

    // 전체 통계
    private Long totalReservations;
    private Long totalReviews;
    private Double averageRating;
    private Long totalLikes;
    private BigDecimal totalRevenue;

    // 오늘 통계
    private Long todayReservations;
    private Long todayCompletedReservations;
    private Long todayPendingReservations;
    private BigDecimal todayRevenue;

    // 이번 달 통계
    private Long monthlyReservations;
    private Long monthlyCompletedReservations;
    private BigDecimal monthlyRevenue;
    private Long monthlyNewReviews;
    private Double monthlyAverageRating;

    // 증가율 (전월 대비)
    private Double reservationGrowthRate;
    private Double revenueGrowthRate;
    private Double ratingChange;

    // 예약 상태별 통계
    private Long pendingReservations;
    private Long confirmedReservations;
    private Long completedReservations;
    private Long cancelledReservations;
    private Double cancellationRate;

    // 평점 분포
    private List<RatingDistribution> ratingDistribution;

    // 인기 시간대
    private List<TimeSlotData> popularTimeSlots;

    // 예약 추이 (최근 30일)
    private List<TrendData> reservationTrend;

    // 매출 추이 (최근 30일)
    private List<TrendData> revenueTrend;

    // 최근 리뷰
    private List<RecentReview> recentReviews;

    // 다가오는 예약
    private List<UpcomingReservation> upcomingReservations;

    // 키워드 분석 (리뷰에서 추출)
    private List<KeywordData> topKeywords;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RatingDistribution {
        private Integer rating;
        private Long count;
        private Double percentage;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TimeSlotData {
        private String timeSlot; // "18:00-19:00"
        private Long reservationCount;
        private Double averagePartySize;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TrendData {
        private LocalDate date;
        private String label;
        private Long count;
        private BigDecimal amount;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RecentReview {
        private Long reviewId;
        private String userName;
        private Integer rating;
        private String content;
        private LocalDateTime createdAt;
        private Boolean hasReply;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UpcomingReservation {
        private Long reservationId;
        private String userName;
        private LocalDateTime reservationTime;
        private Integer partySize;
        private String status;
        private String contactPhone;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class KeywordData {
        private String keyword;
        private Long count;
        private Double sentiment; // 긍정/부정 점수 (추후 확장)
    }
}
