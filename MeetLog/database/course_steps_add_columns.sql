-- course_steps 테이블에 time과 cost 컬럼 추가

ALTER TABLE course_steps
ADD COLUMN time INT DEFAULT 0 COMMENT '소요 시간 (분)' AFTER description,
ADD COLUMN cost INT DEFAULT 0 COMMENT '예상 비용 (원)' AFTER time;
