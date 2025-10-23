-- =====================================================
-- MeetLog - Payments 테이블 생성 스크립트
-- 결제 시스템 (Phase 7)
-- =====================================================

-- payments 테이블 (결제 정보 저장)
CREATE TABLE IF NOT EXISTS payments (
    -- 기본 정보
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '결제 ID',
    payment_type VARCHAR(50) NOT NULL COMMENT '결제 유형 (RESERVATION, COURSE_RESERVATION)',
    reference_id BIGINT NOT NULL COMMENT '참조 ID (reservation_id 또는 course_reservation_id)',
    user_id INT(11) NOT NULL COMMENT '결제 사용자 ID',

    -- 결제 정보
    order_id VARCHAR(100) NOT NULL UNIQUE COMMENT '주문 ID (고유 식별자)',
    order_name VARCHAR(255) NOT NULL COMMENT '주문명',
    amount DECIMAL(15, 2) NOT NULL COMMENT '결제 금액',
    currency VARCHAR(10) DEFAULT 'KRW' COMMENT '통화 (KRW, USD 등)',

    -- 결제 수단
    payment_method VARCHAR(50) COMMENT '결제 수단 (CARD, VIRTUAL_ACCOUNT, TRANSFER, MOBILE_PHONE, etc.)',
    provider VARCHAR(50) COMMENT '결제 제공자 (TOSS, KAKAO, NAVER 등)',

    -- 결제 상태
    status VARCHAR(50) NOT NULL DEFAULT 'READY' COMMENT '결제 상태 (READY, IN_PROGRESS, DONE, CANCELED, PARTIAL_CANCELED, ABORTED, EXPIRED)',
    payment_key VARCHAR(255) COMMENT '결제 승인 키 (PG사 제공)',

    -- 승인/취소 정보
    requested_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '결제 요청 시각',
    approved_at DATETIME COMMENT '결제 승인 시각',
    canceled_at DATETIME COMMENT '결제 취소 시각',
    cancel_reason VARCHAR(500) COMMENT '취소 사유',

    -- 환불 정보
    refund_amount DECIMAL(15, 2) DEFAULT 0.00 COMMENT '환불 금액',
    refund_status VARCHAR(20) DEFAULT 'NONE' COMMENT '환불 상태 (NONE, PARTIAL, FULL)',

    -- 메타 정보
    raw_response TEXT COMMENT 'PG사 응답 원본 (JSON)',
    fail_reason VARCHAR(500) COMMENT '실패 사유',

    -- 타임스탬프
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성 시각',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 시각',

    -- 외래 키
    CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

    -- 인덱스
    INDEX idx_payment_user (user_id),
    INDEX idx_payment_type_ref (payment_type, reference_id),
    INDEX idx_payment_status (status),
    INDEX idx_payment_order_id (order_id),
    INDEX idx_payment_approved_at (approved_at),
    INDEX idx_payment_requested_at (requested_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='결제 정보 테이블';

-- =====================================================
-- 테이블 생성 확인
-- =====================================================
SELECT 'payments 테이블이 성공적으로 생성되었습니다.' AS message;

-- 테이블 구조 확인
DESCRIBE payments;

-- =====================================================
-- 샘플 데이터 (선택 사항)
-- =====================================================

-- 예약 결제 예시 (완료)
INSERT INTO payments (
    payment_type, reference_id, user_id, order_id, order_name, amount, currency,
    payment_method, provider, status, payment_key, requested_at, approved_at
) VALUES (
    'RESERVATION',
    1,
    1,
    CONCAT('ORDER_', DATE_FORMAT(NOW(), '%Y%m%d'), '_', FLOOR(RAND() * 1000000)),
    '강남 레스토랑 예약 결제',
    50000.00,
    'KRW',
    'CARD',
    'TOSS',
    'DONE',
    'toss_payment_key_123456',
    NOW(),
    NOW()
);

-- 예약 결제 예시 (대기 중)
INSERT INTO payments (
    payment_type, reference_id, user_id, order_id, order_name, amount, currency,
    payment_method, provider, status, requested_at
) VALUES (
    'RESERVATION',
    2,
    2,
    CONCAT('ORDER_', DATE_FORMAT(NOW(), '%Y%m%d'), '_', FLOOR(RAND() * 1000000)),
    '홍대 레스토랑 예약 결제',
    80000.00,
    'KRW',
    'VIRTUAL_ACCOUNT',
    'TOSS',
    'READY',
    NOW()
);

-- 코스 예약 결제 예시 (완료)
INSERT INTO payments (
    payment_type, reference_id, user_id, order_id, order_name, amount, currency,
    payment_method, provider, status, payment_key, requested_at, approved_at
) VALUES (
    'COURSE_RESERVATION',
    1,
    3,
    CONCAT('ORDER_', DATE_FORMAT(NOW(), '%Y%m%d'), '_', FLOOR(RAND() * 1000000)),
    '서울 맛집 투어 코스 결제',
    150000.00,
    'KRW',
    'CARD',
    'TOSS',
    'DONE',
    'toss_payment_key_789012',
    NOW(),
    NOW()
);

-- 취소된 결제 예시
INSERT INTO payments (
    payment_type, reference_id, user_id, order_id, order_name, amount, currency,
    payment_method, provider, status, payment_key, requested_at, approved_at, canceled_at, cancel_reason, refund_amount, refund_status
) VALUES (
    'RESERVATION',
    3,
    1,
    CONCAT('ORDER_', DATE_FORMAT(NOW(), '%Y%m%d'), '_', FLOOR(RAND() * 1000000)),
    '신촌 레스토랑 예약 결제 (취소됨)',
    60000.00,
    'KRW',
    'CARD',
    'TOSS',
    'CANCELED',
    'toss_payment_key_345678',
    DATE_SUB(NOW(), INTERVAL 5 DAY),
    DATE_SUB(NOW(), INTERVAL 5 DAY),
    DATE_SUB(NOW(), INTERVAL 3 DAY),
    '예약 취소',
    60000.00,
    'FULL'
);

SELECT 'payments 샘플 데이터가 삽입되었습니다.' AS message;

-- 데이터 확인
SELECT
    id,
    payment_type,
    order_id,
    order_name,
    amount,
    status,
    payment_method,
    provider,
    DATE_FORMAT(requested_at, '%Y-%m-%d %H:%i:%s') as requested_at,
    DATE_FORMAT(approved_at, '%Y-%m-%d %H:%i:%s') as approved_at
FROM payments
ORDER BY id;

-- =====================================================
-- 인덱스 효율성 확인
-- =====================================================
SHOW INDEX FROM payments;

-- =====================================================
-- 통계 정보 확인
-- =====================================================
SELECT
    COUNT(*) as total_payments,
    SUM(CASE WHEN status = 'DONE' THEN 1 ELSE 0 END) as completed_payments,
    SUM(CASE WHEN status = 'CANCELED' THEN 1 ELSE 0 END) as canceled_payments,
    SUM(CASE WHEN status = 'READY' THEN 1 ELSE 0 END) as pending_payments,
    SUM(CASE WHEN status = 'DONE' THEN amount ELSE 0 END) as total_revenue
FROM payments;
