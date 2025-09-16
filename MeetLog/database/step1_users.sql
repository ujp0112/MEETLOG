-- 1단계: 사용자 데이터 삽입
USE meetlog;

INSERT INTO users (email, nickname, password, user_type, profile_image, level, follower_count, following_count) VALUES
('user1@example.com', '데이트장인', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, 1205, 150),
('user2@example.com', '퇴근후한잔', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 3, 890, 45),
('user3@example.com', '효녀딸', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 4, 2100, 78),
('columnist1@example.com', '김맛잘알', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', 6, 12500, 200),
('columnist2@example.com', '미스터노포', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 7, 8200, 150),
('columnist3@example.com', '빵순이', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 5, 25100, 180),
('columnist4@example.com', '가산직장인', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'PERSONAL', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 4, 3100, 95),
('business1@example.com', '고미정사장', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'BUSINESS', 'https://placehold.co/100x100/10b981/ffffff?text=B1', 3, 0, 0);
