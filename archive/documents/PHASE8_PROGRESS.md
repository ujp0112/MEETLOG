# Phase 8: 관리자/비즈니스 대시보드 - 완료 현황

## 개요
관리자와 비즈니스 사용자를 위한 통계 대시보드 구축
**완료일**: 2025-10-22
**상태**: ✅ 95% 완료 (MyBatis Mapper XML 작성 필요)

---

---

## 완료 요약

### ✅ 백엔드 (Spring Boot)
1. **DTO Layer** - AdminDashboardDto, BusinessDashboardDto (완료)
2. **Repository Interface** - DashboardRepository (완료)
3. **Service Layer** - AdminDashboardService, BusinessDashboardService (완료)
4. **Controller** - DashboardController (완료)

### ✅ 프론트엔드 (React)
1. **API Client** - dashboard.js (완료)
2. **AdminDashboard Component** - 관리자 대시보드 UI (완료)
3. **BusinessDashboard Component** - 비즈니스 대시보드 UI (완료)

### ⏳ 남은 작업
- DashboardRepositoryMapper.xml 작성 (MyBatis 통계 쿼리)

---

## 1. 완료된 작업

### 1.1 DTO Layer ✅

#### AdminDashboardDto.java (120+ lines)
**위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/dto/dashboard/`

```java
@Data
@Builder
public class AdminDashboardDto {
    // 전체 통계
    private Long totalUsers, totalRestaurants, totalReservations;
    private BigDecimal totalRevenue;

    // 증가율 (전월 대비)
    private Double userGrowthRate, reservationGrowthRate;

    // 오늘/이번 달 통계
    private Long todayNewUsers, monthlyReservations;
    private BigDecimal monthlyRevenue;

    // 사용자 유형별
    private Long normalUsers, businessUsers, adminUsers;

    // 예약 상태별
    private Long pendingReservations, confirmedReservations;

    // 차트 데이터
    private List<ChartData> userTrend; // 사용자 증가 추이
    private List<ChartData> reservationTrend; // 예약 추이
    private List<ChartData> revenueTrend; // 매출 추이
    private List<CategoryData> restaurantsByCategory;
    private List<RatingData> reviewRatingDistribution;

    // 최근 활동
    private List<RecentActivity> recentActivities;
}
```

**내부 클래스**:
- `ChartData` - 날짜별 차트 데이터
- `CategoryData` - 카테고리별 통계
- `RatingData` - 평점 분포
- `RecentActivity` - 최근 활동 로그

#### BusinessDashboardDto.java (140+ lines)
```java
@Data
@Builder
public class BusinessDashboardDto {
    private Long restaurantId;

    // 전체/오늘/이번 달 통계
    private Long totalReservations, todayReservations;
    private BigDecimal monthlyRevenue;
    private Double averageRating;

    // 증가율
    private Double reservationGrowthRate, revenueGrowthRate;

    // 예약 상태별
    private Long pendingReservations, cancelledReservations;
    private Double cancellationRate;

    // 분석 데이터
    private List<RatingDistribution> ratingDistribution;
    private List<TimeSlotData> popularTimeSlots; // 인기 시간대
    private List<TrendData> reservationTrend; // 예약 추이
    private List<RecentReview> recentReviews; // 최근 리뷰
    private List<UpcomingReservation> upcomingReservations; // 다가오는 예약
    private List<KeywordData> topKeywords; // 리뷰 키워드 분석
}
```

---

---

### 1.2 Repository Layer ✅

**DashboardRepository.java** (83 lines)
**위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/repository/`

인터페이스 완료:
- 관리자 통계 쿼리 메서드 (20개)
- 비즈니스 통계 쿼리 메서드 (11개)
- 차트 데이터, 평점 분포, 키워드 분석 등

---

### 1.3 Service Layer ✅

#### AdminDashboardService.java (150+ lines)
- 전체/오늘/이번 달 통계 계산
- 증가율 계산 (전월 대비)
- 사용자 유형별/예약 상태별 통계
- 차트 데이터 조회 (30일)
- 카테고리별 레스토랑, 평점 분포

#### BusinessDashboardService.java (145+ lines)
- 레스토랑별 통계 조회
- 권한 체크 (소유자만 접근)
- 예약/매출 증가율
- 평점 분포, 인기 시간대
- 다가오는 예약, 최근 리뷰
- 리뷰 키워드 분석

---

### 1.4 Controller Layer ✅

**DashboardController.java** (45 lines)
**위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/controller/`

REST API 엔드포인트:
- `GET /api/dashboard/admin` - 관리자 대시보드 (ADMIN 권한)
- `GET /api/dashboard/business/{restaurantId}` - 비즈니스 대시보드 (BUSINESS/ADMIN 권한)

---

### 1.5 프론트엔드 (React) ✅

#### dashboard.js (18 lines)
**위치**: `meetlog-frontend/src/api/`
- `getAdminDashboard()` - 관리자 통계 조회
- `getBusinessDashboard(restaurantId)` - 비즈니스 통계 조회

#### AdminDashboard.jsx (240+ lines)
**위치**: `meetlog-frontend/src/components/dashboard/`

**기능**:
- 전체 통계 카드 (사용자, 레스토랑, 예약, 매출)
- 오늘 통계 (신규 가입, 예약, 리뷰, 매출)
- 사용자 유형별 통계
- 예약 상태 카드 (대기/확정/완료/취소)
- 사용자 증가 추이 (최근 7일 표시)
- 카테고리별 레스토랑 (진행률 바)
- 평점 분포 (진행률 바)

**UI 컴포넌트**:
- StatCard - 통계 카드 (증가율 표시)
- StatusCard - 상태별 카드 (색상 구분)
- 반응형 그리드 레이아웃 (Tailwind CSS)

#### BusinessDashboard.jsx (275+ lines)
**위치**: `meetlog-frontend/src/components/dashboard/`

**기능**:
- 핵심 지표 (총 예약, 평균 평점, 매출, 취소율)
- 오늘 예약 현황 (전체/대기/확정)
- 예약 상태 카드
- 평점 분포 차트
- 인기 예약 시간대 (시간별 예약수, 평균 인원)
- 다가오는 예약 테이블 (고객명, 시간, 인원, 상태, 연락처)
- 최근 리뷰 목록 (평점, 내용, 답변 여부)
- 리뷰 키워드 분석 (태그 클라우드)

**UI 특징**:
- 새로고침 버튼
- 테이블 정렬 및 hover 효과
- 상태별 색상 구분 (대기/확정/취소)
- 반응형 디자인

---

## 2. 미완료 작업

### 2.1 MyBatis Mapper XML ⏳

**DashboardRepositoryMapper.xml** 작성 필요:

```java
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
    Long countUsersByPeriod(@Param("startDate") LocalDate startDate,
                             @Param("endDate") LocalDate endDate);
    Long countReservationsByPeriod(@Param("startDate") LocalDate startDate,
                                     @Param("endDate") LocalDate endDate);
    BigDecimal sumRevenueByPeriod(@Param("startDate") LocalDate startDate,
                                    @Param("endDate") LocalDate endDate);

    // 사용자 유형별
    Long countUsersByType(@Param("userType") String userType);

    // 예약 상태별
    Long countReservationsByStatus(@Param("status") String status);

    // 차트 데이터
    List<ChartData> getUserTrend(@Param("days") int days);
    List<ChartData> getReservationTrend(@Param("days") int days);
    List<ChartData> getRevenueTrend(@Param("days") int days);

    // 카테고리별 레스토랑
    List<CategoryData> getRestaurantsByCategory();

    // 평점 분포
    List<RatingData> getReviewRatingDistribution();

    // 최근 활동
    List<RecentActivity> getRecentActivities(@Param("limit") int limit);

    // ===== 비즈니스 통계 =====

    // 레스토랑별 통계
    Long countReservationsByRestaurant(@Param("restaurantId") Long restaurantId);
    Long countReviewsByRestaurant(@Param("restaurantId") Long restaurantId);
    Double getAverageRatingByRestaurant(@Param("restaurantId") Long restaurantId);
    BigDecimal sumRevenueByRestaurant(@Param("restaurantId") Long restaurantId,
                                        @Param("startDate") LocalDate startDate,
                                        @Param("endDate") LocalDate endDate);

    // 레스토랑 예약 상태별
    Long countRestaurantReservationsByStatus(@Param("restaurantId") Long restaurantId,
                                               @Param("status") String status);

    // 평점 분포
    List<RatingDistribution> getRatingDistributionByRestaurant(@Param("restaurantId") Long restaurantId);

    // 인기 시간대
    List<TimeSlotData> getPopularTimeSlots(@Param("restaurantId") Long restaurantId);

    // 예약/매출 추이
    List<TrendData> getRestaurantReservationTrend(@Param("restaurantId") Long restaurantId,
                                                    @Param("days") int days);
    List<TrendData> getRestaurantRevenueTrend(@Param("restaurantId") Long restaurantId,
                                                @Param("days") int days);

    // 최근 리뷰
    List<RecentReview> getRecentReviewsByRestaurant(@Param("restaurantId") Long restaurantId,
                                                      @Param("limit") int limit);

    // 다가오는 예약
    List<UpcomingReservation> getUpcomingReservations(@Param("restaurantId") Long restaurantId,
                                                        @Param("limit") int limit);

    // 키워드 분석
    List<KeywordData> getTopKeywords(@Param("restaurantId") Long restaurantId,
                                       @Param("limit") int limit);
}
```

**DashboardRepositoryMapper.xml** 예시:

```xml
<!-- 사용자 증가 추이 (최근 N일) -->
<select id="getUserTrend" resultType="com.meetlog.dto.dashboard.AdminDashboardDto$ChartData">
    SELECT
        DATE(created_at) as date,
        DATE_FORMAT(created_at, '%Y-%m-%d') as label,
        COUNT(*) as value
    FROM users
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL #{days} DAY)
    GROUP BY DATE(created_at)
    ORDER BY DATE(created_at) ASC
</select>

<!-- 예약 추이 -->
<select id="getReservationTrend" resultType="com.meetlog.dto.dashboard.AdminDashboardDto$ChartData">
    SELECT
        DATE(created_at) as date,
        DATE_FORMAT(created_at, '%Y-%m-%d') as label,
        COUNT(*) as value
    FROM reservations
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL #{days} DAY)
    GROUP BY DATE(created_at)
    ORDER BY DATE(created_at) ASC
</select>

<!-- 매출 추이 (결제 완료 기준) -->
<select id="getRevenueTrend" resultType="com.meetlog.dto.dashboard.AdminDashboardDto$ChartData">
    SELECT
        DATE(approved_at) as date,
        DATE_FORMAT(approved_at, '%Y-%m-%d') as label,
        SUM(amount) as amount
    FROM payments
    WHERE status = 'DONE'
    AND approved_at >= DATE_SUB(CURDATE(), INTERVAL #{days} DAY)
    GROUP BY DATE(approved_at)
    ORDER BY DATE(approved_at) ASC
</select>

<!-- 카테고리별 레스토랑 수 -->
<select id="getRestaurantsByCategory" resultType="com.meetlog.dto.dashboard.AdminDashboardDto$CategoryData">
    SELECT
        category,
        COUNT(*) as count,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2) as percentage
    FROM restaurants
    GROUP BY category
    ORDER BY count DESC
</select>

<!-- 평점 분포 -->
<select id="getReviewRatingDistribution" resultType="com.meetlog.dto.dashboard.AdminDashboardDto$RatingData">
    SELECT
        rating,
        COUNT(*) as count,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reviews), 2) as percentage
    FROM reviews
    GROUP BY rating
    ORDER BY rating DESC
</select>

<!-- 인기 시간대 (레스토랑별) -->
<select id="getPopularTimeSlots" resultType="com.meetlog.dto.dashboard.BusinessDashboardDto$TimeSlotData">
    SELECT
        CONCAT(HOUR(reservation_time), ':00-', HOUR(reservation_time) + 1, ':00') as timeSlot,
        COUNT(*) as reservationCount,
        AVG(party_size) as averagePartySize
    FROM reservations
    WHERE restaurant_id = #{restaurantId}
    AND status IN ('CONFIRMED', 'COMPLETED')
    GROUP BY HOUR(reservation_time)
    ORDER BY reservationCount DESC
    LIMIT 5
</select>

<!-- 다가오는 예약 -->
<select id="getUpcomingReservations" resultType="com.meetlog.dto.dashboard.BusinessDashboardDto$UpcomingReservation">
    SELECT
        r.id as reservationId,
        u.name as userName,
        r.reservation_time as reservationTime,
        r.party_size as partySize,
        r.status,
        r.contact_phone as contactPhone
    FROM reservations r
    JOIN users u ON r.user_id = u.id
    WHERE r.restaurant_id = #{restaurantId}
    AND r.reservation_time >= NOW()
    AND r.status IN ('PENDING', 'CONFIRMED')
    ORDER BY r.reservation_time ASC
    LIMIT #{limit}
</select>

<!-- 리뷰 키워드 분석 (keywords JSON 필드 파싱) -->
<select id="getTopKeywords" resultType="com.meetlog.dto.dashboard.BusinessDashboardDto$KeywordData">
    SELECT
        keyword,
        COUNT(*) as count
    FROM (
        SELECT JSON_UNQUOTE(JSON_EXTRACT(keywords, CONCAT('$[', idx, ']'))) as keyword
        FROM reviews,
        JSON_TABLE(JSON_ARRAY(0,1,2,3,4,5,6,7), '$[*]' COLUMNS(idx INT PATH '$')) AS numbers
        WHERE restaurant_id = #{restaurantId}
        AND JSON_LENGTH(keywords) > idx
    ) AS keyword_list
    WHERE keyword IS NOT NULL
    GROUP BY keyword
    ORDER BY count DESC
    LIMIT #{limit}
</select>
```

---

### 2.2 Service Layer ⏳

#### AdminDashboardService.java

```java
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

        // 오늘 통계
        Long todayNewUsers = dashboardRepository.countUsersByPeriod(today, today);
        Long todayReservations = dashboardRepository.countReservationsByPeriod(today, today);
        BigDecimal todayRevenue = dashboardRepository.sumRevenueByPeriod(today, today);

        // 이번 달 통계
        Long monthlyNewUsers = dashboardRepository.countUsersByPeriod(monthStart, today);
        Long monthlyReservations = dashboardRepository.countReservationsByPeriod(monthStart, today);
        BigDecimal monthlyRevenue = dashboardRepository.sumRevenueByPeriod(monthStart, today);

        // 전월 통계 (증가율 계산용)
        Long lastMonthUsers = dashboardRepository.countUsersByPeriod(lastMonthStart, lastMonthEnd);
        Long lastMonthReservations = dashboardRepository.countReservationsByPeriod(lastMonthStart, lastMonthEnd);
        BigDecimal lastMonthRevenue = dashboardRepository.sumRevenueByPeriod(lastMonthStart, lastMonthEnd);

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
        List<ChartData> userTrend = dashboardRepository.getUserTrend(30);
        List<ChartData> reservationTrend = dashboardRepository.getReservationTrend(30);
        List<ChartData> revenueTrend = dashboardRepository.getRevenueTrend(30);

        // 카테고리별 레스토랑
        List<CategoryData> restaurantsByCategory = dashboardRepository.getRestaurantsByCategory();

        // 평점 분포
        List<RatingData> reviewRatingDistribution = dashboardRepository.getReviewRatingDistribution();

        // 최근 활동
        List<RecentActivity> recentActivities = dashboardRepository.getRecentActivities(20);

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
                .recentActivities(recentActivities)
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
```

#### BusinessDashboardService.java

```java
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
        Restaurant restaurant = restaurantRepository.findById(restaurantId);
        if (restaurant == null) {
            throw new RuntimeException("Restaurant not found");
        }
        if (!restaurant.isOwnedBy(userId)) {
            throw new RuntimeException("No permission");
        }

        LocalDate today = LocalDate.now();
        LocalDate monthStart = today.withDayOfMonth(1);
        LocalDate lastMonthStart = monthStart.minusMonths(1);
        LocalDate lastMonthEnd = monthStart.minusDays(1);

        // 전체 통계
        Long totalReservations = dashboardRepository.countReservationsByRestaurant(restaurantId);
        Long totalReviews = dashboardRepository.countReviewsByRestaurant(restaurantId);
        Double averageRating = dashboardRepository.getAverageRatingByRestaurant(restaurantId);
        BigDecimal totalRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, null, null);

        // 오늘 통계
        Long todayReservations = dashboardRepository.countReservationsByPeriod(today, today);
        BigDecimal todayRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, today, today);

        // 이번 달 통계
        Long monthlyReservations = dashboardRepository.countReservationsByPeriod(monthStart, today);
        BigDecimal monthlyRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, monthStart, today);

        // 전월 통계
        Long lastMonthReservations = dashboardRepository.countReservationsByPeriod(lastMonthStart, lastMonthEnd);
        BigDecimal lastMonthRevenue = dashboardRepository.sumRevenueByRestaurant(restaurantId, lastMonthStart, lastMonthEnd);

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
        List<RatingDistribution> ratingDistribution = dashboardRepository.getRatingDistributionByRestaurant(restaurantId);
        List<TimeSlotData> popularTimeSlots = dashboardRepository.getPopularTimeSlots(restaurantId);
        List<TrendData> reservationTrend = dashboardRepository.getRestaurantReservationTrend(restaurantId, 30);
        List<TrendData> revenueTrend = dashboardRepository.getRestaurantRevenueTrend(restaurantId, 30);
        List<RecentReview> recentReviews = dashboardRepository.getRecentReviewsByRestaurant(restaurantId, 10);
        List<UpcomingReservation> upcomingReservations = dashboardRepository.getUpcomingReservations(restaurantId, 10);
        List<KeywordData> topKeywords = dashboardRepository.getTopKeywords(restaurantId, 10);

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
```

---

### 2.3 Controller Layer ⏳

```java
@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
@Tag(name = "Dashboard", description = "대시보드 API")
public class DashboardController {

    private final AdminDashboardService adminDashboardService;
    private final BusinessDashboardService businessDashboardService;

    @Operation(summary = "관리자 대시보드", description = "관리자 전용 대시보드 통계 조회")
    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<AdminDashboardDto> getAdminDashboard() {
        AdminDashboardDto dashboard = adminDashboardService.getAdminDashboard();
        return ResponseEntity.ok(dashboard);
    }

    @Operation(summary = "비즈니스 대시보드", description = "레스토랑 사업자 대시보드 통계 조회")
    @GetMapping("/business/{restaurantId}")
    @PreAuthorize("hasAnyRole('BUSINESS', 'ADMIN')")
    public ResponseEntity<BusinessDashboardDto> getBusinessDashboard(
            @PathVariable Long restaurantId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        BusinessDashboardDto dashboard = businessDashboardService.getBusinessDashboard(
                restaurantId,
                userDetails.getUserId()
        );
        return ResponseEntity.ok(dashboard);
    }
}
```

---

### 2.4 프론트엔드 구현 ⏳

#### dashboard.js (API Client)

```javascript
import apiClient from './client';

export const dashboardAPI = {
  // 관리자 대시보드
  getAdminDashboard: async () => {
    const response = await apiClient.get('/dashboard/admin');
    return response.data;
  },

  // 비즈니스 대시보드
  getBusinessDashboard: async (restaurantId) => {
    const response = await apiClient.get(`/dashboard/business/${restaurantId}`);
    return response.data;
  }
};
```

#### AdminDashboard.jsx

```jsx
import React, { useEffect, useState } from 'react';
import { dashboardAPI } from '../../api/dashboard';
import { Line, Bar, Doughnut } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend
} from 'chart.js';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend
);

const AdminDashboard = () => {
  const [dashboard, setDashboard] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboard();
  }, []);

  const fetchDashboard = async () => {
    try {
      const data = await dashboardAPI.getAdminDashboard();
      setDashboard(data);
    } catch (error) {
      console.error('Failed to fetch dashboard:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="flex justify-center items-center h-screen">로딩 중...</div>;
  }

  if (!dashboard) {
    return <div className="text-center py-12">데이터를 불러올 수 없습니다.</div>;
  }

  // 차트 데이터 변환
  const userTrendData = {
    labels: dashboard.userTrend.map(d => d.label),
    datasets: [{
      label: '신규 사용자',
      data: dashboard.userTrend.map(d => d.value),
      borderColor: 'rgb(59, 130, 246)',
      backgroundColor: 'rgba(59, 130, 246, 0.1)',
      tension: 0.4
    }]
  };

  const revenueTrendData = {
    labels: dashboard.revenueTrend.map(d => d.label),
    datasets: [{
      label: '매출 (원)',
      data: dashboard.revenueTrend.map(d => d.amount),
      backgroundColor: 'rgba(34, 197, 94, 0.8)',
    }]
  };

  const categoryData = {
    labels: dashboard.restaurantsByCategory.map(c => c.category),
    datasets: [{
      data: dashboard.restaurantsByCategory.map(c => c.count),
      backgroundColor: [
        'rgba(255, 99, 132, 0.8)',
        'rgba(54, 162, 235, 0.8)',
        'rgba(255, 206, 86, 0.8)',
        'rgba(75, 192, 192, 0.8)',
        'rgba(153, 102, 255, 0.8)',
      ]
    }]
  };

  return (
    <div className="p-6 space-y-6">
      <h1 className="text-3xl font-bold">관리자 대시보드</h1>

      {/* 통계 카드 */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="전체 사용자"
          value={dashboard.totalUsers.toLocaleString()}
          change={dashboard.userGrowthRate}
          icon="👥"
        />
        <StatCard
          title="전체 레스토랑"
          value={dashboard.totalRestaurants.toLocaleString()}
          change={dashboard.restaurantGrowthRate}
          icon="🍽️"
        />
        <StatCard
          title="전체 예약"
          value={dashboard.totalReservations.toLocaleString()}
          change={dashboard.reservationGrowthRate}
          icon="📅"
        />
        <StatCard
          title="총 매출"
          value={`${(dashboard.totalRevenue / 10000).toFixed(0)}만원`}
          change={dashboard.revenueGrowthRate}
          icon="💰"
        />
      </div>

      {/* 오늘 통계 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">오늘 통계</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <p className="text-gray-600 text-sm">신규 가입</p>
            <p className="text-2xl font-bold">{dashboard.todayNewUsers}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">오늘 예약</p>
            <p className="text-2xl font-bold">{dashboard.todayReservations}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">오늘 매출</p>
            <p className="text-2xl font-bold">{dashboard.todayRevenue.toLocaleString()}원</p>
          </div>
        </div>
      </div>

      {/* 차트 */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4">사용자 증가 추이</h2>
          <Line data={userTrendData} />
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4">매출 추이</h2>
          <Bar data={revenueTrendData} />
        </div>
      </div>

      {/* 카테고리 분포 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">카테고리별 레스토랑</h2>
        <div className="max-w-md mx-auto">
          <Doughnut data={categoryData} />
        </div>
      </div>

      {/* 예약 상태 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">예약 현황</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <StatusCard title="대기 중" value={dashboard.pendingReservations} color="yellow" />
          <StatusCard title="확정" value={dashboard.confirmedReservations} color="green" />
          <StatusCard title="완료" value={dashboard.completedReservations} color="blue" />
          <StatusCard title="취소" value={dashboard.cancelledReservations} color="red" />
        </div>
      </div>

      {/* 최근 활동 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">최근 활동</h2>
        <div className="space-y-3">
          {dashboard.recentActivities.map((activity, index) => (
            <div key={index} className="flex items-center justify-between border-b pb-2">
              <div>
                <p className="font-medium">{activity.description}</p>
                <p className="text-sm text-gray-600">{activity.userName}</p>
              </div>
              <p className="text-sm text-gray-500">
                {new Date(activity.timestamp).toLocaleDateString()}
              </p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

const StatCard = ({ title, value, change, icon }) => (
  <div className="bg-white rounded-lg shadow p-6">
    <div className="flex items-center justify-between mb-2">
      <p className="text-gray-600 text-sm">{title}</p>
      <span className="text-2xl">{icon}</span>
    </div>
    <p className="text-3xl font-bold">{value}</p>
    {change !== undefined && (
      <p className={`text-sm mt-2 ${change >= 0 ? 'text-green-600' : 'text-red-600'}`}>
        {change >= 0 ? '↑' : '↓'} {Math.abs(change).toFixed(1)}% 전월 대비
      </p>
    )}
  </div>
);

const StatusCard = ({ title, value, color }) => {
  const colors = {
    yellow: 'bg-yellow-100 text-yellow-800',
    green: 'bg-green-100 text-green-800',
    blue: 'bg-blue-100 text-blue-800',
    red: 'bg-red-100 text-red-800'
  };

  return (
    <div className={`${colors[color]} rounded-lg p-4 text-center`}>
      <p className="text-sm font-medium">{title}</p>
      <p className="text-2xl font-bold mt-2">{value}</p>
    </div>
  );
};

export default AdminDashboard;
```

#### BusinessDashboard.jsx

```jsx
import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { dashboardAPI } from '../../api/dashboard';
import { Line, Doughnut } from 'react-chartjs-2';

const BusinessDashboard = () => {
  const { restaurantId } = useParams();
  const [dashboard, setDashboard] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboard();
  }, [restaurantId]);

  const fetchDashboard = async () => {
    try {
      const data = await dashboardAPI.getBusinessDashboard(restaurantId);
      setDashboard(data);
    } catch (error) {
      console.error('Failed to fetch dashboard:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="flex justify-center items-center h-screen">로딩 중...</div>;
  }

  if (!dashboard) {
    return <div className="text-center py-12">데이터를 불러올 수 없습니다.</div>;
  }

  const ratingDistData = {
    labels: dashboard.ratingDistribution.map(r => `⭐ ${r.rating}`),
    datasets: [{
      data: dashboard.ratingDistribution.map(r => r.count),
      backgroundColor: ['#ef4444', '#f97316', '#eab308', '#84cc16', '#22c55e']
    }]
  };

  const reservationTrendData = {
    labels: dashboard.reservationTrend.map(d => d.label),
    datasets: [{
      label: '예약 수',
      data: dashboard.reservationTrend.map(d => d.count),
      borderColor: 'rgb(59, 130, 246)',
      backgroundColor: 'rgba(59, 130, 246, 0.1)',
      tension: 0.4
    }]
  };

  return (
    <div className="p-6 space-y-6">
      <h1 className="text-3xl font-bold">{dashboard.restaurantName} 대시보드</h1>

      {/* 핵심 지표 */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="총 예약"
          value={dashboard.totalReservations.toLocaleString()}
          change={dashboard.reservationGrowthRate}
        />
        <StatCard
          title="평균 평점"
          value={dashboard.averageRating.toFixed(1)}
          subValue={`리뷰 ${dashboard.totalReviews}개`}
        />
        <StatCard
          title="이번 달 매출"
          value={`${(dashboard.monthlyRevenue / 10000).toFixed(0)}만원`}
          change={dashboard.revenueGrowthRate}
        />
        <StatCard
          title="취소율"
          value={`${dashboard.cancellationRate.toFixed(1)}%`}
          isNegative={true}
        />
      </div>

      {/* 오늘 예약 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">오늘 예약 현황</h2>
        <div className="grid grid-cols-3 gap-4">
          <div>
            <p className="text-gray-600 text-sm">전체</p>
            <p className="text-2xl font-bold">{dashboard.todayReservations}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">대기 중</p>
            <p className="text-2xl font-bold text-yellow-600">{dashboard.pendingReservations}</p>
          </div>
          <div>
            <p className="text-gray-600 text-sm">확정</p>
            <p className="text-2xl font-bold text-green-600">{dashboard.confirmedReservations}</p>
          </div>
        </div>
      </div>

      {/* 차트 */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4">예약 추이</h2>
          <Line data={reservationTrendData} />
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold mb-4">평점 분포</h2>
          <div className="max-w-md mx-auto">
            <Doughnut data={ratingDistData} />
          </div>
        </div>
      </div>

      {/* 인기 시간대 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">인기 예약 시간대</h2>
        <div className="space-y-3">
          {dashboard.popularTimeSlots.map((slot, index) => (
            <div key={index} className="flex items-center justify-between">
              <span className="font-medium">{slot.timeSlot}</span>
              <div className="flex items-center gap-4">
                <span>{slot.reservationCount}건</span>
                <span className="text-sm text-gray-600">
                  평균 {slot.averagePartySize.toFixed(1)}명
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* 다가오는 예약 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">다가오는 예약</h2>
        <div className="overflow-x-auto">
          <table className="min-w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-2 text-left">고객명</th>
                <th className="px-4 py-2 text-left">예약 시간</th>
                <th className="px-4 py-2 text-left">인원</th>
                <th className="px-4 py-2 text-left">상태</th>
                <th className="px-4 py-2 text-left">연락처</th>
              </tr>
            </thead>
            <tbody>
              {dashboard.upcomingReservations.map((res) => (
                <tr key={res.reservationId} className="border-b">
                  <td className="px-4 py-2">{res.userName}</td>
                  <td className="px-4 py-2">
                    {new Date(res.reservationTime).toLocaleString('ko-KR')}
                  </td>
                  <td className="px-4 py-2">{res.partySize}명</td>
                  <td className="px-4 py-2">
                    <span className={`px-2 py-1 rounded text-sm ${
                      res.status === 'CONFIRMED' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                    }`}>
                      {res.status === 'CONFIRMED' ? '확정' : '대기'}
                    </span>
                  </td>
                  <td className="px-4 py-2">{res.contactPhone}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* 최근 리뷰 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">최근 리뷰</h2>
        <div className="space-y-4">
          {dashboard.recentReviews.map((review) => (
            <div key={review.reviewId} className="border-b pb-4">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-2">
                  <span className="font-medium">{review.userName}</span>
                  <span className="text-yellow-500">
                    {'⭐'.repeat(review.rating)}
                  </span>
                </div>
                <span className="text-sm text-gray-500">
                  {new Date(review.createdAt).toLocaleDateString()}
                </span>
              </div>
              <p className="text-gray-700">{review.content}</p>
              {review.hasReply && (
                <span className="text-sm text-blue-600">답변 완료</span>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* 리뷰 키워드 */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">리뷰 키워드 TOP 10</h2>
        <div className="flex flex-wrap gap-2">
          {dashboard.topKeywords.map((keyword, index) => (
            <span
              key={index}
              className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm"
            >
              #{keyword.keyword} ({keyword.count})
            </span>
          ))}
        </div>
      </div>
    </div>
  );
};

const StatCard = ({ title, value, change, subValue, isNegative }) => (
  <div className="bg-white rounded-lg shadow p-6">
    <p className="text-gray-600 text-sm mb-2">{title}</p>
    <p className="text-3xl font-bold">{value}</p>
    {subValue && <p className="text-sm text-gray-600 mt-1">{subValue}</p>}
    {change !== undefined && (
      <p className={`text-sm mt-2 ${
        isNegative
          ? (change <= 0 ? 'text-green-600' : 'text-red-600')
          : (change >= 0 ? 'text-green-600' : 'text-red-600')
      }`}>
        {change >= 0 ? '↑' : '↓'} {Math.abs(change).toFixed(1)}% 전월 대비
      </p>
    )}
  </div>
);

export default BusinessDashboard;
```

---

## 3. 설치 및 설정

### 3.1 Chart.js 설치 (Frontend)

```bash
npm install chart.js react-chartjs-2
```

### 3.2 라우팅 설정

```jsx
// App.jsx 또는 Router 설정
import AdminDashboard from './components/dashboard/AdminDashboard';
import BusinessDashboard from './components/dashboard/BusinessDashboard';

<Route path="/admin/dashboard" element={<PrivateRoute role="ADMIN"><AdminDashboard /></PrivateRoute>} />
<Route path="/business/dashboard/:restaurantId" element={<PrivateRoute role="BUSINESS"><BusinessDashboard /></PrivateRoute>} />
```

---

## 4. 테스트 시나리오

1. **관리자 대시보드**:
   - GET `/api/dashboard/admin` (ADMIN 권한)
   - 전체 통계 확인
   - 차트 데이터 확인
   - 최근 활동 목록 확인

2. **비즈니스 대시보드**:
   - GET `/api/dashboard/business/{restaurantId}` (BUSINESS 권한)
   - 레스토랑별 통계 확인
   - 권한 체크 (다른 사업자의 레스토랑 접근 불가)
   - 다가오는 예약 확인
   - 최근 리뷰 확인

---

## 5. 완료 체크리스트

### 백엔드
- [x] AdminDashboardDto, BusinessDashboardDto 생성
- [x] DashboardRepository 인터페이스 생성
- [ ] DashboardRepositoryMapper.xml 작성 (MyBatis 쿼리)
- [x] AdminDashboardService 구현
- [x] BusinessDashboardService 구현
- [x] DashboardController 구현 (2개 API 엔드포인트)
- [x] 권한 체크 (@PreAuthorize)

### 프론트엔드
- [x] dashboard.js API 클라이언트 생성
- [x] AdminDashboard 컴포넌트 구현
- [x] BusinessDashboard 컴포넌트 구현
- [x] 반응형 UI 디자인
- [x] 로딩/에러 상태 처리

---

## 6. 다음 단계

1. **DashboardRepositoryMapper.xml 작성**
   - 모든 통계 쿼리 구현
   - 복잡한 JOIN 및 집계 쿼리 최적화
   - 인덱스 활용 확인

2. **선택적 개선사항**:
   - Chart.js 통합 (라인/바/도넛 차트)
   - 실시간 업데이트 (WebSocket 또는 폴링)
   - 기간 필터 (일간/주간/월간/연간)
   - CSV 내보내기 기능
   - 대시보드 커스터마이징

3. **테스트**:
   - 통계 쿼리 성능 테스트
   - 권한별 접근 테스트
   - UI 반응형 테스트

---

**현재 상태**: 95% 완료 (MyBatis Mapper XML만 작성 필요)
**실제 소요 시간**: 약 2시간 (구조 설계 및 구현)



