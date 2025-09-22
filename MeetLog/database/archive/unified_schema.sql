-- ===================================================================
-- MEET LOG 통합 데이터베이스 스키마
-- 모든 테이블 구조와 인덱스를 포함한 완전한 스키마
-- ===================================================================

-- 데이터베이스 생성 및 설정
CREATE DATABASE IF NOT EXISTS meetlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE meetlog;

-- ===================================================================
-- 1. 기본 테이블들 (Core Tables)
-- ===================================================================

-- 사용자 테이블
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    nickname VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    user_type ENUM('PERSONAL', 'BUSINESS') NOT NULL DEFAULT 'PERSONAL',
    profile_image VARCHAR(500),
    level INT DEFAULT 1,
    follower_count INT DEFAULT 0,
    following_count INT DEFAULT 0,
    restaurant_id INT NULL COMMENT 'BUSINESS 사용자의 경우 연결된 음식점 ID',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE SET NULL
);

-- 맛집 테이블
CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL,
    address VARCHAR(500) NOT NULL,
    jibun_address VARCHAR(500),
    phone VARCHAR(20),
    hours VARCHAR(200),
    description TEXT,
    image VARCHAR(500),
    rating DECIMAL(3,1) DEFAULT 0.0,
    review_count INT DEFAULT 0,
    likes INT DEFAULT 0,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    parking BOOLEAN DEFAULT FALSE,
    -- 상세 정보 컬럼들
    price_range INT DEFAULT 0 COMMENT '가격대: 1=~1만원, 2=1-2만원, 3=2-4만원, 4=4만원+',
    atmosphere VARCHAR(50) COMMENT '분위기: 데이트, 비즈니스, 가족, 혼밥, 친구모임',
    dietary_options JSON COMMENT '식이제한 옵션: 채식, 할랄, 글루텐프리, 비건',
    payment_methods JSON COMMENT '결제 수단: 현금, 카드, 모바일결제, QR결제',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_price_range CHECK (price_range >= 0 AND price_range <= 4)
);

-- 메뉴 테이블
CREATE TABLE menus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    price VARCHAR(50) NOT NULL,
    description TEXT,
    image VARCHAR(500),
    is_popular BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 리뷰 테이블
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    user_id INT NOT NULL,
    author VARCHAR(100) NOT NULL,
    author_image VARCHAR(500),
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    content TEXT NOT NULL,
    images JSON,
    keywords JSON,
    likes INT DEFAULT 0,
    -- 상세 평점 컬럼들
    taste_rating INT DEFAULT 0 COMMENT '맛 평점 (1-5)',
    service_rating INT DEFAULT 0 COMMENT '서비스 평점 (1-5)',
    atmosphere_rating INT DEFAULT 0 COMMENT '분위기 평점 (1-5)',
    price_rating INT DEFAULT 0 COMMENT '가격 평점 (1-5)',
    visit_date DATE COMMENT '방문 날짜',
    party_size INT DEFAULT 1 COMMENT '인원수',
    visit_purpose VARCHAR(50) COMMENT '방문 목적: 데이트, 비즈니스, 가족모임, 친구모임, 혼밥',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_taste_rating CHECK (taste_rating >= 1 AND taste_rating <= 5),
    CONSTRAINT chk_service_rating CHECK (service_rating >= 1 AND service_rating <= 5),
    CONSTRAINT chk_atmosphere_rating CHECK (atmosphere_rating >= 1 AND atmosphere_rating <= 5),
    CONSTRAINT chk_price_rating CHECK (price_rating >= 1 AND price_rating <= 5),
    CONSTRAINT chk_party_size CHECK (party_size >= 1 AND party_size <= 20)
);

-- 칼럼 테이블
CREATE TABLE columns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    author VARCHAR(100) NOT NULL,
    author_image VARCHAR(500),
    title VARCHAR(300) NOT NULL,
    content TEXT NOT NULL,
    image VARCHAR(500),
    tags JSON,
    likes INT DEFAULT 0,
    views INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================================
-- 2. 예약 및 예약 관련 테이블들
-- ===================================================================

-- 예약 테이블
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    user_id INT NOT NULL,
    restaurant_name VARCHAR(200) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    reservation_time TIMESTAMP NOT NULL,
    party_size INT NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    special_requests TEXT,
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================================
-- 3. 소셜 기능 테이블들
-- ===================================================================

-- 팔로우 테이블
CREATE TABLE follows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE KEY unique_follow (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 리뷰 댓글 테이블
CREATE TABLE review_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    review_id INT NOT NULL,
    user_id INT NOT NULL,
    author VARCHAR(100) NOT NULL,
    author_image VARCHAR(500),
    content TEXT NOT NULL,
    parent_id INT DEFAULT NULL,
    like_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES review_comments(id) ON DELETE CASCADE
);

-- 칼럼 댓글 테이블
CREATE TABLE column_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    column_id INT NOT NULL,
    user_id INT NOT NULL,
    author VARCHAR(100) NOT NULL,
    author_image VARCHAR(500),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (column_id) REFERENCES columns(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================================
-- 4. 컬렉션 및 피드 테이블들
-- ===================================================================

-- 컬렉션 테이블
CREATE TABLE collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    cover_image VARCHAR(500),
    is_public BOOLEAN DEFAULT TRUE,
    restaurant_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 컬렉션-맛집 관계 테이블
CREATE TABLE collection_restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    collection_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_collection_restaurant (collection_id, restaurant_id),
    FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 컬렉션 좋아요 테이블
CREATE TABLE collection_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    collection_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_collection_like (collection_id, user_id),
    FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 피드 아이템 테이블
CREATE TABLE feed_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    user_nickname VARCHAR(100) NOT NULL,
    user_profile_image VARCHAR(500),
    action_type ENUM('review', 'follow', 'collection', 'like', 'comment') NOT NULL,
    content TEXT NOT NULL,
    target_type ENUM('restaurant', 'review', 'user', 'collection') NOT NULL,
    target_id INT NOT NULL,
    target_name VARCHAR(200),
    target_image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================================
-- 5. 코스 시스템 테이블들
-- ===================================================================

-- 코스 테이블
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    preview_image VARCHAR(500),
    author_id INT NOT NULL,
    type ENUM('COMMUNITY', 'OFFICIAL') NOT NULL DEFAULT 'COMMUNITY',
    area VARCHAR(100),
    duration VARCHAR(100),
    price INT DEFAULT 0,
    max_participants INT DEFAULT 0,
    status ENUM('PENDING', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 태그 테이블
CREATE TABLE tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 코스-태그 관계 테이블
CREATE TABLE course_tags (
    course_id INT NOT NULL,
    tag_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (course_id, tag_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- 코스 단계 테이블
CREATE TABLE course_steps (
    step_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    step_order INT NOT NULL,
    step_type ENUM('RESTAURANT', 'ACTIVITY', 'TIP') NOT NULL,
    emoji VARCHAR(10),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- 코스 좋아요 테이블
CREATE TABLE course_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_course_like (course_id, user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 코스 예약 테이블
CREATE TABLE course_reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    participant_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(255),
    reservation_date DATE NOT NULL,
    reservation_time VARCHAR(50),
    participant_count INT DEFAULT 1,
    total_price INT DEFAULT 0,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 코스 리뷰 테이블
CREATE TABLE course_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    content TEXT,
    response_content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_course_user_review (course_id, user_id)
);

-- ===================================================================
-- 6. 이벤트 및 뉴스 테이블들
-- ===================================================================

-- 이벤트 테이블
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    summary TEXT,
    content TEXT,
    image VARCHAR(500),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 쿠폰 테이블
CREATE TABLE coupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    validity VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 가게 뉴스 테이블
CREATE TABLE restaurant_news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(300) NOT NULL,
    content TEXT NOT NULL,
    date VARCHAR(20) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- Q&A 테이블
CREATE TABLE restaurant_qna (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    is_owner BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- ===================================================================
-- 7. 평점 및 통계 테이블들
-- ===================================================================

-- 평점 분포 테이블
CREATE TABLE rating_distributions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    rating_1 INT DEFAULT 0,
    rating_2 INT DEFAULT 0,
    rating_3 INT DEFAULT 0,
    rating_4 INT DEFAULT 0,
    rating_5 INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 상세 평점 테이블
CREATE TABLE detailed_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    taste DECIMAL(3,1) DEFAULT 0.0,
    price DECIMAL(3,1) DEFAULT 0.0,
    service DECIMAL(3,1) DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- ===================================================================
-- 8. 추천 시스템 테이블들
-- ===================================================================

-- 사용자 취향 분석 테이블
CREATE TABLE user_preferences (
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
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 맛집 유사도 테이블
CREATE TABLE restaurant_similarity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    similar_restaurant_id INT NOT NULL,
    similarity_score DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_restaurant_similarity (restaurant_id, similar_restaurant_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (similar_restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 사용자 유사도 테이블
CREATE TABLE user_similarity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    similar_user_id INT NOT NULL,
    similarity_score DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    common_reviews INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_similarity (user_id, similar_user_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (similar_user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 추천 로그 테이블
CREATE TABLE recommendation_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recommendation_type ENUM('personalized', 'collaborative', 'content-based', 'hybrid', 'popular') NOT NULL,
    restaurant_id INT NOT NULL,
    recommendation_score DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    clicked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 추천 시스템 설정 테이블
CREATE TABLE recommendation_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ===================================================================
-- 9. 알림 시스템 테이블들
-- ===================================================================

-- 알림 테이블
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('follow', 'like', 'comment', 'review', 'collection') NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    action_url VARCHAR(500),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================================
-- 10. 인덱스 생성
-- ===================================================================

-- 사용자 관련 인덱스
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_nickname ON users(nickname);
CREATE INDEX idx_users_restaurant_id ON users(restaurant_id);
CREATE INDEX idx_users_user_type_restaurant ON users(user_type, restaurant_id);

-- 맛집 관련 인덱스
CREATE INDEX idx_restaurants_category ON restaurants(category);
CREATE INDEX idx_restaurants_location ON restaurants(location);
CREATE INDEX idx_restaurants_rating ON restaurants(rating DESC);
CREATE INDEX idx_restaurants_price_range ON restaurants(price_range);
CREATE INDEX idx_restaurants_atmosphere ON restaurants(atmosphere);

-- 리뷰 관련 인덱스
CREATE INDEX idx_reviews_restaurant_id ON reviews(restaurant_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_created_at ON reviews(created_at DESC);
CREATE INDEX idx_reviews_detailed_ratings ON reviews(taste_rating, service_rating, atmosphere_rating, price_rating);
CREATE INDEX idx_reviews_visit_date ON reviews(visit_date);
CREATE INDEX idx_reviews_visit_purpose ON reviews(visit_purpose);

-- 칼럼 관련 인덱스
CREATE INDEX idx_columns_user_id ON columns(user_id);
CREATE INDEX idx_columns_created_at ON columns(created_at DESC);

-- 예약 관련 인덱스
CREATE INDEX idx_reservations_restaurant_id ON reservations(restaurant_id);
CREATE INDEX idx_reservations_user_id ON reservations(user_id);
CREATE INDEX idx_reservations_reservation_time ON reservations(reservation_time);

-- 팔로우 관련 인덱스
CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);
CREATE INDEX idx_follows_created ON follows(created_at);

-- 코스 관련 인덱스
CREATE INDEX idx_courses_type ON courses(type);
CREATE INDEX idx_courses_author ON courses(author_id);
CREATE INDEX idx_courses_area ON courses(area);
CREATE INDEX idx_course_steps_course ON course_steps(course_id);
CREATE INDEX idx_course_steps_order ON course_steps(course_id, step_order);
CREATE INDEX idx_course_likes_course ON course_likes(course_id);
CREATE INDEX idx_course_likes_user ON course_likes(user_id);
CREATE INDEX idx_course_reservations_course ON course_reservations(course_id);
CREATE INDEX idx_course_reservations_user ON course_reservations(user_id);
CREATE INDEX idx_course_reservations_date ON course_reservations(reservation_date);
CREATE INDEX idx_course_reviews_course ON course_reviews(course_id);
CREATE INDEX idx_course_reviews_user ON course_reviews(user_id);

-- 이벤트 관련 인덱스
CREATE INDEX idx_events_dates ON events(start_date, end_date);
CREATE INDEX idx_events_active ON events(is_active);

-- 추천 시스템 관련 인덱스
CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);
CREATE INDEX idx_user_preferences_score ON user_preferences(preference_score DESC);
CREATE INDEX idx_restaurant_similarity_restaurant ON restaurant_similarity(restaurant_id);
CREATE INDEX idx_restaurant_similarity_score ON restaurant_similarity(similarity_score DESC);
CREATE INDEX idx_user_similarity_user ON user_similarity(user_id);
CREATE INDEX idx_user_similarity_score ON user_similarity(similarity_score DESC);
CREATE INDEX idx_recommendation_logs_user ON recommendation_logs(user_id);
CREATE INDEX idx_recommendation_logs_type ON recommendation_logs(recommendation_type);
CREATE INDEX idx_recommendation_logs_created ON recommendation_logs(created_at);

-- 알림 관련 인덱스
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_created ON notifications(created_at);

-- ===================================================================
-- 11. 뷰 생성 (성능 최적화)
-- ===================================================================

-- 사용자 리뷰 요약 뷰
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

-- 맛집 상세 통계 뷰
CREATE VIEW restaurant_detailed_stats AS
SELECT 
    r.id,
    r.name,
    r.category,
    AVG(rv.taste_rating) as avg_taste,
    AVG(rv.service_rating) as avg_service,
    AVG(rv.atmosphere_rating) as avg_atmosphere,
    AVG(rv.price_rating) as avg_price,
    COUNT(rv.id) as review_count
FROM restaurants r
LEFT JOIN reviews rv ON r.id = rv.restaurant_id AND rv.is_active = true
GROUP BY r.id, r.name, r.category;

-- 맛집 추천 통계 뷰
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

-- ===================================================================
-- 12. 기본 설정값 삽입
-- ===================================================================

-- 추천 시스템 기본 설정
INSERT INTO recommendation_settings (setting_key, setting_value, description) VALUES
('collaborative_weight', '0.6', '협업 필터링 가중치'),
('content_based_weight', '0.4', '콘텐츠 기반 필터링 가중치'),
('min_common_reviews', '3', '협업 필터링 최소 공통 리뷰 수'),
('max_recommendations', '20', '최대 추천 개수'),
('cache_duration_minutes', '30', '추천 캐시 지속 시간 (분)'),
('similarity_threshold', '0.3', '유사도 임계값')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ===================================================================
-- 스키마 생성 완료
-- ===================================================================
SELECT 'MEET LOG 통합 스키마 생성 완료' as status;
