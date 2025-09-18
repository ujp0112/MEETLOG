-- ===================================================================
-- restaurants 테이블에 상세 정보 컬럼 추가
-- ===================================================================

USE meetlog;

-- restaurants 테이블에 상세 정보 컬럼 추가
ALTER TABLE restaurants 
ADD COLUMN price_range INT DEFAULT 0 COMMENT '가격대: 1=~1만원, 2=1-2만원, 3=2-4만원, 4=4만원+',
ADD COLUMN atmosphere VARCHAR(50) COMMENT '분위기: 데이트, 비즈니스, 가족, 혼밥, 친구모임',
ADD COLUMN dietary_options JSON COMMENT '식이제한 옵션: 채식, 할랄, 글루텐프리, 비건',
ADD COLUMN payment_methods JSON COMMENT '결제 수단: 현금, 카드, 모바일결제, QR결제';

-- 가격대 제약 조건 추가
ALTER TABLE restaurants 
ADD CONSTRAINT chk_price_range CHECK (price_range >= 0 AND price_range <= 4);

-- 인덱스 추가 (성능 최적화)
CREATE INDEX idx_restaurants_price_range ON restaurants(price_range);
CREATE INDEX idx_restaurants_atmosphere ON restaurants(atmosphere);

-- 기존 데이터에 대한 기본값 설정
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

-- 마이그레이션 완료 확인
SELECT 'Restaurant details migration completed successfully' as status;
