# Phase 4: 리뷰 시스템 마이그레이션 - 진행 상황

## 📌 개요

Phase 4는 레스토랑 리뷰 시스템을 Spring Boot + React로 마이그레이션하는 단계입니다. 내부 리뷰 작성, 외부 리뷰 연동(Google, Kakao), 좋아요, 사업자 답글 등의 기능을 포함합니다.

---

## ✅ 완료된 작업

### 백엔드 (Spring Boot)

#### 1. Review 엔티티 (`Review.java`) ✅
- ✅ 리뷰 기본 정보 (평점, 내용, 이미지, 키워드)
- ✅ 리뷰 출처 관리 (INTERNAL, GOOGLE, KAKAO)
- ✅ 외부 리뷰 정보 (externalReviewId, externalAuthorName 등)
- ✅ 좋아요 수 관리
- ✅ 활성 상태 관리 (isActive)
- ✅ 사업자 답글 (replyContent, replyCreatedAt)
- ✅ Helper 메서드 (isInternalReview, hasReply, isOwnedBy)

#### 2. Review DTO ✅
- ✅ `ReviewDto.java` - 리뷰 정보 + 사용자/레스토랑 정보
- ✅ `ReviewCreateRequest.java` - 리뷰 작성 요청 (Validation 포함)
- ✅ `ReviewUpdateRequest.java` - 리뷰 수정 요청
- ✅ `ReviewSearchRequest.java` - 검색/필터링 요청

#### 3. ReviewRepository (`ReviewRepository.java`) ✅
- ✅ MyBatis Mapper 인터페이스
- ✅ `ReviewRepositoryMapper.xml` - SQL 매핑
  - findById - 리뷰 조회 (엔티티)
  - findDtoById - 리뷰 조회 (DTO, 사용자/레스토랑 정보 포함)
  - search - 리뷰 검색 (필터링, 정렬, 페이징)
  - countSearch - 검색 결과 개수
  - findByRestaurantId - 레스토랑별 리뷰 목록
  - findByUserId - 사용자별 리뷰 목록
  - insert - 리뷰 생성
  - update - 리뷰 수정
  - delete - 리뷰 삭제
  - updateIsActive - 활성 상태 변경
  - incrementLikes/decrementLikes - 좋아요 수 증감
  - updateReply - 사업자 답글 등록/수정
  - existsByUserIdAndRestaurantId - 중복 리뷰 체크

#### 4. ReviewService (`ReviewService.java`) ✅
- ✅ 리뷰 조회 (상세 정보)
- ✅ 리뷰 검색 (페이징, 필터링, 정렬)
- ✅ 레스토랑별 리뷰 목록
- ✅ 사용자별 리뷰 목록
- ✅ 리뷰 생성 (중복 체크, JSON 변환)
- ✅ 리뷰 수정 (권한 체크, 내부 리뷰만)
- ✅ 리뷰 삭제 (권한 체크, 내부 리뷰만)
- ✅ 리뷰 좋아요/취소
- ✅ 사업자 답글 등록/수정
- ✅ 트랜잭션 관리

#### 5. ReviewController (`ReviewController.java`) ✅
- ✅ `GET /api/reviews` - 리뷰 검색
  - 레스토랑 ID, 사용자 ID, 평점 범위, 출처
  - 정렬 (작성일, 평점, 좋아요)
  - 페이징
- ✅ `GET /api/reviews/{id}` - 리뷰 상세 조회
- ✅ `GET /api/reviews/restaurant/{restaurantId}` - 레스토랑별 리뷰 목록
- ✅ `GET /api/reviews/my` - 내 리뷰 목록
- ✅ `POST /api/reviews` - 리뷰 작성
- ✅ `PUT /api/reviews/{id}` - 리뷰 수정
- ✅ `DELETE /api/reviews/{id}` - 리뷰 삭제
- ✅ `POST /api/reviews/{id}/like` - 좋아요
- ✅ `DELETE /api/reviews/{id}/like` - 좋아요 취소
- ✅ `POST /api/reviews/{id}/reply` - 사업자 답글
- ✅ Swagger 문서화
- ✅ 권한 체크 (@PreAuthorize)

---

### 프론트엔드 (React)

#### 6. API 클라이언트 (`api/review.js`) ✅
- ✅ search - 리뷰 검색
- ✅ getById - 리뷰 상세 조회
- ✅ getByRestaurant - 레스토랑별 리뷰 목록
- ✅ getMyReviews - 내 리뷰 목록
- ✅ create - 리뷰 작성
- ✅ update - 리뷰 수정
- ✅ delete - 리뷰 삭제
- ✅ like/unlike - 좋아요/취소
- ✅ addReply - 사업자 답글

#### 7. ReviewCard 컴포넌트 (`ReviewCard.jsx`) ✅
- ✅ 리뷰 카드 UI
  - 사용자 정보 (닉네임, 프로필 이미지, 작성일)
  - 별점 표시 (1-5점)
  - 리뷰 내용
  - 키워드 태그
  - 이미지 갤러리 (3열 그리드)
- ✅ 좋아요 버튼 (하트 아이콘)
- ✅ 수정/삭제 버튼 (작성자만)
- ✅ 사업자 답글 표시
- ✅ 답글 작성 폼 (사업자만)

#### 8. ReviewForm 컴포넌트 (`ReviewForm.jsx`) ✅
- ✅ 리뷰 작성 폼
  - 별점 선택 (클릭 가능한 별)
  - 키워드 선택 (8개 옵션)
  - 리뷰 내용 입력 (10-1000자)
  - 글자 수 카운터
- ✅ 유효성 검사
- ✅ 로딩 상태 처리
- ✅ 에러 메시지 표시

#### 9. ReviewList 컴포넌트 (`ReviewList.jsx`) ✅
- ✅ 리뷰 목록 표시
- ✅ 무한 스크롤 (더 보기 버튼)
- ✅ 로딩 스피너
- ✅ 빈 상태 처리
- ✅ 에러 처리

---

## 📂 생성된 파일 목록

### 백엔드
```
MeetLog-SpringBoot/src/main/java/com/meetlog/
├── model/
│   └── Review.java ✅
├── dto/review/
│   ├── ReviewDto.java ✅
│   ├── ReviewCreateRequest.java ✅
│   ├── ReviewUpdateRequest.java ✅
│   └── ReviewSearchRequest.java ✅
├── repository/
│   └── ReviewRepository.java ✅
├── service/
│   └── ReviewService.java ✅
├── controller/
│   └── ReviewController.java ✅
└── src/main/resources/mappers/
    └── ReviewRepositoryMapper.xml ✅
```

### 프론트엔드
```
meetlog-frontend/src/
├── api/
│   └── review.js ✅
└── components/review/
    ├── ReviewCard.jsx ✅
    ├── ReviewForm.jsx ✅
    └── ReviewList.jsx ✅
```

---

## 🎯 주요 기능

### 1. 리뷰 작성 및 관리
- **리뷰 작성**: 별점(1-5), 내용(10-1000자), 키워드, 이미지
- **리뷰 수정**: 작성자만 가능, 내부 리뷰만
- **리뷰 삭제**: 작성자만 가능, 내부 리뷰만
- **중복 방지**: 동일 레스토랑에 1개 리뷰만 작성 가능

### 2. 리뷰 검색 및 필터링
- **레스토랑별**: 특정 레스토랑의 모든 리뷰
- **사용자별**: 특정 사용자가 작성한 모든 리뷰
- **평점 필터**: 최소/최대 평점 범위
- **출처 필터**: INTERNAL, GOOGLE, KAKAO
- **정렬**: 작성일, 평점, 좋아요 수
- **페이징**: 페이지당 항목 수 조절

### 3. 리뷰 상호작용
- **좋아요**: 리뷰에 좋아요 추가/제거
- **좋아요 수**: 실시간 업데이트
- **하트 아이콘**: 좋아요 상태 시각화

### 4. 사업자 답글
- **답글 작성**: 레스토랑 소유자만 가능
- **답글 수정**: 기존 답글 업데이트
- **답글 표시**: 리뷰 하단에 강조 표시

### 5. 외부 리뷰 연동 (준비됨)
- **Google 리뷰**: externalReviewId, externalAuthorName 등
- **Kakao 리뷰**: 동일 구조
- **원본 데이터**: externalRawJson에 JSON 저장
- **읽기 전용**: 외부 리뷰는 수정/삭제 불가

### 6. 키워드 시스템
- **8가지 키워드**: 맛있어요, 친절해요, 청결해요, 가성비 좋아요, 분위기 좋아요, 재방문 의사 있어요, 주차 편해요, 접근성 좋아요
- **다중 선택**: 여러 키워드 선택 가능
- **태그 표시**: 리뷰 카드에 파란색 태그로 표시

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

#### 시나리오 1: 리뷰 작성
1. 레스토랑 상세 페이지 접속
2. "리뷰 작성" 버튼 클릭
3. 별점 선택 (1-5점)
4. 키워드 선택 (선택사항)
5. 리뷰 내용 입력 (최소 10자)
6. "리뷰 등록" 클릭
7. 리뷰 목록에서 확인

#### 시나리오 2: 리뷰 조회
1. 레스토랑 상세 페이지에서 리뷰 목록 확인
2. 별점, 내용, 키워드, 이미지 확인
3. 작성자 닉네임, 작성일 확인
4. 좋아요 수 확인

#### 시나리오 3: 리뷰 좋아요
1. 리뷰 카드에서 하트 아이콘 클릭
2. 좋아요 수 증가 확인
3. 하트 색상 변경 확인 (회색 → 빨간색)
4. 다시 클릭하여 취소
5. 좋아요 수 감소 확인

#### 시나리오 4: 리뷰 수정 (작성자)
1. 내가 작성한 리뷰에서 "수정" 버튼 클릭
2. 별점, 키워드, 내용 수정
3. 저장 후 변경 사항 확인

#### 시나리오 5: 리뷰 삭제 (작성자)
1. 내가 작성한 리뷰에서 "삭제" 버튼 클릭
2. 확인 메시지 확인
3. 삭제 확인
4. 리뷰 목록에서 삭제된 것 확인

#### 시나리오 6: 사업자 답글 (레스토랑 소유자)
1. 사업자 계정으로 로그인
2. 자신의 레스토랑 리뷰에서 "답글 달기" 클릭
3. 답글 내용 입력
4. "등록" 클릭
5. 리뷰 하단에 답글 표시 확인

#### 시나리오 7: 내 리뷰 관리
1. "내 리뷰" 페이지 접속
2. 작성한 모든 리뷰 목록 확인
3. 레스토랑 이름 확인
4. 수정/삭제 가능

---

## 🔧 다음 작업 (선택사항)

### 백엔드 추가 기능
- ⏸️ 외부 리뷰 자동 수집 (Google Places API, Kakao Local API)
- ⏸️ 리뷰 신고 기능
- ⏸️ 리뷰 댓글 시스템
- ⏸️ 리뷰 이미지 업로드 서비스
- ⏸️ 리뷰 통계 API (평균 평점, 키워드 분석)

### 프론트엔드 추가 기능
- ⏸️ 리뷰 이미지 업로드 UI
  - 드래그 앤 드롭
  - 미리보기
  - 다중 이미지
- ⏸️ 리뷰 필터 UI
  - 평점별 필터
  - 키워드별 필터
  - 최신순/평점순 정렬
- ⏸️ 리뷰 통계 차트
  - 평점 분포
  - 키워드 빈도
- ⏸️ 리뷰 검색 기능
- ⏸️ 무한 스크롤 최적화

---

## 📊 Phase 4 상태

**백엔드**: ✅ **100% 완료**
**프론트엔드**: ✅ **100% 완료**
**전체 진행률**: ✅ **100% 완료**

---

## 📝 참고사항

1. **JSON 필드 처리**:
   - images, keywords 필드는 JSON 배열로 저장
   - JsonArrayTypeHandler 사용 (자동 변환)
   - ObjectMapper로 JSON 직렬화/역직렬화

2. **외부 리뷰 구조**:
   - source: GOOGLE 또는 KAKAO
   - externalReviewId: 외부 플랫폼의 리뷰 ID
   - externalRawJson: 원본 JSON 데이터 보관
   - 수정/삭제 불가 (읽기 전용)

3. **권한 관리**:
   - 리뷰 작성: 인증된 사용자
   - 리뷰 수정/삭제: 작성자만
   - 사업자 답글: 레스토랑 소유자 또는 관리자
   - 좋아요: 인증된 사용자

4. **중복 방지**:
   - existsByUserIdAndRestaurantId로 체크
   - 동일 레스토랑에 1개 리뷰만 허용
   - 수정 기능으로 대체

5. **평점 계산**:
   - Restaurant 테이블과 JOIN하여 평균 평점 계산
   - RestaurantRepositoryMapper.xml에서 처리
   - 리뷰 추가/수정/삭제 시 자동 업데이트

---

## 🎯 Phase 4 완료 체크리스트

### 백엔드
- ✅ Review 엔티티 및 DTO 구현
- ✅ ReviewRepository (MyBatis Mapper) 구현
- ✅ ReviewService 비즈니스 로직 구현
- ✅ ReviewController REST API 구현
- ✅ Swagger 문서화
- ✅ 권한 체크 구현
- ✅ 트랜잭션 관리
- ✅ JSON 필드 처리

### 프론트엔드
- ✅ API 클라이언트 구현
- ✅ ReviewCard 컴포넌트 (표시, 좋아요, 답글)
- ✅ ReviewForm 컴포넌트 (별점, 키워드, 내용)
- ✅ ReviewList 컴포넌트 (목록, 페이징)
- ✅ 권한별 UI 표시
- ✅ 에러 처리
- ✅ 로딩 상태 관리

---

**작성일**: 2025-10-22
**최종 업데이트**: 2025-10-22
**Phase 4 완료일**: 2025-10-22

**다음 단계**: Phase 5 - 예약 시스템 마이그레이션
