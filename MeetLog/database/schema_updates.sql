-- Schema updates for TODO implementations
-- Run this script to add missing database tables and columns

-- 1. Add coupon_usage_logs table
CREATE TABLE IF NOT EXISTS coupon_usage_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_coupon_id INT NOT NULL,
    reservation_id INT NULL,
    action VARCHAR(20) NOT NULL COMMENT 'USE or ROLLBACK',
    discount_amount DECIMAL(10, 2) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_coupon_id (user_coupon_id),
    INDEX idx_reservation_id (reservation_id),
    FOREIGN KEY (user_coupon_id) REFERENCES user_coupons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Add max_discount_amount column to coupons table
ALTER TABLE coupons
ADD COLUMN IF NOT EXISTS max_discount_amount INT NULL COMMENT '최대 할인 금액 (퍼센트 할인 시 적용)';

-- Verify changes
SELECT 'Schema updates completed successfully' AS status;
