-- =========================================================
-- 텔레그램 알림 연동을 위한 스키마
-- Migration: 002_add_telegram_integration.sql
-- =========================================================

SET FOREIGN_KEY_CHECKS = 0;

-- tg_link 테이블: 사용자와 텔레그램 채팅방 매핑
CREATE TABLE IF NOT EXISTS tg_link (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '고유 ID',
  user_id      INT NOT NULL COMMENT '회원 ID (users.id)',
  tg_user_id   BIGINT NULL COMMENT '텔레그램 사용자 ID',
  chat_id      VARCHAR(32) NULL COMMENT '채팅방 ID (DM용)',
  start_token  VARCHAR(64) NOT NULL UNIQUE COMMENT '온보딩 토큰',
  state        ENUM('PENDING','ACTIVE','BLOCKED') NOT NULL DEFAULT 'PENDING' COMMENT '연결 상태',
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성 시각',
  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 시각',

  UNIQUE KEY ux_tg_user (user_id),
  KEY ix_tg_state (state),
  KEY ix_start_token (start_token),

  CONSTRAINT fk_tg_link_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='텔레그램 사용자 연결 정보';

-- 텔레그램 메시지 발송 로그 (선택 사항 - 디버깅/통계용)
CREATE TABLE IF NOT EXISTS telegram_message_logs (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '로그 ID',
  tg_link_id    BIGINT NULL COMMENT 'tg_link.id',
  chat_id       VARCHAR(32) NOT NULL COMMENT '수신자 chat_id',
  message_type  ENUM('RESERVATION_CONFIRM','RESERVATION_CANCEL','PAYMENT_SUCCESS','PAYMENT_FAIL','WELCOME','CUSTOM') NOT NULL COMMENT '메시지 유형',
  message_text  TEXT NOT NULL COMMENT '발송한 메시지 내용',
  reference_type VARCHAR(50) NULL COMMENT '참조 타입 (reservation, payment 등)',
  reference_id  BIGINT NULL COMMENT '참조 ID',
  status        ENUM('SENT','FAILED','BLOCKED') NOT NULL DEFAULT 'SENT' COMMENT '발송 상태',
  error_message VARCHAR(500) NULL COMMENT '오류 메시지',
  sent_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '발송 시각',

  KEY ix_tg_link (tg_link_id),
  KEY ix_sent_at (sent_at),
  KEY ix_status (status),

  CONSTRAINT fk_telegram_log_link FOREIGN KEY (tg_link_id) REFERENCES tg_link(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='텔레그램 메시지 발송 로그';

SET FOREIGN_KEY_CHECKS = 1;

-- 초기 인덱스 확인
SHOW INDEX FROM tg_link;
SHOW INDEX FROM telegram_message_logs;
