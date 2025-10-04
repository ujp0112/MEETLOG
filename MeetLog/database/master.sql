-- ===================================================================
-- DATABASE INITIALIZATION SCRIPT (MEETLOG 최종 통합 버전)
-- Merged from master.sql and master_v2.sql
-- ===================================================================

-- 데이터베이스가 존재하면 삭제하고 새로 생성 (완전 초기화)
DROP DATABASE IF EXISTS meetlog;
CREATE DATABASE meetlog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE meetlog;

-- 외래 키 제약 조건 임시 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- 1. 테이블 구조 생성 (Create Schema)
-- Based on master_v2.sql with modifications
-- ===================================================================
CREATE TABLE `EVENTS` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255) NOT NULL,
  `SUMMARY` varchar(500) DEFAULT NULL,
  `CONTENT` text DEFAULT NULL,
  `IMAGE` varchar(1000) DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `alerts` (
  `alert_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `content` varchar(500) NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`alert_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `badges` (
  `badge_id` int(11) NOT NULL AUTO_INCREMENT,
  `icon` varchar(10) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`badge_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `branch_inventory` (
  `company_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `qty` decimal(12,2) NOT NULL DEFAULT 0.00,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`company_id`,`branch_id`,`material_id`),
  KEY `idx_bi_branch` (`branch_id`),
  KEY `idx_bi_material` (`material_id`),
  KEY `fk_bi_material` (`company_id`,`material_id`),
  CONSTRAINT `fk_bi_branch` FOREIGN KEY (`company_id`, `branch_id`) REFERENCES `business_users` (`company_id`, `user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bi_material` FOREIGN KEY (`company_id`, `material_id`) REFERENCES `material` (`company_id`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `branch_menu_toggle` (
  `company_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `enabled` char(1) NOT NULL DEFAULT 'Y',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`company_id`,`branch_id`,`menu_id`),
  KEY `idx_bmt_branch` (`branch_id`),
  KEY `idx_bmt_menu` (`menu_id`),
  KEY `fk_bmt_menu` (`company_id`,`menu_id`),
  CONSTRAINT `fk_bmt_branch` FOREIGN KEY (`company_id`, `branch_id`) REFERENCES `business_users` (`company_id`, `user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bmt_menu` FOREIGN KEY (`company_id`, `menu_id`) REFERENCES `menu` (`company_id`, `id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `business_notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `view_count` int(11) NOT NULL DEFAULT 0,
  `deleted_yn` char(1) DEFAULT 'N',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_notice_company` (`company_id`),
  CONSTRAINT `fk_notice_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `business_users` (
  `user_id` int(11) NOT NULL,
  `business_name` varchar(200) NOT NULL,
  `owner_name` varchar(100) NOT NULL,
  `business_number` varchar(20) NOT NULL,
  `role` varchar(10) NOT NULL COMMENT '역할 (HQ 또는 BRANCH 또는 INDIVIDUAL)',
  `status` varchar(10) NOT NULL DEFAULT 'PENDING' COMMENT '상태 (PENDING, ACTIVE)',
  `company_id` int(11) DEFAULT NULL COMMENT '소속된 회사의 ID. HQ의 경우 자신의 user_id 또는 별도 ID.',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_business_users_company_id` (`company_id`, `user_id`),
  CONSTRAINT `business_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_business_users_to_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `column_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `column_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `like_count` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_column_id` (`column_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  CONSTRAINT `column_comments_ibfk_1` FOREIGN KEY (`column_id`) REFERENCES `columns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `column_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `column_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `column_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_column_user` (`column_id`,`user_id`),
  KEY `idx_column_likes_column_id` (`column_id`),
  KEY `idx_column_likes_user_id` (`user_id`),
  CONSTRAINT `column_likes_ibfk_1` FOREIGN KEY (`column_id`) REFERENCES `columns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `column_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(300) NOT NULL,
  `content` text NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `likes` int(11) DEFAULT 0,
  `views` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_columns_user_id` (`user_id`),
  KEY `idx_columns_created_at` (`created_at` DESC),
  CONSTRAINT `columns_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `comment_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_comment_user` (`comment_id`,`user_id`),
  KEY `idx_comment_likes_comment_id` (`comment_id`),
  KEY `idx_comment_likes_user_id` (`user_id`),
  CONSTRAINT `comment_likes_ibfk_1` FOREIGN KEY (`comment_id`) REFERENCES `column_comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comment_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '회사 또는 브랜드명',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='본사 또는 브랜드 정보를 담는 테이블';
CREATE TABLE `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `discount_type` ENUM('PERCENTAGE', 'FIXED') DEFAULT NULL,
  `discount_value` int(11) DEFAULT NULL,
  `min_order_amount` int(11) DEFAULT 0,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `per_user_limit` int(11) DEFAULT NULL,
  `usage_count` int(11) NOT NULL DEFAULT 0,
  `validity` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `coupons_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `course_comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`comment_id`),
  KEY `course_id` (`course_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `course_comments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `course_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `course_likes` (
  `course_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`course_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `course_likes_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `course_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `course_reservations` (
  `reservation_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `participant_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `reservation_date` date DEFAULT NULL,
  `reservation_time` varchar(50) DEFAULT NULL,
  `participant_count` int(11) DEFAULT 1,
  `total_price` int(11) DEFAULT 0,
  `status` enum('PENDING','CONFIRMED','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`reservation_id`),
  KEY `course_id` (`course_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `course_reservations_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `course_reservations_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `course_reviews` (
  `review_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT 5,
  `content` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `response_content` text DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `course_id` (`course_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `course_reviews_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `course_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `course_steps` (
  `step_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `step_order` int(11) NOT NULL DEFAULT 0,
  `step_type` varchar(100) DEFAULT NULL,
  `emoji` varchar(10) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL COMMENT '위도',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT '경도',
  `address` varchar(500) DEFAULT NULL COMMENT '주소',
  `description` text DEFAULT NULL,
  `image` varchar(1000) DEFAULT NULL,
  `time` int(11) DEFAULT 0 COMMENT '소요 시간 (분)',
  `cost` int(11) DEFAULT 0 COMMENT '예상 비용 (원)',
  PRIMARY KEY (`step_id`),
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `course_steps_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `course_tags` (
  `course_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`course_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `course_tags_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `course_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL,
  `duration` varchar(100) DEFAULT NULL,
  `price` int(11) DEFAULT 0,
  `max_participants` int(11) DEFAULT 0,
  `status` enum('PENDING','ACTIVE','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `type` enum('OFFICIAL','COMMUNITY') DEFAULT 'COMMUNITY',
  `preview_image` varchar(1000) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `detailed_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `taste` decimal(3,1) DEFAULT 0.0,
  `price` decimal(3,1) DEFAULT 0.0,
  `service` decimal(3,1) DEFAULT 0.0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `detailed_ratings_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `feed_items` (
  `feed_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `feed_type` enum('COLUMN','REVIEW','COURSE','FOLLOW') NOT NULL,
  `content_id` int(11) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`feed_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `feed_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `follows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `follower_id` int(11) NOT NULL,
  `following_id` int(11) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_follow` (`follower_id`,`following_id`),
  KEY `idx_follows_follower_id` (`follower_id`),
  KEY `idx_follows_following_id` (`following_id`),
  KEY `idx_follows_created_at` (`created_at` DESC),
  CONSTRAINT `follows_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `follows_ibfk_2` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `material` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `unit` varchar(30) NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `img_path` varchar(255) DEFAULT NULL,
  `step` decimal(12,2) DEFAULT 1.00,
  `active_yn` char(1) DEFAULT 'Y',
  `deleted_yn` char(1) DEFAULT 'N',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_material_company_id` (`company_id`,`id`),
  KEY `idx_material_company` (`company_id`),
  CONSTRAINT `fk_material_company` FOREIGN KEY (`company_id`) REFERENCES `business_users` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `price` decimal(12,0) NOT NULL,
  `recipe` text DEFAULT NULL COMMENT '메뉴 레시피',
  `img_path` varchar(255) DEFAULT NULL,
  `active_yn` char(1) DEFAULT 'Y',
  `deleted_yn` char(1) DEFAULT 'N',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_menu_company_id` (`company_id`,`id`),
  KEY `idx_menu_company` (`company_id`),
  CONSTRAINT `fk_menu_company` FOREIGN KEY (`company_id`) REFERENCES `business_users` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `menu_ingredient` (
  `company_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `qty` decimal(12,3) NOT NULL,
  PRIMARY KEY (`company_id`,`menu_id`,`material_id`),
  KEY `idx_mi_menu` (`menu_id`),
  KEY `idx_mi_material` (`material_id`),
  KEY `fk_mi_material` (`company_id`,`material_id`),
  CONSTRAINT `fk_mi_material` FOREIGN KEY (`company_id`, `material_id`) REFERENCES `material` (`company_id`, `id`),
  CONSTRAINT `fk_mi_menu` FOREIGN KEY (`company_id`, `menu_id`) REFERENCES `menu` (`company_id`, `id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `price` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `is_popular` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `menus_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `notice_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notice_id` int(11) NOT NULL,
  `company_id` bigint(20) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `saved_filename` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_notice_file_notice` (`notice_id`),
  CONSTRAINT `fk_notice_file_notice` FOREIGN KEY (`notice_id`) REFERENCES `business_notice` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `notice_image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notice_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_notice_image_notice` (`notice_id`),
  CONSTRAINT `fk_notice_image_notice` FOREIGN KEY (`notice_id`) REFERENCES `business_notice` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `notices` (
  `notice_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL COMMENT 'follow, like, comment, review, collection, etc.',
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `action_url` varchar(500) DEFAULT NULL COMMENT '클릭 시 이동할 URL',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `read_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user_id` (`user_id`),
  KEY `idx_notifications_is_read` (`is_read`),
  KEY `idx_notifications_created_at` (`created_at` DESC),
  KEY `idx_notifications_type` (`type`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 알림 테이블';
CREATE TABLE `promotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL COMMENT '프로모션 제목',
  `description` text DEFAULT NULL COMMENT '프로모션 상세 설명',
  `start_date` timestamp NOT NULL COMMENT '프로모션 시작 일시',
  `end_date` timestamp NOT NULL COMMENT '프로모션 종료 일시',
  `deleted_yn` char(1) DEFAULT 'N',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_promotion_company` (`company_id`),
  CONSTRAINT `fk_promotion_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `promotion_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `original_filename` varchar(255) NOT NULL COMMENT '사용자가 올린 원래 파일명',
  `file_path` varchar(255) NOT NULL COMMENT '서버에 저장된 고유 파일명',
  `file_size` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_promo_file_promo` (`promotion_id`),
  CONSTRAINT `fk_promo_file_promo` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `promotion_image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL COMMENT '이미지 파일명',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT '이미지 표시 순서',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_promo_image_promo` (`promotion_id`),
  CONSTRAINT `fk_promo_image_promo` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `purchase_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `status` enum('REQUESTED','APPROVED','REJECTED','RECEIVED') NOT NULL DEFAULT 'REQUESTED',
  `total_price` decimal(14,0) NOT NULL DEFAULT 0,
  `ordered_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_purchase_order_company_id` (`company_id`, `id`),
  KEY `idx_po_company` (`company_id`),
  KEY `idx_po_branch` (`branch_id`),
  KEY `fk_po_branch` (`company_id`,`branch_id`),
  CONSTRAINT `fk_po_branch` FOREIGN KEY (`company_id`, `branch_id`) REFERENCES `business_users` (`company_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `purchase_order_line` (
  `company_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `line_no` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `qty` decimal(12,2) NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `status` enum('REQUESTED','APPROVED','REJECTED','RECEIVED') NOT NULL DEFAULT 'REQUESTED',
  PRIMARY KEY (`company_id`,`order_id`,`line_no`),
  KEY `idx_pol_order` (`order_id`),
  KEY `idx_pol_material` (`material_id`),
  KEY `fk_pol_material` (`company_id`,`material_id`),
  CONSTRAINT `fk_pol_material` FOREIGN KEY (`company_id`, `material_id`) REFERENCES `material` (`company_id`, `id`),
  CONSTRAINT `fk_pol_order` FOREIGN KEY (`company_id`, `order_id`) REFERENCES `purchase_order` (`company_id`, `id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `rating_distributions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `rating_1` int(11) DEFAULT 0,
  `rating_2` int(11) DEFAULT 0,
  `rating_3` int(11) DEFAULT 0,
  `rating_4` int(11) DEFAULT 0,
  `rating_5` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `rating_distributions_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `restaurant_name` varchar(200) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `reservation_time` timestamp NOT NULL,
  `party_size` int(11) NOT NULL,
  `status` enum('PENDING','CONFIRMED','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `special_requests` text DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_reservations_restaurant_id` (`restaurant_id`),
  KEY `idx_reservations_user_id` (`user_id`),
  KEY `idx_reservations_reservation_time` (`reservation_time`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `restaurant_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL COMMENT '서버에 저장된 이미지 파일명',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT '이미지 표시 순서',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_res_images_restaurant` (`restaurant_id`),
  CONSTRAINT `fk_res_images_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
CREATE TABLE `restaurant_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(300) NOT NULL,
  `content` text NOT NULL,
  `date` varchar(20) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_news_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `restaurant_operating_hours` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `day_of_week` int(11) NOT NULL,
  `opening_time` time NOT NULL,
  `closing_time` time NOT NULL,
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_operating_hours_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `restaurant_qna` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `question` text NOT NULL,
  `answer` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `is_owner` tinyint(1) DEFAULT 0,
  `is_resolved` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `answered_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_qna_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `restaurant_reservation_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `reservation_enabled` tinyint(1) DEFAULT 0,
  `auto_accept` tinyint(1) DEFAULT 0,
  `min_party_size` int(11) DEFAULT 1,
  `max_party_size` int(11) DEFAULT 10,
  `advance_booking_days` int(11) DEFAULT 30,
  `min_advance_hours` int(11) DEFAULT 2,
  `reservation_start_time` time DEFAULT '09:00:00',
  `reservation_end_time` time DEFAULT '22:00:00',
  `available_days` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[monday, 	uesday, wednesday, 	hursday, friday, saturday, sunday]' CHECK (json_valid(`available_days`)),
  `time_slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[	09:00, 10:00, 11:00, 12:00, 13:00, 14:00, 15:00, 16:00, 17:00, 18:00, 19:00, 20:00, 21:00]' CHECK (json_valid(`time_slots`)),
  `blackout_dates` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blackout_dates`)),
  `special_notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `monday_enabled` tinyint(1) DEFAULT 1,
  `monday_start` time DEFAULT '09:00:00',
  `monday_end` time DEFAULT '22:00:00',
  `tuesday_enabled` tinyint(1) DEFAULT 1,
  `tuesday_start` time DEFAULT '09:00:00',
  `tuesday_end` time DEFAULT '22:00:00',
  `wednesday_enabled` tinyint(1) DEFAULT 1,
  `wednesday_start` time DEFAULT '09:00:00',
  `wednesday_end` time DEFAULT '22:00:00',
  `thursday_enabled` tinyint(1) DEFAULT 1,
  `thursday_start` time DEFAULT '09:00:00',
  `thursday_end` time DEFAULT '22:00:00',
  `friday_enabled` tinyint(1) DEFAULT 1,
  `friday_start` time DEFAULT '09:00:00',
  `friday_end` time DEFAULT '22:00:00',
  `saturday_enabled` tinyint(1) DEFAULT 1,
  `saturday_start` time DEFAULT '09:00:00',
  `saturday_end` time DEFAULT '22:00:00',
  `sunday_enabled` tinyint(1) DEFAULT 1,
  `sunday_start` time DEFAULT '09:00:00',
  `sunday_end` time DEFAULT '22:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_restaurant` (`restaurant_id`),
  KEY `idx_restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_reservation_settings_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `restaurants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `category` varchar(50) NOT NULL,
  `location` varchar(100) NOT NULL,
  `address` varchar(500) NOT NULL,
  `jibun_address` varchar(500) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `hours` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `rating` decimal(3,1) DEFAULT 0.0,
  `review_count` int(11) DEFAULT 0,
  `likes` int(11) DEFAULT 0,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `parking` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operating_days` varchar(100) DEFAULT NULL COMMENT '대표 운영요일 목록 (예: 월,화,수,목,금)',
  `operating_times_text` varchar(255) DEFAULT NULL COMMENT '대표 운영시간 목록 (예: 09:00~18:00)',
  `break_time_text` varchar(100) DEFAULT NULL COMMENT '브레이크타임 텍스트 (예: 15:00~17:00)',
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  KEY `idx_restaurants_category` (`category`),
  KEY `idx_restaurants_location` (`location`),
  KEY `idx_restaurants_rating` (`rating` DESC),
  CONSTRAINT `restaurants_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=UTF8MB4_UNICODE_CI;

-- restaurants 테이블의 owner_id 컬럼이 NULL 값을 허용하도록 변경합니다.
SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE restaurants MODIFY COLUMN owner_id INT NULL;

-- ▼▼▼ [수정] 외부 API ID 저장을 위한 컬럼 추가 ▼▼▼
ALTER TABLE restaurants ADD COLUMN kakao_place_id VARCHAR(255) UNIQUE;

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `content` text NOT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `keywords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`keywords`)),
  `likes` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reply_content` text COMMENT '사장님 답글 내용',
  `reply_created_at` datetime DEFAULT NULL COMMENT '사장님 답글 작성 시간',
  PRIMARY KEY (`id`),
  KEY `restaurant_id` (`restaurant_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_reviews_restaurant_id` (`restaurant_id`),
  KEY `idx_reviews_user_id` (`user_id`),
  KEY `idx_reviews_created_at` (`created_at` DESC),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK (`rating` >= 1 and `rating` <= 5)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `review_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `is_owner_reply` tinyint(1) DEFAULT 0,
  `is_resolved` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `review_id` (`review_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `review_comments_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`) ON DELETE CASCADE,
  CONSTRAINT `review_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `review_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `review_id` int(11) NOT NULL COMMENT '리뷰 테이블(reviews)의 ID',
  `image_path` varchar(255) NOT NULL COMMENT '저장된 이미지 파일명',
  `created_at` datetime DEFAULT current_timestamp() COMMENT '생성 시간',
  PRIMARY KEY (`id`),
  KEY `review_id` (`review_id`),
  CONSTRAINT `review_images_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='리뷰에 첨부된 이미지 정보';

-- ===================================================================
-- KoBERT 벡터 저장 테이블 (AI 추천 시스템용)
-- ===================================================================

-- 레스토랑 콘텐츠 벡터 테이블
CREATE TABLE `restaurant_vectors` (
  `restaurant_id` int(11) NOT NULL,
  `content_vector` longtext NOT NULL COMMENT '768차원 KoBERT 임베딩 벡터 (JSON 배열)',
  `source_text` text DEFAULT NULL COMMENT '벡터 생성에 사용된 원본 텍스트 (디버깅용)',
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`restaurant_id`),
  KEY `idx_rv_updated_at` (`updated_at`),
  CONSTRAINT `restaurant_vectors_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='레스토랑 KoBERT 벡터 저장소';

-- 사용자 리뷰 벡터 캐시 테이블 (선택적)
CREATE TABLE `user_review_vectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `review_id` int(11) NOT NULL,
  `review_vector` longtext NOT NULL COMMENT '768차원 KoBERT 임베딩 벡터 (JSON 배열)',
  `rating` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_review_vector` (`review_id`),
  KEY `idx_urv_user_rating` (`user_id`,`rating`),
  KEY `idx_urv_created_at` (`created_at`),
  CONSTRAINT `user_review_vectors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_review_vectors_ibfk_2` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 리뷰 벡터 캐시';

CREATE TABLE `tags` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tag_name` (`tag_name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `user_badges` (
  `user_id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL,
  `earned_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`,`badge_id`),
  KEY `badge_id` (`badge_id`),
  CONSTRAINT `user_badges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_badges_ibfk_2` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`badge_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `user_storage_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `storage_id` int(11) NOT NULL,
  `item_type` enum('RESTAURANT','COURSE','COLUMN') NOT NULL,
  `content_id` int(11) NOT NULL,
  `added_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `unique_storage_item` (`storage_id`,`item_type`,`content_id`),
  KEY `idx_storage_items_storage_id` (`storage_id`),
  KEY `idx_storage_items_type_content` (`item_type`,`content_id`),
  KEY `idx_storage_items_added_at` (`added_at` DESC),
  CONSTRAINT `user_storage_items_ibfk_1` FOREIGN KEY (`storage_id`) REFERENCES `user_storages` (`storage_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `user_storages` (
  `storage_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `color_class` varchar(50) DEFAULT 'bg-blue-100',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`storage_id`),
  KEY `idx_user_storages_user_id` (`user_id`),
  KEY `idx_user_storages_created_at` (`created_at` DESC),
  CONSTRAINT `user_storages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_type` enum('PERSONAL','BUSINESS','ADMIN') NOT NULL DEFAULT 'PERSONAL',
  `profile_image` varchar(500) DEFAULT NULL,
  `level` int(11) DEFAULT 1,
  `follower_count` int(11) DEFAULT 0,
  `following_count` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nickname`),
  KEY `idx_users_email` (`email`),
  KEY `idx_users_nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================================
-- 2. 추가된 기능 테이블
-- ===================================================================

CREATE TABLE `review_likes` (
    `user_id` INT NOT NULL,
    `review_id` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`, `review_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`review_id`) REFERENCES `reviews`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `reservation_blackout_dates` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT NOT NULL,
    `blackout_date` DATE NOT NULL COMMENT '예약 불가 날짜',
    `reason` VARCHAR(255) COMMENT '불가 사유',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT '활성화 상태',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY `idx_blackout_restaurant_date` (`restaurant_id`, `blackout_date`),
    UNIQUE KEY `unique_restaurant_blackout_date` (`restaurant_id`, `blackout_date`),
    CONSTRAINT `fk_blackout_restaurant`
        FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='예약 불가 날짜 관리';

CREATE TABLE `restaurant_tables` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT NOT NULL,
    `table_name` VARCHAR(50) NOT NULL COMMENT '테이블명',
    `table_number` INT NOT NULL COMMENT '테이블 번호',
    `capacity` INT NOT NULL COMMENT '수용 인원',
    `table_type` ENUM('REGULAR', 'VIP', 'PRIVATE', 'BAR') DEFAULT 'REGULAR' COMMENT '테이블 유형',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT '사용 가능 여부',
    `notes` TEXT COMMENT '특이사항',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_restaurant_table_number` (`restaurant_id`, `table_number`),
    KEY `idx_restaurant_capacity` (`restaurant_id`, `capacity`),
    CONSTRAINT `fk_table_restaurant`
        FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `chk_table_number` CHECK (`table_number` > 0 AND `table_number` <= 999),
    CONSTRAINT `chk_table_capacity` CHECK (`capacity` > 0 AND `capacity` <= 20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='음식점 테이블 관리';

CREATE TABLE `reservation_tables` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `reservation_id` INT NOT NULL,
    `table_id` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_reservation_table` (`reservation_id`, `table_id`),
    CONSTRAINT `fk_reservation_table_reservation`
        FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_reservation_table_table`
        FOREIGN KEY (`table_id`) REFERENCES `restaurant_tables`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='예약과 테이블 연결';

CREATE TABLE `reservation_notifications` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `reservation_id` INT NOT NULL,
    `notification_type` ENUM('SMS', 'EMAIL', 'PUSH') NOT NULL,
    `recipient` VARCHAR(255) NOT NULL COMMENT '수신자 (전화번호 또는 이메일)',
    `message` TEXT NOT NULL,
    `status` ENUM('PENDING', 'SENT', 'FAILED', 'SCHEDULED') DEFAULT 'PENDING',
    `scheduled_time` TIMESTAMP NULL COMMENT '예약 발송 시간',
    `sent_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_reservation_notifications` (`reservation_id`),
    CONSTRAINT `fk_notification_reservation`
        FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='예약 알림 발송 로그';

CREATE TABLE `reservation_table_assignments` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `reservation_id` INT(11) NOT NULL,
  `table_id` INT(11) NOT NULL,
  `assigned_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_reservation` (`reservation_id`),
  KEY `table_id` (`table_id`),
  CONSTRAINT `reservation_table_assignments_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reservation_table_assignments_ibfk_2` FOREIGN KEY (`table_id`) REFERENCES `restaurant_tables` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='예약-테이블 배정 정보';

CREATE TABLE `inquiries` (
    `inquiry_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NULL,
    `user_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NULL,
    `subject` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `status` ENUM('PENDING', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'PENDING',
    `reply` TEXT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `category` VARCHAR(50) DEFAULT 'GENERAL' COMMENT '문의 카테고리: RESERVATION, PAYMENT, TECHNICAL, GENERAL',
    `priority` ENUM('HIGH', 'MEDIUM', 'LOW') DEFAULT 'MEDIUM' COMMENT '우선순위',
    `response_time_hours` DECIMAL(10,2) COMMENT '응답 시간(시간)',
    `resolved_at` DATETIME COMMENT '해결 완료 시각',
    INDEX `idx_inquiries_status` (`status`),
    INDEX `idx_inquiries_category` (`category`),
    INDEX `idx_inquiries_priority` (`priority`),
    INDEX `idx_inquiries_created_at` (`created_at` DESC),
    CONSTRAINT `fk_inquiry_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='고객 문의';

CREATE TABLE `recommendation_metrics` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `recommendation_count` INT(11) NOT NULL,
  `avg_score` DOUBLE DEFAULT 0.0,
  `category_diversity` INT(11) DEFAULT 0,
  `timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `timestamp` (`timestamp`),
  CONSTRAINT `recommendation_metrics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='추천 성능 메트릭';

CREATE TABLE `recommendation_items` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `metric_id` INT(11) NOT NULL,
  `restaurant_id` INT(11) NOT NULL,
  `recommendation_score` DOUBLE DEFAULT 0.0,
  `predicted_rating` DOUBLE DEFAULT 0.0,
  `reason` VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `metric_id` (`metric_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `recommendation_items_ibfk_1` FOREIGN KEY (`metric_id`) REFERENCES `recommendation_metrics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recommendation_items_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='추천 항목 상세';


CREATE TABLE user_coupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    coupon_id INT NOT NULL,
    received_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    used_at TIMESTAMP NULL DEFAULT NULL,
    is_used TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_user_coupons_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_coupons_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE faqs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL COMMENT 'FAQ 카테고리 (계정 관련, 예약 관련, 서비스 이용, 기타)',
    question TEXT NOT NULL COMMENT '자주 묻는 질문',
    answer TEXT NOT NULL COMMENT '질문에 대한 답변',
    display_order INT DEFAULT 0 COMMENT '표시 순서',
    is_active TINYINT(1) DEFAULT 1 COMMENT '활성화 여부',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_faqs_category (category),
    INDEX idx_faqs_active (is_active),
    INDEX idx_faqs_order (display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='자주 묻는 질문 테이블';

-- 신고 관리 테이블
CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id INT NOT NULL COMMENT '신고자 ID',
    reported_type ENUM('REVIEW', 'COLUMN', 'COURSE', 'USER') NOT NULL COMMENT '신고 대상 타입',
    reported_id INT NOT NULL COMMENT '신고 대상 ID',
    reported_user_id INT COMMENT '피신고자 ID',
    reason VARCHAR(500) NOT NULL COMMENT '신고 사유',
    status ENUM('PENDING', 'PROCESSED', 'DISMISSED') DEFAULT 'PENDING' COMMENT '처리 상태',
    admin_note TEXT COMMENT '관리자 메모',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '신고 일시',
    processed_at TIMESTAMP NULL COMMENT '처리 일시',
    processed_by INT COMMENT '처리자 ID',
    FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reported_user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (processed_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_reports_status (status),
    INDEX idx_reports_type (reported_type),
    INDEX idx_reports_reporter (reporter_id),
    INDEX idx_reports_reported_user (reported_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='신고 관리 테이블';

-- Admin user
INSERT INTO users (id, email, nickname, password, user_type, profile_image, follower_count, is_active) VALUES (11, 'admin@meetlog.com', 'admin', 'admin123', 'ADMIN', NULL, 0, 1);
-- 칼럼과 맛집의 다대다(N:M) 관계를 위한 연결 테이블 생성
CREATE TABLE column_restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    column_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_column FOREIGN KEY (column_id) REFERENCES columns(id) ON DELETE CASCADE,
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    UNIQUE KEY unique_column_restaurant (column_id, restaurant_id)
);

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

-- ===================================================================
-- 3. 데이터 삽입 (Insert Data)
-- ===================================================================
-- Data from master.sql
INSERT INTO users (id, email, nickname, password, user_type, profile_image, follower_count) VALUES (1, 'kim.expert@meetlog.com', '김맛잘알', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', 12500), (2, 'mr.nopo@meetlog.com', '미스터노포', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 8200), (3, 'bbang@meetlog.com', '빵순이', 'hashed_password_123', 'PERSONAL', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 25100), (4, 'date.master@meetlog.com', '데이트장인', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/e879f9/ffffff?text=Me', 1200), (5, 'gasan.worker@meetlog.com', '가산직장인', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 3100), (6, 'after.work@meetlog.com', '퇴근후한잔', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 0), (7, 'hyonyeo@meetlog.com', '효녀딸', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 0), (8, 'jungdae@meetlog.com', '중데생', 'hashed_password_123', 'PERSONAL', 'https://bbscdn.df.nexon.com/data7/commu/202004/230754_5e89e63a88677.png', 0), (9, 'sando.bread@meetlog.com', '상도동빵주먹', 'hashed_password_123', 'PERSONAL', 'https://dcimg1.dcinside.com/viewimage.php?id=3da9da27e7d13c&no=24b0d769e1d32ca73de983fa11d02831c6c0b61130e4349ff064c51af2dccfaaa69ce6d782ffbe3cfce75d0ab4b0153873c98d17df4da1937ce4df7cc1e73f9d543acb95a114b61478ff194f7f2b81facc7cc6acb3074408f65976d67d2fe0deaebbfb2ef40152de', 0);
INSERT INTO restaurants (id, name, category, location, address, jibun_address, phone, hours, description, image, rating, review_count, likes, latitude, longitude) VALUES (1, '고미정', '한식', '강남', '서울특별시 강남구 테헤란로 123', '역삼동 123-45', '02-1234-5678', '매일 11:00 - 22:00', '강남역 한정식, 상견례 장소', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', 4.8, 152, 1203, 37.501, 127.039), (2, '파스타 팩토리', '양식', '홍대', '서울 마포구 와우산로29길 14-12', '서교동 333-1', '02-333-4444', '매일 11:30 - 22:00', '홍대입구역 소개팅, 데이트 맛집', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 4.6, 258, 2341, 37.5559, 126.9238), (3, '스시 마에', '일식', '여의도', '서울 영등포구 국제금융로 10', '여의도동 23', '02-555-6666', '매일 12:00 - 22:00 (브레이크타임 15:00-18:00)', '여의도 하이엔드 오마카세', 'https://placehold.co/600x400/60a5fa/ffffff?text=오마카세', 4.9, 189, 1890, 37.525, 126.925), (4, '치맥 하우스', '한식', '종로', '서울 종로구 종로 123', '종로3가 11-1', '02-777-8888', '매일 16:00 - 02:00', '종로 수제맥주와 치킨 맛집', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨', 4.4, 310, 3104, 37.570, 126.989), (5, '카페 클라우드', '카페', '성수', '서울 성동구 연무장길 12', '성수동2가 300-1', '02-464-1234', '매일 10:00 - 22:00', '성수동 뷰맛집 감성 카페', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', 4.5, 288, 2880, 37.543, 127.054), (6, '북경 오리', '중식', '명동', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/f472b6/ffffff?text=중식', 4.7, 0, 1550, NULL, NULL), (7, '브루클린 버거', '양식', '이태원', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/fb923c/ffffff?text=버거', 4.5, 0, 2543, NULL, NULL), (8, '소담길', '한식', '인사동', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://www.ourhomehospitality.com/hos_img/1720054355745.jpg', 4.7, 0, 980, NULL, NULL);
INSERT INTO menus (restaurant_id, name, price) VALUES (1, '궁중 수라상', '75,000원'), (1, '고미정 정식', '55,000원'), (1, '보리굴비 정식', '45,000원'), (2, '트러플 크림 파스타', '18,000원'), (2, '봉골레 파스타', '16,000원'), (2, '마르게리따 피자', '20,000원'), (3, '런치 오마카세', '120,000원'), (3, '디너 오마카세', '250,000원'), (4, '반반치킨', '19,000원'), (4, '종로 페일에일', '7,500원'), (5, '아인슈페너', '7,000원'), (5, '클라우드 케이크', '8,500원'), (11, '단호박 머핀', '4,000원'), (11, '쌀바게트', '4,500원'), (11, '홍국단팥빵', '4,000원');
INSERT INTO reviews (id, restaurant_id, user_id, rating, content, images, keywords, likes) VALUES (1, 2, 4, 5, '여기 진짜 분위기 깡패에요! 소개팅이나 데이트 초반에 가면 무조건 성공입니다.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832"]', NULL, 0), (2, 4, 6, 4, '일 끝나고 동료들이랑 갔는데, 스트레스가 확 풀리네요. 새로 나온 마늘간장치킨이 진짜 맛있어요.', NULL, NULL, 0), (3, 1, 7, 5, '부모님 생신이라 모시고 갔는데 정말 좋아하셨어요. 음식 하나하나 정성이 느껴져요.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832"]', NULL, 0), (4, 10, 2, 5, '역시 여름엔 평양냉면이죠. 이 집 육수는 정말 최고입니다.', NULL, NULL, 0), (5, 12, 2, 5, '가산에서 이만한 퀄리티의 삼겹살을 찾기 힘듭니다. 회식 장소로 강력 추천!', NULL, NULL, 0), (6, 13, 5, 4, '점심시간에 웨이팅은 좀 있지만, 든든하게 한 끼 해결하기에 최고입니다. 깍두기가 맛있어요.', NULL, NULL, 0), (7, 19, 3, 4, '산미있는 원두를 좋아하시면 여기입니다. 디저트 케이크도 괜찮았어요.', NULL, NULL, 0), (8, 14, 4, 4, '가산에서 파스타 먹고 싶을 때 가끔 들러요. 창가 자리가 분위기 좋아요.', NULL, NULL, 0), (9, 11, 4, 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다. 다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832"]', NULL, 0), (10, 11, 3, 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다.
다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832", "https://d12zq4w4guyljn.cloudfront.net/750_750_20241013104136219_menu_tWPMh0i8m0ba.jpg", "https://d12zq4w4guyljn.cloudfront.net/750_750_20241013104128192_photo_tWPMh0i8m0ba.webp"]', '["#음식이 맛있어요", "#재료가 신선해요"]', 25);
INSERT INTO `columns` (id, user_id, title, content, image) VALUES (1, 3, '상도동 비건 빵집 ''우부래도'' 솔직 리뷰', '상도동에는 숨겨진 비건 빵 맛집들이 많습니다. 그 중에서도 제가 가장 사랑하는 곳은 바로 ''우부래도''입니다. 특히 이곳의 쌀바게트는 정말 일품입니다. 겉은 바삭하고 속은 쫀득한 식감이 살아있죠.

제가 남겼던 리뷰를 첨부해봅니다. 여러분도 상도동에 가시면 꼭 들러보세요!', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832'), (2, 2, '을지로 직장인들을 위한 최고의 평양냉면', '여름이면 어김없이 생각나는 평양냉면. 을지로의 수많은 노포 중에서도 ''평양면옥''은 단연 최고라고 할 수 있습니다. 슴슴하면서도 깊은 육수 맛이 일품입니다. 점심시간에는 웨이팅이 길 수 있으니 조금 서두르는 것을 추천합니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832'), (3, 1, '한식 다이닝의 정수, 강남 ''고미정'' 방문기', '특별한 날, 소중한 사람과 함께할 장소를 찾는다면 강남의 ''고미정''을 추천합니다. 정갈한 상차림과 깊은 맛의 한정식 코스는 먹는 내내 감탄을 자아냅니다. 특히 부모님을 모시고 가기에 최고의 장소입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832'), (4, 4, '홍대 최고의 파스타, 데이트 성공 보장!', '홍대에서 데이트 약속이 잡혔다면 고민하지 말고 ''파스타 팩토리''로 가세요. 분위기, 맛, 서비스 뭐 하나 빠지는 게 없는 곳입니다. 특히 트러플 크림 파스타는 꼭 먹어봐야 할 메뉴입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832'), (5, 5, '가산디지털단지 직장인 점심 맛집 BEST 3', '매일 반복되는 점심 메뉴 고민, 힘드시죠? G밸리 5년차 직장인이 추천하는 점심 맛집 리스트를 공개합니다. ''직장인 국밥''부터...', 'https://placehold.co/600x400/f97316/ffffff?text=국밥'), (6, 6, '퇴근 후 한잔, 가산 이자카야 ''가디'' 방문기', '지친 하루의 피로를 풀어주는 시원한 맥주와 맛있는 안주. ''가디 이자카야''는 회식 2차 장소로도, 혼술하기에도 좋은 곳입니다.', 'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야');
INSERT INTO reservations (id, restaurant_id, user_id, restaurant_name, user_name, reservation_time, party_size, status) VALUES (1, 11, 4, '우부래도', '데이트장인', '2025-09-14 19:00:00', 2, 'CONFIRMED'), (2, 2, 4, '파스타 팩토리', '데이트장인', '2025-09-13 20:00:00', 4, 'COMPLETED'), (3, 32, 4, '툭툭누들타이', '데이트장인', '2025-08-15 18:00:00', 2, 'CANCELLED');
INSERT INTO follows (follower_id, following_id, is_active) VALUES (2, 4, TRUE), (4, 3, TRUE), (4, 2, TRUE);
INSERT INTO review_comments (id, review_id, user_id, content) VALUES (1, 10, 8, '오 여기 진짜 맛있죠! 저도 쌀바게트 제일 좋아해요.');
INSERT INTO column_comments (id, column_id, user_id, content) VALUES (1, 1, 8, '여기 학교 앞이라 지나가다가 봤는데 이런 맛집인지 몰랐어요 가봐야겠네요!'), (2, 1, 9, '비건 빵집이라니! 츄라이 해봐야겠어요!');
INSERT INTO coupons (restaurant_id, title, description, validity) VALUES (11, '비건 디저트 20% 할인', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31'), (1, '상견례 10% 할인', '상견례 예약 시 제공', '~ 2025.12.31'), (2, '에이드 1잔 무료', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31');
INSERT INTO restaurant_news (restaurant_id, type, title, content, date) VALUES (11, '이벤트', '여름 한정! 단호박 빙수 출시!', '무더운 여름을 날려버릴 시원하고 달콤한 우부래도표 비건 단호박 빙수가 출시되었습니다. 많은 관심 부탁드립니다!', '2025.08.05'), (1, '공지', '겨울 한정 메뉴 출시', '따뜻한 겨울을 위한 전통 한정식 메뉴가 새롭게 출시되었습니다.', '2025.12.01'), (2, '이벤트', '신메뉴 출시! 트러플 파스타', '프리미엄 트러플을 사용한 새로운 파스타 메뉴가 출시되었습니다.', '2025.11.20');
INSERT INTO restaurant_qna (restaurant_id, question, answer, is_owner) VALUES (11, '주차는 가능한가요?', '네, 가게 앞에 2대 정도 주차 가능합니다.', TRUE), (1, '상견례 예약을 하고 싶은데 룸이 있나요?', '네, 8~12인까지 수용 가능한 프라이빗 룸이 준비되어 있습니다. 예약 시 말씀해주세요.', TRUE), (2, '주말 웨이팅이 긴가요?', '네, 주말 저녁에는 웨이팅이 있을 수 있으니 앱을 통해 예약해주시면 편리합니다.', TRUE);
INSERT INTO rating_distributions (restaurant_id, rating_1, rating_2, rating_3, rating_4, rating_5) VALUES (11, 0, 0, 2, 1, 3), (1, 0, 0, 4, 28, 120), (2, 0, 0, 18, 60, 180);
INSERT INTO detailed_ratings (restaurant_id, taste, price, service) VALUES (11, 4.0, 3.3, 3.3), (1, 4.9, 4.5, 4.8), (2, 4.7, 4.2, 4.5);
INSERT INTO tags (tag_id, tag_name) VALUES (1, '데이트'), (2, '홍대'), (3, '성수'), (4, '양식'), (5, '카페'), (6, '커뮤니티추천'), (7, '을지로'), (8, '직장인'), (9, '노포'), (10, '카페투어'), (11, '디저트');
INSERT INTO courses (course_id, title, description, area, duration, type, preview_image, author_id) VALUES (1, '홍대 데이트 완벽 코스 (파스타+카페)', '데이트장인이 추천하는 홍대 데이트 코스입니다. 이대로만 따라오시면 실패 없는 하루!', '홍대/연남', '약 3시간', 'COMMUNITY', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 4), (2, '[MEET LOG] 성수동 감성 투어', 'MEET LOG가 직접 큐레이션한 성수동 감성 맛집과 카페 코스입니다. 힙한 성수를 느껴보세요.', '성수/건대', '약 4시간', 'OFFICIAL', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', NULL), (3, '을지로 직장인 힐링 코스', '미스터노포가 추천하는 을지로 찐 맛집 코스. 칼퇴하고 바로 달려가세요.', '을지로', '약 2.5시간', 'COMMUNITY', 'https://mblogthumb-phinf.pstatic.net/MjAyMTAzMTdfNTUg/MDAxNjE1OTM3NTYyNDA4.q9XslyF7jKUHI6QbbhHqbBqk19Ox3GNAQoT9hxbqOkAg.fRlvymC8y7o-4LgTKKPUHR4zymM4da2dnHPtRveiD8Mg.JPEG.ichufs/DSC_3894.jpg?type=w800', 3), (4, '성수동 카페 뽀개기', '빵순이가 추천하는 성수동 디저트 카페 완전 정복 코스', '성수', '약 3시간', 'COMMUNITY', 'https://placehold.co/600x400/c4b5fd/ffffff?text=Seongsu+Cafe', 3);
INSERT INTO course_tags (course_id, tag_id) VALUES (1, 1), (1, 2), (1, 4), (1, 6), (2, 1), (2, 3), (2, 5), (3, 7), (3, 8), (3, 9), (3, 6), (4, 3), (4, 5), (4, 10), (4, 11), (4, 6);
INSERT INTO course_steps (course_id, step_order, step_type, emoji, name, description, image) VALUES (1, 1, 'RESTAURANT', '🍝', '파스타 팩토리 (ID: 2)', '분위기 좋은 곳에서 맛있는 파스타로 시작!', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832'), (1, 2, 'ETC', '🚶', '연남동 산책', '소화시킬 겸 연트럴파크를 가볍게 산책하세요.', NULL), (1, 3, 'RESTAURANT', '☕', '연남동 감성 카페', '분위기 좋은 카페에서 디저트와 커피로 마무리.', 'https://placehold.co/600x400/fde68a/ffffff?text=Yeonnam+Cafe'), (2, 1, 'RESTAURANT', '🍔', '브루클린 버거 (ID: 7)', '육즙 가득한 수제버거로 든든하게 시작!', 'https://placehold.co/600x400/fb923c/ffffff?text=버거'), (2, 2, 'ETC', '🛍️', '성수 소품샵 구경', '아기자기한 소품샵들을 구경하며 성수의 감성을 느껴보세요.', NULL), (2, 3, 'RESTAURANT', '🍰', '카페 클라우드 (ID: 5)', '뷰맛집 카페에서 시그니처 케이크와 커피 즐기기', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg'), (3, 1, 'RESTAURANT', '🍜', '평양면옥 (ID: 10)', '슴슴한 평양냉면으로 속을 달래며 1차 시작', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832'), (3, 2, 'RESTAURANT', '🍺', '치맥 하우스 (ID: 4)', '바삭한 치킨과 시원한 수제맥주로 2차 마무리!', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨'), (4, 1, 'RESTAURANT', '☕', '카페 클라우드 (ID: 5)', '뷰맛집 카페에서 시그니처 케이크와 커피', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg'), (4, 2, 'RESTAURANT', '🍞', '성수동 대림창고', '공장을 개조한 갤러리형 카페에서 커피 한 잔', 'https://placehold.co/600x400/8d99ae/ffffff?text=대림창고');
INSERT INTO course_likes (course_id, user_id) VALUES (1, 3), (1, 5), (1, 1), (1, 2), (2, 1), (2, 3), (2, 4), (3, 1), (3, 4), (3, 5), (4, 1), (4, 2), (4, 4), (4, 5);
INSERT INTO course_reservations (course_id, user_id, participant_name, phone, email, reservation_date, reservation_time, participant_count, total_price, status) VALUES (2, 3, '빵순이', '010-1234-5678', 'bbang@meetlog.com', '2025-09-20', '14:00', 2, 30000, 'CONFIRMED');
INSERT INTO course_reviews (course_id, user_id, rating, content, response_content) VALUES (1, 3, 5, '이 코스 그대로 다녀왔는데 정말 좋았어요! 파스타 팩토리 진짜 맛있네요. 추천 감사합니다!', '좋게 봐주셔서 감사합니다! (작성자: 데이트장인)'), (3, 5, 4, '미스터노포님 믿고 다녀왔습니다. 평양면옥은 역시 최고네요. 치맥하우스는 그냥 그랬어요.', '방문 감사합니다! (작성자: 미스터노포)');
INSERT INTO badges (icon, name, description) VALUES ('🏆', '첫 리뷰', '첫 리뷰를 작성하여 획득'), ('✍️', '칼럼니스트 데뷔', '첫 칼럼을 발행하여 획득'), ('📸', '포토그래퍼', '리뷰에 사진 10장 첨부하여 획득'), ('👍', '첫 팔로워', '첫 팔로워가 생기면 획득');
INSERT INTO user_badges (user_id, badge_id) VALUES (4, 1), (4, 2), (3, 1), (3, 2), (3, 4);
INSERT INTO notices (title, content, created_at) VALUES ('개인정보처리방침 개정 안내', '개인정보처리방침이 개정되어 안내드립니다. ...', '2025-09-01'), ('서버 점검 안내 (09/15 02:00 ~ 04:00)', '보다 나은 서비스 제공을 위해 서버 점검을 실시합니다. ...', '2025-09-08'), ('나만의 코스 만들기 기능 업데이트 안내', '이제 나만의 맛집 코스를 만들고 친구들과 공유할 수 있습니다. 많은 이용 바랍니다.', '2025-09-10');
INSERT INTO feed_items (user_id, feed_type, content_id, is_active, created_at) VALUES (3, 'COLUMN', 1, TRUE, '2025-09-16 19:00:00'), (2, 'REVIEW', 4, TRUE, '2025-09-15 14:00:00');
INSERT INTO alerts (user_id, content, is_read, created_at) VALUES (4, '<span class="font-bold">미스터노포</span>님이 회원님을 팔로우하기 시작했습니다.', FALSE, '2025-09-16 20:00:00'), (4, '<span class="font-bold">중데생</span>님이 회원님의 [홍대 최고의 파스타...] 칼럼에 댓글을 남겼습니다.', TRUE, '2025-09-16 18:00:00'), (4, '[공지] 개인정보처리방침 개정 안내', TRUE, '2025-09-14 09:00:00');
INSERT INTO user_storages (user_id, name, color_class) VALUES (4, '강남역 데이트', 'text-red-500'), (4, '혼밥하기 좋은 곳', 'text-sky-500'), (5, '가산 맛집', 'text-amber-500'), (2, '여의도 점심', 'text-green-500'), (3, '저장한 코스', 'text-violet-500');
INSERT INTO user_storage_items (storage_id, item_type, content_id) VALUES (1, 'RESTAURANT', 1), (1, 'RESTAURANT', 7), (2, 'RESTAURANT', 10), (3, 'RESTAURANT', 12), (3, 'RESTAURANT', 13), (3, 'RESTAURANT', 22), (4, 'RESTAURANT', 3), (5, 'COURSE', 1);
INSERT INTO EVENTS (TITLE, SUMMARY, CONTENT, IMAGE, START_DATE, END_DATE) VALUES ('MEET LOG 가을맞이! 5성급 호텔 뷔페 30% 할인', '선선한 가을, MEET LOG가 추천하는 최고의 호텔 뷔페에서 특별한 미식을 경험하세요. MEET LOG 회원 전용 특별 할인을 놓치지 마세요.', '이벤트 내용 본문입니다. 상세한 약관과 참여 방법이 여기에 들어갑니다.', 'https://placehold.co/800x400/f97316/ffffff?text=Hotel+Buffet+Event', '2025-09-01', '2025-10-31'), ('신규 맛집 ''파스타 팩토리'' 리뷰 이벤트', '홍대 ''파스타 팩토리'' 방문 후 MEET LOG에 리뷰를 남겨주세요! 추첨을 통해 2인 식사권을 드립니다!', '상세 내용: 1. 파스타 팩토리 방문 2. 사진과 함께 정성스러운 리뷰 작성 3. 자동 응모 완료!', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', '2025-09-10', '2025-09-30'), ('[종료] 여름맞이 치맥 하우스! 수제맥주 1+1', '무더운 여름 밤, 종로 ''치맥 하우스''에서 시원한 수제맥주 1+1 이벤트를 즐겨보세요. MEET LOG 회원이라면 누구나!', '본 이벤트는 8월 31일부로 종료되었습니다. 성원에 감사드립니다.', 'https://placehold.co/800x400/fbbf24/ffffff?text=Beer+Event+(Finished)', '2025-07-01', '2025-08-31'), ('이번 주 최고의 리뷰 선정', '정성스러운 맛집 리뷰를 작성하고 10,000 포인트를 받으세요!', '매주 3명을 선정하여 10,000 포인트를 드립니다. 사진 3장 이상, 200자 이상의 리뷰가 대상입니다. 당첨자는 매주 월요일 공지됩니다.', 'https://example.com/images/events/best_review_contest.jpg', '2025-09-15', '2025-09-21'), ('신규 오픈 ''강남 이탈리안 키친'' 방문 챌린지', '''강남 이탈리안 키친'' 방문 리뷰 작성 시, 참여자 전원 3,000 포인트 증정!', '강남역 10번 출구에 새로 오픈한 ''이탈리안 키친''에 방문하고 #강남이탈리안키친 태그와 함께 인증샷, 리뷰를 남겨주세요. (1인 1회 한정)', 'https://example.com/images/restaurants/gangnam_italian_promo.png', '2025-09-10', '2025-10-10'), ('''나만의 가을 맛집'' 추천 이벤트', '가을 분위기 물씬 나는 나만 아는 맛집을 공유해주세요. 5분께 백화점 상품권 증정!', '#가을맛집 태그를 달아 커뮤니티에 글을 작성해주세요. 추첨을 통해 5분께 백화점 상품권 5만원권을 드립니다.', '/static/images/events/autumn_food_challenge.gif', '2025-09-16', '2025-09-30'), ('맛zip 커뮤니티 10만 회원 달성!', '감사하는 마음으로 이벤트 기간 동안 로그인하는 모든 회원님께 1,000 포인트를 드립니다.', NULL, 'https://example.com/images/events/100k_members_party.jpg', '2025-10-01', '2025-10-07'), ('첫 리뷰 작성 100% 선물', '가입 후 첫 맛집 리뷰를 작성하시면 스타벅스 기프티콘 증정!', '정성스러운 첫 리뷰를 작성해주시는 모든 신규 회원님께 감사의 의미로 스타벅스 아메리카노 기프티콘을 드립니다. (본 이벤트는 별도 공지 시까지 계속됩니다)', NULL, '2025-01-01', NULL);
INSERT INTO restaurant_operating_hours (restaurant_id, day_of_week, opening_time, closing_time) VALUES (1, 1, '11:30:00', '22:00:00'), (1, 2, '11:30:00', '22:00:00'), (1, 3, '11:30:00', '22:00:00'), (1, 4, '11:30:00', '22:00:00'), (1, 5, '11:30:00', '22:00:00'), (1, 6, '11:30:00', '22:00:00'), (1, 7, '11:30:00', '22:00:00');

-- Data from master_v2.sql (new entries only)
-- Using INSERT IGNORE to avoid conflicts with existing primary keys.
INSERT IGNORE INTO `users` VALUES (10,'gugu@meetlog.com','구구콘','m2tFIFw+1psjCYLXjBAbUd3IY8jB6L/VCaB8eEc1tPMKgSQnC9BX/7iOREyyLBiC','BUSINESS',NULL,1,0,0,1,'2025-09-27 01:29:10','2025-09-27 01:29:10','구구','0299999999','도산대로1');
INSERT IGNORE INTO `companies` VALUES (1,'구구콘','2025-09-27 01:29:10','2025-09-27 01:29:10');
INSERT IGNORE INTO `business_users` VALUES (10,'구구콘','구구','999999999','INDIVIDUAL','APPROVED',1,'2025-09-27 01:29:10','2025-09-27 01:29:10');
INSERT IGNORE INTO `restaurants` VALUES (33,10,'구구콘','고기/구이','강남구','서울 강남구 도산대로 지하 102 1','서울 강남구 신사동 667','0299999999',NULL,'99',NULL,0.0,0,0,37.51643246,127.02032689,0,1,'2025-09-27 01:29:45','2025-09-27 01:29:45','화,수,목,금,토,일','00:00~22:00,00:00~22:00,00:00~22:00,00:00~22:00,00:00~22:00,00:00~22:00','',NULL);
INSERT IGNORE INTO `reviews` VALUES (11,33,10,5,'9999',NULL,'["음식이 맛있어요","가성비가 좋아요","양이 푸짐해요","친구","회식","인테리어가 예뻐요","좌석이 편해요","조용해요","활기찬 분위기","주차가 편해요","접근성이 좋아요"]',0,0,'2025-09-27 01:40:23','2025-09-27 15:20:42',NULL,NULL), (12,33,10,4,'999990',NULL,'["음식이 맛있어요","데이트","인테리어가 예뻐요","주차가 편해요"]',0,1,'2025-09-27 01:45:48','2025-09-27 15:20:29',NULL,NULL);
INSERT IGNORE INTO `column_comments` VALUES (3,3,10,'ㅎㅇ',NULL,0,1,'2025-09-27 14:51:21','2025-09-27 14:51:21'), (4,15,10,'지쟈스',NULL,0,1,'2025-09-27 16:42:45','2025-09-28 19:49:44');
INSERT IGNORE INTO `column_likes` VALUES (1,3,10,'2025-09-27 14:51:16'),(2,15,10,'2025-09-27 14:58:15');
INSERT IGNORE INTO `comment_likes` VALUES (1,1,10,'2025-09-27 14:51:16');
INSERT IGNORE INTO `course_comments` VALUES (1,4,10,'굿','2025-09-28 00:20:16','2025-09-28 00:26:41',0), (2,4,10,'ㄱㄱ','2025-09-28 00:32:44','2025-09-28 00:32:49',1);
INSERT IGNORE INTO `feed_items` VALUES (6,4,'COURSE',1,1,'2025-09-28 00:42:58'),(7,3,'COURSE',3,1,'2025-09-28 00:42:58'),(8,3,'COURSE',4,1,'2025-09-28 00:42:58');
INSERT IGNORE INTO `follows` VALUES (6,10,7,1,'2025-09-27 16:20:45'),(7,10,3,1,'2025-09-27 16:21:01'),(8,10,2,1,'2025-09-27 16:53:42');
INSERT IGNORE INTO `restaurant_operating_hours` VALUES (8,33,2,'00:00:00','22:00:00'),(9,33,3,'00:00:00','22:00:00'),(10,33,4,'00:00:00','22:00:00'),(11,33,5,'00:00:00','22:00:00'),(12,33,6,'00:00:00','22:00:00'),(13,33,7,'00:00:00','22:00:00');
INSERT IGNORE INTO `restaurant_qna` (id, restaurant_id, question, answer, is_owner, is_resolved, answered_at) VALUES (4,1,'영업시간이 궁금합니다.','평일 오전 10시부터 오후 10시까지 영업합니다.',1,1,'2025-09-28 00:54:05');
INSERT IGNORE INTO `restaurant_reservation_settings` VALUES (1,33,1,1,1,10,30,2,'09:00:00','22:00:00',NULL,NULL,'["2025-09-30"]','5','2025-09-28 15:45:05','2025-09-29 09:37:34',1,'09:00:00','22:00:00',1,'09:00:00','23:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00'),(2,1,1,0,2,8,30,2,'11:00:00','21:00:00','["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]','["11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30"]',NULL,NULL,'2025-09-29 07:24:59','2025-09-29 07:24:59',1,'11:00:00','21:00:00',1,'11:00:00','21:00:00',1,'11:00:00','21:00:00',1,'11:00:00','21:00:00',1,'11:00:00','22:00:00',1,'10:00:00','22:00:00',1,'10:00:00','21:00:00'),(3,2,1,1,1,6,14,1,'09:00:00','22:00:00','["monday", "tuesday", "thursday", "friday", "saturday", "sunday"]','["09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30"]',NULL,NULL,'2025-09-29 07:25:06','2025-09-29 07:25:06',1,'09:00:00','22:00:00',1,'09:00:00','22:00:00',0,'09:00:00','22:00:00',1,'09:00:00','22:00:00',1,'09:00:00','23:00:00',1,'08:00:00','23:00:00',1,'08:00:00','22:00:00');
INSERT IGNORE INTO `user_storages` (storage_id, user_id, name, color_class) VALUES (6,1,'내가 찜한 로그','bg-blue-100'),(7,9,'내가 찜한 로그','bg-blue-100'),(8,8,'내가 찜한 로그','bg-blue-100'),(9,6,'내가 찜한 로그','bg-blue-100'),(10,7,'내가 찜한 로그','bg-blue-100'),(11,10,'내가 찜한 로그','bg-blue-100'),(12,10,'2','bg-green-100'),(13,10,'3','bg-blue-100');
INSERT IGNORE INTO `user_storage_items` VALUES (9,6,'COURSE',1,'2025-09-27 20:01:24'),(12,11,'COURSE',3,'2025-09-27 20:29:30'),(13,11,'COURSE',4,'2025-09-27 23:19:20');


-- Inquiries 샘플 데이터
INSERT INTO inquiries (user_name, email, subject, content, status, reply, created_at, updated_at) VALUES
('김철수', 'kim@example.com', '예약 취소 관련 문의', '어제 예약한 코스를 취소하고 싶은데 어떻게 해야 하나요?', 'PENDING', NULL, NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR),
('이영희', 'lee@example.com', '결제 오류 문의', '결제가 두 번 처리된 것 같습니다. 확인 부탁드립니다.', 'IN_PROGRESS', NULL, NOW() - INTERVAL 5 HOUR, NOW() - INTERVAL 1 HOUR),
('박민수', 'park@example.com', '코스 상세 정보 문의', '강남 맛집 투어 코스의 구체적인 일정을 알려주세요.', 'RESOLVED', '안녕하세요. 강남 맛집 투어는 오전 11시에 시작하여...', NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 12 HOUR),
('정수진', 'jung@example.com', '회원 탈퇴 요청', '개인 사정으로 회원 탈퇴를 원합니다.', 'IN_PROGRESS', NULL, NOW() - INTERVAL 8 HOUR, NOW() - INTERVAL 3 HOUR),
('최동욱', 'choi@example.com', '리뷰 수정 요청', '작성한 리뷰를 수정하고 싶습니다.', 'RESOLVED', '리뷰 페이지에서 직접 수정하실 수 있습니다.', NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 1 DAY),
('강민지', 'kang@example.com', '예약 변경 문의', '예약 날짜를 다음 주로 변경할 수 있나요?', 'PENDING', NULL, NOW() - INTERVAL 30 MINUTE, NOW() - INTERVAL 30 MINUTE),
('윤서아', 'yoon@example.com', '쿠폰 사용 문의', '받은 쿠폰을 어떻게 사용하나요?', 'RESOLVED', '예약 시 쿠폰 코드를 입력하시면 됩니다.', NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 2 DAY),
('조현우', 'jo@example.com', '단체 예약 문의', '10명 이상 단체 예약이 가능한가요?', 'IN_PROGRESS', NULL, NOW() - INTERVAL 4 HOUR, NOW() - INTERVAL 2 HOUR),
('임지훈', 'lim@example.com', '포인트 적립 오류', '포인트가 적립되지 않았습니다.', 'PENDING', NULL, NOW() - INTERVAL 1 HOUR, NOW() - INTERVAL 1 HOUR),
('한소희', 'han@example.com', '맛집 추천 요청', '홍대 근처 맛집 추천 부탁드립니다.', 'RESOLVED', '홍대 맛집 투어 코스를 추천드립니다.', NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 4 DAY),
('송지효', 'song@example.com', '비밀번호 재설정', '비밀번호를 잊어버렸습니다.', 'RESOLVED', '이메일로 비밀번호 재설정 링크를 보내드렸습니다.', NOW() - INTERVAL 6 DAY, NOW() - INTERVAL 5 DAY),
('배수지', 'bae@example.com', '알레르기 정보 문의', '코스에 해산물 알레르기가 있는데 대체 가능한가요?', 'IN_PROGRESS', NULL, NOW() - INTERVAL 6 HOUR, NOW() - INTERVAL 4 HOUR),
('김태희', 'kimt@example.com', '환불 처리 문의', '취소한 예약의 환불이 언제 되나요?', 'PENDING', NULL, NOW() - INTERVAL 3 HOUR, NOW() - INTERVAL 3 HOUR),
('전지현', 'jeon@example.com', '이벤트 참여 문의', '진행 중인 이벤트에 참여하고 싶습니다.', 'RESOLVED', '이벤트 페이지에서 신청하실 수 있습니다.', NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 6 DAY),
('이민호', 'leemh@example.com', '앱 오류 신고', '앱이 자꾸 종료됩니다.', 'IN_PROGRESS', NULL, NOW() - INTERVAL 10 HOUR, NOW() - INTERVAL 5 HOUR),
('박보검', 'parkbg@example.com', '추천인 코드 문의', '추천인 코드는 어디서 확인하나요?', 'RESOLVED', '마이페이지에서 확인하실 수 있습니다.', NOW() - INTERVAL 4 DAY, NOW() - INTERVAL 3 DAY),
('수지', 'suzy@example.com', 'VIP 등급 혜택 문의', 'VIP 등급 혜택이 무엇인가요?', 'PENDING', NULL, NOW() - INTERVAL 45 MINUTE, NOW() - INTERVAL 45 MINUTE),
('아이유', 'iu@example.com', '코스 예약 확인', '예약이 제대로 됐는지 확인하고 싶습니다.', 'RESOLVED', '예약이 정상적으로 완료되었습니다.', NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 7 DAY),
('공유', 'gong@example.com', '기업 제휴 문의', '회사 단체 예약 제휴가 가능한가요?', 'IN_PROGRESS', NULL, NOW() - INTERVAL 12 HOUR, NOW() - INTERVAL 6 HOUR),
('손예진', 'son@example.com', '선물하기 기능 문의', '코스를 선물할 수 있나요?', 'PENDING', NULL, NOW() - INTERVAL 20 MINUTE, NOW() - INTERVAL 20 MINUTE);

-- FAQ 샘플 데이터 삽입
INSERT INTO faqs (category, question, answer, display_order, is_active) VALUES
('계정 관련', '비밀번호를 잊어버렸어요. 어떻게 해야 하나요?', '로그인 페이지에서 ''비밀번호 찾기''를 클릭하시면 가입하신 이메일로 비밀번호 재설정 링크를 보내드립니다.', 1, 1),
('계정 관련', '회원탈퇴는 어떻게 하나요?', '마이페이지 > 계정 설정에서 회원탈퇴를 진행하실 수 있습니다. 탈퇴 시 모든 데이터가 삭제되며 복구가 불가능합니다.', 2, 1),
('계정 관련', '이메일 변경이 가능한가요?', '보안상의 이유로 가입 이메일 변경은 지원하지 않습니다. 새로운 이메일로 재가입을 하시기 바랍니다.', 3, 1),
('예약 관련', '예약을 취소하고 싶어요.', '마이페이지 > 예약 내역에서 예약 취소가 가능합니다. 예약 시간 2시간 전까지만 취소 가능합니다.', 4, 1),
('예약 관련', '예약 확인은 어떻게 하나요?', '예약 완료 후 가입하신 이메일로 확인 메일이 발송되며, 마이페이지에서도 확인하실 수 있습니다.', 5, 1),
('예약 관련', '예약 인원을 변경할 수 있나요?', '예약 인원 변경은 해당 음식점에 직접 연락하시거나, 기존 예약을 취소하고 다시 예약해주세요.', 6, 1),
('서비스 이용', '리뷰는 어떻게 작성하나요?', '음식점 상세 페이지 하단의 ''리뷰 작성'' 버튼을 클릭하여 작성하실 수 있습니다. 사진과 함께 올리시면 더욱 좋습니다.', 7, 1),
('서비스 이용', '팔로우 기능은 무엇인가요?', '다른 사용자를 팔로우하면 그들의 리뷰와 칼럼을 피드에서 확인할 수 있습니다.', 8, 1),
('서비스 이용', '포인트는 어떻게 적립되나요?', '리뷰 작성, 칼럼 발행, 코스 완주 등의 활동으로 포인트가 적립됩니다. 적립된 포인트는 쿠폰으로 교환 가능합니다.', 9, 1),
('기타', '음식점 정보가 잘못되어 있어요.', '음식점 상세 페이지 하단의 ''정보 수정 제안'' 버튼을 통해 신고해주시면 확인 후 수정하겠습니다.', 10, 1),
('기타', '앱이 자주 꺼져요.', '앱 재설치 후에도 문제가 지속되면 고객센터(help@meetlog.com)로 연락해주세요. 기기 정보와 오류 상황을 함께 알려주시면 더 빠른 해결이 가능합니다.', 11, 1),
('기타', '제휴 문의는 어디로 하나요?', '사업 제휴 및 입점 문의는 business@meetlog.com으로 연락해주시기 바랍니다.', 12, 1);

-- =====================================================
-- 1. inquiries 테이블 기존 데이터 업데이트 (admin-statistics-sample-data.sql 에서 가져옴)
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
-- 2. 고객 만족도 샘플 데이터 (admin-statistics-sample-data.sql 에서 가져옴)
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
-- 3. 월별 통계 데이터 (최근 6개월) (admin-statistics-sample-data.sql 에서 가져옴)
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
-- 4. 카테고리별 통계 (최근 3개월) (admin-statistics-sample-data.sql 에서 가져옴)
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
-- 5. 지역별 통계 (최근 3개월) (admin-statistics-sample-data.sql 에서 가져옴)
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
-- 6. 지점 월별 성과 (branches 테이블이 있다고 가정) (admin-statistics-sample-data.sql 에서 가져옴)
-- =====================================================

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
-- 7. 일별 활동 통계 (최근 30일) (admin-statistics-sample-data.sql 에서 가져옴)
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
-- 8. 지점 샘플 데이터 (성과 데이터를 위한 기본 지점) (admin-statistics-sample-data.sql 에서 가져옴)
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
-- 9. 맛집 인기도 (최근 4주, 상위 맛집만) (admin-statistics-sample-data.sql 에서 가져옴)
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

-- ===================================================================
-- 4. 제약 조건 및 인덱스 활성화
-- ===================================================================
ALTER TABLE users ADD COLUMN social_provider VARCHAR(20) NULL COMMENT '소셜 로그인 제공자 (KAKAO, NAVER, GOOGLE)';
ALTER TABLE users ADD COLUMN social_id VARCHAR(255) NULL COMMENT '소셜 서비스의 고유 사용자 ID';

-- 소셜 ID는 중복 로그인을 방지하기 위해 UNIQUE 제약조건을 거는 것이 좋습니다.
ALTER TABLE users ADD UNIQUE `UK_social` (social_provider, social_id);

-- 기존 이메일/비밀번호 가입자는 social_id가 없으므로, email을 UNIQUE로 설정하여 중복 가입을 방지합니다.
ALTER TABLE users ADD UNIQUE `UK_email` (email);

-- inquiries 테이블 추가 인덱스
CREATE INDEX IF NOT EXISTS idx_inquiries_status ON inquiries(status);
CREATE INDEX IF NOT EXISTS idx_inquiries_category ON inquiries(category);
CREATE INDEX IF NOT EXISTS idx_inquiries_priority ON inquiries(priority);
CREATE INDEX IF NOT EXISTS idx_inquiries_created ON inquiries(created_at DESC);

-- ===================================================================
-- 5. 샘플 데이터 삽입 (reports)
-- ===================================================================
INSERT INTO reports (reporter_id, reported_type, reported_id, reported_user_id, reason, status) VALUES
(1, 'REVIEW', 1, 2, '부적절한 언어 사용 및 욕설', 'PENDING'),
(2, 'COLUMN', 1, 3, '허위 정보 게시', 'PENDING'),
(3, 'COURSE', 1, 4, '스팸 콘텐츠', 'PROCESSED'),
(4, 'REVIEW', 2, 2, '광고 및 홍보', 'PENDING'),
(1, 'USER', 5, 5, '부적절한 프로필 이미지', 'DISMISSED');

-- 외래 키 제약 조건 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;
