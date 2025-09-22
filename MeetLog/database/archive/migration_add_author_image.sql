-- author_image 컬럼 추가 마이그레이션 스크립트
-- 기존 데이터베이스에 author_image 컬럼을 추가합니다.

-- 1. columns 테이블에 author_image 컬럼 추가
ALTER TABLE columns ADD COLUMN author_image VARCHAR(500) AFTER author;

-- 2. 기존 데이터에 기본 프로필 이미지 설정
UPDATE columns SET author_image = 'https://placehold.co/150x150/94a3b8/ffffff?text=A' WHERE author_image IS NULL;

-- 3. reviews 테이블의 author_image 컬럼이 없다면 추가 (이미 있을 수 있음)
-- ALTER TABLE reviews ADD COLUMN author_image VARCHAR(500) AFTER author;

-- 4. 기존 리뷰 데이터에 기본 프로필 이미지 설정 (필요시)
-- UPDATE reviews SET author_image = 'https://placehold.co/100x100/94a3b8/ffffff?text=U' WHERE author_image IS NULL;

-- 5. 마이그레이션 완료 확인
SELECT 'Migration completed successfully' as status;
