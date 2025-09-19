-- ===================================================================
-- MEET LOG 통합 샘플 데이터
-- 모든 테이블에 대한 완전한 샘플 데이터
-- ===================================================================

USE meetlog;

-- 외래 키 제약 조건 검사를 임시로 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- 기존 데이터 삭제 (순서 중요)
DELETE FROM course_reviews;
DELETE FROM course_reservations;
DELETE FROM course_likes;
DELETE FROM course_steps;
DELETE FROM course_tags;
DELETE FROM courses;
DELETE FROM tags;
DELETE FROM notifications;
DELETE FROM recommendation_logs;
DELETE FROM user_similarity;
DELETE FROM restaurant_similarity;
DELETE FROM user_preferences;
DELETE FROM detailed_ratings;
DELETE FROM rating_distributions;
DELETE FROM restaurant_qna;
DELETE FROM restaurant_news;
DELETE FROM coupons;
DELETE FROM events;
DELETE FROM collection_likes;
DELETE FROM collection_restaurants;
DELETE FROM collections;
DELETE FROM feed_items;
DELETE FROM review_comment_likes;
DELETE FROM review_comments;
DELETE FROM column_comments;
DELETE FROM follows;
DELETE FROM reservations;
DELETE FROM columns;
DELETE FROM reviews;
DELETE FROM menus;
DELETE FROM restaurants;
DELETE FROM users;

-- 외래 키 제약 조건 검사를 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;

-- ===================================================================
-- 1. 사용자 데이터
-- ===================================================================
INSERT INTO users (id, email, nickname, password, user_type, profile_image, level, follower_count, following_count, restaurant_id) VALUES
(1, 'kim.expert@meetlog.com', '김맛잘알', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', 6, 12500, 200, NULL),
(2, 'mr.nopo@meetlog.com', '미스터노포', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 7, 8200, 150, NULL),
(3, 'bbang@meetlog.com', '빵순이', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 5, 25100, 180, NULL),
(4, 'date.master@meetlog.com', '데이트장인', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/e879f9/ffffff?text=Me', 5, 1205, 150, NULL),
(5, 'gasan.worker@meetlog.com', '가산직장인', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 4, 3100, 95, NULL),
(6, 'after.work@meetlog.com', '퇴근후한잔', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 3, 890, 45, NULL),
(7, 'hyonyeo@meetlog.com', '효녀딸', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 4, 2100, 78, NULL),
(8, 'jungdae@meetlog.com', '중데생', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://bbscdn.df.nexon.com/data7/commu/202004/230754_5e89e63a88677.png', 2, 0, 0, NULL),
(9, 'sando.bread@meetlog.com', '상도동빵주먹', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://dcimg1.dcinside.com/viewimage.php?id=3da9da27e7d13c&no=24b0d769e1d32ca73de983fa11d02831c6c0b61130e4349ff064c51af2dccfaaa69ce6d782ffbe3cfce75d0ab4b0153873c98d17df4da1937ce4df7cc1e73f9d543acb95a114b61478ff194f7f2b81facc7cc6acb3074408f65976d67d2fe0deaebbfb2ef40152de', 3, 0, 0, NULL),
(10, 'gomi.sa장@meetlog.com', '고미정사장', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'BUSINESS', 'https://placehold.co/100x100/10b981/ffffff?text=B1', 3, 0, 0, 1);

-- ===================================================================
-- 2. 맛집 데이터
-- ===================================================================
INSERT INTO restaurants (id, name, category, location, address, jibun_address, phone, hours, description, image, rating, review_count, likes, latitude, longitude, parking, price_range, atmosphere, dietary_options, payment_methods) VALUES
(1, '고미정', '한식', '강남', '서울특별시 강남구 테헤란로 123', '역삼동 123-45', '02-1234-5678', '매일 11:00 - 22:00', '강남역 한정식, 상견례 장소', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', 4.8, 152, 1203, 37.501, 127.039, TRUE, 4, '가족', '["일반"]', '["현금", "카드", "모바일결제"]'),
(2, '파스타 팩토리', '양식', '홍대', '서울 마포구 와우산로29길 14-12', '서교동 333-1', '02-333-4444', '매일 11:30 - 22:00', '홍대입구역 소개팅, 데이트 맛집', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 4.6, 258, 2341, 37.5559, 126.9238, FALSE, 3, '데이트', '["일반"]', '["현금", "카드", "모바일결제"]'),
(3, '스시 마에', '일식', '여의도', '서울 영등포구 국제금융로 10', '여의도동 23', '02-555-6666', '매일 12:00 - 22:00 (브레이크타임 15:00-18:00)', '여의도 하이엔드 오마카세', 'https://placehold.co/600x400/60a5fa/ffffff?text=오마카세', 4.9, 189, 1890, 37.525, 126.925, TRUE, 4, '비즈니스', '["일반"]', '["현금", "카드", "모바일결제"]'),
(4, '치맥 하우스', '한식', '종로', '서울 종로구 종로 123', '종로3가 11-1', '02-777-8888', '매일 16:00 - 02:00', '종로 수제맥주와 치킨 맛집', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨', 4.4, 310, 3104, 37.570, 126.989, FALSE, 2, '친구모임', '["일반"]', '["현금", "카드", "모바일결제"]'),
(5, '카페 클라우드', '카페', '성수', '서울 성동구 연무장길 12', '성수동2가 300-1', '02-464-1234', '매일 10:00 - 22:00', '성수동 뷰맛집 감성 카페', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', 4.5, 288, 2880, 37.543, 127.054, TRUE, 2, '데이트', '["일반"]', '["현금", "카드", "모바일결제"]'),
(6, '우부래도', '베이커리', '상도', '서울특별시 동작구 상도로37길 3', '상도1동 666-3', '0507-1428-0599', '매일 10:00 - 22:00', '상도역 베이커리, 비건', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832', 4.2, 6, 850, 37.4953, 126.9448, TRUE, 2, '일반', '["비건", "글루텐프리"]', '["현금", "카드", "모바일결제"]'),
(7, '가산생고기', '한식', '가산', '서울 금천구 가산디지털1로 123', '가산동 456-7', '02-678-9012', '매일 17:00 - 02:00', '가산 수제 삼겹살 전문점', 'https://placehold.co/600x400/ef4444/ffffff?text=삼겹살', 4.7, 285, 2850, 37.481, 126.882, TRUE, 3, '친구모임', '["일반"]', '["현금", "카드", "모바일결제"]'),
(8, '직장인 국밥', '한식', '가산', '서울 금천구 가산디지털2로 45', '가산동 789-0', '02-789-0123', '매일 11:00 - 15:00', '가산 직장인 점심 국밥집', 'https://placehold.co/600x400/f97316/ffffff?text=국밥', 4.5, 312, 3120, 37.481, 126.882, FALSE, 1, '혼밥', '["일반"]', '["현금", "카드", "모바일결제"]'),
(9, '파파 이탈리아노', '양식', '가산', '서울 금천구 가산디지털1로 67', '가산동 123-4', '02-890-1234', '매일 11:30 - 22:00', '가산 이탈리안 레스토랑', 'https://placehold.co/600x400/84cc16/ffffff?text=파스타', 4.4, 189, 1890, 37.481, 126.882, TRUE, 3, '비즈니스', '["일반"]', '["현금", "카드", "모바일결제"]'),
(10, '가디 이자카야', '일식', '가산', '서울 금천구 가산디지털2로 89', '가산동 567-8', '02-901-2345', '매일 18:00 - 01:00', '가산 이자카야', 'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야', 4.6, 234, 2340, 37.481, 126.882, FALSE, 3, '친구모임', '["일반"]', '["현금", "카드", "모바일결제"]');

-- ===================================================================
-- 3. 메뉴 데이터
-- ===================================================================
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
(5, '클라우드 케이크', '8,500원', '입안에서 사라지는 부드러운 케이크', TRUE),
(6, '단호박 머핀', '4,000원', '비건 단호박 머핀', TRUE),
(6, '쌀바게트', '4,500원', '쌀로 만든 바게트', TRUE),
(6, '홍국단팥빵', '4,000원', '홍국과 단팥이 들어간 빵', FALSE);

-- ===================================================================
-- 4. 리뷰 데이터
-- ===================================================================
INSERT INTO reviews (restaurant_id, user_id, author, author_image, rating, content, images, keywords, likes, taste_rating, service_rating, atmosphere_rating, price_rating, visit_date, party_size, visit_purpose) VALUES
(2, 4, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '여기 진짜 분위기 깡패에요! 소개팅이나 데이트 초반에 가면 무조건 성공입니다.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832"]', NULL, 25, 5, 5, 5, 4, '2025-09-10', 2, '데이트'),
(4, 6, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 4, '일 끝나고 동료들이랑 갔는데, 스트레스가 확 풀리네요. 새로 나온 마늘간장치킨이 진짜 맛있어요.', NULL, NULL, 18, 4, 4, 4, 4, '2025-09-08', 4, '친구모임'),
(1, 7, '효녀딸', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 5, '부모님 생신이라 모시고 갔는데 정말 좋아하셨어요. 음식 하나하나 정성이 느껴져요.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832"]', NULL, 32, 5, 5, 5, 4, '2025-09-05', 4, '가족모임'),
(6, 4, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832"]', '["#음식이 맛있어요", "#재료가 신선해요"]', 25, 5, 4, 4, 4, '2025-09-12', 2, '데이트'),
(6, 3, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다.', '["https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832"]', '["#음식이 맛있어요", "#재료가 신선해요"]', 25, 5, 4, 4, 4, '2025-09-11', 1, '혼밥');

-- ===================================================================
-- 5. 칼럼 데이터
-- ===================================================================
INSERT INTO columns (user_id, author, author_image, title, content, image, tags, likes, views) VALUES
(3, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', '상도동 비건 빵집 우부래도 솔직 리뷰', '상도동에는 숨겨진 비건 빵 맛집들이 많습니다. 그 중에서도 제가 가장 사랑하는 곳은 바로 우부래도입니다. 특히 이곳의 쌀바게트는 정말 일품입니다. 겉은 바삭하고 속은 쫀득한 식감이 살아있죠.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832', '["#상도동", "#비건", "#베이커리"]', 245, 1200),
(2, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', '을지로 직장인들을 위한 최고의 평양냉면', '여름이면 어김없이 생각나는 평양냉면. 을지로의 수많은 노포 중에서도 평양면옥은 단연 최고라고 할 수 있습니다. 슴슴하면서도 깊은 육수 맛이 일품입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832', '["#을지로", "#평양냉면", "#노포"]', 188, 890),
(1, '김맛잘알', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', '한식 다이닝의 정수, 강남 고미정 방문기', '특별한 날, 소중한 사람과 함께할 장소를 찾는다면 강남의 고미정을 추천합니다. 정갈한 상차림과 깊은 맛의 한정식 코스는 먹는 내내 감탄을 자아냅니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', '["#한식", "#강남", "#데이트"]', 245, 1200);

-- ===================================================================
-- 6. 예약 데이터
-- ===================================================================
INSERT INTO reservations (restaurant_id, user_id, restaurant_name, user_name, reservation_time, party_size, status, contact_phone) VALUES
(6, 4, '우부래도', '데이트장인', '2025-09-14 19:00:00', 2, 'CONFIRMED', '010-1234-5678'),
(2, 4, '파스타 팩토리', '데이트장인', '2025-09-13 20:00:00', 4, 'COMPLETED', '010-1234-5678'),
(1, 7, '고미정', '효녀딸', '2025-09-15 18:30:00', 4, 'CONFIRMED', '010-3456-7890');

-- ===================================================================
-- 7. 팔로우 데이터
-- ===================================================================
INSERT INTO follows (follower_id, following_id) VALUES
(2, 4), -- 미스터노포가 데이트장인을 팔로우
(4, 3), -- 데이트장인이 빵순이를 팔로우
(4, 2), -- 데이트장인이 미스터노포를 팔로우
(6, 4), -- 퇴근후한잔이 데이트장인을 팔로우
(7, 4); -- 효녀딸이 데이트장인을 팔로우

-- ===================================================================
-- 8. 코스 시스템 데이터
-- ===================================================================
INSERT INTO tags (tag_id, tag_name) VALUES
(1, '데이트'),
(2, '홍대'),
(3, '성수'),
(4, '양식'),
(5, '카페'),
(6, '커뮤니티추천');

INSERT INTO courses (course_id, title, description, area, duration, price, type, preview_image, author_id) VALUES
(1, '홍대 데이트 완벽 코스 (파스타+카페)', '데이트장인이 추천하는 홍대 데이트 코스입니다. 이대로만 따라오시면 실패 없는 하루!', '홍대/연남', '약 3시간', 0, 'COMMUNITY', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', 4),
(2, '[MEET LOG] 성수동 감성 투어', 'MEET LOG가 직접 큐레이션한 성수동 감성 맛집과 카페 코스입니다. 힙한 성수를 느껴보세요.', '성수/건대', '약 4시간', 15000, 'OFFICIAL', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', NULL);

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

-- ===================================================================
-- 9. 이벤트 및 뉴스 데이터
-- ===================================================================
INSERT INTO events (title, summary, content, image, start_date, end_date) VALUES
('MEET LOG 가을맞이! 5성급 호텔 뷔페 30% 할인', '선선한 가을, MEET LOG가 추천하는 최고의 호텔 뷔페에서 특별한 미식을 경험하세요.', '이벤트 내용 본문입니다. 상세한 약관과 참여 방법이 여기에 들어갑니다.', 'https://placehold.co/800x400/f97316/ffffff?text=Hotel+Buffet+Event', '2025-09-01', '2025-10-31'),
('신규 맛집 파스타 팩토리 리뷰 이벤트', '홍대 파스타 팩토리 방문 후 MEET LOG에 리뷰를 남겨주세요! 추첨을 통해 2인 식사권을 드립니다!', '상세 내용: 1. 파스타 팩토리 방문 2. 사진과 함께 정성스러운 리뷰 작성 3. 자동 응모 완료!', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', '2025-09-10', '2025-09-30');

INSERT INTO coupons (restaurant_id, title, description, validity) VALUES
(6, '비건 디저트 20% 할인', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31'),
(1, '상견례 10% 할인', '상견례 예약 시 제공', '~ 2025.12.31'),
(2, '에이드 1잔 무료', 'MEET LOG 회원 인증 시 제공', '~ 2025.12.31');

INSERT INTO restaurant_news (restaurant_id, type, title, content, date) VALUES
(6, '이벤트', '여름 한정! 단호박 빙수 출시!', '무더운 여름을 날려버릴 시원하고 달콤한 우부래도표 비건 단호박 빙수가 출시되었습니다.', '2025.08.05'),
(1, '공지', '겨울 한정 메뉴 출시', '따뜻한 겨울을 위한 전통 한정식 메뉴가 새롭게 출시되었습니다.', '2025.12.01'),
(2, '이벤트', '신메뉴 출시! 트러플 파스타', '프리미엄 트러플을 사용한 새로운 파스타 메뉴가 출시되었습니다.', '2025.11.20');

-- ===================================================================
-- 10. 평점 및 통계 데이터
-- ===================================================================
INSERT INTO rating_distributions (restaurant_id, rating_1, rating_2, rating_3, rating_4, rating_5) VALUES
(6, 0, 0, 2, 1, 3),
(1, 0, 0, 4, 28, 120),
(2, 0, 0, 18, 60, 180);

INSERT INTO detailed_ratings (restaurant_id, taste, price, service) VALUES
(6, 4.0, 3.3, 3.3),
(1, 4.9, 4.5, 4.8),
(2, 4.7, 4.2, 4.5);

-- ===================================================================
-- 11. 추천 시스템 초기 데이터
-- ===================================================================
INSERT INTO user_preferences (user_id, category, price_range, atmosphere, preference_score, review_count) VALUES
(4, '양식', 3, '데이트', 0.95, 2),
(4, '베이커리', 2, '일반', 0.90, 1),
(3, '베이커리', 2, '일반', 0.95, 1),
(6, '한식', 2, '친구모임', 0.80, 1),
(7, '한식', 4, '가족모임', 0.95, 1);

-- ===================================================================
-- 12. 알림 데이터
-- ===================================================================
INSERT INTO notifications (user_id, type, title, content, action_url) VALUES
(4, 'follow', '새로운 팔로워', '미스터노포님이 당신을 팔로우하기 시작했습니다.', '/user/2'),
(4, 'like', '리뷰에 좋아요', '빵순이님이 당신의 리뷰에 좋아요를 눌렀습니다.', '/review/1'),
(3, 'comment', '칼럼에 댓글', '중데생님이 당신의 칼럼에 댓글을 남겼습니다.', '/column/1');

-- ===================================================================
-- 샘플 데이터 삽입 완료
-- ===================================================================
SELECT 'MEET LOG 통합 샘플 데이터 삽입 완료' as status;
