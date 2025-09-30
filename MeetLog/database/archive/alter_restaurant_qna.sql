-- restaurant_qna 테이블에 사용자 정보 및 상태 관리 컬럼 추가

-- 1. answer 컬럼을 NULL 허용으로 변경
ALTER TABLE `restaurant_qna`
MODIFY COLUMN `answer` TEXT DEFAULT NULL;

-- 2. 새 컬럼 추가
ALTER TABLE `restaurant_qna`
ADD COLUMN `user_id` INT DEFAULT NULL AFTER `restaurant_id`,
ADD COLUMN `user_name` VARCHAR(100) DEFAULT NULL AFTER `user_id`,
ADD COLUMN `user_email` VARCHAR(255) DEFAULT NULL AFTER `user_name`,
ADD COLUMN `status` VARCHAR(20) DEFAULT 'PENDING' AFTER `answer`,
ADD COLUMN `is_resolved` TINYINT(1) DEFAULT 0 AFTER `is_owner`,
ADD COLUMN `answered_at` TIMESTAMP NULL DEFAULT NULL AFTER `created_at`,
ADD COLUMN `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `answered_at`;

-- user_id에 외래키 제약조건 추가 (선택사항)
-- ALTER TABLE `restaurant_qna`
-- ADD CONSTRAINT `restaurant_qna_user_fk`
-- FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;