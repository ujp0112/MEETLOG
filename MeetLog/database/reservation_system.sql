-- ===================================================================
-- 예약 설정 시스템 데이터베이스 스키마
-- ===================================================================

-- 외래 키 제약 조건 임시 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- 1. 기본 예약 설정 테이블
-- ===================================================================
DROP TABLE IF EXISTS reservation_settings;

CREATE TABLE reservation_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    auto_accept BOOLEAN DEFAULT FALSE COMMENT '자동 승인 여부',
    max_advance_days INT DEFAULT 30 COMMENT '최대 예약 가능 일수',
    min_advance_hours INT DEFAULT 2 COMMENT '최소 예약 시간 (몇 시간 전까지)',
    max_party_size INT DEFAULT 8 COMMENT '최대 인원수',
    time_slot_interval INT DEFAULT 30 COMMENT '시간 간격 (분 단위)',
    special_instructions TEXT COMMENT '특별 안내사항',
    deposit_required BOOLEAN DEFAULT FALSE COMMENT '예약금 필요 여부',
    deposit_amount DECIMAL(10,2) DEFAULT 0 COMMENT '예약금 금액',
    allow_waiting_list BOOLEAN DEFAULT FALSE COMMENT '대기 예약 허용',
    max_waiting_list INT DEFAULT 5 COMMENT '최대 대기 인원',
    send_sms_confirmation BOOLEAN DEFAULT TRUE COMMENT 'SMS 확정 알림',
    penalty_for_noshow BOOLEAN DEFAULT FALSE COMMENT '노쇼 패널티',
    is_active BOOLEAN DEFAULT TRUE COMMENT '활성화 상태',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- 인덱스 및 제약조건
    UNIQUE KEY unique_restaurant_setting (restaurant_id),
    CONSTRAINT fk_reservation_settings_restaurant
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    -- 데이터 유효성 검증
    CONSTRAINT chk_max_advance_days CHECK (max_advance_days > 0 AND max_advance_days <= 365),
    CONSTRAINT chk_min_advance_hours CHECK (min_advance_hours >= 0 AND min_advance_hours <= 168),
    CONSTRAINT chk_max_party_size CHECK (max_party_size > 0 AND max_party_size <= 50),
    CONSTRAINT chk_time_slot_interval CHECK (time_slot_interval IN (15, 30, 60)),
    CONSTRAINT chk_deposit_amount CHECK (deposit_amount >= 0 AND deposit_amount <= 1000000),
    CONSTRAINT chk_max_waiting_list CHECK (max_waiting_list >= 0 AND max_waiting_list <= 20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='예약 설정 기본 정보';

-- ===================================================================
-- 2. 요일별 운영시간 테이블
-- ===================================================================
DROP TABLE IF EXISTS reservation_operating_hours;

CREATE TABLE reservation_operating_hours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    settings_id INT NOT NULL,
    day_of_week ENUM('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY') NOT NULL,
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '해당 요일 예약 활성화',
    start_time TIME NOT NULL COMMENT '예약 시작 시간',
    end_time TIME NOT NULL COMMENT '예약 종료 시간',
    break_start_time TIME NULL COMMENT '브레이크 시작 시간',
    break_end_time TIME NULL COMMENT '브레이크 종료 시간',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- 인덱스 및 제약조건
    UNIQUE KEY unique_settings_day (settings_id, day_of_week),
    CONSTRAINT fk_operating_hours_settings
        FOREIGN KEY (settings_id) REFERENCES reservation_settings(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    -- 시간 유효성 검증
    CONSTRAINT chk_time_order CHECK (start_time < end_time),
    CONSTRAINT chk_break_time_order CHECK (
        (break_start_time IS NULL AND break_end_time IS NULL) OR
        (break_start_time IS NOT NULL AND break_end_time IS NOT NULL AND break_start_time < break_end_time)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='요일별 예약 가능 시간';

-- ===================================================================
-- 3. 예약 불가 날짜 테이블
-- ===================================================================
DROP TABLE IF EXISTS reservation_blackout_dates;

CREATE TABLE reservation_blackout_dates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    blackout_date DATE NOT NULL COMMENT '예약 불가 날짜',
    reason VARCHAR(255) COMMENT '불가 사유',
    is_active BOOLEAN DEFAULT TRUE COMMENT '활성화 상태',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- 인덱스 및 제약조건
    KEY idx_blackout_restaurant_date (restaurant_id, blackout_date),
    UNIQUE KEY unique_restaurant_blackout_date (restaurant_id, blackout_date, is_active),
    CONSTRAINT fk_blackout_restaurant
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    -- 날짜 유효성 검증
    CONSTRAINT chk_blackout_date_future CHECK (blackout_date >= CURDATE())
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='예약 불가 날짜 관리';

-- ===================================================================
-- 4. 테이블 관리 (추가 기능)
-- ===================================================================
DROP TABLE IF EXISTS restaurant_tables;

CREATE TABLE restaurant_tables (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    table_name VARCHAR(50) NOT NULL COMMENT '테이블명',
    table_number INT NOT NULL COMMENT '테이블 번호',
    capacity INT NOT NULL COMMENT '수용 인원',
    table_type ENUM('REGULAR', 'VIP', 'PRIVATE', 'BAR') DEFAULT 'REGULAR' COMMENT '테이블 유형',
    is_active BOOLEAN DEFAULT TRUE COMMENT '사용 가능 여부',
    notes TEXT COMMENT '특이사항',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- 인덱스 및 제약조건
    UNIQUE KEY unique_restaurant_table_number (restaurant_id, table_number),
    KEY idx_restaurant_capacity (restaurant_id, capacity),
    CONSTRAINT fk_table_restaurant
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    -- 데이터 유효성 검증
    CONSTRAINT chk_table_number CHECK (table_number > 0 AND table_number <= 999),
    CONSTRAINT chk_table_capacity CHECK (capacity > 0 AND capacity <= 20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='음식점 테이블 관리';

-- ===================================================================
-- 5. 기본 데이터 삽입
-- ===================================================================

-- 기존 음식점들에 대한 기본 예약 설정 생성 (안전한 삽입)
INSERT IGNORE INTO reservation_settings (restaurant_id)
SELECT id FROM restaurants
WHERE NOT EXISTS (
    SELECT 1 FROM reservation_settings rs WHERE rs.restaurant_id = restaurants.id
);

-- 기본 운영시간 설정 (월~일, 11:00-21:00)
INSERT IGNORE INTO reservation_operating_hours (settings_id, day_of_week, start_time, end_time)
SELECT rs.id, days.day_name, '11:00:00', '21:00:00'
FROM reservation_settings rs
CROSS JOIN (
    SELECT 'MONDAY' as day_name UNION ALL
    SELECT 'TUESDAY' UNION ALL
    SELECT 'WEDNESDAY' UNION ALL
    SELECT 'THURSDAY' UNION ALL
    SELECT 'FRIDAY' UNION ALL
    SELECT 'SATURDAY' UNION ALL
    SELECT 'SUNDAY'
) days
WHERE NOT EXISTS (
    SELECT 1 FROM reservation_operating_hours roh
    WHERE roh.settings_id = rs.id AND roh.day_of_week = days.day_name
);

-- 외래 키 제약 조건 재활성화
SET FOREIGN_KEY_CHECKS = 1;

-- ===================================================================
-- 테이블 정보 확인 쿼리 (참고용)
-- ===================================================================
/*
-- 예약 설정 확인
SELECT rs.*, r.name as restaurant_name
FROM reservation_settings rs
JOIN restaurants r ON rs.restaurant_id = r.id;

-- 운영시간 확인
SELECT roh.*, rs.restaurant_id
FROM reservation_operating_hours roh
JOIN reservation_settings rs ON roh.settings_id = rs.id;

-- 예약 불가 날짜 확인
SELECT rbd.*, r.name as restaurant_name
FROM reservation_blackout_dates rbd
JOIN restaurants r ON rbd.restaurant_id = r.id;
*/