-- ===================================================================
-- 추천 시스템을 위한 데이터베이스 마이그레이션 스크립트
-- ===================================================================

USE meetlog;

-- 1. 사용자 취향 분석 테이블
CREATE TABLE IF NOT EXISTS user_preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    price_range INT NOT NULL,
    atmosphere VARCHAR(50) NOT NULL,
    preference_score DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    review_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_preference (user_id, category, price_range, atmosphere),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_preferences_user_id (user_id),
    INDEX idx_user_preferences_score (preference_score DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. 맛집 유사도 테이블 (콘텐츠 기반 필터링용)
CREATE TABLE IF NOT EXISTS restaurant_similarity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    similar_restaurant_id INT NOT NULL,
    similarity_score DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_restaurant_similarity (restaurant_id, similar_restaurant_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (similar_restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    INDEX idx_restaurant_similarity_restaurant (restaurant_id),
    INDEX idx_restaurant_similarity_score (similarity_score DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. 사용자 유사도 테이블 (협업 필터링용)
CREATE TABLE IF NOT EXISTS user_similarity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    similar_user_id INT NOT NULL,
    similarity_score DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    common_reviews INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_similarity (user_id, similar_user_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (similar_user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_similarity_user (user_id),
    INDEX idx_user_similarity_score (similarity_score DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. 추천 로그 테이블 (추천 성능 분석용)
CREATE TABLE IF NOT EXISTS recommendation_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recommendation_type ENUM('personalized', 'collaborative', 'content-based', 'hybrid', 'popular') NOT NULL,
    restaurant_id INT NOT NULL,
    recommendation_score DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    clicked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    INDEX idx_recommendation_logs_user (user_id),
    INDEX idx_recommendation_logs_type (recommendation_type),
    INDEX idx_recommendation_logs_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. 추천 시스템 설정 테이블
CREATE TABLE IF NOT EXISTS recommendation_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. 기본 설정값 삽입
INSERT INTO recommendation_settings (setting_key, setting_value, description) VALUES
('collaborative_weight', '0.6', '협업 필터링 가중치'),
('content_based_weight', '0.4', '콘텐츠 기반 필터링 가중치'),
('min_common_reviews', '3', '협업 필터링 최소 공통 리뷰 수'),
('max_recommendations', '20', '최대 추천 개수'),
('cache_duration_minutes', '30', '추천 캐시 지속 시간 (분)'),
('similarity_threshold', '0.3', '유사도 임계값')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- 7. 기존 데이터를 활용한 초기 사용자 취향 분석
-- (기존 리뷰 데이터가 있는 사용자들의 취향을 분석)
INSERT INTO user_preferences (user_id, category, price_range, atmosphere, preference_score, review_count)
SELECT 
    r.user_id,
    res.category,
    COALESCE(res.price_range, 3) as price_range,
    COALESCE(res.atmosphere, '일반') as atmosphere,
    ROUND(AVG(r.rating) / 5.0, 2) as preference_score,
    COUNT(*) as review_count
FROM reviews r
JOIN restaurants res ON r.restaurant_id = res.id
WHERE r.is_active = true 
AND res.is_active = true
GROUP BY r.user_id, res.category, res.price_range, res.atmosphere
HAVING COUNT(*) >= 2  -- 최소 2개 이상의 리뷰가 있는 경우만
ON DUPLICATE KEY UPDATE
    preference_score = VALUES(preference_score),
    review_count = VALUES(review_count),
    updated_at = CURRENT_TIMESTAMP;

-- 8. 인덱스 최적화
CREATE INDEX idx_reviews_user_rating ON reviews(user_id, rating, is_active);
CREATE INDEX idx_reviews_restaurant_rating ON reviews(restaurant_id, rating, is_active);
CREATE INDEX idx_restaurants_category_price ON restaurants(category, price_range, is_active);

-- 9. 추천 시스템 성능을 위한 뷰 생성
CREATE VIEW user_review_summary AS
SELECT 
    u.id as user_id,
    u.nickname,
    COUNT(r.id) as total_reviews,
    AVG(r.rating) as avg_rating,
    AVG(r.taste_rating) as avg_taste_rating,
    AVG(r.service_rating) as avg_service_rating,
    AVG(r.atmosphere_rating) as avg_atmosphere_rating,
    AVG(r.price_rating) as avg_price_rating
FROM users u
LEFT JOIN reviews r ON u.id = r.user_id AND r.is_active = true
WHERE u.is_active = true
GROUP BY u.id, u.nickname;

-- 10. 맛집 추천 통계 뷰
CREATE VIEW restaurant_recommendation_stats AS
SELECT 
    res.id as restaurant_id,
    res.name,
    res.category,
    res.rating,
    res.review_count,
    COUNT(rl.id) as recommendation_count,
    SUM(CASE WHEN rl.clicked = true THEN 1 ELSE 0 END) as click_count,
    ROUND(SUM(CASE WHEN rl.clicked = true THEN 1 ELSE 0 END) / COUNT(rl.id) * 100, 2) as click_rate
FROM restaurants res
LEFT JOIN recommendation_logs rl ON res.id = rl.restaurant_id
WHERE res.is_active = true
GROUP BY res.id, res.name, res.category, res.rating, res.review_count;

-- 11. 마이그레이션 완료 확인
SELECT 'Recommendation system migration completed successfully' as status;
