-- 쿠폰 테이블에 새로운 필드 추가
-- 기존 테이블 구조: id, restaurant_id, title, description, validity, is_active, created_at

ALTER TABLE coupons
ADD COLUMN discount_type ENUM('PERCENTAGE', 'FIXED') NULL AFTER description,
ADD COLUMN discount_value INT NULL AFTER discount_type,
ADD COLUMN min_order_amount INT NULL DEFAULT 0 AFTER discount_value,
ADD COLUMN valid_from DATE NULL AFTER min_order_amount,
ADD COLUMN valid_to DATE NULL AFTER valid_from,
ADD COLUMN usage_limit INT NULL AFTER valid_to,
ADD COLUMN per_user_limit INT NULL AFTER usage_limit,
ADD COLUMN usage_count INT NOT NULL DEFAULT 0 AFTER per_user_limit;

-- validity 컬럼은 호환성을 위해 유지 (valid_from ~ valid_to로 자동 생성될 수 있음)