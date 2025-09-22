# MEET LOG 데이터베이스 마이그레이션 가이드

이 가이드는 MEET LOG 데이터베이스의 새로운 구조로 마이그레이션하는 방법을 설명합니다.

## 📋 개요

### 기존 구조 (통합 파일)
- `unified_schema.sql` - 모든 테이블을 하나의 파일에 통합
- `unified_sample_data.sql` - 모든 샘플 데이터를 하나의 파일에 통합

### 새로운 구조 (모듈화)
- `01_schema.sql` - 메인 애플리케이션 스키마
- `02_data.sql` - 메인 애플리케이션 샘플 데이터
- `erp_schema.sql` - ERP 기능 스키마

## 🚀 마이그레이션 방법

### 1. 기존 데이터베이스 백업
```sql
-- 기존 데이터베이스 백업
mysqldump -u username -p meetlog > backup_meetlog_$(date +%Y%m%d_%H%M%S).sql
```

### 2. 새로운 구조로 마이그레이션

#### 방법 A: 완전 재구성 (권장)
```sql
-- 1. 기존 데이터베이스 삭제
DROP DATABASE IF EXISTS meetlog;

-- 2. 새로운 데이터베이스 생성
CREATE DATABASE meetlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. 새로운 구조 적용
USE meetlog;
SOURCE 01_schema.sql;    -- 메인 스키마
SOURCE 02_data.sql;      -- 메인 데이터
SOURCE erp_schema.sql;   -- ERP 스키마 (선택사항)
```

#### 방법 B: 점진적 마이그레이션
```sql
-- 1. 기존 데이터베이스 유지
USE meetlog;

-- 2. 메인 기능만 새로 구성
SOURCE 01_schema.sql;    -- 메인 스키마 (기존 테이블 덮어쓰기)
SOURCE 02_data.sql;      -- 메인 데이터 (기존 데이터 덮어쓰기)

-- 3. ERP 기능 추가 (필요시)
SOURCE erp_schema.sql;   -- ERP 스키마
```

## 📊 구조 비교

### 기존 통합 구조
```
unified_schema.sql
├── 모든 테이블 정의
├── 모든 인덱스
├── 모든 제약조건
└── 모든 뷰

unified_sample_data.sql
├── 모든 샘플 데이터
├── TRUNCATE 구문
└── INSERT 구문
```

### 새로운 모듈화 구조
```
01_schema.sql (메인 애플리케이션)
├── users, restaurants, reviews
├── columns, courses, reservations
├── follows, comments, notifications
└── 관련 인덱스 및 제약조건

02_data.sql (메인 샘플 데이터)
├── 32개 레스토랑 데이터
├── 10명 사용자 데이터
├── 리뷰, 칼럼, 코스 데이터
└── 완전한 관계형 데이터

erp_schema.sql (ERP 기능)
├── company, branch, material
├── menu, purchase_order
└── 멀티테넌트 구조
```

## 🔧 마이그레이션 단계별 가이드

### 1단계: 준비 작업
```bash
# 1. 현재 데이터베이스 상태 확인
mysql -u username -p -e "SHOW TABLES;" meetlog

# 2. 백업 생성
mysqldump -u username -p meetlog > backup_before_migration.sql

# 3. 새로운 파일들 확인
ls -la database/01_schema.sql database/02_data.sql database/erp_schema.sql
```

### 2단계: 스키마 마이그레이션
```sql
-- 1. 메인 스키마 적용
USE meetlog;
SOURCE 01_schema.sql;

-- 2. 스키마 확인
SHOW TABLES;
DESCRIBE users;
DESCRIBE restaurants;
```

### 3단계: 데이터 마이그레이션
```sql
-- 1. 샘플 데이터 적용
SOURCE 02_data.sql;

-- 2. 데이터 확인
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM restaurants;
SELECT COUNT(*) FROM reviews;
```

### 4단계: ERP 기능 추가 (선택사항)
```sql
-- 1. ERP 스키마 적용
SOURCE erp_schema.sql;

-- 2. ERP 테이블 확인
SHOW TABLES LIKE '%company%';
SHOW TABLES LIKE '%branch%';
```

## ⚠️ 주의사항

### 1. 데이터 손실 위험
- **백업 필수**: 마이그레이션 전 반드시 데이터베이스 백업
- **테스트 환경**: 프로덕션 적용 전 테스트 환경에서 검증
- **점진적 적용**: 가능하면 단계별로 적용

### 2. 애플리케이션 코드 업데이트
- **테이블 구조**: 새로운 컬럼이나 변경된 구조 확인
- **쿼리 수정**: 변경된 테이블명이나 컬럼명에 맞게 쿼리 수정
- **인덱스 활용**: 새로운 인덱스를 활용한 쿼리 최적화

### 3. 성능 고려사항
- **인덱스 재구성**: 마이그레이션 후 인덱스 통계 업데이트
- **쿼리 최적화**: 새로운 구조에 맞는 쿼리 최적화
- **모니터링**: 마이그레이션 후 성능 모니터링

## 🔍 검증 방법

### 1. 스키마 검증
```sql
-- 테이블 개수 확인
SELECT COUNT(*) as table_count FROM information_schema.tables 
WHERE table_schema = 'meetlog';

-- 외래키 제약조건 확인
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE 
WHERE table_schema = 'meetlog' 
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### 2. 데이터 검증
```sql
-- 데이터 개수 확인
SELECT 
    'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'restaurants', COUNT(*) FROM restaurants
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'columns', COUNT(*) FROM columns;

-- 데이터 무결성 확인
SELECT 
    r.id, r.restaurant_id, r.user_id,
    res.name as restaurant_name,
    u.nickname as user_nickname
FROM reviews r
LEFT JOIN restaurants res ON r.restaurant_id = res.id
LEFT JOIN users u ON r.user_id = u.id
WHERE r.restaurant_id IS NULL OR r.user_id IS NULL;
```

### 3. 성능 검증
```sql
-- 인덱스 사용률 확인
SHOW INDEX FROM users;
SHOW INDEX FROM restaurants;
SHOW INDEX FROM reviews;

-- 쿼리 실행 계획 확인
EXPLAIN SELECT * FROM restaurants WHERE category = '한식';
EXPLAIN SELECT * FROM reviews WHERE restaurant_id = 1;
```

## 🚨 문제 해결

### 1. 외래키 제약조건 오류
```sql
-- 외래키 제약조건 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- 스키마 재적용
SOURCE 01_schema.sql;
SOURCE 02_data.sql;

-- 외래키 제약조건 활성화
SET FOREIGN_KEY_CHECKS = 1;
```

### 2. 데이터 중복 오류
```sql
-- 중복 데이터 확인
SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1;
SELECT nickname, COUNT(*) FROM users GROUP BY nickname HAVING COUNT(*) > 1;

-- 중복 데이터 삭제
DELETE u1 FROM users u1
INNER JOIN users u2 
WHERE u1.id > u2.id AND u1.email = u2.email;
```

### 3. 성능 문제
```sql
-- 인덱스 재구성
ANALYZE TABLE users;
ANALYZE TABLE restaurants;
ANALYZE TABLE reviews;

-- 테이블 최적화
OPTIMIZE TABLE users;
OPTIMIZE TABLE restaurants;
OPTIMIZE TABLE reviews;
```

## 📈 마이그레이션 후 최적화

### 1. 인덱스 최적화
```sql
-- 사용하지 않는 인덱스 확인
SELECT 
    t.TABLE_NAME,
    t.INDEX_NAME,
    t.CARDINALITY
FROM information_schema.STATISTICS t
WHERE t.TABLE_SCHEMA = 'meetlog'
ORDER BY t.TABLE_NAME, t.CARDINALITY;
```

### 2. 쿼리 최적화
```sql
-- 느린 쿼리 확인
SHOW PROCESSLIST;

-- 쿼리 프로파일링 활성화
SET profiling = 1;
-- 쿼리 실행
SELECT * FROM restaurants WHERE category = '한식';
-- 프로파일 결과 확인
SHOW PROFILES;
```

## 📞 지원

마이그레이션 과정에서 문제가 발생하면:

1. **로그 확인**: MySQL 에러 로그 확인
2. **백업 복원**: 문제 발생 시 백업으로 복원
3. **개발팀 문의**: 복잡한 문제는 개발팀에 문의

---

**마지막 업데이트**: 2025년 1월  
**유지보수**: MEET LOG 개발팀