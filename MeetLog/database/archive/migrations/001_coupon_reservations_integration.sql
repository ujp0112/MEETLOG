-- 쿠폰 기능 개선: reservations 테이블에 쿠폰 관련 컬럼 추가
-- 작성일: 2025-10-10
-- 목적: 예약-쿠폰 연동 및 할인 금액 추적

SET FOREIGN_KEY_CHECKS = 0;

-- 예약-쿠폰 매핑 (reservations 테이블에 FK 추가)
ALTER TABLE reservations
  ADD COLUMN user_coupon_id INT(11) NULL COMMENT '사용된 사용자 쿠폰 ID' AFTER deposit_amount,
  ADD COLUMN coupon_discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '쿠폰 할인 금액' AFTER user_coupon_id;

-- FK 제약조건 추가 (user_coupons 테이블이 존재하는 경우)
ALTER TABLE reservations
  ADD CONSTRAINT fk_reservations_user_coupon
    FOREIGN KEY (user_coupon_id) REFERENCES user_coupons(id) ON DELETE SET NULL;

-- 인덱스 추가 (조회 성능 향상)
ALTER TABLE reservations
  ADD INDEX idx_reservations_user_coupon (user_coupon_id);

-- 쿠폰 사용 로그 테이블 (선택 사항 - 상세 이력 추적용)
CREATE TABLE IF NOT EXISTS coupon_usage_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_coupon_id INT(11) NOT NULL COMMENT '사용자 쿠폰 ID',
  reservation_id INT(11) NULL COMMENT '관련 예약 ID',
  action ENUM('USE', 'ROLLBACK') NOT NULL COMMENT '동작 유형',
  discount_amount DECIMAL(10,2) NOT NULL COMMENT '할인 금액',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성 시각',
  FOREIGN KEY (user_coupon_id) REFERENCES user_coupons(id),
  FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='쿠폰 사용 이력 로그';

SET FOREIGN_KEY_CHECKS = 1;
