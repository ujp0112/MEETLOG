-- =====================================================
-- 관리자 대시보드 통계용 테이블 스키마
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 1. 고객 지원 관련 테이블
-- =====================================================

-- 기존 inquiries 테이블 확장 (ALTER로 필드 추가)
ALTER TABLE inquiries
ADD COLUMN IF NOT EXISTS category VARCHAR(50) DEFAULT 'GENERAL' COMMENT '문의 카테고리: RESERVATION, PAYMENT, TECHNICAL, GENERAL',
ADD COLUMN IF NOT EXISTS priority ENUM('HIGH', 'MEDIUM', 'LOW') DEFAULT 'MEDIUM' COMMENT '우선순위',
ADD COLUMN IF NOT EXISTS response_time_hours DECIMAL(10,2) COMMENT '응답 시간(시간)',
ADD COLUMN IF NOT EXISTS resolved_at DATETIME COMMENT '해결 완료 시각';

-- 고객 만족도 테이블
CREATE TABLE IF NOT EXISTS inquiry_satisfaction (
    satisfaction_id INT PRIMARY KEY AUTO_INCREMENT,
    inquiry_id INT NOT NULL,
    rating INT NOT NULL COMMENT '1~5점 만족도',
    comment TEXT COMMENT '만족도 코멘트',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (inquiry_id) REFERENCES inquiries(inquiry_id) ON DELETE CASCADE,
    INDEX idx_rating (rating),
    INDEX idx_created (created_at),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='고객 문의 만족도';

-- =====================================================
-- 2. 통계 집계 테이블 (성능 최적화)
-- =====================================================

-- 월별 종합 통계 스냅샷
CREATE TABLE IF NOT EXISTS monthly_statistics (
    stat_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    `year_month` VARCHAR(7) NOT NULL COMMENT 'YYYY-MM 형식',
    total_users INT DEFAULT 0 COMMENT '누적 총 회원 수',
    new_users INT DEFAULT 0 COMMENT '해당 월 신규 가입자',
    total_restaurants INT DEFAULT 0 COMMENT '누적 총 맛집 수',
    new_restaurants INT DEFAULT 0 COMMENT '해당 월 신규 등록 맛집',
    total_reservations INT DEFAULT 0 COMMENT '해당 월 예약 건수',
    total_revenue DECIMAL(15,2) DEFAULT 0 COMMENT '해당 월 총 매출',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_year_month (`year_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='월별 종합 통계';

-- 카테고리별 월별 통계
CREATE TABLE IF NOT EXISTS category_statistics (
    category_stat_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL COMMENT '카테고리명',
    `year_month` VARCHAR(7) NOT NULL,
    restaurant_count INT DEFAULT 0 COMMENT '해당 카테고리 맛집 수',
    reservation_count INT DEFAULT 0 COMMENT '예약 건수',
    revenue DECIMAL(15,2) DEFAULT 0 COMMENT '매출',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_category_month (category_name, `year_month`),
    INDEX idx_year_month (`year_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='카테고리별 통계';

-- 지역별 월별 통계
CREATE TABLE IF NOT EXISTS regional_statistics (
    regional_stat_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    region VARCHAR(100) NOT NULL COMMENT '지역명 (시/도 단위)',
    `year_month` VARCHAR(7) NOT NULL,
    restaurant_count INT DEFAULT 0,
    reservation_count INT DEFAULT 0,
    revenue DECIMAL(15,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_region_month (region, `year_month`),
    INDEX idx_year_month (`year_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지역별 통계';

-- =====================================================
-- 3. 지점 성과 관련 테이블
-- =====================================================

-- 지점 기본 정보 테이블
CREATE TABLE IF NOT EXISTS branches (
    branch_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(200) NOT NULL COMMENT '지점명',
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE' COMMENT '운영 상태',
    address VARCHAR(500) COMMENT '주소',
    phone VARCHAR(20) COMMENT '전화번호',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 정보';

-- 지점 월별 성과 테이블
CREATE TABLE IF NOT EXISTS branch_monthly_performance (
    performance_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    branch_id BIGINT NOT NULL,
    `year_month` VARCHAR(7) NOT NULL,
    employee_count INT DEFAULT 0 COMMENT '직원 수',
    customer_count INT DEFAULT 0 COMMENT '고객 수',
    reservation_count INT DEFAULT 0 COMMENT '예약 건수',
    revenue DECIMAL(15,2) DEFAULT 0 COMMENT '매출',
    rating DECIMAL(3,2) DEFAULT 0 COMMENT '평점 (1.00 ~ 5.00)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,
    UNIQUE KEY uk_branch_month (branch_id, `year_month`),
    INDEX idx_year_month (`year_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점별 월별 성과';

-- =====================================================
-- 4. 일별 활동 통계 테이블
-- =====================================================

-- 일별 활동 집계
CREATE TABLE IF NOT EXISTS daily_activity_stats (
    stat_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    stat_date DATE NOT NULL COMMENT '통계 날짜',
    reviews_count INT DEFAULT 0 COMMENT '당일 작성 리뷰 수',
    courses_created_count INT DEFAULT 0 COMMENT '당일 생성 코스 수',
    wishlist_saves_count INT DEFAULT 0 COMMENT '당일 위시리스트 저장 수',
    new_follows_count INT DEFAULT 0 COMMENT '당일 신규 팔로우 수',
    active_users_count INT DEFAULT 0 COMMENT '당일 활성 사용자 수',
    new_users_count INT DEFAULT 0 COMMENT '당일 신규 가입자 수',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_stat_date (stat_date),
    INDEX idx_stat_date (stat_date DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='일별 활동 통계';

-- =====================================================
-- 5. 맛집 인기도 테이블
-- =====================================================

-- 주별 맛집 인기도 스냅샷
CREATE TABLE IF NOT EXISTS restaurant_popularity (
    popularity_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    week_start_date DATE NOT NULL COMMENT '주 시작일 (월요일)',
    reservation_count INT DEFAULT 0 COMMENT '주간 예약 수',
    review_count INT DEFAULT 0 COMMENT '주간 리뷰 수',
    rating DECIMAL(3,2) DEFAULT 0 COMMENT '평점',
    reservation_growth_rate DECIMAL(5,2) DEFAULT 0 COMMENT '전주 대비 예약 증가율(%)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    UNIQUE KEY uk_restaurant_week (restaurant_id, week_start_date),
    INDEX idx_week_start (week_start_date DESC),
    INDEX idx_reservation_count (reservation_count DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='맛집 주별 인기도';

-- =====================================================
-- 6. 성능 최적화 인덱스
-- =====================================================

-- inquiries 테이블 추가 인덱스
CREATE INDEX IF NOT EXISTS idx_inquiries_status ON inquiries(status);
CREATE INDEX IF NOT EXISTS idx_inquiries_category ON inquiries(category);
CREATE INDEX IF NOT EXISTS idx_inquiries_priority ON inquiries(priority);
CREATE INDEX IF NOT EXISTS idx_inquiries_created ON inquiries(created_at DESC);

SET FOREIGN_KEY_CHECKS = 1;
