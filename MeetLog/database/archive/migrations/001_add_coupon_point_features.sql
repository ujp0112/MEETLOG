-- Migration: 쿠폰 기능 개선 및 포인트 시스템 추가
-- 작성일: 2025-10-11
-- 설명: reservations 테이블에 포인트 컬럼 추가, 쿠폰 사용 로그 테이블, 포인트 시스템 테이블 생성

-- 1. reservations 테이블 확인 (points_used, points_earned 컬럼 이미 존재)
-- Skip: points_used, points_earned columns already exist

-- 2. 쿠폰 사용 로그 테이블 생성 (상세 이력 추적용)
CREATE TABLE IF NOT EXISTS coupon_usage_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_coupon_id INT NOT NULL COMMENT '사용자 쿠폰 ID',
  reservation_id INT NULL COMMENT '예약 ID',
  action ENUM('USE', 'ROLLBACK') NOT NULL COMMENT '액션 타입',
  discount_amount DECIMAL(10,2) NOT NULL COMMENT '할인 금액',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_coupon_id) REFERENCES user_coupons(id) ON DELETE CASCADE,
  FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
  INDEX idx_user_coupon (user_coupon_id),
  INDEX idx_reservation (reservation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='쿠폰 사용 및 롤백 로그';

-- 3. 사용자 포인트 잔액 테이블
CREATE TABLE IF NOT EXISTS user_points (
  user_id INT PRIMARY KEY COMMENT '사용자 ID',
  balance INT NOT NULL DEFAULT 0 COMMENT '현재 포인트 잔액',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 업데이트 시각',
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT chk_balance_positive CHECK (balance >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='사용자별 포인트 잔액';

-- 4. 포인트 거래 내역 테이블
CREATE TABLE IF NOT EXISTS point_transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL COMMENT '사용자 ID',
  change_amount INT NOT NULL COMMENT '변동 포인트 (양수: 적립, 음수: 차감)',
  type ENUM('EARN', 'REDEEM', 'REFUND', 'EXPIRE', 'ADMIN') NOT NULL COMMENT '거래 유형',
  reference_type ENUM('RESERVATION', 'REVIEW', 'PAYMENT', 'CANCEL', 'MANUAL') NULL COMMENT '참조 타입',
  reference_id BIGINT NULL COMMENT '참조 ID (예약 ID, 리뷰 ID 등)',
  balance_after INT NOT NULL COMMENT '거래 후 잔액 (검증용)',
  expires_at DATE NULL COMMENT '만료일 (적립 시에만 설정)',
  memo VARCHAR(500) NULL COMMENT '메모',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성 시각',
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_created (user_id, created_at DESC),
  INDEX idx_expires (expires_at),
  INDEX idx_reference (reference_type, reference_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='포인트 거래 내역';

-- 5. 기존 사용자에 대한 포인트 계정 초기화 (선택 사항)
INSERT INTO user_points (user_id, balance)
SELECT id, 0 FROM users
WHERE id NOT IN (SELECT user_id FROM user_points)
ON DUPLICATE KEY UPDATE balance = balance;

-- 완료
SELECT 'Migration 001_add_coupon_point_features.sql completed successfully' AS status;
