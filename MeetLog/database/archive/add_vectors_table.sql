-- KoBERT 벡터 저장을 위한 테이블 생성
SET FOREIGN_KEY_CHECKS = 0;

-- 레스토랑 콘텐츠 벡터 테이블
CREATE TABLE IF NOT EXISTS restaurant_vectors (
    restaurant_id INT PRIMARY KEY,
    content_vector JSON NOT NULL COMMENT '768차원 KoBERT 임베딩 벡터',
    source_text TEXT COMMENT '벡터 생성에 사용된 원본 텍스트 (디버깅용)',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    INDEX idx_updated_at (updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 사용자 리뷰 벡터 캐시 테이블 (선택적)
CREATE TABLE IF NOT EXISTS user_review_vectors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    review_id INT NOT NULL,
    review_vector JSON NOT NULL COMMENT '768차원 KoBERT 임베딩 벡터',
    rating INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    UNIQUE KEY uk_review_vector (review_id),
    INDEX idx_user_rating (user_id, rating),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
