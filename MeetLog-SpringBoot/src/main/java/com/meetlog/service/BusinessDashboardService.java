package com.meetlog.service;

import com.meetlog.dto.dashboard.BusinessDashboardDto;
import com.meetlog.model.Restaurant;
import com.meetlog.repository.DashboardRepository;
import com.meetlog.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

/**
 * 비즈니스 대시보드 서비스
 */
@Service
@RequiredArgsConstructor
public class BusinessDashboardService {

    private final DashboardRepository dashboardRepository;
    private final RestaurantRepository restaurantRepository;

    /**
     * 비즈니스 대시보드 통계 조회
     */
    @Transactional(readOnly = true)
    public BusinessDashboardDto getBusinessDashboard(Long restaurantId, Long userId) {
        // 권한 체크
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        if (!restaurant.isOwnedBy(userId)) {
            throw new RuntimeException("No permission to access this restaurant's dashboard");
        }

        LocalDate today = LocalDate.now();
        LocalDate monthStart = today.withDayOfMonth(1);
        LocalDate lastMonthStart = monthStart.minusMonths(1);
        LocalDate lastMonthEnd = monthStart.minusDays(1);

        // 전체 통계
        Long totalReservations = dashboardRepository.countReservationsByRestaurant(restaurantId);
        Long totalReviews = dashboardRepository.countReviewsByRestaurant(restaurantId);
        Double averageRating = dashboardRepository.getAverageRatingByRestaurant(restaurantId);
        if (averageRating == null) averageRating = 0.0;

        BigDecimal totalRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, null, null);
        if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

        // 오늘 통계
        Long todayReservations = dashboardRepository.countRestaurantReservationsByPeriod(restaurantId, today, today);
        BigDecimal todayRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, today, today);
        if (todayRevenue == null) todayRevenue = BigDecimal.ZERO;

        // 이번 달 통계
        Long monthlyReservations = dashboardRepository.countRestaurantReservationsByPeriod(restaurantId, monthStart, today);
        BigDecimal monthlyRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, monthStart, today);
        if (monthlyRevenue == null) monthlyRevenue = BigDecimal.ZERO;

        // 전월 통계
        Long lastMonthReservations = dashboardRepository.countRestaurantReservationsByPeriod(restaurantId, lastMonthStart, lastMonthEnd);
        BigDecimal lastMonthRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, lastMonthStart, lastMonthEnd);
        if (lastMonthRevenue == null) lastMonthRevenue = BigDecimal.ZERO;

        // 증가율
        Double reservationGrowthRate = calculateGrowthRate(monthlyReservations, lastMonthReservations);
        Double revenueGrowthRate = calculateGrowthRate(monthlyRevenue, lastMonthRevenue);

        // 예약 상태별
        Long pendingReservations = dashboardRepository.countRestaurantReservationsByStatus(restaurantId, "PENDING");
        Long confirmedReservations = dashboardRepository.countRestaurantReservationsByStatus(restaurantId, "CONFIRMED");
        Long completedReservations = dashboardRepository.countRestaurantReservationsByStatus(restaurantId, "COMPLETED");
        Long cancelledReservations = dashboardRepository.countRestaurantReservationsByStatus(restaurantId, "CANCELLED");

        // 취소율
        Double cancellationRate = (totalReservations > 0)
                ? (cancelledReservations * 100.0) / totalReservations
                : 0.0;

        // 분석 데이터
        var ratingDistribution = dashboardRepository.getRatingDistributionByRestaurant(restaurantId);
        var popularTimeSlots = dashboardRepository.getPopularTimeSlots(restaurantId);
        var reservationTrend = dashboardRepository.getRestaurantReservationTrend(restaurantId, 30);
        var revenueTrend = dashboardRepository.getRestaurantRevenueTrend(restaurantId, 30);
        var recentReviews = dashboardRepository.getRecentReviewsByRestaurant(restaurantId, 10);
        var upcomingReservations = dashboardRepository.getUpcomingReservations(restaurantId, 10);
        var topKeywords = dashboardRepository.getTopKeywordsByRestaurant(restaurantId, 10);

        return BusinessDashboardDto.builder()
                .restaurantId(restaurantId)
                .restaurantName(restaurant.getName())
                .totalReservations(totalReservations)
                .totalReviews(totalReviews)
                .averageRating(averageRating)
                .totalRevenue(totalRevenue)
                .todayReservations(todayReservations)
                .todayRevenue(todayRevenue)
                .monthlyReservations(monthlyReservations)
                .monthlyRevenue(monthlyRevenue)
                .reservationGrowthRate(reservationGrowthRate)
                .revenueGrowthRate(revenueGrowthRate)
                .pendingReservations(pendingReservations)
                .confirmedReservations(confirmedReservations)
                .completedReservations(completedReservations)
                .cancelledReservations(cancelledReservations)
                .cancellationRate(cancellationRate)
                .ratingDistribution(ratingDistribution)
                .popularTimeSlots(popularTimeSlots)
                .reservationTrend(reservationTrend)
                .revenueTrend(revenueTrend)
                .recentReviews(recentReviews)
                .upcomingReservations(upcomingReservations)
                .topKeywords(topKeywords)
                .build();
    }

    private Double calculateGrowthRate(Long current, Long previous) {
        if (previous == null || previous == 0) return 0.0;
        return ((current - previous) * 100.0) / previous;
    }

    private Double calculateGrowthRate(BigDecimal current, BigDecimal previous) {
        if (previous == null || previous.compareTo(BigDecimal.ZERO) == 0) return 0.0;
        return current.subtract(previous)
                      .multiply(BigDecimal.valueOf(100))
                      .divide(previous, 2, RoundingMode.HALF_UP)
                      .doubleValue();
    }
}
