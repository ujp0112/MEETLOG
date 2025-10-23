package com.meetlog.repository;

import com.meetlog.dto.dashboard.AdminDashboardDto;
import com.meetlog.dto.dashboard.BusinessDashboardDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Dashboard Repository Interface
 * 대시보드 통계 쿼리용 MyBatis 매퍼
 */
@Mapper
public interface DashboardRepository {

    // ===== 관리자 통계 =====

    // 전체 카운트
    Long countTotalUsers();
    Long countTotalRestaurants();
    Long countTotalReservations();
    Long countTotalReviews();
    Long countTotalCourses();
    BigDecimal sumTotalRevenue();

    // 기간별 카운트
    Long countUsersByPeriod(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);
    Long countReservationsByPeriod(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);
    BigDecimal sumRevenueByPeriod(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    // 사용자 유형별
    Long countUsersByType(@Param("userType") String userType);

    // 예약 상태별
    Long countReservationsByStatus(@Param("status") String status);

    // 차트 데이터 (최근 N일)
    List<AdminDashboardDto.ChartData> getUserTrend(@Param("days") int days);
    List<AdminDashboardDto.ChartData> getReservationTrend(@Param("days") int days);
    List<AdminDashboardDto.ChartData> getRevenueTrend(@Param("days") int days);

    // 카테고리별 레스토랑
    List<AdminDashboardDto.CategoryData> getRestaurantsByCategory();

    // 평점 분포
    List<AdminDashboardDto.RatingData> getReviewRatingDistribution();

    // ===== 비즈니스 통계 =====

    // 레스토랑별 기본 통계
    Long countReservationsByRestaurant(@Param("restaurantId") Long restaurantId);
    Long countReviewsByRestaurant(@Param("restaurantId") Long restaurantId);
    Double getAverageRatingByRestaurant(@Param("restaurantId") Long restaurantId);

    // 레스토랑별 기간 매출
    BigDecimal sumRevenueByRestaurant(@Param("restaurantId") Long restaurantId,
                                       @Param("startDate") LocalDate startDate,
                                       @Param("endDate") LocalDate endDate);

    // 레스토랑 예약 상태별
    Long countRestaurantReservationsByStatus(@Param("restaurantId") Long restaurantId, @Param("status") String status);

    // 레스토랑별 기간 예약수
    Long countRestaurantReservationsByPeriod(@Param("restaurantId") Long restaurantId,
                                               @Param("startDate") LocalDate startDate,
                                               @Param("endDate") LocalDate endDate);

    // 평점 분포
    List<BusinessDashboardDto.RatingDistribution> getRatingDistributionByRestaurant(@Param("restaurantId") Long restaurantId);

    // 인기 시간대
    List<BusinessDashboardDto.TimeSlotData> getPopularTimeSlots(@Param("restaurantId") Long restaurantId);

    // 예약 추이
    List<BusinessDashboardDto.TrendData> getRestaurantReservationTrend(@Param("restaurantId") Long restaurantId, @Param("days") int days);

    // 매출 추이
    List<BusinessDashboardDto.TrendData> getRestaurantRevenueTrend(@Param("restaurantId") Long restaurantId, @Param("days") int days);

    // 최근 리뷰
    List<BusinessDashboardDto.RecentReview> getRecentReviewsByRestaurant(@Param("restaurantId") Long restaurantId, @Param("limit") int limit);

    // 다가오는 예약
    List<BusinessDashboardDto.UpcomingReservation> getUpcomingReservations(@Param("restaurantId") Long restaurantId, @Param("limit") int limit);

    // 리뷰 키워드 (JSON 파싱)
    List<BusinessDashboardDto.KeywordData> getTopKeywordsByRestaurant(@Param("restaurantId") Long restaurantId, @Param("limit") int limit);
}
