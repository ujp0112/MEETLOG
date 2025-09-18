-- ===================================================================
-- 마이그레이션: users 테이블에 restaurant_id 컬럼 추가
-- ===================================================================
USE meetlog;

-- users 테이블에 restaurant_id 컬럼 추가
ALTER TABLE users 
ADD COLUMN restaurant_id INT NULL COMMENT 'BUSINESS 사용자의 경우 연결된 음식점 ID';

-- 외래키 제약조건 추가
ALTER TABLE users 
ADD CONSTRAINT fk_users_restaurant 
FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE SET NULL;

-- 인덱스 추가 (성능 최적화)
CREATE INDEX idx_users_restaurant_id ON users(restaurant_id);
CREATE INDEX idx_users_user_type_restaurant ON users(user_type, restaurant_id);
