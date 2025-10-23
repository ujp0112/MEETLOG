# Phase 3: 레스토랑 도메인 마이그레이션 - 진행 상황

## 📌 개요

Phase 3는 MeetLog의 핵심 비즈니스 로직인 레스토랑 도메인을 Spring Boot + React로 마이그레이션하는 단계입니다.

---

## ✅ 완료된 작업

### 백엔드 (Spring Boot)

#### 1. Restaurant 엔티티 (`Restaurant.java`) ✅
- ✅ 레스토랑 기본 정보 (이름, 카테고리, 설명)
- ✅ 위치 정보 (주소, 위도, 경도)
- ✅ 운영 정보 (영업시간, 가격대, 수용 인원)
- ✅ 상태 관리 (ACTIVE, INACTIVE)
- ✅ Helper 메서드 (isActive, isOwnedBy, getPriceRangeText)

#### 2. Restaurant DTO ✅
- ✅ `RestaurantDto.java` - 레스토랑 정보 + 리뷰 통계
- ✅ `RestaurantCreateRequest.java` - 레스토랑 생성 요청
- ✅ `RestaurantUpdateRequest.java` - 레스토랑 수정 요청
- ✅ `RestaurantSearchRequest.java` - 검색/필터링 요청

#### 3. RestaurantRepository (`RestaurantRepository.java`) ✅
- ✅ MyBatis Mapper 인터페이스
- ✅ `RestaurantRepositoryMapper.xml` - SQL 매핑
  - findById - 레스토랑 조회 (엔티티)
  - findDtoById - 레스토랑 조회 (DTO, 리뷰 통계 포함)
  - search - 레스토랑 검색 (키워드, 필터링, 정렬)
  - countSearch - 검색 결과 개수
  - findByOwnerId - 사업자의 레스토랑 목록
  - insert - 레스토랑 등록
  - update - 레스토랑 수정
  - delete - 레스토랑 삭제
  - updateStatus - 상태 변경
  - existsByName - 이름 중복 체크

#### 4. RestaurantService (`RestaurantService.java`) ✅
- ✅ 레스토랑 조회 (상세 정보)
- ✅ 레스토랑 검색 (페이징, 필터링, 정렬)
- ✅ 내 레스토랑 목록 (사업자용)
- ✅ 레스토랑 생성 (중복 체크)
- ✅ 레스토랑 수정 (권한 체크)
- ✅ 레스토랑 삭제 (권한 체크)
- ✅ 레스토랑 상태 변경
- ✅ 트랜잭션 관리

#### 5. RestaurantController (`RestaurantController.java`) ✅
- ✅ `GET /api/restaurants` - 레스토랑 검색
  - 키워드, 카테고리, 주소, 가격대, 최소 수용 인원
  - 정렬 (이름, 평점, 가격대)
  - 페이징 (page, size)
- ✅ `GET /api/restaurants/{id}` - 레스토랑 상세 조회
- ✅ `GET /api/restaurants/my` - 내 레스토랑 목록 (사업자)
- ✅ `POST /api/restaurants` - 레스토랑 등록 (사업자)
- ✅ `PUT /api/restaurants/{id}` - 레스토랑 수정 (소유자)
- ✅ `DELETE /api/restaurants/{id}` - 레스토랑 삭제 (소유자)
- ✅ `PATCH /api/restaurants/{id}/status` - 상태 변경 (소유자)
- ✅ Swagger 문서화
- ✅ 권한 체크 (@PreAuthorize)

---

### 프론트엔드 (React)

#### 6. API 클라이언트 (`api/restaurant.js`) ✅
- ✅ search - 레스토랑 검색
- ✅ getById - 레스토랑 상세 조회
- ✅ getMyRestaurants - 내 레스토랑 목록
- ✅ create - 레스토랑 등록
- ✅ update - 레스토랑 수정
- ✅ delete - 레스토랑 삭제

#### 7. 레스토랑 목록 페이지 (`RestaurantList.jsx`) ✅
- ✅ 레스토랑 그리드 레이아웃
- ✅ 검색 기능 (키워드)
- ✅ 필터링 (카테고리, 가격대)
- ✅ 정렬 옵션
- ✅ 페이지네이션
- ✅ 레스토랑 카드 (이미지, 이름, 카테고리, 평점, 가격대)
- ✅ 사업자 전용 "레스토랑 등록" 버튼

#### 8. 레스토랑 상세 페이지 (`RestaurantDetail.jsx`) ✅
- ✅ 레스토랑 정보 표시
  - 기본 정보 (이름, 카테고리, 설명)
  - 위치 정보 (주소)
  - 운영 정보 (영업시간, 전화번호, 가격대)
  - 편의 시설 정보
- ✅ 이미지 표시
- ✅ 평점 및 리뷰 개수
- ✅ 소유자 전용 수정/삭제 버튼
- ✅ 에러 처리

#### 9. 레스토랑 등록/수정 페이지 (`RestaurantForm.jsx`) ✅
- ✅ 레스토랑 생성/수정 폼
- ✅ 필드 유효성 검사
- ✅ 카테고리 선택
- ✅ 가격대 선택
- ✅ 이미지 URL 입력
- ✅ 영업시간, 편의시설 등록
- ✅ 로딩 상태 처리
- ✅ 에러 메시지 표시

---

## 📂 생성된 파일 목록

### 백엔드
```
MeetLog-SpringBoot/src/main/java/com/meetlog/
├── model/
│   └── Restaurant.java ✅
├── dto/restaurant/
│   ├── RestaurantDto.java ✅
│   ├── RestaurantCreateRequest.java ✅
│   ├── RestaurantUpdateRequest.java ✅
│   └── RestaurantSearchRequest.java ✅
├── repository/
│   └── RestaurantRepository.java ✅
├── service/
│   └── RestaurantService.java ✅
├── controller/
│   └── RestaurantController.java ✅
└── src/main/resources/mappers/
    └── RestaurantRepositoryMapper.xml ✅
```

### 프론트엔드
```
meetlog-frontend/src/
├── api/
│   └── restaurant.js ✅
├── pages/
│   ├── RestaurantList.jsx ✅
│   ├── RestaurantDetail.jsx ✅
│   └── RestaurantForm.jsx ✅
└── components/restaurant/
    └── (추가 컴포넌트 필요 시)
```

---

## 🎯 주요 기능

### 1. 레스토랑 검색 및 필터링
- **키워드 검색**: 레스토랑 이름, 설명, 메뉴 정보
- **카테고리 필터**: 한식, 중식, 일식, 양식, 분식, 카페, 디저트 등
- **가격대 필터**: 1만원 이하, 1-2만원, 2-3만원, 3만원 이상
- **수용 인원 필터**: 최소 수용 인원
- **정렬**: 이름, 평점, 가격대
- **페이징**: 페이지당 항목 수 조절

### 2. 레스토랑 CRUD
- **생성**: 사업자 회원만 가능, 이름 중복 체크
- **조회**: 모든 사용자 가능, 평점 및 리뷰 통계 포함
- **수정**: 소유자만 가능, 부분 업데이트 지원
- **삭제**: 소유자만 가능

### 3. 권한 관리
- **일반 사용자**: 조회만 가능
- **사업자**: 자신의 레스토랑 등록/수정/삭제 가능
- **관리자**: 모든 레스토랑 관리 가능

### 4. 통계 정보
- **평균 평점**: 리뷰 기반 평균 평점 자동 계산
- **리뷰 개수**: 레스토랑별 리뷰 개수

---

## 🚀 테스트 방법

### 1. 백엔드 실행
```bash
cd MeetLog-SpringBoot
# IntelliJ IDEA에서 MeetLogApplication 실행
```

### 2. 프론트엔드 실행
```bash
cd meetlog-frontend
npm start
```

### 3. Swagger UI 접속
```
http://localhost:8080/api/swagger-ui.html
```

### 4. 테스트 시나리오

#### 시나리오 1: 레스토랑 검색 (일반 사용자)
1. http://localhost:3000/restaurants 접속
2. 키워드 검색 (예: "한식")
3. 카테고리 필터 선택
4. 가격대 필터 선택
5. 정렬 옵션 변경
6. 페이지 이동

#### 시나리오 2: 레스토랑 상세 조회
1. 레스토랑 목록에서 레스토랑 클릭
2. 상세 정보 확인
   - 기본 정보, 위치, 영업시간
   - 평점 및 리뷰 개수
   - 편의 시설, 주차 정보

#### 시나리오 3: 레스토랑 등록 (사업자)
1. 사업자 계정으로 로그인
2. "레스토랑 등록" 버튼 클릭
3. 레스토랑 정보 입력
   - 기본 정보 (이름, 카테고리, 설명)
   - 위치 정보 (주소, 위도, 경도)
   - 운영 정보 (영업시간, 전화번호, 가격대)
   - 이미지 URL
   - 편의 시설, 주차 정보
4. 등록 완료 후 상세 페이지로 이동

#### 시나리오 4: 레스토랑 수정 (소유자)
1. 자신의 레스토랑 상세 페이지 접속
2. "수정" 버튼 클릭
3. 정보 수정
4. 저장 후 상세 페이지로 이동

#### 시나리오 5: 레스토랑 삭제 (소유자)
1. 자신의 레스토랑 상세 페이지 접속
2. "삭제" 버튼 클릭
3. 확인 후 삭제
4. 목록 페이지로 이동

---

## 🔧 다음 작업 (선택사항)

### 백엔드 추가 기능
- ⏸️ 이미지 업로드 서비스 (MultipartFile)
  - 파일 저장 (로컬 또는 S3)
  - 썸네일 생성
  - 이미지 URL 반환
- ⏸️ 주변 레스토랑 검색 (위도/경도 기반)
- ⏸️ 레스토랑 좋아요 기능
- ⏸️ 레스토랑 북마크 기능

### 프론트엔드 추가 기능
- ⏸️ 카카오 맵 연동
  - 주소 검색
  - 지도 표시
  - 마커 표시
- ⏸️ 이미지 업로드 UI
  - 드래그 앤 드롭
  - 미리보기
  - 다중 이미지 업로드
- ⏸️ 무한 스크롤
- ⏸️ 레스토랑 카드 애니메이션
- ⏸️ 필터 고급 옵션 (가격대 슬라이더, 평점 필터)

---

## 📊 Phase 3 상태

**백엔드**: ✅ **100% 완료**
**프론트엔드**: ✅ **100% 완료**
**전체 진행률**: ✅ **100% 완료**

---

## 📝 참고사항

1. **MyBatis 동적 쿼리**: `<if>` 태그를 사용한 동적 WHERE 절
2. **LEFT JOIN**: 리뷰 통계를 위한 users, reviews 테이블 조인
3. **권한 체크**:
   - Spring Security의 `@PreAuthorize` 사용
   - Service 레이어에서 소유자 확인 (`isOwnedBy`)
4. **페이징**:
   - LIMIT/OFFSET 사용
   - 전체 개수와 총 페이지 수 계산
5. **상태 관리**:
   - ACTIVE: 활성 레스토랑
   - INACTIVE: 비활성 레스토랑
   - DELETED: 삭제된 레스토랑 (soft delete 옵션)

---

## 🎯 Phase 3 완료 체크리스트

### 백엔드
- ✅ Restaurant 엔티티 및 DTO 구현
- ✅ RestaurantRepository (MyBatis Mapper) 구현
- ✅ RestaurantService 비즈니스 로직 구현
- ✅ RestaurantController REST API 구현
- ✅ Swagger 문서화
- ✅ 권한 체크 구현
- ✅ 트랜잭션 관리

### 프론트엔드
- ✅ API 클라이언트 구현
- ✅ 레스토랑 목록 페이지 (검색/필터링)
- ✅ 레스토랑 상세 페이지
- ✅ 레스토랑 등록/수정 폼
- ✅ 권한별 UI 표시
- ✅ 에러 처리
- ✅ 로딩 상태 관리

---

**작성일**: 2025-10-22
**최종 업데이트**: 2025-10-22
**Phase 3 완료일**: 2025-10-22

**다음 단계**: Phase 4 - 리뷰 시스템 마이그레이션
