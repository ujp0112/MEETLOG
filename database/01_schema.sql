-- ===================================================================
-- MEET LOG : Database Schema Script (DDL)
-- ===================================================================

-- 데이터베이스 선택
USE meetlog;

-- 외래 키 제약 조건 임시 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- 1. 기존 테이블 삭제 (Drop Existing Tables)
-- ===================================================================
DROP TABLE IF EXISTS review_comments;
DROP TABLE IF EXISTS column_comments;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS detailed_ratings;
DROP TABLE IF EXISTS rating_distributions;
DROP TABLE IF EXISTS restaurant_qna;
DROP TABLE IF EXISTS restaurant_news;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS columns;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS business_users;
DROP TABLE IF EXISTS restaurant_operating_hours;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS course_reviews;
DROP TABLE IF EXISTS course_reservations;
DROP TABLE IF EXISTS course_likes;
DROP TABLE IF EXISTS course_steps;
DROP TABLE IF EXISTS course_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS user_storage_items;
DROP TABLE IF EXISTS user_storages;
DROP TABLE IF EXISTS user_badges;
DROP TABLE IF EXISTS badges;
DROP TABLE IF EXISTS notices;
DROP TABLE IF EXISTS feed_items;
DROP TABLE IF EXISTS alerts;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS EVENTS;


-- ===================================================================
-- 2. 테이블 구조 생성 (Create Schema)
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
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 비즈니스 사용자 테이블
CREATE TABLE business_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    business_name VARCHAR(200) NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    business_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
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
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES users(id)
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
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
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

-- 팔로우 테이블
CREATE TABLE follows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_follow (follower_id, following_id)
);

-- 리뷰 댓글 테이블
CREATE TABLE review_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    review_id INT NOT NULL,
    user_id INT NOT NULL,
    author VARCHAR(100) NOT NULL,
    author_image VARCHAR(500),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
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

-- 이벤트 테이블
CREATE TABLE EVENTS (
    ID BIGINT PRIMARY KEY AUTO_INCREMENT,
    TITLE VARCHAR(255) NOT NULL,
    SUMMARY VARCHAR(500),
    CONTENT TEXT,
    IMAGE VARCHAR(1000),
    START_DATE DATE,
    END_DATE DATE
);

-- 코스 테이블
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    area VARCHAR(100),
    duration VARCHAR(100),
    price INT DEFAULT 0,
    max_participants INT DEFAULT 0,
    status ENUM('PENDING', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type ENUM('OFFICIAL', 'COMMUNITY') DEFAULT 'COMMUNITY' COMMENT '코스 타입 (운영자/커뮤니티)',
    preview_image VARCHAR(1000) COMMENT '목록용 썸네일 이미지',
    author_id INT NULL COMMENT '작성자 ID (users.id 참조)',
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 태그 테이블
CREATE TABLE tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '태그 고유 ID',
    tag_name VARCHAR(50) NOT NULL UNIQUE COMMENT '태그 이름'
) COMMENT '코스 태그 목록';

-- 코스-태그 연결 테이블
CREATE TABLE course_tags (
    course_id INT NOT NULL COMMENT '코스 ID',
    tag_id INT NOT NULL COMMENT '태그 ID',
    PRIMARY KEY (course_id, tag_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
) COMMENT '코스와 태그 연결 테이블';

-- 코스 상세 단계 테이블
CREATE TABLE course_steps (
    step_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '단계 고유 ID',
    course_id INT NOT NULL COMMENT '코스 ID',
    step_order INT NOT NULL DEFAULT 0 COMMENT '단계 순서',
    step_type VARCHAR(100),
    emoji VARCHAR(10),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image VARCHAR(1000),
    KEY idx_course_id (course_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) COMMENT '코스 상세 단계 목록';

-- 코스 좋아요 테이블
CREATE TABLE course_likes (
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (course_id, user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 코스 예약 테이블
CREATE TABLE course_reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    participant_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(255),
    reservation_date DATE,
    reservation_time VARCHAR(50),
    participant_count INT DEFAULT 1,
    total_price INT DEFAULT 0,
    status ENUM('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 코스 리뷰 테이블
CREATE TABLE course_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT DEFAULT 5,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_content TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 사용자 저장소 테이블
CREATE TABLE user_storages (
    storage_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    color_class VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 사용자 저장소 아이템 테이블
CREATE TABLE user_storage_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    storage_id INT NOT NULL,
    item_type ENUM('RESTAURANT', 'COURSE') NOT NULL,
    content_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (storage_id) REFERENCES user_storages(storage_id) ON DELETE CASCADE,
    UNIQUE KEY uk_storage_item (storage_id, item_type, content_id)
);

-- 뱃지 테이블
CREATE TABLE badges (
    badge_id INT AUTO_INCREMENT PRIMARY KEY,
    icon VARCHAR(10),
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

-- 사용자 뱃지 테이블
CREATE TABLE user_badges (
    user_id INT NOT NULL,
    badge_id INT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES badges(badge_id) ON DELETE CASCADE
);

-- 공지사항 테이블
CREATE TABLE notices (
    notice_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at DATE
);

-- 팔로우 피드 테이블
CREATE TABLE feed_items (
    feed_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    feed_type ENUM('COLUMN', 'REVIEW') NOT NULL,
    content_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 알림 테이블
CREATE TABLE alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content VARCHAR(500) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 가게 영업시간 테이블
CREATE TABLE restaurant_operating_hours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    day_of_week INT NOT NULL, /* 1:월요일, 2:화요일, ..., 7:일요일 */
    opening_time TIME NOT NULL, /* 예: '11:00:00' */
    closing_time TIME NOT NULL, /* 예: '15:00:00' */
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ===================================================================
-- 3. 인덱스 생성 (Create Indexes)
-- ===================================================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_nickname ON users(nickname);
CREATE INDEX idx_restaurants_category ON restaurants(category);
CREATE INDEX idx_restaurants_location ON restaurants(location);
CREATE INDEX idx_restaurants_rating ON restaurants(rating DESC);
CREATE INDEX idx_reviews_restaurant_id ON reviews(restaurant_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_created_at ON reviews(created_at DESC);
CREATE INDEX idx_columns_user_id ON columns(user_id);
CREATE INDEX idx_columns_created_at ON columns(created_at DESC);
CREATE INDEX idx_reservations_restaurant_id ON reservations(restaurant_id);
CREATE INDEX idx_reservations_user_id ON reservations(user_id);
CREATE INDEX idx_reservations_reservation_time ON reservations(reservation_time);


-- 외래 키 제약 조건 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;


-- ===================================================================
-- SCRIPT EXECUTION FINISHED
-- ===================================================================