package com.meetlog.service;

import com.meetlog.dto.dashboard.AdminDashboardDto;
import com.meetlog.repository.DashboardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

/**
 * 관리자 대시보드 서비스
 */
@Service
@RequiredArgsConstructor
public class AdminDashboardService {

    private final DashboardRepository dashboardRepository;

    /**
     * 관리자 대시보드 전체 통계 조회
     */
    @Transactional(readOnly = true)
    public AdminDashboardDto getAdminDashboard() {
        LocalDate today = LocalDate.now();
        LocalDate monthStart = today.withDayOfMonth(1);
        LocalDate lastMonthStart = monthStart.minusMonths(1);
        LocalDate lastMonthEnd = monthStart.minusDays(1);

        // 전체 통계
        Long totalUsers = dashboardRepository.countTotalUsers();
        Long totalRestaurants = dashboardRepository.countTotalRestaurants();
        Long totalReservations = dashboardRepository.countTotalReservations();
        Long totalReviews = dashboardRepository.countTotalReviews();
        Long totalCourses = dashboardRepository.countTotalCourses();
        BigDecimal totalRevenue = dashboardRepository.sumTotalRevenue();
        if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

        // 오늘 통계
        Long todayNewUsers = dashboardRepository.countUsersByPeriod(today, today);
        Long todayReservations = dashboardRepository.countReservationsByPeriod(today, today);
        BigDecimal todayRevenue = dashboardRepository.sumRevenueByPeriod(today, today);
        if (todayRevenue == null) todayRevenue = BigDecimal.ZERO;

        // 이번 달 통계
        Long monthlyNewUsers = dashboardRepository.countUsersByPeriod(monthStart, today);
        Long monthlyReservations = dashboardRepository.countReservationsByPeriod(monthStart, today);
        BigDecimal monthlyRevenue = dashboardRepository.sumRevenueByPeriod(monthStart, today);
        if (monthlyRevenue == null) monthlyRevenue = BigDecimal.ZERO;

        // 전월 통계 (증가율 계산용)
        Long lastMonthUsers = dashboardRepository.countUsersByPeriod(lastMonthStart, lastMonthEnd);
        Long lastMonthReservations = dashboardRepository.countReservationsByPeriod(lastMonthStart, lastMonthEnd);
        BigDecimal lastMonthRevenue = dashboardRepository.sumRevenueByPeriod(lastMonthStart, lastMonthEnd);
        if (lastMonthRevenue == null) lastMonthRevenue = BigDecimal.ZERO;

        // 증가율 계산
        Double userGrowthRate = calculateGrowthRate(monthlyNewUsers, lastMonthUsers);
        Double reservationGrowthRate = calculateGrowthRate(monthlyReservations, lastMonthReservations);
        Double revenueGrowthRate = calculateGrowthRate(monthlyRevenue, lastMonthRevenue);

        // 사용자 유형별
        Long normalUsers = dashboardRepository.countUsersByType("NORMAL");
        Long businessUsers = dashboardRepository.countUsersByType("BUSINESS");
        Long adminUsers = dashboardRepository.countUsersByType("ADMIN");

        // 예약 상태별
        Long pendingReservations = dashboardRepository.countReservationsByStatus("PENDING");
        Long confirmedReservations = dashboardRepository.countReservationsByStatus("CONFIRMED");
        Long completedReservations = dashboardRepository.countReservationsByStatus("COMPLETED");
        Long cancelledReservations = dashboardRepository.countReservationsByStatus("CANCELLED");

        // 차트 데이터 (최근 30일)
        var userTrend = dashboardRepository.getUserTrend(30);
        var reservationTrend = dashboardRepository.getReservationTrend(30);
        var revenueTrend = dashboardRepository.getRevenueTrend(30);

        // 카테고리별 레스토랑
        var restaurantsByCategory = dashboardRepository.getRestaurantsByCategory();

        // 평점 분포
        var reviewRatingDistribution = dashboardRepository.getReviewRatingDistribution();

        return AdminDashboardDto.builder()
                .totalUsers(totalUsers)
                .totalRestaurants(totalRestaurants)
                .totalReservations(totalReservations)
                .totalReviews(totalReviews)
                .totalCourses(totalCourses)
                .totalRevenue(totalRevenue)
                .userGrowthRate(userGrowthRate)
                .reservationGrowthRate(reservationGrowthRate)
                .revenueGrowthRate(revenueGrowthRate)
                .todayNewUsers(todayNewUsers)
                .todayReservations(todayReservations)
                .todayRevenue(todayRevenue)
                .monthlyNewUsers(monthlyNewUsers)
                .monthlyReservations(monthlyReservations)
                .monthlyRevenue(monthlyRevenue)
                .normalUsers(normalUsers)
                .businessUsers(businessUsers)
                .adminUsers(adminUsers)
                .pendingReservations(pendingReservations)
                .confirmedReservations(confirmedReservations)
                .completedReservations(completedReservations)
                .cancelledReservations(cancelledReservations)
                .userTrend(userTrend)
                .reservationTrend(reservationTrend)
                .revenueTrend(revenueTrend)
                .restaurantsByCategory(restaurantsByCategory)
                .reviewRatingDistribution(reviewRatingDistribution)
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
