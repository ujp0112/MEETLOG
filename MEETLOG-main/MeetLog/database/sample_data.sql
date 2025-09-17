-- MEET LOG 샘플 데이터
USE meetlog;

-- 사용자 샘플 데이터
INSERT INTO users (email, nickname, password, user_type, profile_image, level, follower_count, following_count) VALUES
('user1@example.com', '데이트장인', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, 1205, 150),
('user2@example.com', '퇴근후한잔', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 3, 890, 45),
('user3@example.com', '효녀딸', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 4, 2100, 78),
('columnist1@example.com', '김맛잘알', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', 6, 12500, 200),
('columnist2@example.com', '미스터노포', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 7, 8200, 150),
('business1@example.com', '고미정사장', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'BUSINESS', 'https://placehold.co/100x100/10b981/ffffff?text=B1', 3, 0, 0);

-- 맛집 샘플 데이터
INSERT INTO restaurants (name, category, location, address, jibun_address, phone, hours, description, image, rating, review_count, likes, latitude, longitude, parking) VALUES
('고미정', '한식', '강남', '서울특별시 강남구 테헤란로 123', '역삼동 123-45', '02-1234-5678', '매일 11:00 - 22:00', '강남역 한정식, 상견례 장소', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', 4.8, 152, 1203, 37.501, 127.039, TRUE),
('파스타 팩토리', '양식', '홍대', '서울 마포구 와우산로29길 14-12', '서교동 333-1', '02-333-4444', '매일 11:30 - 22:00', '홍대입구역 소개팅, 데이트 맛집', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 4.6, 258, 2341, 37.5559, 126.9238, FALSE),
('스시 마에', '일식', '여의도', '서울 영등포구 국제금융로 10', '여의도동 23', '02-555-6666', '매일 12:00 - 22:00 (브레이크타임 15:00-18:00)', '여의도 하이엔드 오마카세', 'https://placehold.co/600x400/60a5fa/ffffff?text=오마카세', 4.9, 189, 1890, 37.525, 126.925, TRUE),
('치맥 하우스', '한식', '종로', '서울 종로구 종로 123', '종로3가 11-1', '02-777-8888', '매일 16:00 - 02:00', '종로 수제맥주와 치킨 맛집', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨', 4.4, 310, 3104, 37.570, 126.989, FALSE),
('카페 클라우드', '카페', '성수', '서울 성동구 연무장길 12', '성수동2가 300-1', '02-464-1234', '매일 10:00 - 22:00', '성수동 뷰맛집 감성 카페', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', 4.5, 288, 2880, 37.543, 127.054, TRUE);

-- 메뉴 샘플 데이터
INSERT INTO menus (restaurant_id, name, price, description, is_popular) VALUES
(1, '궁중 수라상', '75,000원', '전통 궁중요리 코스', TRUE),
(1, '고미정 정식', '55,000원', '고미정 대표 정식', TRUE),
(1, '보리굴비 정식', '45,000원', '보리굴비와 함께하는 정식', FALSE),
(2, '트러플 크림 파스타', '18,000원', '트러플 향이 진한 크림 파스타', TRUE),
(2, '봉골레 파스타', '16,000원', '신선한 조개와 화이트 와인 소스', TRUE),
(2, '마르게리따 피자', '20,000원', '토마토, 모짜렐라, 바질의 클래식 피자', FALSE),
(3, '런치 오마카세', '120,000원', '점심 오마카세 코스', TRUE),
(3, '디너 오마카세', '250,000원', '저녁 프리미엄 오마카세', TRUE),
(4, '반반치킨', '19,000원', '양념+후라이드 반반', TRUE),
(4, '종로 페일에일', '7,500원', '수제 맥주', TRUE),
(5, '아인슈페너', '7,000원', '오스트리아 전통 커피', TRUE),
(5, '클라우드 케이크', '8,500원', '입안에서 사라지는 부드러운 케이크', TRUE);

-- 리뷰 샘플 데이터
INSERT INTO reviews (restaurant_id, user_id, author, author_image, rating, content, likes) VALUES
(2, 1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '여기 진짜 분위기 깡패에요! 소개팅이나 데이트 초반에 가면 무조건 성공입니다.', 25),
(4, 2, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 4, '일 끝나고 동료들이랑 갔는데, 스트레스가 확 풀리네요. 새로 나온 마늘간장치킨이 진짜 맛있어요.', 18),
(1, 3, '효녀딸', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 5, '부모님 생신이라 모시고 갔는데 정말 좋아하셨어요. 음식 하나하나 정성이 느껴져요.', 32),
(3, 4, '김맛잘알', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', 5, '여의도에서 이만한 퀄리티의 오마카세를 찾기 힘듭니다. 셰프님의 솜씨가 정말 뛰어나세요.', 45),
(5, 5, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 4, '성수동 카페 중에서도 단연 최고입니다. 특히 아인슈페너는 정말 맛있어요.', 28);

-- 칼럼 샘플 데이터
INSERT INTO columns (user_id, author, author_image, title, content, image, tags, likes, views) VALUES
(4, '김맛잘알', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', '한식 다이닝의 정수, 강남 고미정 방문기', '특별한 날, 소중한 사람과 함께할 장소를 찾는다면 강남의 고미정을 추천합니다. 정갈한 상차림과 깊은 맛의 한정식 코스는 먹는 내내 감탄을 자아냅니다. 특히 부모님을 모시고 가기에 최고의 장소입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', '["#한식", "#강남", "#데이트"]', 245, 1200),
(1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', '홍대 최고의 파스타, 데이트 성공 보장!', '홍대에서 데이트 약속이 잡혔다면 고민하지 말고 파스타 팩토리로 가세요. 분위기, 맛, 서비스 뭐 하나 빠지는 게 없는 곳입니다. 특히 트러플 크림 파스타는 꼭 먹어봐야 할 메뉴입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', '["#홍대", "#데이트", "#파스타"]', 188, 890),
(5, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', '성수동에서 발견한 인생 커피, 카페 클라우드', '수많은 성수동 카페들 속에서 보석 같은 곳을 발견했습니다. 바로 카페 클라우드입니다. 특히 이곳의 시그니처 라떼는 정말 일품이에요.', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', '["#성수동", "#카페", "#커피"]', 312, 1500);

-- 예약 샘플 데이터
INSERT INTO reservations (restaurant_id, user_id, restaurant_name, user_name, reservation_time, party_size, status, contact_phone) VALUES
(1, 1, '고미정', '데이트장인', '2025-01-15 19:00:00', 2, 'CONFIRMED', '010-1234-5678'),
(2, 2, '파스타 팩토리', '퇴근후한잔', '2025-01-16 20:00:00', 4, 'PENDING', '010-2345-6789'),
(3, 3, '스시 마에', '효녀딸', '2025-01-17 18:30:00', 2, 'CONFIRMED', '010-3456-7890');

-- 팔로우 샘플 데이터
INSERT INTO follows (follower_id, following_id) VALUES
(2, 1), -- 퇴근후한잔이 데이트장인을 팔로우
(3, 1), -- 효녀딸이 데이트장인을 팔로우
(1, 4), -- 데이트장인이 김맛잘알을 팔로우
(1, 5); -- 데이트장인이 미스터노포를 팔로우
