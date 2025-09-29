-- ===================================================================
-- DATABASE INITIALIZATION SCRIPT (MEETLOG 최종 통합 버전 V2)
-- ===================================================================

-- 데이터베이스가 존재하면 삭제하고 새로 생성 (완전 초기화)
DROP DATABASE IF EXISTS meetlog;
CREATE DATABASE meetlog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE meetlog;

-- 외래 키 제약 조건 임시 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- 1. 테이블 구조 생성 (Create Schema)
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
  KEY `fk_business_users_to_companies` (`company_id`),
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
  KEY `user_id` (`user_id`),
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
  `description` text DEFAULT NULL,
  `image` varchar(1000) DEFAULT NULL,
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
  `feed_type` enum('COLUMN','REVIEW','COURSE') NOT NULL,
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
  `question` text NOT NULL,
  `answer` text NOT NULL,
  `is_owner` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `review_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
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
-- 2. 데이터 삽입 (Insert Data)
-- ===================================================================
INSERT INTO `EVENTS` VALUES
(1,'MEET LOG 가을맞이! 5성급 호텔 뷔페 30% 할인','선선한 가을, MEET LOG가 추천하는 최고의 호텔 뷔페에서 특별한 미식을 경험하세요. MEET LOG 회원 전용 특별 할인을 놓치지 마세요.','이벤트 내용 본문입니다. 상세한 약관과 참여 방법이 여기에 들어갑니다.','https://placehold.co/800x400/f97316/ffffff?text=Hotel+Buffet+Event','2025-09-01','2025-10-31'),
(2,'신규 맛집 \'파스타 팩토리\' 리뷰 이벤트','홍대 \'파스타 팩토리\' 방문 후 MEET LOG에 리뷰를 남겨주세요! 추첨을 통해 2인 식사권을 드립니다!','상세 내용: 1. 파스타 팩토리 방문 2. 사진과 함께 정성스러운 리뷰 작성 3. 자동 응모 완료!','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832','2025-09-10','2025-09-30'),
(3,'[종료] 여름맞이 치맥 하우스! 수제맥주 1+1','무더운 여름 밤, 종로 \'치맥 하우스\'에서 시원한 수제맥주 1+1 이벤트를 즐겨보세요. MEET LOG 회원이라면 누구나!','본 이벤트는 8월 31일부로 종료되었습니다. 성원에 감사드립니다.','https://placehold.co/800x400/fbbf24/ffffff?text=Beer+Event+(Finished)','2025-07-01','2025-08-31'),
(4,'이번 주 최고의 리뷰 선정','정성스러운 맛집 리뷰를 작성하고 10,000 포인트를 받으세요!','매주 3명을 선정하여 10,000 포인트를 드립니다. 사진 3장 이상, 200자 이상의 리뷰가 대상입니다. 당첨자는 매주 월요일 공지됩니다.','https://example.com/images/events/best_review_contest.jpg','2025-09-15','2025-09-21'),
(5,'신규 오픈 \'강남 이탈리안 키친\' 방문 챌린지','\'강남 이탈리안 키친\' 방문 리뷰 작성 시, 참여자 전원 3,000 포인트 증정!','강남역 10번 출구에 새로 오픈한 \'이탈리안 키친\'에 방문하고 #강남이탈리안키친 태그와 함께 인증샷, 리뷰를 남겨주세요. (1인 1회 한정)','https://example.com/images/restaurants/gangnam_italian_promo.png','2025-09-10','2025-10-10'),
(6,'\'나만의 가을 맛집\' 추천 이벤트','가을 분위기 물씬 나는 나만 아는 맛집을 공유해주세요. 5분께 백화점 상품권 증정!','#가을맛집 태그를 달아 커뮤니티에 글을 작성해주세요. 추첨을 통해 5분께 백화점 상품권 5만원권을 드립니다.','/static/images/events/autumn_food_challenge.gif','2025-09-16','2025-09-30'),
(7,'맛zip 커뮤니티 10만 회원 달성!','감사하는 마음으로 이벤트 기간 동안 로그인하는 모든 회원님께 1,000 포인트를 드립니다.',NULL,'https://example.com/images/events/100k_members_party.jpg','2025-10-01','2025-10-07'),
(8,'첫 리뷰 작성 100% 선물','가입 후 첫 맛집 리뷰를 작성하시면 스타벅스 기프티콘 증정!','정성스러운 첫 리뷰를 작성해주시는 모든 신규 회원님께 감사의 의미로 스타벅스 아메리카노 기프티콘을 드립니다. (본 이벤트는 별도 공지 시까지 계속됩니다)',NULL,'2025-01-01',NULL);
INSERT INTO `alerts` VALUES
(1,4,'<span class="font-bold">미스터노포</span>님이 회원님을 팔로우하기 시작했습니다.',0,'2025-09-16 20:00:00'),
(2,4,'<span class="font-bold">중데생</span>님이 회원님의 [홍대 최고의 파스타...] 칼럼에 댓글을 남겼습니다.',1,'2025-09-16 18:00:00'),
(3,4,'[공지] 개인정보처리방침 개정 안내',1,'2025-09-14 09:00:00');
INSERT INTO `badges` VALUES
(1,'🏆','첫 리뷰','첫 리뷰를 작성하여 획득'),
(2,'✍️','칼럼니스트 데뷔','첫 칼럼을 발행하여 획득'),
(3,'📸','포토그래퍼','리뷰에 사진 10장 첨부하여 획득'),
(4,'👍','첫 팔로워','첫 팔로워가 생기면 획득');
INSERT INTO `business_users` VALUES
(10,'구구콘','구구','999999999','INDIVIDUAL','APPROVED',1,'2025-09-27 01:29:10','2025-09-27 01:29:10');
INSERT INTO `column_comments` VALUES
(1,1,8,'여기 학교 앞이라 지나가다가 봤는데 이런 맛집인지 몰랐어요 가봐야겠네요!',NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(2,1,9,'비건 빵집이라니! 츄라이 해봐야겠어요!',NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(3,3,10,'ㅎㅇ',NULL,0,1,'2025-09-27 14:51:21','2025-09-27 14:51:21'),
(4,15,10,'지쟈스',NULL,0,1,'2025-09-27 16:42:45','2025-09-28 19:49:44');
INSERT INTO `column_likes` VALUES
(1,3,10,'2025-09-27 14:51:16'),
(2,15,10,'2025-09-27 14:58:15');
INSERT INTO `columns` VALUES
(1,3,'상도동 비건 빵집 \'우부래도\' 솔직 리뷰','상도동에는 숨겨진 비건 빵 맛집들이 많습니다. 그 중에서도 제가 가장 사랑하는 곳은 바로 \'우부래도\'입니다. 특히 이곳의 쌀바게트는 정말 일품입니다. 겉은 바삭하고 속은 쫀득한 식감이 살아있죠.

제가 남겼던 리뷰를 첨부해봅니다. 여러분도 상도동에 가시면 꼭 들러보세요!','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832',NULL,0,7,1,'2025-09-27 01:27:51','2025-09-27 19:42:18'),
(2,2,'을지로 직장인들을 위한 최고의 평양냉면','여름이면 어김없이 생각나는 평양냉면. 을지로의 수많은 노포 중에서도 \'평양면옥\'은 단연 최고라고 할 수 있습니다. 슴슴하면서도 깊은 육수 맛이 일품입니다. 점심시간에는 웨이팅이 길 수 있으니 조금 서두르는 것을 추천합니다.','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832',NULL,0,2,1,'2025-09-27 01:27:51','2025-09-27 16:53:31'),
(3,1,'한식 다이닝의 정수, 강남 \'고미정\' 방문기','특별한 날, 소중한 사람과 함께할 장소를 찾는다면 강남의 \'고미정\'을 추천합니다. 정갈한 상차림과 깊은 맛의 한정식 코스는 먹는 내내 감탄을 자아냅니다. 특히 부모님을 모시고 가기에 최고의 장소입니다.','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832',NULL,1,2,1,'2025-09-27 01:27:51','2025-09-27 14:51:21'),
(4,4,'홍대 최고의 파스타, 데이트 성공 보장!','홍대에서 데이트 약속이 잡혔다면 고민하지 말고 \'파스타 팩토리\'로 가세요. 분위기, 맛, 서비스 뭐 하나 빠지는 게 없는 곳입니다. 특히 트러플 크림 파스타는 꼭 먹어봐야 할 메뉴입니다.','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(5,5,'가산디지털단지 직장인 점심 맛집 BEST 3','매일 반복되는 점심 메뉴 고민, 힘드시죠? G밸리 5년차 직장인이 추천하는 점심 맛집 리스트를 공개합니다. \'직장인 국밥\'부터...','https://placehold.co/600x400/f97316/ffffff?text=국밥',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(6,6,'퇴근 후 한잔, 가산 이자카야 \'가디\' 방문기','지친 하루의 피로를 풀어주는 시원한 맥주와 맛있는 안주. \'가디 이자카야\'는 회식 2차 장소로도, 혼술하기에도 좋은 곳입니다.','https://placehold.co/600x400/14b8a6/ffffff?text=이자카야',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(7,3,'성수동에서 발견한 인생 커피, \'카페 클라우드\'','수많은 성수동 카페들 속에서 보석 같은 곳을 발견했습니다. 바로 \'카페 클라우드\'입니다. 특히 이곳의 시그니처 라떼는...','https://placehold.co/600x400/34d399/ffffff?text=카페',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(8,4,'이태원 수제버거의 정석, \'브루클린 버거\'','육즙 가득한 패티와 신선한 야채의 조화. \'브루클린 버거\'는 언제나 옳은 선택입니다. 치즈 스커트 버거는 꼭 드셔보세요.','https://placehold.co/600x400/fb923c/ffffff?text=버거',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(9,5,'G밸리 회식장소 끝판왕, \'월화 G밸리점\'','두툼한 목살과 삼겹살이 일품인 곳. 단체석도 잘 마련되어 있어 가산디지털단지 회식 장소로 이만한 곳이 없습니다.','https://placehold.co/600x400/ef4444/ffffff?text=고기',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(10,6,'종로 치맥의 성지, \'치맥 하우스\'를 가다','바삭한 치킨과 시원한 생맥주의 조합은 진리입니다. \'치맥 하우스\'는 다양한 종류의 수제 맥주를 맛볼 수 있어 더욱 좋습니다.','https://placehold.co/600x400/fbbf24/ffffff?text=치킨',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(11,1,'여의도 오마카세 입문자에게 추천, \'스시 마에\'','오마카세가 처음이라 부담스러우신가요? \'스시 마에\'는 합리적인 가격과 친절한 설명으로 입문자들에게 최고의 경험을 선사합니다.','https://placehold.co/600x400/60a5fa/ffffff?text=오마카세',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(12,2,'명동의 숨은 맛, \'북경 오리\' 전문점 탐방','북적이는 명동 거리 안쪽에 위치한 이 곳은 수십 년 경력의 주방장님이 선보이는 정통 북경 오리 요리를 맛볼 수 있는 숨은 고수의 가게입니다.','https://placehold.co/600x400/f472b6/ffffff?text=중식',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(13,5,'가산 W몰 쇼핑 후 필수코스, \'샐러디\'','쇼핑으로 지쳤을 때, 건강하고 가볍게 한 끼 식사를 해결하고 싶다면 \'샐러디\'를 추천합니다. 든든한 웜볼 메뉴가 특히 좋습니다.','https://placehold.co/600x400/22c55e/ffffff?text=샐러드',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(14,1,'인사동 골목의 정겨움, \'소담길\' 보쌈정식','전통적인 분위기의 인사동에서 맛보는 부드러운 보쌈과 맛깔나는 반찬들. \'소담길\'은 부모님을 모시고 가기에도 손색없는 곳입니다.','https://placehold.co/600x400/c084fc/ffffff?text=보쌈',NULL,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(15,10,'어서오고','<p>어 도우너 어서오고</p>
<p>이거 테스트인데 100자 채워야함</p>
<p>초능력 맛좀 볼래?</p>
<p>이래도 100자가 안채워지네</p>
<p>오바쓴 오오바쓴인데</p>
<p>료이키 텐카이 무료쿠쇼</p>
<p>빅베이비팝 빅베이비팝 한번 먹어봐요 또 흔들어 먹어요</p>
<p>새로나온 빅베이비 팝~!</p>
<p>123 굿</p>','e58dc538-e353-481c-9a1c-d326885d8d01_어서오고.jpeg',NULL,1,12,1,'2025-09-27 14:54:04','2025-09-28 19:49:40');
INSERT INTO `companies` VALUES
(1,'구구콘','2025-09-27 01:29:10','2025-09-27 01:29:10');
INSERT INTO `coupons` VALUES
(1,11,'비건 디저트 20% 할인','MEET LOG 회원 인증 시 제공','~ 2025.12.31',1,'2025-09-27 01:27:51'),
(2,1,'상견례 10% 할인','상견례 예약 시 제공','~ 2025.12.31',1,'2025-09-27 01:27:51'),
(3,2,'에이드 1잔 무료','MEET LOG 회원 인증 시 제공','~ 2025.12.31',1,'2025-09-27 01:27:51');
INSERT INTO `course_comments` VALUES
(1,4,10,'굿','2025-09-28 00:20:16','2025-09-28 00:26:41',0),
(2,4,10,'ㄱㄱ','2025-09-28 00:32:44','2025-09-28 00:32:49',1);
INSERT INTO `course_likes` VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(1,2),
(4,2),
(1,3),
(2,3),
(2,4),
(3,4),
(4,4),
(1,5),
(3,5),
(4,5);
INSERT INTO `course_reservations` VALUES
(1,2,3,'빵순이','010-1234-5678','bbang@meetlog.com','2025-09-20','14:00',2,30000,'CONFIRMED','2025-09-27 01:27:51');
INSERT INTO `course_reviews` VALUES
(1,1,3,5,'이 코스 그대로 다녀왔는데 정말 좋았어요! 파스타 팩토리 진짜 맛있네요. 추천 감사합니다!','2025-09-27 01:27:51','좋게 봐주셔서 감사합니다! (작성자: 데이트장인)'),
(2,3,5,4,'미스터노포님 믿고 다녀왔습니다. 평양면옥은 역시 최고네요. 치맥하우스는 그냥 그랬어요.','2025-09-27 01:27:51','방문 감사합니다! (작성자: 미스터노포)');
INSERT INTO `course_steps` VALUES
(1,1,1,'RESTAURANT','🍝','파스타 팩토리 (ID: 2)','분위기 좋은 곳에서 맛있는 파스타로 시작!','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832'),
(2,1,2,'ETC','🚶','연남동 산책','소화시킬 겸 연트럴파크를 가볍게 산책하세요.',NULL),
(3,1,3,'RESTAURANT','☕','연남동 감성 카페','분위기 좋은 카페에서 디저트와 커피로 마무리.','https://placehold.co/600x400/fde68a/ffffff?text=Yeonnam+Cafe'),
(4,2,1,'RESTAURANT','🍔','브루클린 버거 (ID: 7)','육즙 가득한 수제버거로 든든하게 시작!','https://placehold.co/600x400/fb923c/ffffff?text=버거'),
(5,2,2,'ETC','🛍️','성수 소품샵 구경','아기자기한 소품샵들을 구경하며 성수의 감성을 느껴보세요.',NULL),
(6,2,3,'RESTAURANT','🍰','카페 클라우드 (ID: 5)','뷰맛집 카페에서 시그니처 케이크와 커피 즐기기','https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg'),
(7,3,1,'RESTAURANT','🍜','평양면옥 (ID: 10)','슴슴한 평양냉면으로 속을 달래며 1차 시작','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832'),
(8,3,2,'RESTAURANT','🍺','치맥 하우스 (ID: 4)','바삭한 치킨과 시원한 수제맥주로 2차 마무리!','https://placehold.co/600x400/fbbf24/ffffff?text=치킨'),
(9,4,1,'RESTAURANT','☕','카페 클라우드 (ID: 5)','뷰맛집 카페에서 시그니처 케이크와 커피','https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg'),
(10,4,2,'RESTAURANT','🍞','성수동 대림창고','공장을 개조한 갤러리형 카페에서 커피 한 잔','https://placehold.co/600x400/8d99ae/ffffff?text=대림창고');
INSERT INTO `course_tags` VALUES
(1,1),
(2,1),
(1,2),
(2,3),
(4,3),
(1,4),
(2,5),
(4,5),
(1,6),
(3,6),
(4,6),
(3,7),
(3,8),
(3,9),
(4,10),
(4,11);
INSERT INTO `courses` VALUES
(1,'홍대 데이트 완벽 코스 (파스타+카페)','데이트장인이 추천하는 홍대 데이트 코스입니다. 이대로만 따라오시면 실패 없는 하루!','홍대/연남','약 3시간',0,0,'PENDING','2025-09-27 01:27:51','COMMUNITY','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832',4),
(2,'[MEET LOG] 성수동 감성 투어','MEET LOG가 직접 큐레이션한 성수동 감성 맛집과 카페 코스입니다. 힙한 성수를 느껴보세요.','성수/건대','약 4시간',0,0,'PENDING','2025-09-27 01:27:51','OFFICIAL','https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg',NULL),
(3,'을지로 직장인 힐링 코스','미스터노포가 추천하는 을지로 찐 맛집 코스. 칼퇴하고 바로 달려가세요.','을지로','약 2.5시간',0,0,'PENDING','2025-09-27 01:27:51','COMMUNITY','https://mblogthumb-phinf.pstatic.net/MjAyMTAzMTdfNTUg/MDAxNjE1OTM3NTYyNDA4.q9XslyF7jKUHI6QbbhHqbBqk19Ox3GNAQoT9hxbqOkAg.fRlvymC8y7o-4LgTKKPUHR4zymM4da2dnHPtRveiD8Mg.JPEG.ichufs/DSC_3894.jpg?type=w800',3),
(4,'성수동 카페 뽀개기','빵순이가 추천하는 성수동 디저트 카페 완전 정복 코스','성수','약 3시간',0,0,'PENDING','2025-09-27 01:27:51','COMMUNITY','https://placehold.co/600x400/c4b5fd/ffffff?text=Seongsu+Cafe',3);
INSERT INTO `detailed_ratings` VALUES
(1,11,4.0,3.3,3.3,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(2,1,4.9,4.5,4.8,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(3,2,4.7,4.2,4.5,'2025-09-27 01:27:51','2025-09-27 01:27:51');
INSERT INTO `feed_items` VALUES
(1,3,'COLUMN',1,1,'2025-09-16 19:00:00'),
(2,2,'REVIEW',4,1,'2025-09-15 14:00:00'),
(3,8,'COLUMN',1,1,'2025-09-27 01:27:51'),
(4,9,'REVIEW',1,1,'2025-09-27 00:27:51'),
(5,8,'COLUMN',2,1,'2025-09-26 23:27:51'),
(6,4,'COURSE',1,1,'2025-09-28 00:42:58'),
(7,3,'COURSE',3,1,'2025-09-28 00:42:58'),
(8,3,'COURSE',4,1,'2025-09-28 00:42:58');
INSERT INTO `follows` VALUES
(1,2,4,1,'2025-09-27 01:27:51'),
(2,4,3,1,'2025-09-27 01:27:51'),
(3,4,2,1,'2025-09-27 01:27:51'),
(4,8,9,1,'2025-09-27 01:27:51'),
(5,9,8,1,'2025-09-27 01:27:51'),
(6,10,7,1,'2025-09-27 16:20:45'),
(7,10,3,1,'2025-09-27 16:21:01'),
(8,10,2,1,'2025-09-27 16:53:42');
INSERT INTO `menus` VALUES
(16,1,'궁중 수라상','75,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(17,1,'고미정 정식','55,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(18,1,'보리굴비 정식','45,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(19,2,'트러플 크림 파스타','18,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(20,2,'봉골레 파스타','16,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(21,2,'마르게리따 피자','20,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(22,3,'런치 오마카세','120,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(23,3,'디너 오마카세','250,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(24,4,'반반치킨','19,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(25,4,'종로 페일에일','7,500원',NULL,NULL,0,'2025-09-27 01:27:51'),
(26,5,'아인슈페너','7,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(27,5,'클라우드 케이크','8,500원',NULL,NULL,0,'2025-09-27 01:27:51'),
(28,11,'단호박 머핀','4,000원',NULL,NULL,0,'2025-09-27 01:27:51'),
(29,11,'쌀바게트','4,500원',NULL,NULL,0,'2025-09-27 01:27:51'),
(30,11,'홍국단팥빵','4,000원',NULL,NULL,0,'2025-09-27 01:27:51');
INSERT INTO `notices` VALUES
(1,'개인정보처리방침 개정 안내','개인정보처리방침이 개정되어 안내드립니다. ...','2025-09-01'),
(2,'서버 점검 안내 (09/15 02:00 ~ 04:00)','보다 나은 서비스 제공을 위해 서버 점검을 실시합니다. ...','2025-09-08'),
(3,'나만의 코스 만들기 기능 업데이트 안내','이제 나만의 맛집 코스를 만들고 친구들과 공유할 수 있습니다. 많은 이용 바랍니다.','2025-09-10');
INSERT INTO `rating_distributions` VALUES
(1,11,0,0,2,1,3,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(2,1,0,0,4,28,120,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(3,2,0,0,18,60,180,'2025-09-27 01:27:51','2025-09-27 01:27:51');
INSERT INTO `reservations` VALUES
(1,11,4,'우부래도','데이트장인','2025-09-14 19:00:00',2,'CONFIRMED',NULL,NULL,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(2,2,4,'파스타 팩토리','데이트장인','2025-09-13 20:00:00',4,'COMPLETED',NULL,NULL,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(3,32,4,'툭툭누들타이','데이트장인','2025-08-15 18:00:00',2,'CANCELLED',NULL,NULL,'2025-09-27 01:27:51','2025-09-27 01:27:51');
INSERT INTO `restaurant_news` VALUES
(1,11,'이벤트','여름 한정! 단호박 빙수 출시!','무더운 여름을 날려버릴 시원하고 달콤한 우부래도표 비건 단호박 빙수가 출시되었습니다. 많은 관심 부탁드립니다!','2025.08.05',1,'2025-09-27 01:27:51'),
(2,1,'공지','겨울 한정 메뉴 출시','따뜻한 겨울을 위한 전통 한정식 메뉴가 새롭게 출시되었습니다.','2025.12.01',1,'2025-09-27 01:27:51'),
(3,2,'이벤트','신메뉴 출시! 트러플 파스타','프리미엄 트러플을 사용한 새로운 파스타 메뉴가 출시되었습니다.','2025.11.20',1,'2025-09-27 01:27:51');
INSERT INTO `restaurant_operating_hours` VALUES
(1,1,1,'11:30:00','22:00:00'),
(2,1,2,'11:30:00','22:00:00'),
(3,1,3,'11:30:00','22:00:00'),
(4,1,4,'11:30:00','22:00:00'),
(5,1,5,'11:30:00','22:00:00'),
(6,1,6,'11:30:00','22:00:00'),
(7,1,7,'11:30:00','22:00:00'),
(8,33,2,'00:00:00','22:00:00'),
(9,33,3,'00:00:00','22:00:00'),
(10,33,4,'00:00:00','22:00:00'),
(11,33,5,'00:00:00','22:00:00'),
(12,33,6,'00:00:00','22:00:00'),
(13,33,7,'00:00:00','22:00:00');
INSERT INTO `restaurant_qna` VALUES
(1,11,'주차는 가능한가요?','네, 가게 앞에 2대 정도 주차 가능합니다.',1,1,'2025-09-27 01:27:51'),
(2,1,'상견례 예약을 하고 싶은데 룸이 있나요?','네, 8~12인까지 수용 가능한 프라이빗 룸이 준비되어 있습니다. 예약 시 말씀해주세요.',1,1,'2025-09-27 01:27:51'),
(3,2,'주말 웨이팅이 긴가요?','네, 주말 저녁에는 웨이팅이 있을 수 있으니 앱을 통해 예약해주시면 편리합니다.',1,1,'2025-09-27 01:27:51'),
(4,1,'영업시간이 궁금합니다.','평일 오전 10시부터 오후 10시까지 영업합니다.',1,1,'2025-09-28 00:54:05');
INSERT INTO `restaurant_reservation_settings` VALUES
(1,33,1,1,1,10,30,2,'09:00:00','22:00:00',NULL,NULL,'["2025-09-30"]','5','2025-09-28 15:45:05','2025-09-29 09:37:34',1,'09:00:00','22:00:00',1,'09:00:00','23:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00',0,'09:00:00','22:00:00'),
(2,1,1,0,2,8,30,2,'11:00:00','21:00:00','["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]','["11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30"]',NULL,NULL,'2025-09-29 07:24:59','2025-09-29 07:24:59',1,'11:00:00','21:00:00',1,'11:00:00','21:00:00',1,'11:00:00','21:00:00',1,'11:00:00','21:00:00',1,'11:00:00','22:00:00',1,'10:00:00','22:00:00',1,'10:00:00','21:00:00'),
(3,2,1,1,1,6,14,1,'09:00:00','22:00:00','["monday", "tuesday", "thursday", "friday", "saturday", "sunday"]','["09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30"]',NULL,NULL,'2025-09-29 07:25:06','2025-09-29 07:25:06',1,'09:00:00','22:00:00',1,'09:00:00','22:00:00',0,'09:00:00','22:00:00',1,'09:00:00','22:00:00',1,'09:00:00','23:00:00',1,'08:00:00','23:00:00',1,'08:00:00','22:00:00');
INSERT INTO `restaurants` VALUES
(1,NULL,'고미정','한식','강남','서울특별시 강남구 테헤란로 123','역삼동 123-45','02-1234-5678','매일 11:00 - 22:00','강남역 한정식, 상견례 장소','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832',4.8,152,1203,37.50100000,127.03900000,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(2,NULL,'파스타 팩토리','양식','홍대','서울 마포구 와우산로29길 14-12','서교동 333-1','02-333-4444','매일 11:30 - 22:00','홍대입구역 소개팅, 데이트 맛집','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832',4.6,258,2341,37.55590000,126.92380000,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(3,NULL,'스시 마에','일식','여의도','서울 영등포구 국제금융로 10','여의도동 23','02-555-6666','매일 12:00 - 22:00 (브레이크타임 15:00-18:00)','여의도 하이엔드 오마카세','https://placehold.co/600x400/60a5fa/ffffff?text=오마카세',4.9,189,1890,37.52500000,126.92500000,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(4,NULL,'치맥 하우스','한식','종로','서울 종로구 종로 123','종로3가 11-1','02-777-8888','매일 16:00 - 02:00','종로 수제맥주와 치킨 맛집','https://placehold.co/600x400/fbbf24/ffffff?text=치킨',4.4,310,3104,37.57000000,126.98900000,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(5,NULL,'카페 클라우드','카페','성수','서울 성동구 연무장길 12','성수동2가 300-1','02-464-1234','매일 10:00 - 22:00','성수동 뷰맛집 감성 카페','https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg',4.5,288,2880,37.54300000,127.05400000,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(6,NULL,'북경 오리','중식','명동','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/f472b6/ffffff?text=중식',4.7,0,1550,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(7,NULL,'브루클린 버거','양식','이태원','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/fb923c/ffffff?text=버거',4.5,0,2543,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(8,NULL,'소담길','한식','인사동','주소 정보 없음',NULL,NULL,NULL,NULL,'https://www.ourhomehospitality.com/hos_img/1720054355745.jpg',4.7,0,980,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(9,NULL,'인도 커리 왕','기타','혜화','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/facc15/ffffff?text=커리',4.5,0,2130,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(10,NULL,'평양면옥','한식','을지로','주소 정보 없음',NULL,NULL,NULL,NULL,'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832',4.8,0,1760,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(11,NULL,'우부래도','베이커리','상도','서울특별시 동작구 상도로37길 3','상도1동 666-3','0507-1428-0599','매일 10:00 - 22:00','상도역 베이커리, 비건','https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832',4.2,6,850,37.49530000,126.94480000,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(12,NULL,'가산생고기','한식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/ef4444/ffffff?text=삼겹살',4.7,0,2850,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(13,NULL,'직장인 국밥','한식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/f97316/ffffff?text=국밥',4.5,0,3120,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(14,NULL,'파파 이탈리아노','양식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/84cc16/ffffff?text=파스타',4.4,0,1890,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(15,NULL,'가디 이자카야','일식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야',4.6,0,2340,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(16,NULL,'마리오아울렛 푸드코트','기타','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/6366f1/ffffff?text=푸드코트',4.3,0,4500,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(17,NULL,'더현대아울렛 중식당','중식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/8b5cf6/ffffff?text=중식',4.5,0,1980,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(18,NULL,'퇴근길 포차','한식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/ec4899/ffffff?text=포차',4.4,0,2670,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(19,NULL,'커피 브레이크 가산점','카페','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/10b981/ffffff?text=Cafe',4.6,0,3500,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(20,NULL,'가산 돈까스 클럽','일식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/f59e0b/ffffff?text=돈까스',4.7,0,2990,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(21,NULL,'구로디지털단지 족발야시장','한식','구로','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/78716c/ffffff?text=족발',4.8,0,3200,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(22,NULL,'월화 G밸리점','한식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/ef4444/ffffff?text=고기',4.8,0,4100,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(23,NULL,'스시메이진 가산점','일식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/3b82f6/ffffff?text=초밥',4.5,0,2800,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(24,NULL,'샐러디 W몰점','양식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/22c55e/ffffff?text=샐러드',4.4,0,1500,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(25,NULL,'베트남 노상식당','기타','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/f97316/ffffff?text=쌀국수',4.5,0,2400,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(26,NULL,'리춘시장 가산디지털역점','중식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/dc2626/ffffff?text=마라탕',4.3,0,2100,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(27,NULL,'폴바셋 현대아울렛가산점','카페','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/172554/ffffff?text=Paul+Bassett',4.7,0,2900,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(28,NULL,'해물품은닭','한식','구로','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/fbbf24/ffffff?text=닭볶음탕',4.7,0,2650,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(29,NULL,'인도요리 아그라','기타','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/c2410c/ffffff?text=커리',4.5,0,1750,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(30,NULL,'오봉집 가산디지털점','한식','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/991b1b/ffffff?text=보쌈',4.6,0,3800,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(31,NULL,'투썸플레이스 가산W몰점','카페','가산','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/ef4444/ffffff?text=Twosome',4.4,0,2200,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(32,NULL,'툭툭누들타이','기타','연남','주소 정보 없음',NULL,NULL,NULL,NULL,'https://placehold.co/600x400/16a34a/ffffff?text=Thai',4.8,0,4500,NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(33,10,'구구콘','고기/구이','강남구','서울 강남구 도산대로 지하 102 1','서울 강남구 신사동 667','0299999999',NULL,'99',NULL,0.0,0,0,37.51643246,127.02032689,0,1,'2025-09-27 01:29:45','2025-09-27 01:29:45','화,수,목,금,토,일','00:00~22:00,00:00~22:00,00:00~22:00,00:00~22:00,00:00~22:00,00:00~22:00','');
INSERT INTO `review_comments` VALUES
(1,10,8,'오 여기 진짜 맛있죠! 저도 쌀바게트 제일 좋아해요.','2025-09-27 01:27:51');
INSERT INTO `reviews` VALUES
(1,2,4,5,'여기 진짜 분위기 깡패에요! 소개팅이나 데이트 초반에 가면 무조건 성공입니다.','["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832"]',NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(2,4,6,4,'일 끝나고 동료들이랑 갔는데, 스트레스가 확 풀리네요. 새로 나온 마늘간장치킨이 진짜 맛있어요.',NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(3,1,7,5,'부모님 생신이라 모시고 갔는데 정말 좋아하셨어요. 음식 하나하나 정성이 느껴져요.','["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832"]',NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(4,10,2,5,'역시 여름엔 평양냉면이죠. 이 집 육수는 정말 최고입니다.',NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(5,12,2,5,'가산에서 이만한 퀄리티의 삼겹살을 찾기 힘듭니다. 회식 장소로 강력 추천!',NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(6,13,5,4,'점심시간에 웨이팅은 좀 있지만, 든든하게 한 끼 해결하기에 최고입니다. 깍두기가 맛있어요.',NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(7,19,3,4,'산미있는 원두를 좋아하시면 여기입니다. 디저트 케이크도 괜찮았어요.',NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(8,14,4,4,'가산에서 파스타 먹고 싶을 때 가끔 들러요. 창가 자리가 분위기 좋아요.',NULL,NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(9,11,4,5,'언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다. 다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!','["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832"]',NULL,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(10,11,3,5,'언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다.
다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!','["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832", "https://d12zq4w4guyljn.cloudfront.net/750_750_20241013104136219_menu_tWPMh0i8m0ba.jpg", "https://d12zq4w4guyljn.cloudfront.net/750_750_20241013104128192_photo_tWPMh0i8m0ba.webp"]','["#음식이 맛있어요", "#재료가 신선해요"]',25,1,'2025-09-27 01:27:51','2025-09-27 01:27:51'),
(11,33,10,5,'9999',NULL,'["음식이 맛있어요","가성비가 좋아요","양이 푸짐해요","친구","회식","인테리어가 예뻐요","좌석이 편해요","조용해요","활기찬 분위기","주차가 편해요","접근성이 좋아요"]',0,0,'2025-09-27 01:40:23','2025-09-27 15:20:42'),
(12,33,10,4,'999990',NULL,'["음식이 맛있어요","데이트","인테리어가 예뻐요","주차가 편해요"]',0,1,'2025-09-27 01:45:48','2025-09-27 15:20:29');
INSERT INTO `tags` VALUES
(9,'노포'),
(1,'데이트'),
(11,'디저트'),
(3,'성수'),
(4,'양식'),
(7,'을지로'),
(8,'직장인'),
(5,'카페'),
(10,'카페투어'),
(6,'커뮤니티추천'),
(2,'홍대');
INSERT INTO `user_badges` VALUES
(3,1,'2025-09-27 01:27:51'),
(3,2,'2025-09-27 01:27:51'),
(3,4,'2025-09-27 01:27:51'),
(4,1,'2025-09-27 01:27:51'),
(4,2,'2025-09-27 01:27:51');
INSERT INTO `user_storage_items` VALUES
(1,1,'RESTAURANT',1,'2025-09-27 01:27:51'),
(2,1,'RESTAURANT',7,'2025-09-27 01:27:51'),
(3,2,'RESTAURANT',10,'2025-09-27 01:27:51'),
(4,3,'RESTAURANT',12,'2025-09-27 01:27:51'),
(5,3,'RESTAURANT',13,'2025-09-27 01:27:51'),
(6,3,'RESTAURANT',22,'2025-09-27 01:27:51'),
(7,4,'RESTAURANT',3,'2025-09-27 01:27:51'),
(8,5,'COURSE',1,'2025-09-27 01:27:51'),
(9,6,'COURSE',1,'2025-09-27 20:01:24'),
(12,11,'COURSE',3,'2025-09-27 20:29:30'),
(13,11,'COURSE',4,'2025-09-27 23:19:20');
INSERT INTO `user_storages` VALUES
(1,4,'강남역 데이트','text-red-500','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(2,4,'혼밥하기 좋은 곳','text-sky-500','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(3,5,'가산 맛집','text-amber-500','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(4,2,'여의도 점심','text-green-500','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(5,3,'저장한 코스','text-violet-500','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(6,1,'내가 찜한 로그','bg-blue-100','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(7,9,'내가 찜한 로그','bg-blue-100','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(8,8,'내가 찜한 로그','bg-blue-100','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(9,6,'내가 찜한 로그','bg-blue-100','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(10,7,'내가 찜한 로그','bg-blue-100','2025-09-27 01:27:51','2025-09-27 01:27:51'),
(11,10,'내가 찜한 로그','bg-blue-100','2025-09-27 19:50:55','2025-09-27 19:50:55'),
(12,10,'2','bg-green-100','2025-09-27 22:34:37','2025-09-27 22:34:37'),
(13,10,'3','bg-blue-100','2025-09-27 23:19:18','2025-09-27 23:19:18');
INSERT INTO `users` VALUES
(1,'kim.expert@meetlog.com','김맛잘알','hashed_password_123','PERSONAL','https://placehold.co/150x150/fca5a5/ffffff?text=C1',1,12500,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(2,'mr.nopo@meetlog.com','미스터노포','hashed_password_123','PERSONAL','https://placehold.co/150x150/93c5fd/ffffff?text=C2',1,8200,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(3,'bbang@meetlog.com','빵순이','hashed_password_123','PERSONAL','https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd',1,25100,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(4,'date.master@meetlog.com','데이트장인','hashed_password_123','PERSONAL','https://placehold.co/150x150/e879f9/ffffff?text=Me',1,1200,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(5,'gasan.worker@meetlog.com','가산직장인','hashed_password_123','PERSONAL','https://placehold.co/150x150/a78bfa/ffffff?text=가산',1,3100,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(6,'after.work@meetlog.com','퇴근후한잔','hashed_password_123','PERSONAL','https://placehold.co/100x100/22d3ee/ffffff?text=U2',1,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(7,'hyonyeo@meetlog.com','효녀딸','hashed_password_123','PERSONAL','https://placehold.co/100x100/f87171/ffffff?text=U3',1,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(8,'jungdae@meetlog.com','중데생','hashed_password_123','PERSONAL','https://bbscdn.df.nexon.com/data7/commu/202004/230754_5e89e63a88677.png',1,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(9,'sando.bread@meetlog.com','상도동빵주먹','hashed_password_123','PERSONAL','https://dcimg1.dcinside.com/viewimage.php?id=3da9da27e7d13c&no=24b0d769e1d32ca73de983fa11d02831c6c0b61130e4349ff064c51af2dccfaaa69ce6d782ffbe3cfce75d0ab4b0153873c98d17df4da1937ce4df7cc1e73f9d543acb95a114b61478ff194f7f2b81facc7cc6acb3074408f65976d67d2fe0deaebbfb2ef40152de',1,0,0,1,'2025-09-27 01:27:51','2025-09-27 01:27:51',NULL,NULL,NULL),
(10,'gugu@meetlog.com','구구콘','m2tFIFw+1psjCYLXjBAbUd3IY8jB6L/VCaB8eEc1tPMKgSQnC9BX/7iOREyyLBiC','BUSINESS',NULL,1,0,0,1,'2025-09-27 01:29:10','2025-09-27 01:29:10','구구','0299999999','도산대로1');

-- ===================================================================
-- 3. 제약 조건 및 인덱스 활성화
-- ===================================================================

-- 외래 키 제약 조건 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;