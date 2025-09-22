-- ===================================================================
-- 1. [schema.sql] 테이블 구조 생성 시작
-- ===================================================================
USE meetlog;

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
    restaurant_id INT NULL, -- BUSINESS 사용자의 경우 연결된 음식점 ID
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
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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

-- 인덱스 생성
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
-- ===================================================================
-- 1. [schema.sql] 테이블 구조 생성 끝
-- ===================================================================


-- ===================================================================
-- 2. (필수!) 누락된 `events` 테이블 생성
-- ===================================================================
CREATE TABLE EVENTS (
    ID BIGINT PRIMARY KEY AUTO_INCREMENT,
    TITLE VARCHAR(255) NOT NULL,
    SUMMARY VARCHAR(500),
    CONTENT TEXT,
    IMAGE VARCHAR(1000),
    START_DATE DATE,
    END_DATE DATE
);

-- ===================================================================
-- 2. `events` 테이블 생성 끝
-- ===================================================================


-- ===================================================================
-- 3. [new.sql] 데이터 삽입 시작
-- ===================================================================
-- 외래 키 제약 조건 검사를 임시로 비활성화합니다.
SET FOREIGN_KEY_CHECKS = 0;

-- 모든 테이블의 데이터를 삭제하고 Auto_Increment 값을 1로 리셋합니다.
TRUNCATE TABLE users;
TRUNCATE TABLE restaurants;
TRUNCATE TABLE menus;
TRUNCATE TABLE reviews;
TRUNCATE TABLE columns;
TRUNCATE TABLE reservations;
TRUNCATE TABLE follows;
TRUNCATE TABLE review_comments;
TRUNCATE TABLE column_comments;

-- 외래 키 제약 조건 검사를 다시 활성화합니다.
SET FOREIGN_KEY_CHECKS = 1;

-- --- 이제 여기에 위에서 드린 INSERT 쿼리문 전체를 붙여넣고 실행하면 됩니다. ---

/**
 * 1. 사용자 테이블 (users)
 * - mockData.columnists와 mockData.reviews/comments의 작성자들을 기반으로 생성
 * - (user_id: 1=김맛잘알, 2=미스터노포, 3=빵순이, 4=데이트장인, 5=가산직장인, 6=퇴근후한잔, 7=효녀딸, 8=중데생, 9=상도동빵주먹)
 */
INSERT INTO users (id, email, nickname, password, user_type, profile_image, follower_count) VALUES
(1, 'kim.expert@meetlog.com', '김맛잘알', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', 12500),
(2, 'mr.nopo@meetlog.com', '미스터노포', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 8200),
(3, 'bbang@meetlog.com', '빵순이', 'hashed_password_123', 'PERSONAL', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 25100),
(4, 'date.master@meetlog.com', '데이트장인', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/e879f9/ffffff?text=Me', 1200),
(5, 'gasan.worker@meetlog.com', '가산직장인', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 3100),
(6, 'after.work@meetlog.com', '퇴근후한잔', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 0),
(7, 'hyonyeo@meetlog.com', '효녀딸', 'hashed_password_123', 'PERSONAL', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 0),
(8, 'jungdae@meetlog.com', '중데생', 'hashed_password_123', 'PERSONAL', 'https://bbscdn.df.nexon.com/data7/commu/202004/230754_5e89e63a88677.png', 0),
(9, 'sando.bread@meetlog.com', '상도동빵주먹', 'hashed_password_123', 'PERSONAL', 'https://dcimg1.dcinside.com/viewimage.php?id=3da9da27e7d13c&no=24b0d769e1d32ca73de983fa11d02831c6c0b61130e4349ff064c51af2dccfaaa69ce6d782ffbe3cfce75d0ab4b0153873c98d17df4da1937ce4df7cc1e73f9d543acb95a114b61478ff194f7f2b81facc7cc6acb3074408f65976d67d2fe0deaebbfb2ef40152de', 0);

/**
 * 2. 맛집 테이블 (restaurants)
 * - mockData.restaurants 배열 기반
 * - rating은 details.ratingAvg 값을 사용. details가 없는 경우 list의 rating을 5점 만점으로 환산 (예: 94점 -> 4.7점)
 */
INSERT INTO restaurants (id, name, category, location, address, jibun_address, phone, hours, description, image, rating, review_count, likes, latitude, longitude) VALUES
(1, '고미정', '한식', '강남', '서울특별시 강남구 테헤란로 123', '역삼동 123-45', '02-1234-5678', '매일 11:00 - 22:00', '강남역 한정식, 상견례 장소', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', 4.8, 152, 1203, 37.501, 127.039),
(2, '파스타 팩토리', '양식', '홍대', '서울 마포구 와우산로29길 14-12', '서교동 333-1', '02-333-4444', '매일 11:30 - 22:00', '홍대입구역 소개팅, 데이트 맛집', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 4.6, 258, 2341, 37.5559, 126.9238),
(3, '스시 마에', '일식', '여의도', '서울 영등포구 국제금융로 10', '여의도동 23', '02-555-6666', '매일 12:00 - 22:00 (브레이크타임 15:00-18:00)', '여의도 하이엔드 오마카세', 'https://placehold.co/600x400/60a5fa/ffffff?text=오마카세', 4.9, 189, 1890, 37.525, 126.925),
(4, '치맥 하우스', '한식', '종로', '서울 종로구 종로 123', '종로3가 11-1', '02-777-8888', '매일 16:00 - 02:00', '종로 수제맥주와 치킨 맛집', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨', 4.4, 310, 3104, 37.570, 126.989),
(5, '카페 클라우드', '카페', '성수', '서울 성동구 연무장길 12', '성수동2가 300-1', '02-464-1234', '매일 10:00 - 22:00', '성수동 뷰맛집 감성 카페', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', 4.5, 288, 2880, 37.543, 127.054),
(6, '북경 오리', '중식', '명동', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/f472b6/ffffff?text=중식', 4.7, 0, 1550, NULL, NULL),
(7, '브루클린 버거', '양식', '이태원', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/fb923c/ffffff?text=버거', 4.5, 0, 2543, NULL, NULL),
(8, '소담길', '한식', '인사동', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://www.ourhomehospitality.com/hos_img/1720054355745.jpg', 4.7, 0, 980, NULL, NULL),
(9, '인도 커리 왕', '기타', '혜화', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/facc15/ffffff?text=커리', 4.5, 0, 2130, NULL, NULL),
(10, '평양면옥', '한식', '을지로', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832', 4.8, 0, 1760, NULL, NULL),
(11, '우부래도', '베이커리', '상도', '서울특별시 동작구 상도로37길 3', '상도1동 666-3', '0507-1428-0599', '매일 10:00 - 22:00', '상도역 베이커리, 비건', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832', 4.2, 6, 850, 37.4953, 126.9448),
(12, '가산생고기', '한식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/ef4444/ffffff?text=삼겹살', 4.7, 0, 2850, NULL, NULL),
(13, '직장인 국밥', '한식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/f97316/ffffff?text=국밥', 4.5, 0, 3120, NULL, NULL),
(14, '파파 이탈리아노', '양식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/84cc16/ffffff?text=파스타', 4.4, 0, 1890, NULL, NULL),
(15, '가디 이자카야', '일식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야', 4.6, 0, 2340, NULL, NULL),
(16, '마리오아울렛 푸드코트', '기타', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/6366f1/ffffff?text=푸드코트', 4.3, 0, 4500, NULL, NULL),
(17, '더현대아울렛 중식당', '중식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/8b5cf6/ffffff?text=중식', 4.5, 0, 1980, NULL, NULL),
(18, '퇴근길 포차', '한식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/ec4899/ffffff?text=포차', 4.4, 0, 2670, NULL, NULL),
(19, '커피 브레이크 가산점', '카페', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/10b981/ffffff?text=Cafe', 4.6, 0, 3500, NULL, NULL),
(20, '가산 돈까스 클럽', '일식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/f59e0b/ffffff?text=돈까스', 4.7, 0, 2990, NULL, NULL),
(21, '구로디지털단지 족발야시장', '한식', '구로', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/78716c/ffffff?text=족발', 4.8, 0, 3200, NULL, NULL),
(22, '월화 G밸리점', '한식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/ef4444/ffffff?text=고기', 4.8, 0, 4100, NULL, NULL),
(23, '스시메이진 가산점', '일식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/3b82f6/ffffff?text=초밥', 4.5, 0, 2800, NULL, NULL),
(24, '샐러디 W몰점', '양식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/22c55e/ffffff?text=샐러드', 4.4, 0, 1500, NULL, NULL),
(25, '베트남 노상식당', '기타', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/f97316/ffffff?text=쌀국수', 4.5, 0, 2400, NULL, NULL),
(26, '리춘시장 가산디지털역점', '중식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/dc2626/ffffff?text=마라탕', 4.3, 0, 2100, NULL, NULL),
(27, '폴바셋 현대아울렛가산점', '카페', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/172554/ffffff?text=Paul+Bassett', 4.7, 0, 2900, NULL, NULL),
(28, '해물품은닭', '한식', '구로', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/fbbf24/ffffff?text=닭볶음탕', 4.7, 0, 2650, NULL, NULL),
(29, '인도요리 아그라', '기타', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/c2410c/ffffff?text=커리', 4.5, 0, 1750, NULL, NULL),
(30, '오봉집 가산디지털점', '한식', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/991b1b/ffffff?text=보쌈', 4.6, 0, 3800, NULL, NULL),
(31, '투썸플레이스 가산W몰점', '카페', '가산', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/ef4444/ffffff?text=Twosome', 4.4, 0, 2200, NULL, NULL),
(32, '툭툭누들타이', '기타', '연남', '주소 정보 없음', NULL, NULL, NULL, NULL, 'https://placehold.co/600x400/16a34a/ffffff?text=Thai', 4.8, 0, 4500, NULL, NULL);

/**
 * 3. 메뉴 테이블 (menus)
 * - mockData.restaurants[...].details.menu 배열 기반
 */
INSERT INTO menus (restaurant_id, name, price) VALUES
(1, '궁중 수라상', '75,000원'),
(1, '고미정 정식', '55,000원'),
(1, '보리굴비 정식', '45,000원'),
(2, '트러플 크림 파스타', '18,000원'),
(2, '봉골레 파스타', '16,000원'),
(2, '마르게리따 피자', '20,000원'),
(3, '런치 오마카세', '120,000원'),
(3, '디너 오마카세', '250,000원'),
(4, '반반치킨', '19,000원'),
(4, '종로 페일에일', '7,500원'),
(5, '아인슈페너', '7,000원'),
(5, '클라우드 케이크', '8,500원'),
(11, '단호박 머핀', '4,000원'),
(11, '쌀바게트', '4,500원'),
(11, '홍국단팥빵', '4,000원');

/**
 * 4. 리뷰 테이블 (reviews)
 * - mockData.reviews 배열 기반
 * - user_id는 위 1번 항목의 사용자 ID 매핑 참조
 * - images, keywords는 JSON 타입이므로 JSON 배열 문자열로 저장
 */
INSERT INTO reviews (id, restaurant_id, user_id, author, author_image, rating, content, images, keywords, likes) VALUES
(1, 2, 4, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '여기 진짜 분위기 깡패에요! 소개팅이나 데이트 초반에 가면 무조건 성공입니다.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832"]', NULL, 0),
(2, 4, 6, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 4, '일 끝나고 동료들이랑 갔는데, 스트레스가 확 풀리네요. 새로 나온 마늘간장치킨이 진짜 맛있어요.', NULL, NULL, 0),
(3, 1, 7, '효녀딸', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 5, '부모님 생신이라 모시고 갔는데 정말 좋아하셨어요. 음식 하나하나 정성이 느껴져요.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832"]', NULL, 0),
(4, 10, 2, '미스터노포', 'https://placehold.co/100x100/93c5fd/ffffff?text=C2', 5, '역시 여름엔 평양냉면이죠. 이 집 육수는 정말 최고입니다.', NULL, NULL, 0),
(5, 12, 2, '미스터노포', 'https://placehold.co/100x100/93c5fd/ffffff?text=C2', 5, '가산에서 이만한 퀄리티의 삼겹살을 찾기 힘듭니다. 회식 장소로 강력 추천!', NULL, NULL, 0),
(6, 13, 5, '가산직장인', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 4, '점심시간에 웨이팅은 좀 있지만, 든든하게 한 끼 해결하기에 최고입니다. 깍두기가 맛있어요.', NULL, NULL, 0),
(7, 19, 3, '빵순이', 'https://placehold.co/150x150/fcd34d/ffffff?text=C3', 4, '산미있는 원두를 좋아하시면 여기입니다. 디저트 케이크도 괜찮았어요.', NULL, NULL, 0),
(8, 14, 4, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 4, '가산에서 파스타 먹고 싶을 때 가끔 들러요. 창가 자리가 분위기 좋아요.', NULL, NULL, 0),
(9, 11, 4, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다. 다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832"]', NULL, 0),
(10, 11, 3, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다.\n다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832", "https://d12zq4w4guyljn.cloudfront.net/750_750_20241013104136219_menu_tWPMh0i8m0ba.jpg", "https://d12zq4w4guyljn.cloudfront.net/750_750_20241013104128192_photo_tWPMh0i8m0ba.webp"]', '["#음식이 맛있어요", "#재료가 신선해요"]', 25);

/**
 * 5. 칼럼 테이블 (columns)
 * - mockData.columns 배열 기반
 * - user_id는 위 1번 항목의 사용자 ID 매핑 참조
 * - SQL 예약어인 작은따옴표(')는 두 개('')로 이스케이프 처리
 */
INSERT INTO columns (id, user_id, author, title, content, image) VALUES
(1, 3, '빵순이', '상도동 비건 빵집 ''우부래도'' 솔직 리뷰', '상도동에는 숨겨진 비건 빵 맛집들이 많습니다. 그 중에서도 제가 가장 사랑하는 곳은 바로 ''우부래도''입니다. 특히 이곳의 쌀바게트는 정말 일품입니다. 겉은 바삭하고 속은 쫀득한 식감이 살아있죠.\n\n제가 남겼던 리뷰를 첨부해봅니다. 여러분도 상도동에 가시면 꼭 들러보세요!', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832'),
(2, 2, '미스터노포', '을지로 직장인들을 위한 최고의 평양냉면', '여름이면 어김없이 생각나는 평양냉면. 을지로의 수많은 노포 중에서도 ''평양면옥''은 단연 최고라고 할 수 있습니다. 슴슴하면서도 깊은 육수 맛이 일품입니다. 점심시간에는 웨이팅이 길 수 있으니 조금 서두르는 것을 추천합니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832'),
(3, 1, '김맛잘알', '한식 다이닝의 정수, 강남 ''고미정'' 방문기', '특별한 날, 소중한 사람과 함께할 장소를 찾는다면 강남의 ''고미정''을 추천합니다. 정갈한 상차림과 깊은 맛의 한정식 코스는 먹는 내내 감탄을 자아냅니다. 특히 부모님을 모시고 가기에 최고의 장소입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832'),
(4, 4, '데이트장인', '홍대 최고의 파스타, 데이트 성공 보장!', '홍대에서 데이트 약속이 잡혔다면 고민하지 말고 ''파스타 팩토리''로 가세요. 분위기, 맛, 서비스 뭐 하나 빠지는 게 없는 곳입니다. 특히 트러플 크림 파스타는 꼭 먹어봐야 할 메뉴입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832'),
(5, 5, '가산직장인', '가산디지털단지 직장인 점심 맛집 BEST 3', '매일 반복되는 점심 메뉴 고민, 힘드시죠? G밸리 5년차 직장인이 추천하는 점심 맛집 리스트를 공개합니다. ''직장인 국밥''부터...', 'https://placehold.co/600x400/f97316/ffffff?text=국밥'),
(6, 6, '퇴근후한잔', '퇴근 후 한잔, 가산 이자카야 ''가디'' 방문기', '지친 하루의 피로를 풀어주는 시원한 맥주와 맛있는 안주. ''가디 이자카야''는 회식 2차 장소로도, 혼술하기에도 좋은 곳입니다.', 'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야'),
(7, 3, '빵순이', '성수동에서 발견한 인생 커피, ''카페 클라우드''', '수많은 성수동 카페들 속에서 보석 같은 곳을 발견했습니다. 바로 ''카페 클라우드''입니다. 특히 이곳의 시그니처 라떼는...', 'https://placehold.co/600x400/34d399/ffffff?text=카페'),
(8, 4, '데이트장인', '이태원 수제버거의 정석, ''브루클린 버거''', '육즙 가득한 패티와 신선한 야채의 조화. ''브루클린 버거''는 언제나 옳은 선택입니다. 치즈 스커트 버거는 꼭 드셔보세요.', 'https://placehold.co/600x400/fb923c/ffffff?text=버거'),
(9, 5, '가산직장인', 'G밸리 회식장소 끝판왕, ''월화 G밸리점''', '두툼한 목살과 삼겹살이 일품인 곳. 단체석도 잘 마련되어 있어 가산디지털단지 회식 장소로 이만한 곳이 없습니다.', 'https://placehold.co/600x400/ef4444/ffffff?text=고기'),
(10, 6, '퇴근후한잔', '종로 치맥의 성지, ''치맥 하우스''를 가다', '바삭한 치킨과 시원한 생맥주의 조합은 진리입니다. ''치맥 하우스''는 다양한 종류의 수제 맥주를 맛볼 수 있어 더욱 좋습니다.', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨'),
(11, 1, '김맛잘알', '여의도 오마카세 입문자에게 추천, ''스시 마에''', '오마카세가 처음이라 부담스러우신가요? ''스시 마에''는 합리적인 가격과 친절한 설명으로 입문자들에게 최고의 경험을 선사합니다.', 'https://placehold.co/600x400/60a5fa/ffffff?text=오마카세'),
(12, 2, '미스터노포', '명동의 숨은 맛, ''북경 오리'' 전문점 탐방', '북적이는 명동 거리 안쪽에 위치한 이 곳은 수십 년 경력의 주방장님이 선보이는 정통 북경 오리 요리를 맛볼 수 있는 숨은 고수의 가게입니다.', 'https://placehold.co/600x400/f472b6/ffffff?text=중식'),
(13, 5, '가산직장인', '가산 W몰 쇼핑 후 필수코스, ''샐러디''', '쇼핑으로 지쳤을 때, 건강하고 가볍게 한 끼 식사를 해결하고 싶다면 ''샐러디''를 추천합니다. 든든한 웜볼 메뉴가 특히 좋습니다.', 'https://placehold.co/600x400/22c55e/ffffff?text=샐러드'),
(14, 1, '김맛잘알', '인사동 골목의 정겨움, ''소담길'' 보쌈정식', '전통적인 분위기의 인사동에서 맛보는 부드러운 보쌈과 맛깔나는 반찬들. ''소담길''은 부모님을 모시고 가기에도 손색없는 곳입니다.', 'https://placehold.co/600x400/c084fc/ffffff?text=보쌈');

/**
 * 6. 예약 테이블 (reservations)
 * - mockData.myReservations 기반
 * - user_id는 '데이트장인'(id=4)으로 가정 (mockData.columnists의 프로필 텍스트 'Me' 참조)
 * - '오늘'(2025-09-14), '어제'(2025-09-13) 등 상대 날짜는 현재 시점(2025-09-14) 기준으로 변환
 */
INSERT INTO reservations (id, restaurant_id, user_id, restaurant_name, user_name, reservation_time, party_size, status) VALUES
(1, 11, 4, '우부래도', '데이트장인', '2025-09-14 19:00:00', 2, 'CONFIRMED'),
(2, 2, 4, '파스타 팩토리', '데이트장인', '2025-09-13 20:00:00', 4, 'COMPLETED'),
(3, 32, 4, '툭툭누들타이', '데이트장인', '2025-08-15 18:00:00', 2, 'CANCELLED');

/**
 * 7. 팔로우 테이블 (follows)
 * - mockData.feedItems와 mockData.alerts를 기반으로 '나'(user_id=4, 데이트장인)의 관계를 추론
 */
INSERT INTO follows (follower_id, following_id) VALUES
(2, 4), -- 미스터노포(2)가 '나'(4)를 팔로우 (alerts[0])
(4, 3), -- '나'(4)가 빵순이(3)를 팔로우 (feedItems[0])
(4, 2); -- '나'(4)가 미스터노포(2)를 팔로우 (feedItems[1])

/**
 * 8. 리뷰 댓글 테이블 (review_comments)
 * - mockData.reviewComments 배열 기반
 * - user_id는 1번 항목의 '중데생'(id=8) 매핑
 */
INSERT INTO review_comments (id, review_id, user_id, author, author_image, content) VALUES
(1, 10, 8, '중데생', 'https://bbscdn.df.nexon.com/data7/commu/202004/230754_5e89e63a88677.png', '오 여기 진짜 맛있죠! 저도 쌀바게트 제일 좋아해요.');

/**
 * 9. 칼럼 댓글 테이블 (column_comments)
 * - mockData.comments 배열 기반
 * - user_id는 1번 항목의 '중데생'(id=8), '상도동빵주먹'(id=9) 매핑
 */
INSERT INTO column_comments (id, column_id, user_id, author, author_image, content) VALUES
(1, 1, 8, '중데생', 'https://bbscdn.df.nexon.com/data7/commu/202004/230754_5e89e63a88677.png', '여기 학교 앞이라 지나가다가 봤는데 이런 맛집인지 몰랐어요 가봐야겠네요!'),
(2, 1, 9, '상도동빵주먹', 'https://dcimg1.dcinside.com/viewimage.php?id=3da9da27e7d13c&no=24b0d769e1d32ca73de983fa11d02831c6c0b61130e4349ff064c51af2dccfaaa69ce6d782ffbe3cfce75d0ab4b0153873c98d17df4da1937ce4df7cc1e73f9d543acb95a114b61478ff194f7f2b81facc7cc6acb3074408f65976d67d2fe0deaebbfb2ef40152de', '비건 빵집이라니! 츄라이 해봐야겠어요!');
-- ===================================================================
-- 3. [new.sql] 데이터 삽입 끝
-- ===================================================================


-- ===================================================================
-- 4. [restaurant_details_data.sql] 추가 데이터 삽입 시작
-- ===================================================================
-- 쿠폰 데이터
-- (참고: new.sql의 맛집 ID 1, 2, 11을 참조하도록 수정)
INSERT INTO coupons (restaurant_id, title, description, validity) VALUES
-- 우부래도 (ID: 11)
(11, '비건 디저트 20% 할인', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31'),

-- 고미정 (ID: 1) 
(1, '상견례 10% 할인', '상견례 예약 시 제공', '~ 2025.12.31'),

-- 파스타 팩토리 (ID: 2)
(2, '에이드 1잔 무료', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31');

-- 가게 뉴스 데이터
INSERT INTO restaurant_news (restaurant_id, type, title, content, date) VALUES
-- 우부래도 (ID: 11)
(11, '이벤트', '여름 한정! 단호박 빙수 출시!', '무더운 여름을 날려버릴 시원하고 달콤한 우부래도표 비건 단호박 빙수가 출시되었습니다. 많은 관심 부탁드립니다!', '2025.08.05'),

-- 고미정 (ID: 1)
(1, '공지', '겨울 한정 메뉴 출시', '따뜻한 겨울을 위한 전통 한정식 메뉴가 새롭게 출시되었습니다.', '2025.12.01'),

-- 파스타 팩토리 (ID: 2)
(2, '이벤트', '신메뉴 출시! 트러플 파스타', '프리미엄 트러플을 사용한 새로운 파스타 메뉴가 출시되었습니다.', '2025.11.20');

-- Q&A 데이터
INSERT INTO restaurant_qna (restaurant_id, question, answer, is_owner) VALUES
-- 우부래도 (ID: 11)
(11, '주차는 가능한가요?', '네, 가게 앞에 2대 정도 주차 가능합니다.', TRUE),

-- 고미정 (ID: 1)
(1, '상견례 예약을 하고 싶은데 룸이 있나요?', '네, 8~12인까지 수용 가능한 프라이빗 룸이 준비되어 있습니다. 예약 시 말씀해주세요.', TRUE),

-- 파스타 팩토리 (ID: 2)
(2, '주말 웨이팅이 긴가요?', '네, 주말 저녁에는 웨이팅이 있을 수 있으니 앱을 통해 예약해주시면 편리합니다.', TRUE);

-- 평점 분포 데이터
INSERT INTO rating_distributions (restaurant_id, rating_1, rating_2, rating_3, rating_4, rating_5) VALUES
-- 우부래도 (ID: 11)
(11, 0, 0, 2, 1, 3),

-- 고미정 (ID: 1)
(1, 0, 0, 4, 28, 120),

-- 파스타 팩토리 (ID: 2)
(2, 0, 0, 18, 60, 180);

-- 상세 평점 데이터
INSERT INTO detailed_ratings (restaurant_id, taste, price, service) VALUES
-- 우부래도 (ID: 11)
(11, 4.0, 3.3, 3.3),

-- 고미정 (ID: 1)
(1, 4.9, 4.5, 4.8),

-- 파스타 팩토리 (ID: 2)
(2, 4.7, 4.2, 4.5);
-- ===================================================================
-- 4. [restaurant_details_data.sql] 추가 데이터 삽입 끝
-- ===================================================================


INSERT INTO events (title, summary, content, image, start_date, end_date) 
VALUES
(
    'MEET LOG 가을맞이! 5성급 호텔 뷔페 30% 할인',
    '선선한 가을, MEET LOG가 추천하는 최고의 호텔 뷔페에서 특별한 미식을 경험하세요. MEET LOG 회원 전용 특별 할인을 놓치지 마세요.',
    '이벤트 내용 본문입니다. 상세한 약관과 참여 방법이 여기에 들어갑니다.',
    'https://placehold.co/800x400/f97316/ffffff?text=Hotel+Buffet+Event',
    '2025-09-01',
    '2025-10-31'
),
(
    "신규 맛집 '파스타 팩토리' 리뷰 이벤트",
    "홍대 '파스타 팩토리' 방문 후 MEET LOG에 리뷰를 남겨주세요! 추첨을 통해 2인 식사권을 드립니다!",
    '상세 내용: 1. 파스타 팩토리 방문 2. 사진과 함께 정성스러운 리뷰 작성 3. 자동 응모 완료!',
    'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832',
    '2025-09-10',
    '2025-09-30'
),
(
    '[종료] 여름맞이 치맥 하우스! 수제맥주 1+1',
    '무더운 여름 밤, 종로 ''치맥 하우스''에서 시원한 수제맥주 1+1 이벤트를 즐겨보세요. MEET LOG 회원이라면 누구나!',
    '본 이벤트는 8월 31일부로 종료되었습니다. 성원에 감사드립니다.',
    'https://placehold.co/800x400/fbbf24/ffffff?text=Beer+Event+(Finished)',
    '2025-07-01',
    '2025-08-31'
);


-- ===================================================================
-- 0. 외래 키 제약 조건 임시 비활성화
-- ===================================================================
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- 1. 기존 코스 관련 테이블 삭제 (있을 경우)
-- ===================================================================
DROP TABLE IF EXISTS course_reviews;
DROP TABLE IF EXISTS course_reservations;
DROP TABLE IF EXISTS course_likes;
DROP TABLE IF EXISTS course_steps;
DROP TABLE IF EXISTS course_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS courses;

-- ===================================================================
-- 2. 외래 키 제약 조건 다시 활성화
-- ===================================================================
SET FOREIGN_KEY_CHECKS = 1;

-- ===================================================================
-- 3. 코스(Course) 관련 테이블 생성 (FK 포함)
-- (users 테이블이 존재한다고 가정)
-- ===================================================================

-- 3-1. 코스 테이블 (users 참조)
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
    
    -- 외래 키(FK) 설정: users 테이블의 id 참조
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 3-2. 태그 테이블 (독립 테이블)
CREATE TABLE tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '태그 고유 ID',
    tag_name VARCHAR(50) NOT NULL UNIQUE COMMENT '태그 이름'
) COMMENT '코스 태그 목록';

-- 3-3. 코스-태그 연결 테이블 (courses, tags 참조)
CREATE TABLE course_tags (
    course_id INT NOT NULL COMMENT '코스 ID',
    tag_id INT NOT NULL COMMENT '태그 ID',
    
    PRIMARY KEY (course_id, tag_id),
    
    -- 외래 키(FK) 설정
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
) COMMENT '코스와 태그 연결 테이블';

-- 3-4. 코스 상세 단계 테이블 (courses 참조)
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
    
    -- 외래 키(FK) 설정
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) COMMENT '코스 상세 단계 목록';

-- 3-5. 코스 좋아요 테이블 (courses, users 참조)
CREATE TABLE course_likes (
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    
    PRIMARY KEY (course_id, user_id), 
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3-6. 코스 예약 테이블 (courses, users 참조)
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

-- 3-7. 코스 리뷰 테이블 (courses, users 참조)
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

-- ===================================================================
-- 4. 목 데이터(Mock Data) 삽입
-- ===================================================================

INSERT INTO tags (tag_id, tag_name) VALUES
(1, '데이트'),
(2, '홍대'),
(3, '성수'),
(4, '양식'),
(5, '카페'),
(6, '커뮤니티추천');

INSERT INTO courses (course_id, title, description, area, duration, price, type, preview_image, author_id) VALUES
(
    1, 
    '홍대 데이트 완벽 코스 (파스타+카페)', 
    '데이트장인이 추천하는 홍대 데이트 코스입니다. 이대로만 따라오시면 실패 없는 하루!', 
    '홍대/연남', 
    '약 3시간', 
    0, 
    'COMMUNITY', 
    'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 
    4 -- '데이트장인' (users.id = 4)
),
(
    2, 
    '[MEET LOG] 성수동 감성 투어', 
    'MEET LOG가 직접 큐레이션한 성수동 감성 맛집과 카페 코스입니다. 힙한 성수를 느껴보세요.', 
    '성수/건대', 
    '약 4시간', 
    15000, 
    'OFFICIAL', 
    'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', 
    NULL -- OFFICIAL 코스 (운영자)
);

INSERT INTO course_tags (course_id, tag_id) VALUES
(1, 1), (1, 2), (1, 4), (1, 6),
(2, 1), (2, 3), (2, 5);

INSERT INTO course_steps (course_id, step_order, step_type, emoji, name, description, image) VALUES
(1, 1, 'RESTAURANT', '🍝', '파스타 팩토리 (ID: 2)', '분위기 좋은 곳에서 맛있는 파스타로 시작!', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832'),
(1, 2, 'ETC', '🚶', '연남동 산책', '소화시킬 겸 연트럴파크를 가볍게 산책하세요.', NULL),
(1, 3, 'RESTAURANT', '☕', '연남동 감성 카페', '분위기 좋은 카페에서 디저트와 커피로 마무리.', 'https://placehold.co/600x400/fde68a/ffffff?text=Yeonnam+Cafe'),
(2, 1, 'RESTAURANT', '🍔', '브루클린 버거 (ID: 7)', '육즙 가득한 수제버거로 든든하게 시작!', 'https://placehold.co/600x400/fb923c/ffffff?text=버거'),
(2, 2, 'ETC', '🛍️', '성수 소품샵 구경', '아기자기한 소품샵들을 구경하며 성수의 감성을 느껴보세요.', NULL),
(2, 3, 'RESTAURANT', '🍰', '카페 클라우드 (ID: 5)', '뷰맛집 카페에서 시그니처 케이크와 커피 즐기기', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg');

INSERT INTO course_likes (course_id, user_id) VALUES
(1, 3), (1, 5),
(2, 1), (2, 3), (2, 4);

INSERT INTO course_reservations (course_id, user_id, participant_name, phone, email, reservation_date, reservation_time, participant_count, total_price, status) VALUES
(
    2, 3, '빵순이', '010-1234-5678', 'bbang@meetlog.com', '2025-09-20', '14:00', 2, 30000, 'CONFIRMED'
);

INSERT INTO course_reviews (course_id, user_id, rating, content, response_content) VALUES
(
    1, 3, 5, '이 코스 그대로 다녀왔는데 정말 좋았어요! 파스타 팩토리 진짜 맛있네요. 추천 감사합니다!', '좋게 봐주셔서 감사합니다! (작성자: 데이트장인)'
);


