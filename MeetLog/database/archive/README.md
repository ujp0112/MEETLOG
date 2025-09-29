# MEET LOG 데이터베이스

이 폴더는 MEET LOG 프로젝트의 데이터베이스 관련 파일들을 포함합니다.

## 📁 파일 구조

```
database/
├── 01_schema.sql              # 🎯 메인 애플리케이션 스키마
├── 02_data.sql                # 🎯 메인 애플리케이션 샘플 데이터
├── erp_schema.sql             # 🏢 ERP 기능 스키마
├── MIGRATION_GUIDE.md         # 📖 마이그레이션 가이드
├── README.md                  # 📖 이 파일
└── archive/                   # 📦 기존 통합 파일들 보관
    ├── unified_schema.sql
    └── unified_sample_data.sql
```

## 🚀 빠른 시작

### 1. 데이터베이스 생성
```sql
CREATE DATABASE meetlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. 메인 애플리케이션 설정
```sql
USE meetlog;
SOURCE 01_schema.sql;    -- 스키마 생성
SOURCE 02_data.sql;      -- 샘플 데이터 삽입
```

### 3. ERP 기능 설정 (선택사항)
```sql
SOURCE erp_schema.sql;   -- ERP 스키마 생성
```

## 📋 파일 설명

### `01_schema.sql` - 메인 애플리케이션 스키마
- **용도**: 맛집 리뷰, 사용자, 예약 등 핵심 기능
- **포함 테이블**: users, restaurants, reviews, columns, courses, reservations 등
- **특징**: 완전한 CRUD 기능을 위한 최적화된 구조

### `02_data.sql` - 메인 애플리케이션 샘플 데이터
- **용도**: 개발/테스트용 실제 데이터
- **포함 데이터**: 32개 레스토랑, 10명 사용자, 리뷰, 칼럼, 코스 등
- **특징**: 실제 서비스에서 바로 사용 가능한 수준의 데이터

### `erp_schema.sql` - ERP 기능 스키마
- **용도**: 멀티테넌트 ERP 기능 (재고, 발주, 메뉴 관리)
- **포함 테이블**: company, branch, material, menu, purchase_order 등
- **특징**: 회사별 데이터 분리, 확장 가능한 구조

## 🔧 사용법

### 개발 환경 설정
1. MySQL 8.0 이상 설치
2. `meetlog` 데이터베이스 생성
3. `01_schema.sql` 실행 (스키마 생성)
4. `02_data.sql` 실행 (샘플 데이터 삽입)
5. 필요시 `erp_schema.sql` 실행 (ERP 기능)

### 프로덕션 환경
- `01_schema.sql`만 실행 (메인 기능)
- `erp_schema.sql` 실행 (ERP 기능 필요시)
- 실제 데이터는 애플리케이션을 통해 삽입

## 📊 주요 테이블

### 메인 애플리케이션 (`01_schema.sql`)
- **users**: 사용자 정보 (개인/비즈니스)
- **restaurants**: 맛집 정보
- **reviews**: 리뷰 및 평점
- **columns**: 칼럼/블로그 포스트
- **courses**: 맛집 코스
- **reservations**: 예약 관리
- **follows**: 팔로우 관계

### ERP 기능 (`erp_schema.sql`)
- **company**: 회사 정보
- **branch**: 지점 정보
- **material**: 재료 관리
- **menu**: 메뉴 관리
- **purchase_order**: 발주 관리

## 🔧 주요 특징

### 1. 모듈화된 구조
- 메인 기능과 ERP 기능 분리
- 각 기능별 독립적 관리
- 확장성과 유지보수성 향상

### 2. 성능 최적화
- 효율적인 인덱스 구성
- 외래키 제약조건 최적화
- 쿼리 성능 향상

### 3. 실제 사용 가능한 데이터
- 32개 실제 레스토랑 데이터
- 10명의 다양한 사용자 프로필
- 완전한 관계형 데이터

## 🛠️ 유지보수

### 메인 기능 수정
- 스키마 변경: `01_schema.sql` 수정
- 샘플 데이터 변경: `02_data.sql` 수정

### ERP 기능 수정
- ERP 스키마 변경: `erp_schema.sql` 수정

### 새로운 기능 추가
- 메인 기능: `01_schema.sql`에 테이블 추가
- ERP 기능: `erp_schema.sql`에 테이블 추가
- 독립 기능: 새로운 파일 생성

## ⚠️ 주의사항

1. **실행 순서**: `01_schema.sql` → `02_data.sql` → `erp_schema.sql`
2. **외래키**: 각 파일 내에서 외래키 제약조건 관리
3. **데이터 초기화**: `02_data.sql`은 TRUNCATE로 기존 데이터 삭제
4. **ERP 기능**: 선택사항이므로 필요시에만 사용

## 🔄 마이그레이션

기존 통합 파일에서 새로운 구조로 마이그레이션하는 방법은 `MIGRATION_GUIDE.md`를 참조하세요.

## 📞 지원

데이터베이스 관련 문의사항이 있으시면 개발팀에 연락해주세요.

---

**마지막 업데이트**: 2025년 1월  
**유지보수**: MEET LOG 개발팀