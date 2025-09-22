-- MEET LOG 완전한 샘플 데이터 (data.js 기반)
USE meetlog;

-- 기존 데이터 삭제 (순서 중요)
DELETE FROM follows;
DELETE FROM reservations;
DELETE FROM columns;
DELETE FROM reviews;
DELETE FROM menus;
DELETE FROM restaurants;
DELETE FROM users;

-- 사용자 샘플 데이터 (data.js의 칼럼니스트 + 사용자)
INSERT INTO users (email, nickname, password, user_type, profile_image, level, follower_count, following_count) VALUES
('user1@example.com', '데이트장인', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, 1205, 150),
('user2@example.com', '퇴근후한잔', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 3, 890, 45),
('user3@example.com', '효녀딸', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 4, 2100, 78),
('columnist1@example.com', '김맛잘알', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', 6, 12500, 200),
('columnist2@example.com', '미스터노포', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 7, 8200, 150),
('columnist3@example.com', '빵순이', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 5, 25100, 180),
('columnist4@example.com', '가산직장인', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 4, 3100, 95),
('business1@example.com', '고미정사장', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'BUSINESS', 'https://placehold.co/100x100/10b981/ffffff?text=B1', 3, 0, 0);

-- 맛집 샘플 데이터 (data.js의 32개 레스토랑)
INSERT INTO restaurants (name, category, location, address, jibun_address, phone, hours, description, image, rating, review_count, likes, latitude, longitude, parking) VALUES
('고미정', '한식', '강남', '서울특별시 강남구 테헤란로 123', '역삼동 123-45', '02-1234-5678', '매일 11:00 - 22:00', '강남역 한정식, 상견례 장소', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', 4.8, 152, 1203, 37.501, 127.039, TRUE),
('파스타 팩토리', '양식', '홍대', '서울 마포구 와우산로29길 14-12', '서교동 333-1', '02-333-4444', '매일 11:30 - 22:00', '홍대입구역 소개팅, 데이트 맛집', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 4.6, 258, 2341, 37.5559, 126.9238, FALSE),
('스시 마에', '일식', '여의도', '서울 영등포구 국제금융로 10', '여의도동 23', '02-555-6666', '매일 12:00 - 22:00 (브레이크타임 15:00-18:00)', '여의도 하이엔드 오마카세', 'https://placehold.co/600x400/60a5fa/ffffff?text=오마카세', 4.9, 189, 1890, 37.525, 126.925, TRUE),
('치맥 하우스', '한식', '종로', '서울 종로구 종로 123', '종로3가 11-1', '02-777-8888', '매일 16:00 - 02:00', '종로 수제맥주와 치킨 맛집', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨', 4.4, 310, 3104, 37.570, 126.989, FALSE),
('카페 클라우드', '카페', '성수', '서울 성동구 연무장길 12', '성수동2가 300-1', '02-464-1234', '매일 10:00 - 22:00', '성수동 뷰맛집 감성 카페', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', 4.5, 288, 2880, 37.543, 127.054, TRUE),
('북경 오리', '중식', '명동', '서울 중구 명동길 45', '명동2가 12-3', '02-123-4567', '매일 11:00 - 21:00', '명동 정통 북경 오리 전문점', 'https://placehold.co/600x400/f472b6/ffffff?text=중식', 4.7, 195, 1550, 37.563, 126.982, TRUE),
('브루클린 버거', '양식', '이태원', '서울 용산구 이태원로 27길 12', '이태원동 123-4', '02-234-5678', '매일 12:00 - 23:00', '이태원 수제버거 전문점', 'https://placehold.co/600x400/fb923c/ffffff?text=버거', 4.5, 320, 2543, 37.534, 126.994, FALSE),
('소담길', '한식', '인사동', '서울 종로구 인사동길 12', '인사동 45-6', '02-345-6789', '매일 11:30 - 21:30', '인사동 전통 보쌈 정식', 'https://www.ourhomehospitality.com/hos_img/1720054355745.jpg', 4.6, 180, 980, 37.571, 126.985, TRUE),
('인도 커리 왕', '기타', '혜화', '서울 종로구 혜화로 12길 34', '혜화동 78-9', '02-456-7890', '매일 11:00 - 22:00', '혜화 인도 커리 전문점', 'https://placehold.co/600x400/facc15/ffffff?text=커리', 4.4, 165, 2130, 37.586, 126.999, FALSE),
('평양면옥', '한식', '을지로', '서울 중구 을지로 12길 34', '을지로2가 56-7', '02-567-8901', '매일 11:00 - 20:00', '을지로 평양냉면 전문점', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832', 4.8, 220, 1760, 37.566, 126.985, TRUE),
('우부래도', '베이커리', '상도', '서울특별시 동작구 상도로37길 3', '상도1동 666-3', '0507-1428-0599', '매일 10:00 - 22:00', '상도역 베이커리, 비건', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832', 4.2, 6, 850, 37.4953, 126.9448, TRUE),
('가산생고기', '한식', '가산', '서울 금천구 가산디지털1로 123', '가산동 456-7', '02-678-9012', '매일 17:00 - 02:00', '가산 수제 삼겹살 전문점', 'https://placehold.co/600x400/ef4444/ffffff?text=삼겹살', 4.7, 285, 2850, 37.481, 126.882, TRUE),
('직장인 국밥', '한식', '가산', '서울 금천구 가산디지털2로 45', '가산동 789-0', '02-789-0123', '매일 11:00 - 15:00', '가산 직장인 점심 국밥집', 'https://placehold.co/600x400/f97316/ffffff?text=국밥', 4.5, 312, 3120, 37.481, 126.882, FALSE),
('파파 이탈리아노', '양식', '가산', '서울 금천구 가산디지털1로 67', '가산동 123-4', '02-890-1234', '매일 11:30 - 22:00', '가산 이탈리안 레스토랑', 'https://placehold.co/600x400/84cc16/ffffff?text=파스타', 4.4, 189, 1890, 37.481, 126.882, TRUE),
('가디 이자카야', '일식', '가산', '서울 금천구 가산디지털2로 89', '가산동 567-8', '02-901-2345', '매일 18:00 - 01:00', '가산 이자카야', 'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야', 4.6, 234, 2340, 37.481, 126.882, FALSE),
('마리오아울렛 푸드코트', '기타', '가산', '서울 금천구 가산디지털1로 101', '가산동 901-2', '02-012-3456', '매일 10:00 - 22:00', '가산 아울렛 푸드코트', 'https://placehold.co/600x400/6366f1/ffffff?text=푸드코트', 4.3, 450, 4500, 37.481, 126.882, TRUE),
('더현대아울렛 중식당', '중식', '가산', '서울 금천구 가산디지털2로 111', '가산동 345-6', '02-123-4567', '매일 11:00 - 21:00', '가산 아울렛 중식당', 'https://placehold.co/600x400/8b5cf6/ffffff?text=중식', 4.4, 198, 1980, 37.481, 126.882, TRUE),
('퇴근길 포차', '한식', '가산', '서울 금천구 가산디지털1로 133', '가산동 789-0', '02-234-5678', '매일 18:00 - 02:00', '가산 퇴근길 포차', 'https://placehold.co/600x400/ec4899/ffffff?text=포차', 4.4, 267, 2670, 37.481, 126.882, FALSE),
('커피 브레이크 가산점', '카페', '가산', '서울 금천구 가산디지털2로 155', '가산동 123-4', '02-345-6789', '매일 07:00 - 22:00', '가산 커피 브레이크', 'https://placehold.co/600x400/10b981/ffffff?text=Cafe', 4.6, 350, 3500, 37.481, 126.882, TRUE),
('가산 돈까스 클럽', '일식', '가산', '서울 금천구 가산디지털1로 177', '가산동 567-8', '02-456-7890', '매일 11:30 - 21:30', '가산 돈까스 전문점', 'https://placehold.co/600x400/f59e0b/ffffff?text=돈까스', 4.7, 299, 2990, 37.481, 126.882, TRUE),
('구로디지털단지 족발야시장', '한식', '구로', '서울 구로구 디지털로 123', '구로동 901-2', '02-567-8901', '매일 17:00 - 02:00', '구로 족발 전문점', 'https://placehold.co/600x400/78716c/ffffff?text=족발', 4.8, 320, 3200, 37.485, 126.901, TRUE),
('월화 G밸리점', '한식', '가산', '서울 금천구 가산디지털2로 199', '가산동 345-6', '02-678-9012', '매일 17:00 - 02:00', '가산 고기 전문점', 'https://placehold.co/600x400/ef4444/ffffff?text=고기', 4.8, 410, 4100, 37.481, 126.882, TRUE),
('스시메이진 가산점', '일식', '가산', '서울 금천구 가산디지털1로 211', '가산동 789-0', '02-789-0123', '매일 11:30 - 22:00', '가산 스시 전문점', 'https://placehold.co/600x400/3b82f6/ffffff?text=초밥', 4.5, 280, 2800, 37.481, 126.882, TRUE),
('샐러디 W몰점', '양식', '가산', '서울 금천구 가산디지털2로 233', '가산동 123-4', '02-890-1234', '매일 10:00 - 22:00', '가산 샐러드 전문점', 'https://placehold.co/600x400/22c55e/ffffff?text=샐러드', 4.4, 150, 1500, 37.481, 126.882, TRUE),
('베트남 노상식당', '기타', '가산', '서울 금천구 가산디지털1로 255', '가산동 567-8', '02-901-2345', '매일 11:00 - 21:00', '가산 베트남 쌀국수', 'https://placehold.co/600x400/f97316/ffffff?text=쌀국수', 4.5, 240, 2400, 37.481, 126.882, FALSE),
('리춘시장 가산디지털역점', '중식', '가산', '서울 금천구 가산디지털2로 277', '가산동 901-2', '02-012-3456', '매일 11:00 - 22:00', '가산 마라탕 전문점', 'https://placehold.co/600x400/dc2626/ffffff?text=마라탕', 4.3, 210, 2100, 37.481, 126.882, FALSE),
('폴바셋 현대아울렛가산점', '카페', '가산', '서울 금천구 가산디지털1로 299', '가산동 345-6', '02-123-4567', '매일 08:00 - 22:00', '가산 폴바셋', 'https://placehold.co/600x400/172554/ffffff?text=Paul+Bassett', 4.7, 290, 2900, 37.481, 126.882, TRUE),
('해물품은닭', '한식', '구로', '서울 구로구 디지털로 145', '구로동 789-0', '02-234-5678', '매일 17:00 - 02:00', '구로 닭볶음탕 전문점', 'https://placehold.co/600x400/fbbf24/ffffff?text=닭볶음탕', 4.7, 265, 2650, 37.485, 126.901, TRUE),
('인도요리 아그라', '기타', '가산', '서울 금천구 가산디지털2로 321', '가산동 123-4', '02-345-6789', '매일 11:30 - 22:00', '가산 인도 커리', 'https://placehold.co/600x400/c2410c/ffffff?text=커리', 4.4, 175, 1750, 37.481, 126.882, TRUE),
('오봉집 가산디지털점', '한식', '가산', '서울 금천구 가산디지털1로 343', '가산동 567-8', '02-456-7890', '매일 11:30 - 22:00', '가산 보쌈 전문점', 'https://placehold.co/600x400/991b1b/ffffff?text=보쌈', 4.6, 380, 3800, 37.481, 126.882, TRUE),
('투썸플레이스 가산W몰점', '카페', '가산', '서울 금천구 가산디지털2로 365', '가산동 901-2', '02-567-8901', '매일 07:00 - 23:00', '가산 투썸플레이스', 'https://placehold.co/600x400/ef4444/ffffff?text=Twosome', 4.4, 220, 2200, 37.481, 126.882, TRUE),
('툭툭누들타이', '기타', '연남', '서울 마포구 연남로 12길 34', '연남동 567-8', '02-678-9012', '매일 11:30 - 22:00', '연남 태국 쌀국수', 'https://placehold.co/600x400/16a34a/ffffff?text=Thai', 4.8, 450, 4500, 37.556, 126.923, FALSE);

-- 메뉴 샘플 데이터 (주요 레스토랑들)
INSERT INTO menus (restaurant_id, name, price, description, is_popular) VALUES
-- 고미정
(1, '궁중 수라상', '75,000원', '전통 궁중요리 코스', TRUE),
(1, '고미정 정식', '55,000원', '고미정 대표 정식', TRUE),
(1, '보리굴비 정식', '45,000원', '보리굴비와 함께하는 정식', FALSE),
-- 파스타 팩토리
(2, '트러플 크림 파스타', '18,000원', '트러플 향이 진한 크림 파스타', TRUE),
(2, '봉골레 파스타', '16,000원', '신선한 조개와 화이트 와인 소스', TRUE),
(2, '마르게리따 피자', '20,000원', '토마토, 모짜렐라, 바질의 클래식 피자', FALSE),
-- 스시 마에
(3, '런치 오마카세', '120,000원', '점심 오마카세 코스', TRUE),
(3, '디너 오마카세', '250,000원', '저녁 프리미엄 오마카세', TRUE),
-- 치맥 하우스
(4, '반반치킨', '19,000원', '양념+후라이드 반반', TRUE),
(4, '종로 페일에일', '7,500원', '수제 맥주', TRUE),
-- 카페 클라우드
(5, '아인슈페너', '7,000원', '오스트리아 전통 커피', TRUE),
(5, '클라우드 케이크', '8,500원', '입안에서 사라지는 부드러운 케이크', TRUE),
-- 우부래도
(11, '단호박 머핀', '4,000원', '비건 단호박 머핀', TRUE),
(11, '쌀바게트', '4,500원', '쌀로 만든 바게트', TRUE),
(11, '홍국단팥빵', '4,000원', '홍국과 단팥이 들어간 빵', FALSE);

-- 리뷰 샘플 데이터 (data.js 기반)
INSERT INTO reviews (restaurant_id, user_id, author, author_image, rating, content, likes) VALUES
(2, 1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '여기 진짜 분위기 깡패에요! 소개팅이나 데이트 초반에 가면 무조건 성공입니다.', 25),
(4, 2, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 4, '일 끝나고 동료들이랑 갔는데, 스트레스가 확 풀리네요. 새로 나온 마늘간장치킨이 진짜 맛있어요.', 18),
(1, 3, '효녀딸', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 5, '부모님 생신이라 모시고 갔는데 정말 좋아하셨어요. 음식 하나하나 정성이 느껴져요.', 32),
(10, 4, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 5, '역시 여름엔 평양냉면이죠. 이 집 육수는 정말 최고입니다.', 28),
(12, 4, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 5, '가산에서 이만한 퀄리티의 삼겹살을 찾기 힘듭니다. 회식 장소로 강력 추천!', 35),
(13, 7, '가산직장인', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 4, '점심시간에 웨이팅은 좀 있지만, 든든하게 한 끼 해결하기에 최고입니다. 깍두기가 맛있어요.', 22),
(19, 6, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 4, '산미있는 원두를 좋아하시면 여기입니다. 디저트 케이크도 괜찮았어요.', 19),
(14, 1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 4, '가산에서 파스타 먹고 싶을 때 가끔 들러요. 창가 자리가 분위기 좋아요.', 15),
(11, 1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다. 다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!', 25);

-- 칼럼 샘플 데이터 (data.js 기반)
INSERT INTO columns (user_id, author, author_image, title, content, image, tags, likes, views) VALUES
(6, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', '상도동 비건 빵집 우부래도 솔직 리뷰', '상도동에는 숨겨진 비건 빵 맛집들이 많습니다. 그 중에서도 제가 가장 사랑하는 곳은 바로 우부래도입니다. 특히 이곳의 쌀바게트는 정말 일품입니다. 겉은 바삭하고 속은 쫀득한 식감이 살아있죠.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832', '["#상도동", "#비건", "#베이커리"]', 245, 1200),
(4, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', '을지로 직장인들을 위한 최고의 평양냉면', '여름이면 어김없이 생각나는 평양냉면. 을지로의 수많은 노포 중에서도 평양면옥은 단연 최고라고 할 수 있습니다. 슴슴하면서도 깊은 육수 맛이 일품입니다. 점심시간에는 웨이팅이 길 수 있으니 조금 서두르는 것을 추천합니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832', '["#을지로", "#평양냉면", "#노포"]', 188, 890),
(4, '김맛잘알', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', '한식 다이닝의 정수, 강남 고미정 방문기', '특별한 날, 소중한 사람과 함께할 장소를 찾는다면 강남의 고미정을 추천합니다. 정갈한 상차림과 깊은 맛의 한정식 코스는 먹는 내내 감탄을 자아냅니다. 특히 부모님을 모시고 가기에 최고의 장소입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', '["#한식", "#강남", "#데이트"]', 245, 1200),
(1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', '홍대 최고의 파스타, 데이트 성공 보장!', '홍대에서 데이트 약속이 잡혔다면 고민하지 말고 파스타 팩토리로 가세요. 분위기, 맛, 서비스 뭐 하나 빠지는 게 없는 곳입니다. 특히 트러플 크림 파스타는 꼭 먹어봐야 할 메뉴입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', '["#홍대", "#데이트", "#파스타"]', 188, 890),
(7, '가산직장인', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', '가산디지털단지 직장인 점심 맛집 BEST 3', '매일 반복되는 점심 메뉴 고민, 힘드시죠? G밸리 5년차 직장인이 추천하는 점심 맛집 리스트를 공개합니다. 직장인 국밥부터...', 'https://placehold.co/600x400/f97316/ffffff?text=국밥', '["#가산", "#직장인", "#점심"]', 312, 1500),
(2, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', '퇴근 후 한잔, 가산 이자카야 가디 방문기', '지친 하루의 피로를 풀어주는 시원한 맥주와 맛있는 안주. 가디 이자카야는 회식 2차 장소로도, 혼술하기에도 좋은 곳입니다.', 'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야', '["#가산", "#이자카야", "#회식"]', 156, 780),
(6, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', '성수동에서 발견한 인생 커피, 카페 클라우드', '수많은 성수동 카페들 속에서 보석 같은 곳을 발견했습니다. 바로 카페 클라우드입니다. 특히 이곳의 시그니처 라떼는...', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', '["#성수동", "#카페", "#커피"]', 312, 1500),
(1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', '이태원 수제버거의 정석, 브루클린 버거', '육즙 가득한 패티와 신선한 야채의 조화. 브루클린 버거는 언제나 옳은 선택입니다. 치즈 스커트 버거는 꼭 드셔보세요.', 'https://placehold.co/600x400/fb923c/ffffff?text=버거', '["#이태원", "#버거", "#수제"]', 199, 950),
(7, '가산직장인', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 'G밸리 회식장소 끝판왕, 월화 G밸리점', '두툼한 목살과 삼겹살이 일품인 곳. 단체석도 잘 마련되어 있어 가산디지털단지 회식 장소로 이만한 곳이 없습니다.', 'https://placehold.co/600x400/ef4444/ffffff?text=고기', '["#가산", "#회식", "#고기"]', 410, 2000),
(2, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', '종로 치맥의 성지, 치맥 하우스를 가다', '바삭한 치킨과 시원한 생맥주의 조합은 진리입니다. 치맥 하우스는 다양한 종류의 수제 맥주를 맛볼 수 있어 더욱 좋습니다.', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨', '["#종로", "#치맥", "#수제맥주"]', 267, 1300);

-- 예약 샘플 데이터
INSERT INTO reservations (restaurant_id, user_id, restaurant_name, user_name, reservation_time, party_size, status, contact_phone) VALUES
(11, 1, '우부래도', '데이트장인', '2025-09-14 19:00:00', 2, 'CONFIRMED', '010-1234-5678'),
(2, 2, '파스타 팩토리', '퇴근후한잔', '2025-09-13 20:00:00', 4, 'COMPLETED', '010-2345-6789'),
(32, 3, '툭툭누들타이', '효녀딸', '2025-08-15 18:30:00', 2, 'CANCELED', '010-3456-7890');

-- 팔로우 샘플 데이터
INSERT INTO follows (follower_id, following_id) VALUES
(2, 1), -- 퇴근후한잔이 데이트장인을 팔로우
(3, 1), -- 효녀딸이 데이트장인을 팔로우
(1, 4), -- 데이트장인이 김맛잘알을 팔로우
(1, 5), -- 데이트장인이 미스터노포를 팔로우
(1, 6), -- 데이트장인이 빵순이를 팔로우
(2, 4), -- 퇴근후한잔이 김맛잘알을 팔로우
(3, 6); -- 효녀딸이 빵순이를 팔로우
