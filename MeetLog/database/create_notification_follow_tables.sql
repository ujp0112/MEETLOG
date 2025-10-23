-- =====================================================
-- MeetLog - Notification & Follow 테이블 생성 스크립트
-- 알림/소셜 기능 (Phase 9)
-- =====================================================

-- notifications 테이블 (알림)
CREATE TABLE IF NOT EXISTS notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '알림 ID',
    user_id INT(11) NOT NULL COMMENT '알림 받을 사용자 ID',
    type VARCHAR(50) NOT NULL COMMENT '알림 유형 (follow, like, comment, review, reservation)',
    title VARCHAR(255) NOT NULL COMMENT '알림 제목',
    content TEXT NOT NULL COMMENT '알림 내용',
    action_url VARCHAR(500) COMMENT '클릭 시 이동할 URL',
    is_read BOOLEAN DEFAULT false COMMENT '읽음 여부',
    actor_id INT(11) COMMENT '알림을 발생시킨 사용자 ID',
    reference_id BIGINT COMMENT '참조 ID (게시글, 댓글 등)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성 시각',
    read_at DATETIME COMMENT '읽은 시각',

    -- 외래 키
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_notification_actor FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE SET NULL,

    -- 인덱스
    INDEX idx_notification_user (user_id),
    INDEX idx_notification_created (created_at),
    INDEX idx_notification_is_read (is_read),
    INDEX idx_notification_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='알림 테이블';

-- follows 테이블 (팔로우)
CREATE TABLE IF NOT EXISTS follows (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '팔로우 ID',
    follower_id INT(11) NOT NULL COMMENT '팔로우하는 사용자 ID',
    following_id INT(11) NOT NULL COMMENT '팔로우 받는 사용자 ID',
    is_active BOOLEAN DEFAULT true COMMENT '활성 여부',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '팔로우 시작 시각',

    -- 외래 키
    CONSTRAINT fk_follow_follower FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_follow_following FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE,

    -- 유니크 제약조건 (중복 팔로우 방지)
    UNIQUE KEY uk_follower_following (follower_id, following_id),

    -- 인덱스
    INDEX idx_follow_follower (follower_id),
    INDEX idx_follow_following (following_id),
    INDEX idx_follow_created (created_at),
    INDEX idx_follow_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='팔로우 테이블';

-- =====================================================
-- 테이블 생성 확인
-- =====================================================
SELECT 'notifications, follows 테이블이 성공적으로 생성되었습니다.' AS message;

-- 테이블 구조 확인
DESCRIBE notifications;
DESCRIBE follows;

-- =====================================================
-- 샘플 데이터
-- =====================================================

-- 알림 샘플 데이터
INSERT INTO notifications (user_id, type, title, content, action_url, is_read, actor_id) VALUES
(1, 'follow', '새 팔로워', '홍길동님이 회원님을 팔로우하기 시작했습니다.', '/users/2', false, 2),
(1, 'like', '새 좋아요', '김철수님이 회원님의 리뷰를 좋아합니다.', '/reviews/1', false, 3),
(2, 'comment', '새 댓글', '이영희님이 회원님의 코스에 댓글을 남겼습니다.', '/courses/1', false, 1),
(2, 'review', '새 리뷰', '회원님의 레스토랑에 새로운 리뷰가 등록되었습니다.', '/restaurants/1', true, 3);

-- 팔로우 샘플 데이터
INSERT INTO follows (follower_id, following_id, is_active) VALUES
(1, 2, true),  -- 사용자 1이 사용자 2를 팔로우
(1, 3, true),  -- 사용자 1이 사용자 3을 팔로우
(2, 1, true),  -- 사용자 2가 사용자 1을 팔로우 (맞팔)
(3, 1, true);  -- 사용자 3이 사용자 1을 팔로우

SELECT '샘플 데이터가 삽입되었습니다.' AS message;

-- =====================================================
-- 통계 확인
-- =====================================================

-- 알림 통계
SELECT
    COUNT(*) as total_notifications,
    SUM(CASE WHEN is_read = false THEN 1 ELSE 0 END) as unread_notifications,
    SUM(CASE WHEN is_read = true THEN 1 ELSE 0 END) as read_notifications
FROM notifications;

-- 팔로우 통계
SELECT
    COUNT(*) as total_follows,
    COUNT(DISTINCT follower_id) as unique_followers,
    COUNT(DISTINCT following_id) as unique_following
FROM follows
WHERE is_active = true;

-- 사용자별 팔로워/팔로잉 수
SELECT
    u.id,
    u.nickname,
    (SELECT COUNT(*) FROM follows WHERE following_id = u.id AND is_active = true) as followers_count,
    (SELECT COUNT(*) FROM follows WHERE follower_id = u.id AND is_active = true) as following_count
FROM users u
LIMIT 10;

-- =====================================================
-- 인덱스 확인
-- =====================================================
SHOW INDEX FROM notifications;
SHOW INDEX FROM follows;
