-- =========================================================
-- 외부 연동 레스토랑 지원 및 클레임 테이블
-- Migration: 003_external_restaurant_support.sql
-- =========================================================

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE restaurants
  ADD COLUMN external_source ENUM('INTERNAL','GOOGLE','KAKAO') NOT NULL DEFAULT 'INTERNAL' AFTER owner_id,
  ADD COLUMN external_id VARCHAR(128) NULL AFTER external_source,
  ADD COLUMN external_synced_at DATETIME NULL AFTER external_id,
  ADD COLUMN supports_interactions TINYINT(1) NOT NULL DEFAULT 1 AFTER external_synced_at,
  ADD COLUMN claimed_flag TINYINT(1) NOT NULL DEFAULT 0 AFTER supports_interactions,
  ADD UNIQUE KEY ux_restaurant_external (external_source, external_id);

UPDATE restaurants
   SET external_source = 'INTERNAL',
       supports_interactions = 1,
       claimed_flag = CASE WHEN owner_id IS NOT NULL THEN 1 ELSE 0 END
 WHERE external_source IS NULL;

CREATE TABLE IF NOT EXISTS restaurant_claim_requests (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '클레임 요청 ID',
  restaurant_id INT NOT NULL COMMENT '대상 레스토랑',
  user_id       INT NOT NULL COMMENT '신청 사용자',
  status        ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING' COMMENT '처리 상태',
  evidence_url  VARCHAR(512) NULL COMMENT '증빙 자료 URL',
  memo          VARCHAR(1000) NULL COMMENT '추가 설명',
  decline_reason VARCHAR(500) NULL COMMENT '거절 사유',
  submitted_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '제출 시각',
  processed_at  DATETIME NULL COMMENT '처리 시각',

  KEY ix_restaurant_claim_status (status),
  KEY ix_restaurant_claim_restaurant (restaurant_id),
  KEY ix_restaurant_claim_user (user_id),
  CONSTRAINT fk_restaurant_claim_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  CONSTRAINT fk_restaurant_claim_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='외부 레스토랑 점주 클레임 요청';

CREATE TABLE IF NOT EXISTS restaurant_external_meta (
  restaurant_id INT PRIMARY KEY COMMENT '레스토랑 ID',
  source        ENUM('GOOGLE','KAKAO') NOT NULL COMMENT '외부 소스',
  payload_json  JSON NULL COMMENT '외부 API 원본 데이터',
  photo_refs_json JSON NULL COMMENT '사진 참조 목록',
  last_synced_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최근 동기화 시각',

  CONSTRAINT fk_restaurant_external_meta FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='외부 레스토랑 세부 정보 스냅샷';

CREATE TABLE IF NOT EXISTS restaurant_external_reviews (
  id                  BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '외부 리뷰 ID',
  restaurant_id       INT NOT NULL COMMENT '레스토랑 ID',
  source              ENUM('GOOGLE','KAKAO') NOT NULL COMMENT '리뷰 출처',
  external_review_id  VARCHAR(191) NOT NULL COMMENT '외부 리뷰 식별자',
  author_name         VARCHAR(191) NULL COMMENT '작성자 이름',
  profile_photo_url   VARCHAR(512) NULL COMMENT '프로필 이미지',
  rating              DECIMAL(2,1) NULL COMMENT '평점',
  content             TEXT NULL COMMENT '리뷰 내용',
  reviewed_at         DATETIME NULL COMMENT '작성 시각',
  payload_json        JSON NULL COMMENT '원본 JSON',
  synced_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '동기화 시각',

  UNIQUE KEY ux_external_review (source, external_review_id),
  KEY ix_external_review_restaurant (restaurant_id),

  CONSTRAINT fk_external_reviews_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='외부 API 리뷰 저장소';

SET FOREIGN_KEY_CHECKS = 1;

