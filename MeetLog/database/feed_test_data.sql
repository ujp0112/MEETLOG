-- 피드 시스템 테스트 데이터

-- 테스트용 피드 아이템들 추가
INSERT INTO feed_items (user_id, user_nickname, user_profile_image, action_type, content,
                       target_type, target_id, target_name, target_image, created_at, is_active)
VALUES
    (8, '맛집탐방가', null, 'column', '새 칼럼을 작성했습니다.',
     'column', 1, '비건 빵집에서 맛본 특별한 경험', null, NOW(), true),
    (9, '푸드블로거', null, 'review', '새로운 리뷰를 작성했습니다.',
     'restaurant', 1, '더블랙', null, DATE_SUB(NOW(), INTERVAL 1 HOUR), true),
    (8, '맛집탐방가', null, 'course', '새로운 코스를 만들었습니다.',
     'course', 1, '홍대 맛집 투어', null, DATE_SUB(NOW(), INTERVAL 2 HOUR), true);

-- 팔로우 관계 확인/추가 (사용자 8과 9가 서로 팔로우)
INSERT IGNORE INTO follows (follower_id, following_id, created_at, is_active)
VALUES
    (8, 9, NOW(), true),
    (9, 8, NOW(), true);

-- 피드 데이터 확인 쿼리
-- SELECT * FROM feed_items WHERE is_active = true ORDER BY created_at DESC;
-- SELECT * FROM follows WHERE is_active = true;