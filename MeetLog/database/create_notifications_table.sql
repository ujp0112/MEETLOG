-- ===================================================================
-- MEET LOG : Notifications Table Creation Script
-- ===================================================================

USE meetlog;

-- notifications 테이블 생성
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type VARCHAR(50) NOT NULL COMMENT 'follow, like, comment, review, collection, etc.',
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    action_url VARCHAR(500) COMMENT '클릭 시 이동할 URL',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notifications_user_id (user_id),
    INDEX idx_notifications_is_read (is_read),
    INDEX idx_notifications_created_at (created_at DESC)
) COMMENT '사용자 알림 테이블';

-- 알림 타입별 인덱스 추가 (선택적 성능 최적화)
CREATE INDEX idx_notifications_type ON notifications(type);

-- ===================================================================
-- SCRIPT EXECUTION FINISHED
-- ===================================================================
