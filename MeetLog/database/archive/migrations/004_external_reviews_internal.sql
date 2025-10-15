-- =========================================================
-- 외부 리뷰 내부화 지원
-- Migration: 004_external_reviews_internal.sql
-- =========================================================

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE reviews
  ADD COLUMN source ENUM('INTERNAL','GOOGLE','KAKAO') NOT NULL DEFAULT 'INTERNAL' AFTER user_id,
  ADD COLUMN external_review_id VARCHAR(191) NULL AFTER source,
  ADD COLUMN external_author_name VARCHAR(191) NULL AFTER external_review_id,
  ADD COLUMN external_profile_image VARCHAR(512) NULL AFTER external_author_name,
  ADD COLUMN external_created_at DATETIME NULL AFTER external_profile_image,
  ADD COLUMN external_raw_json JSON NULL AFTER external_created_at,
  ADD UNIQUE KEY ux_reviews_external (source, external_review_id);

UPDATE reviews
   SET source = 'INTERNAL'
 WHERE source IS NULL;

SET FOREIGN_KEY_CHECKS = 1;

