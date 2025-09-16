-- 맛집 상세 정보 데이터 삽입

-- 쿠폰 데이터
INSERT INTO coupons (restaurant_id, title, description, validity) VALUES
-- 우부래도 (ID: 48)
(48, '비건 디저트 20% 할인', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31'),

-- 고미정 (ID: 1) 
(1, '상견례 10% 할인', '상견례 예약 시 제공', '~ 2025.12.31'),

-- 파스타 팩토리 (ID: 2)
(2, '에이드 1잔 무료', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31');

-- 가게 뉴스 데이터
INSERT INTO restaurant_news (restaurant_id, type, title, content, date) VALUES
-- 우부래도
(48, '이벤트', '여름 한정! 단호박 빙수 출시!', '무더운 여름을 날려버릴 시원하고 달콤한 우부래도표 비건 단호박 빙수가 출시되었습니다. 많은 관심 부탁드립니다!', '2025.08.05'),

-- 고미정
(1, '공지', '겨울 한정 메뉴 출시', '따뜻한 겨울을 위한 전통 한정식 메뉴가 새롭게 출시되었습니다.', '2025.12.01'),

-- 파스타 팩토리
(2, '이벤트', '신메뉴 출시! 트러플 파스타', '프리미엄 트러플을 사용한 새로운 파스타 메뉴가 출시되었습니다.', '2025.11.20');

-- Q&A 데이터
INSERT INTO restaurant_qna (restaurant_id, question, answer, is_owner) VALUES
-- 우부래도
(48, '주차는 가능한가요?', '네, 가게 앞에 2대 정도 주차 가능합니다.', TRUE),

-- 고미정
(1, '상견례 예약을 하고 싶은데 룸이 있나요?', '네, 8~12인까지 수용 가능한 프라이빗 룸이 준비되어 있습니다. 예약 시 말씀해주세요.', TRUE),

-- 파스타 팩토리
(2, '주말 웨이팅이 긴가요?', '네, 주말 저녁에는 웨이팅이 있을 수 있으니 앱을 통해 예약해주시면 편리합니다.', TRUE);

-- 평점 분포 데이터
INSERT INTO rating_distributions (restaurant_id, rating_1, rating_2, rating_3, rating_4, rating_5) VALUES
-- 우부래도
(48, 0, 0, 2, 1, 3),

-- 고미정
(1, 0, 0, 4, 28, 120),

-- 파스타 팩토리
(2, 0, 0, 18, 60, 180);

-- 상세 평점 데이터
INSERT INTO detailed_ratings (restaurant_id, taste, price, service) VALUES
-- 우부래도
(48, 4.0, 3.3, 3.3),

-- 고미정
(1, 4.9, 4.5, 4.8),

-- 파스타 팩토리
(2, 4.7, 4.2, 4.5);
