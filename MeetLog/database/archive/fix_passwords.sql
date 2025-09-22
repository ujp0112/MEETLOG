-- 비밀번호를 평문으로 변경하는 스크립트
USE meetlog;

-- 모든 사용자의 비밀번호를 'password123'으로 변경
UPDATE users SET password = 'password123' WHERE email = 'user1@example.com';
UPDATE users SET password = 'password123' WHERE email = 'user2@example.com';
UPDATE users SET password = 'password123' WHERE email = 'user3@example.com';
UPDATE users SET password = 'password123' WHERE email = 'columnist1@example.com';
UPDATE users SET password = 'password123' WHERE email = 'columnist2@example.com';
UPDATE users SET password = 'password123' WHERE email = 'business1@example.com';

-- 변경된 비밀번호 확인
SELECT email, password FROM users;
