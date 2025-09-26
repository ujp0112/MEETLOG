-- MEETLOG 프로젝트 좋아요 토글 기능 구현을 위한 SQL문들
-- 작성일: 2025-09-25
-- 작성자: sang

-- 1. 칼럼 좋아요 테이블 생성
CREATE TABLE IF NOT EXISTS column_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    column_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_column_user (column_id, user_id),
    FOREIGN KEY (column_id) REFERENCES `columns`(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 2. 댓글 좋아요 테이블 생성 (이미 존재하는 경우 건너뛰기)
CREATE TABLE IF NOT EXISTS comment_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_comment_user (comment_id, user_id),
    FOREIGN KEY (comment_id) REFERENCES column_comments(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. column_comments 테이블에 like_count 컬럼 추가 (존재하지 않는 경우만)
ALTER TABLE column_comments
ADD COLUMN IF NOT EXISTS like_count INT DEFAULT 0;

-- 4. 기존 데이터의 like_count 초기화 (NULL 값을 0으로 설정)
UPDATE column_comments SET like_count = 0 WHERE like_count IS NULL;

-- 5. 테이블 구조 확인용 쿼리들
-- SELECT * FROM column_likes;
-- SELECT * FROM comment_likes;
-- DESCRIBE column_comments;
-- DESCRIBE `columns`;

-- 6. 좋아요 상태 확인용 쿼리 예제
-- 특정 사용자가 특정 칼럼에 좋아요했는지 확인
-- SELECT id FROM column_likes WHERE column_id = ? AND user_id = ?;

-- 특정 사용자가 특정 댓글에 좋아요했는지 확인
-- SELECT id FROM comment_likes WHERE comment_id = ? AND user_id = ?;

-- 7. 좋아요 수 업데이트 쿼리들
-- 칼럼 좋아요 수 증가
-- UPDATE `columns` SET likes = likes + 1 WHERE id = ?;

-- 칼럼 좋아요 수 감소
-- UPDATE `columns` SET likes = GREATEST(likes - 1, 0) WHERE id = ?;

-- 댓글 좋아요 수 증가
-- UPDATE column_comments SET like_count = COALESCE(like_count, 0) + 1 WHERE id = ?;

-- 댓글 좋아요 수 감소
-- UPDATE column_comments SET like_count = GREATEST(COALESCE(like_count, 1) - 1, 0) WHERE id = ?;

-- 8. 좋아요 추가/제거 쿼리들
-- 칼럼 좋아요 추가
-- INSERT INTO column_likes (column_id, user_id, created_at) VALUES (?, ?, NOW());

-- 칼럼 좋아요 제거
-- DELETE FROM column_likes WHERE column_id = ? AND user_id = ?;

-- 댓글 좋아요 추가
-- INSERT INTO comment_likes (comment_id, user_id, created_at) VALUES (?, ?, NOW());

-- 댓글 좋아요 제거
-- DELETE FROM comment_likes WHERE comment_id = ? AND user_id = ?;

-- 9. 데이터 정합성 확인 쿼리들
-- 칼럼별 실제 좋아요 수와 저장된 좋아요 수 비교
/*
SELECT
    c.id,
    c.title,
    c.likes as stored_likes,
    COUNT(cl.id) as actual_likes
FROM `columns` c
LEFT JOIN column_likes cl ON c.id = cl.column_id
GROUP BY c.id, c.title, c.likes
HAVING stored_likes != actual_likes;
*/

-- 댓글별 실제 좋아요 수와 저장된 좋아요 수 비교
/*
SELECT
    cc.id,
    cc.content,
    cc.like_count as stored_likes,
    COUNT(ccl.id) as actual_likes
FROM column_comments cc
LEFT JOIN comment_likes ccl ON cc.id = ccl.comment_id
GROUP BY cc.id, cc.content, cc.like_count
HAVING stored_likes != actual_likes;
*/

-- 10. 인덱스 추가 (성능 최적화)
-- CREATE INDEX idx_column_likes_column_id ON column_likes(column_id);
-- CREATE INDEX idx_column_likes_user_id ON column_likes(user_id);
-- CREATE INDEX idx_comment_likes_comment_id ON comment_likes(comment_id);
-- CREATE INDEX idx_comment_likes_user_id ON comment_likes(user_id);