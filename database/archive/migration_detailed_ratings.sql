-- ===================================================================
-- 상세 평점 시스템을 위한 데이터베이스 마이그레이션 스크립트
-- ===================================================================

USE meetlog;

-- 1. restaurants 테이블에 상세 정보 컬럼 추가
ALTER TABLE restaurants 
ADD COLUMN price_range INT DEFAULT 0 COMMENT '가격대: 1=~1만원, 2=1-2만원, 3=2-4만원, 4=4만원+',
ADD COLUMN atmosphere VARCHAR(50) COMMENT '분위기: 데이트, 비즈니스, 가족, 혼밥, 친구모임',
ADD COLUMN dietary_options JSON COMMENT '식이제한 옵션: 채식, 할랄, 글루텐프리, 비건',
ADD COLUMN payment_methods JSON COMMENT '결제 수단: 현금, 카드, 모바일결제, QR결제';

-- 2. reviews 테이블에 상세 평점 컬럼 추가
ALTER TABLE reviews 
ADD COLUMN taste_rating INT DEFAULT 0 COMMENT '맛 평점 (1-5)',
ADD COLUMN service_rating INT DEFAULT 0 COMMENT '서비스 평점 (1-5)',
ADD COLUMN atmosphere_rating INT DEFAULT 0 COMMENT '분위기 평점 (1-5)',
ADD COLUMN price_rating INT DEFAULT 0 COMMENT '가격 평점 (1-5)',
ADD COLUMN visit_date DATE COMMENT '방문 날짜',
ADD COLUMN party_size INT DEFAULT 1 COMMENT '인원수',
ADD COLUMN visit_purpose VARCHAR(50) COMMENT '방문 목적: 데이트, 비즈니스, 가족모임, 친구모임, 혼밥';

-- 3. 기존 데이터에 대한 기본값 설정 (제약 조건 추가 전에)
-- 기존 리뷰들의 상세 평점을 전체 평점과 동일하게 설정
UPDATE reviews 
SET taste_rating = rating,
    service_rating = rating,
    atmosphere_rating = rating,
    price_rating = rating,
    visit_date = DATE(created_at),
    party_size = 2,
    visit_purpose = '일반'
WHERE taste_rating = 0;

-- 4. 평점 제약 조건 추가
ALTER TABLE reviews 
ADD CONSTRAINT chk_taste_rating CHECK (taste_rating >= 1 AND taste_rating <= 5),
ADD CONSTRAINT chk_service_rating CHECK (service_rating >= 1 AND service_rating <= 5),
ADD CONSTRAINT chk_atmosphere_rating CHECK (atmosphere_rating >= 1 AND atmosphere_rating <= 5),
ADD CONSTRAINT chk_price_rating CHECK (price_rating >= 1 AND price_rating <= 5),
ADD CONSTRAINT chk_party_size CHECK (party_size >= 1 AND party_size <= 20);

-- 5. 가격대 제약 조건 추가
ALTER TABLE restaurants 
ADD CONSTRAINT chk_price_range CHECK (price_range >= 0 AND price_range <= 4);

-- 6. 인덱스 추가 (성능 최적화)
CREATE INDEX idx_reviews_detailed_ratings ON reviews(taste_rating, service_rating, atmosphere_rating, price_rating);
CREATE INDEX idx_reviews_visit_date ON reviews(visit_date);
CREATE INDEX idx_reviews_visit_purpose ON reviews(visit_purpose);
CREATE INDEX idx_restaurants_price_range ON restaurants(price_range);
CREATE INDEX idx_restaurants_atmosphere ON restaurants(atmosphere);

-- 7. 샘플 데이터 업데이트 (기존 맛집들에 상세 정보 추가)
UPDATE restaurants 
SET price_range = CASE 
    WHEN name LIKE '%고급%' OR name LIKE '%프리미엄%' THEN 4
    WHEN name LIKE '%중급%' OR name LIKE '%일반%' THEN 3
    WHEN name LIKE '%저렴%' OR name LIKE '%가성비%' THEN 2
    ELSE 3
END,
atmosphere = CASE 
    WHEN category = '카페' THEN '데이트'
    WHEN category = '한식' THEN '가족'
    WHEN category = '양식' THEN '비즈니스'
    ELSE '일반'
END,
dietary_options = JSON_ARRAY('일반'),
payment_methods = JSON_ARRAY('현금', '카드', '모바일결제')
WHERE price_range = 0;

-- 8. 상세 평점 통계를 위한 뷰 생성
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

-- 9. 마이그레이션 완료 확인
SELECT 'Migration completed successfully' as status;
