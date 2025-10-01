-- course_steps 테이블에 위도/경도 컬럼 추가

ALTER TABLE course_steps
ADD COLUMN latitude DECIMAL(10, 8) NULL COMMENT '위도' AFTER name,
ADD COLUMN longitude DECIMAL(11, 8) NULL COMMENT '경도' AFTER latitude,
ADD COLUMN address VARCHAR(500) NULL COMMENT '주소' AFTER longitude;
