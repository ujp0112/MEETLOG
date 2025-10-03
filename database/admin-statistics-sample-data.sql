-- =====================================================
-- 관리자 대시보드 통계용 샘플 데이터
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 1. inquiries 테이블 기존 데이터 업데이트
-- =====================================================

-- 기존 inquiries 데이터에 category, priority 추가
UPDATE inquiries SET
    category = CASE
        WHEN subject LIKE '%예약%' THEN 'RESERVATION'
        WHEN subject LIKE '%결제%' OR subject LIKE '%환불%' THEN 'PAYMENT'
        WHEN subject LIKE '%로그인%' OR subject LIKE '%오류%' THEN 'TECHNICAL'
        ELSE 'GENERAL'
    END,
    priority = CASE
        WHEN status = 'PENDING' AND created_at < DATE_SUB(NOW(), INTERVAL 24 HOUR) THEN 'HIGH'
        WHEN status = 'IN_PROGRESS' THEN 'MEDIUM'
        ELSE 'LOW'
    END
WHERE category IS NULL OR category = 'GENERAL';

-- 응답 시간 계산 (resolved 건만)
UPDATE inquiries SET
    response_time_hours = TIMESTAMPDIFF(HOUR, created_at, updated_at),
    resolved_at = CASE WHEN status = 'RESOLVED' THEN updated_at ELSE NULL END
WHERE status = 'RESOLVED' AND response_time_hours IS NULL;

-- =====================================================
-- 2. 고객 만족도 샘플 데이터
-- =====================================================

INSERT INTO inquiry_satisfaction (inquiry_id, rating, comment)
SELECT
    inquiry_id,
    FLOOR(3 + RAND() * 3) as rating,  -- 3~5점 랜덤
    CASE
        WHEN RAND() > 0.7 THEN '친절한 답변 감사합니다'
        WHEN RAND() > 0.4 THEN '빠른 해결 감사드립니다'
        ELSE NULL
    END
FROM inquiries
WHERE status = 'RESOLVED'
LIMIT 50
ON DUPLICATE KEY UPDATE rating=rating;

-- =====================================================
-- 3. 월별 통계 데이터 (최근 6개월)
-- =====================================================

INSERT INTO monthly_statistics (`year_month`, total_users, new_users, total_restaurants, new_restaurants, total_reservations, total_revenue)
VALUES
    ('2024-09', 1200, 150, 450, 25, 3200, 48500000.00),
    ('2024-10', 1380, 180, 485, 35, 3850, 56200000.00),
    ('2024-11', 1590, 210, 528, 43, 4320, 62800000.00),
    ('2024-12', 1845, 255, 580, 52, 5100, 74500000.00),
    ('2025-01', 2140, 295, 645, 65, 5980, 87300000.00),
    ('2025-02', 2480, 340, 720, 75, 6750, 98600000.00)
ON DUPLICATE KEY UPDATE
    total_users=VALUES(total_users),
    new_users=VALUES(new_users),
    total_restaurants=VALUES(total_restaurants),
    new_restaurants=VALUES(new_restaurants),
    total_reservations=VALUES(total_reservations),
    total_revenue=VALUES(total_revenue);

-- =====================================================
-- 4. 카테고리별 통계 (최근 3개월)
-- =====================================================

INSERT INTO category_statistics (category_name, `year_month`, restaurant_count, reservation_count, revenue)
VALUES
    -- 2024-12
    ('한식', '2024-12', 180, 1850, 28500000.00),
    ('일식', '2024-12', 125, 1320, 21800000.00),
    ('중식', '2024-12', 95, 890, 13200000.00),
    ('양식', '2024-12', 110, 1040, 16500000.00),
    ('카페/디저트', '2024-12', 70, 450, 6800000.00),
    -- 2025-01
    ('한식', '2025-01', 195, 2150, 33200000.00),
    ('일식', '2025-01', 142, 1580, 26500000.00),
    ('중식', '2025-01', 108, 1020, 15800000.00),
    ('양식', '2025-01', 128, 1230, 19800000.00),
    ('카페/디저트', '2025-01', 82, 520, 7900000.00),
    -- 2025-02
    ('한식', '2025-02', 218, 2480, 38500000.00),
    ('일식', '2025-02', 165, 1850, 31200000.00),
    ('중식', '2025-02', 125, 1180, 18500000.00),
    ('양식', '2025-02', 145, 1420, 23100000.00),
    ('카페/디저트', '2025-02', 95, 600, 9200000.00)
ON DUPLICATE KEY UPDATE
    restaurant_count=VALUES(restaurant_count),
    reservation_count=VALUES(reservation_count),
    revenue=VALUES(revenue);

-- =====================================================
-- 5. 지역별 통계 (최근 3개월)
-- =====================================================

INSERT INTO regional_statistics (region, `year_month`, restaurant_count, reservation_count, revenue)
VALUES
    -- 2024-12
    ('서울', '2024-12', 285, 2850, 42500000.00),
    ('경기', '2024-12', 165, 1420, 19800000.00),
    ('부산', '2024-12', 78, 580, 8200000.00),
    ('대구', '2024-12', 52, 250, 4000000.00),
    -- 2025-01
    ('서울', '2025-01', 315, 3380, 51200000.00),
    ('경기', '2025-01', 195, 1720, 24500000.00),
    ('부산', '2025-01', 92, 680, 9800000.00),
    ('대구', '2025-01', 63, 320, 5100000.00),
    -- 2025-02
    ('서울', '2025-02', 352, 3920, 59800000.00),
    ('경기', '2025-02', 228, 2050, 28900000.00),
    ('부산', '2025-02', 108, 780, 11500000.00),
    ('대구', '2025-02', 72, 380, 6200000.00)
ON DUPLICATE KEY UPDATE
    restaurant_count=VALUES(restaurant_count),
    reservation_count=VALUES(reservation_count),
    revenue=VALUES(revenue);

-- =====================================================
-- 6. 지점 월별 성과 (branches 테이블이 있다고 가정)
-- =====================================================

-- branch_id 1~5번 지점 최근 3개월 데이터
INSERT INTO branch_monthly_performance (branch_id, `year_month`, employee_count, customer_count, reservation_count, revenue, rating)
VALUES
    -- 2024-12
    (1, '2024-12', 25, 1850, 520, 15800000.00, 4.65),
    (2, '2024-12', 18, 1320, 385, 11200000.00, 4.52),
    (3, '2024-12', 22, 1580, 450, 13500000.00, 4.58),
    (4, '2024-12', 15, 980, 280, 8900000.00, 4.45),
    (5, '2024-12', 20, 1420, 410, 12500000.00, 4.61),
    -- 2025-01
    (1, '2025-01', 26, 2150, 615, 19200000.00, 4.68),
    (2, '2025-01', 19, 1580, 465, 14100000.00, 4.55),
    (3, '2025-01', 23, 1820, 528, 16800000.00, 4.62),
    (4, '2025-01', 16, 1150, 335, 10800000.00, 4.48),
    (5, '2025-01', 21, 1680, 485, 15200000.00, 4.64),
    -- 2025-02
    (1, '2025-02', 27, 2520, 720, 23500000.00, 4.72),
    (2, '2025-02', 20, 1850, 548, 17200000.00, 4.59),
    (3, '2025-02', 24, 2120, 615, 20500000.00, 4.66),
    (4, '2025-02', 17, 1350, 395, 13200000.00, 4.51),
    (5, '2025-02', 22, 1980, 575, 18800000.00, 4.68)
ON DUPLICATE KEY UPDATE
    employee_count=VALUES(employee_count),
    customer_count=VALUES(customer_count),
    reservation_count=VALUES(reservation_count),
    revenue=VALUES(revenue),
    rating=VALUES(rating);

-- =====================================================
-- 7. 일별 활동 통계 (최근 30일)
-- =====================================================

-- 최근 30일치 데이터 생성 (동적)
INSERT INTO daily_activity_stats (stat_date, reviews_count, courses_created_count, wishlist_saves_count, new_follows_count, active_users_count, new_users_count)
SELECT
    DATE_SUB(CURDATE(), INTERVAL n DAY) as stat_date,
    FLOOR(50 + RAND() * 100) as reviews_count,
    FLOOR(10 + RAND() * 30) as courses_created_count,
    FLOOR(20 + RAND() * 50) as wishlist_saves_count,
    FLOOR(30 + RAND() * 70) as new_follows_count,
    FLOOR(500 + RAND() * 500) as active_users_count,
    FLOOR(10 + RAND() * 20) as new_users_count
FROM (
    SELECT 0 as n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL
    SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL
    SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL
    SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
    SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29
) as numbers
ON DUPLICATE KEY UPDATE
    reviews_count=VALUES(reviews_count),
    active_users_count=VALUES(active_users_count);

-- =====================================================
-- 8. 지점 샘플 데이터 (성과 데이터를 위한 기본 지점)
-- =====================================================

INSERT INTO branches (branch_name, status, address, phone)
VALUES
    ('강남점', 'ACTIVE', '서울시 강남구 테헤란로 123', '02-1234-5678'),
    ('홍대점', 'ACTIVE', '서울시 마포구 와우산로 45', '02-2345-6789'),
    ('판교점', 'ACTIVE', '경기도 성남시 분당구 판교역로 235', '031-3456-7890'),
    ('부산점', 'ACTIVE', '부산시 해운대구 해운대로 567', '051-4567-8901'),
    ('대구점', 'ACTIVE', '대구시 중구 동성로 89', '053-5678-9012')
ON DUPLICATE KEY UPDATE branch_name=branch_name;

-- =====================================================
-- 9. 맛집 인기도 (최근 4주, 상위 맛집만)
-- =====================================================

-- 이번 주 시작일 계산 (월요일 기준)
SET @this_monday = DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY);

INSERT INTO restaurant_popularity (restaurant_id, week_start_date, reservation_count, review_count, rating, reservation_growth_rate)
SELECT
    r.id as restaurant_id,
    @this_monday as week_start_date,
    FLOOR(50 + RAND() * 150) as reservation_count,
    FLOOR(10 + RAND() * 30) as review_count,
    ROUND(3.5 + RAND() * 1.5, 2) as rating,
    ROUND(-20 + RAND() * 60, 2) as reservation_growth_rate
FROM restaurants r
WHERE r.id <= 20  -- 상위 20개 맛집만
ON DUPLICATE KEY UPDATE
    reservation_count=VALUES(reservation_count),
    review_count=VALUES(review_count);

-- 전주 데이터
INSERT INTO restaurant_popularity (restaurant_id, week_start_date, reservation_count, review_count, rating, reservation_growth_rate)
SELECT
    r.id as restaurant_id,
    DATE_SUB(@this_monday, INTERVAL 7 DAY) as week_start_date,
    FLOOR(40 + RAND() * 130) as reservation_count,
    FLOOR(8 + RAND() * 25) as review_count,
    ROUND(3.4 + RAND() * 1.5, 2) as rating,
    ROUND(-15 + RAND() * 50, 2) as reservation_growth_rate
FROM restaurants r
WHERE r.id <= 20
ON DUPLICATE KEY UPDATE
    reservation_count=VALUES(reservation_count);

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 데이터 확인 쿼리
-- =====================================================

-- SELECT '=== 월별 통계 ===' as '';
-- SELECT * FROM monthly_statistics ORDER BY year_month DESC;

-- SELECT '=== 카테고리별 통계 (최근월) ===' as '';
-- SELECT * FROM category_statistics WHERE year_month = '2025-02' ORDER BY revenue DESC;

-- SELECT '=== 지역별 통계 (최근월) ===' as '';
-- SELECT * FROM regional_statistics WHERE year_month = '2025-02' ORDER BY revenue DESC;

-- SELECT '=== 일별 활동 (최근 7일) ===' as '';
-- SELECT * FROM daily_activity_stats ORDER BY stat_date DESC LIMIT 7;

-- SELECT '=== 인기 맛집 (이번주) ===' as '';
-- SELECT rp.*, r.name FROM restaurant_popularity rp
-- JOIN restaurants r ON rp.restaurant_id = r.id
-- WHERE week_start_date = DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)
-- ORDER BY reservation_count DESC LIMIT 10;
