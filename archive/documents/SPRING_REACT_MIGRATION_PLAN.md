# MeetLog Spring Boot + React 마이그레이션 계획

## 📌 프로젝트 개요

**목표**: 기존 JSP/Servlet + MyBatis 애플리케이션을 Spring Boot + React 기반 모던 아키텍처로 전환

**마이그레이션 전략**: 점진적 마이그레이션 (Strangler Fig Pattern)
- 기존 시스템 유지하며 단계별 전환
- API 우선 개발 후 프론트엔드 교체
- 도메인별 순차 마이그레이션

---

## 🎯 Phase 1: 프로젝트 기반 구축 (1-2주)

### 1.1 Spring Boot 프로젝트 초기 설정

**우선순위**: ⭐⭐⭐ (최우선)

#### 작업 목록
1. **Spring Boot 프로젝트 생성**
   ```bash
   # Spring Initializr 사용
   - Java: 11
   - Build Tool: Maven
   - Spring Boot: 2.7.18 (Java 11 호환 최신 LTS)
   - Packaging: JAR
   ```

2. **의존성 설정**
   - Spring Web (REST API)
   - MyBatis Spring Boot Starter
   - MariaDB Driver
   - Lombok
   - Spring Validation
   - Spring Security (JWT)
   - SpringDoc OpenAPI (API 문서)

3. **프로젝트 구조 생성**
   ```
   MeetLog-SpringBoot/
   ├── src/main/java/com/meetlog/
   │   ├── MeetLogApplication.java
   │   ├── config/              # 설정 클래스
   │   ├── controller/          # REST Controllers
   │   ├── service/             # 비즈니스 로직
   │   ├── repository/          # Data Access
   │   ├── model/               # Entity
   │   ├── dto/                 # DTO
   │   ├── exception/           # 예외 처리
   │   ├── security/            # 인증/권한
   │   └── util/                # 유틸리티
   ├── src/main/resources/
   │   ├── application.yml
   │   ├── application-dev.yml
   │   ├── application-prod.yml
   │   ├── mybatis-config.xml
   │   └── mappers/
   └── pom.xml
   ```

4. **application.yml 기본 설정**
   - 데이터베이스 연결
   - MyBatis 설정
   - 파일 업로드 설정
   - 로깅 설정
   - CORS 설정

#### 검증 기준
- [ ] Spring Boot 애플리케이션 정상 실행
- [ ] 데이터베이스 연결 성공
- [ ] Swagger UI 접근 가능 (`/swagger-ui.html`)
- [ ] Health Check 엔드포인트 동작 (`/actuator/health`)

---

### 1.2 React 프로젝트 초기 설정

**우선순위**: ⭐⭐⭐ (최우선)

#### 작업 목록
1. **React 프로젝트 생성**
   ```bash
   npx create-react-app meetlog-frontend
   cd meetlog-frontend
   ```

2. **핵심 패키지 설치**
   ```bash
   npm install react-router-dom@6
   npm install axios
   npm install @tanstack/react-query
   npm install zustand  # 상태 관리 (선택)
   ```

3. **Tailwind CSS 설정**
   ```bash
   npm install -D tailwindcss postcss autoprefixer
   npx tailwindcss init -p
   ```

4. **프로젝트 구조 생성**
   ```
   meetlog-frontend/
   ├── public/
   ├── src/
   │   ├── api/              # API 클라이언트
   │   ├── components/       # 재사용 컴포넌트
   │   │   ├── common/
   │   │   ├── layout/
   │   │   ├── restaurant/
   │   │   └── course/
   │   ├── pages/            # 페이지 컴포넌트
   │   ├── hooks/            # Custom Hooks
   │   ├── context/          # Context API
   │   ├── utils/            # 유틸리티
   │   ├── styles/           # CSS
   │   ├── App.jsx
   │   └── index.js
   ├── .env.development
   ├── .env.production
   └── package.json
   ```

5. **환경 변수 설정**
   ```
   # .env.development
   REACT_APP_API_URL=http://localhost:8080/api
   ```

6. **Axios 클라이언트 구성**
   - BaseURL 설정
   - 인터셉터 구성 (토큰, 에러 처리)
   - API 함수 모듈화

#### 검증 기준
- [ ] React 개발 서버 정상 실행 (`npm start`)
- [ ] Tailwind CSS 적용 확인
- [ ] React Router 라우팅 동작
- [ ] API 클라이언트 통신 테스트

---

## 🔧 Phase 2: 인증/권한 시스템 구축 (2주)

**우선순위**: ⭐⭐⭐ (최우선)
**이유**: 모든 기능의 기반이 되는 시스템

### 2.1 백엔드 인증 시스템

#### 작업 목록
1. **JWT 기반 인증 구현**
   - JWT 토큰 생성/검증 유틸리티
   - JwtAuthenticationFilter 구현
   - SecurityConfig 설정

2. **사용자 인증 API**
   - `POST /api/auth/login` - 로그인
   - `POST /api/auth/register` - 회원가입
   - `POST /api/auth/refresh` - 토큰 갱신
   - `POST /api/auth/logout` - 로그아웃
   - `GET /api/auth/me` - 현재 사용자 정보

3. **소셜 로그인 통합**
   - 카카오 로그인 OAuth 연동
   - 네이버 로그인 OAuth 연동
   - 구글 로그인 OAuth 연동

4. **권한 관리**
   - Role 기반 접근 제어 (ROLE_USER, ROLE_BUSINESS, ROLE_ADMIN)
   - 메서드 레벨 보안 (`@PreAuthorize`)

#### 변환 대상 코드
- `controller/LoginServlet.java`
- `service/AuthService.java`
- `util/GoogleLoginBO.java`
- `util/NaverLoginBO.java`
- `util/KakaoLoginBO.java`
- `filter/AuthenticationFilter.java`

#### 검증 기준
- [ ] 로그인 성공 시 JWT 토큰 발급
- [ ] 토큰 검증 및 사용자 인증 성공
- [ ] 소셜 로그인 OAuth 플로우 동작
- [ ] 권한별 API 접근 제어 확인

---

### 2.2 프론트엔드 인증 시스템

#### 작업 목록
1. **AuthContext 구현**
   - 사용자 상태 관리
   - 로그인/로그아웃 함수
   - 토큰 저장/관리

2. **로그인 페이지 구현**
   - 일반 로그인 폼
   - 소셜 로그인 버튼
   - 폼 검증

3. **회원가입 페이지 구현**
   - 사용자/비즈니스 회원 구분
   - 입력 검증
   - 중복 확인

4. **보호 라우트 구현**
   - PrivateRoute 컴포넌트
   - 권한별 리다이렉트

5. **Axios 인터셉터 통합**
   - 요청 시 토큰 자동 추가
   - 401 에러 시 자동 로그아웃

#### 변환 대상 JSP
- `login.jsp`
- `register.jsp`
- `idpwsearch.jsp`

#### 검증 기준
- [ ] 로그인 성공 후 토큰 저장
- [ ] 보호된 페이지 접근 제어
- [ ] 토큰 만료 시 자동 로그아웃
- [ ] 소셜 로그인 리다이렉트 처리

---

## 🍽️ Phase 3: 레스토랑 도메인 마이그레이션 (3주)

**우선순위**: ⭐⭐⭐ (최우선)
**이유**: 핵심 도메인

### 3.1 백엔드 레스토랑 API

#### 작업 목록
1. **Restaurant 엔티티 및 DTO**
   - Restaurant 모델 클래스
   - RestaurantDto, CreateRestaurantRequest, UpdateRestaurantRequest
   - MapStruct 또는 ModelMapper 설정

2. **RestaurantRepository**
   - MyBatis Mapper 연동
   - 기존 Mapper XML 재사용 또는 리팩토링

3. **RestaurantService**
   - CRUD 비즈니스 로직
   - 검색/필터링 로직
   - 이미지 업로드 처리
   - 트랜잭션 관리

4. **RestaurantController**
   - `GET /api/restaurants` - 목록 조회 (페이징, 필터링)
   - `GET /api/restaurants/{id}` - 상세 조회
   - `POST /api/restaurants` - 생성 (비즈니스 회원)
   - `PUT /api/restaurants/{id}` - 수정
   - `DELETE /api/restaurants/{id}` - 삭제
   - `GET /api/restaurants/search` - 고급 검색
   - `GET /api/restaurants/nearby` - 주변 검색

5. **이미지 처리**
   - MultipartFile 업로드
   - 파일 저장 서비스
   - 썸네일 생성 (선택)

#### 변환 대상 코드
- `controller/RestaurantServlet.java`
- `service/RestaurantService.java`
- `dao/RestaurantDAO.java`
- `model/Restaurant.java`

#### API 명세서 (Swagger)
모든 엔드포인트에 대한 자동 문서 생성

#### 검증 기준
- [ ] CRUD API 모두 정상 동작
- [ ] 페이징 및 정렬 기능
- [ ] 검색 필터링 (카테고리, 지역, 가격대)
- [ ] 이미지 업로드 및 조회
- [ ] Swagger UI에서 API 테스트 가능

---

### 3.2 프론트엔드 레스토랑 기능

#### 작업 목록
1. **API 클라이언트**
   - `src/api/restaurants.js` 구현
   - React Query hooks 구성

2. **레스토랑 목록 페이지**
   - 그리드 레이아웃
   - 필터링 UI (카테고리, 지역, 가격)
   - 페이지네이션
   - 검색 기능

3. **레스토랑 상세 페이지**
   - 이미지 갤러리
   - 정보 표시
   - 리뷰 목록
   - 예약 버튼

4. **레스토랑 등록/수정 페이지** (비즈니스 회원)
   - 다단계 폼
   - 이미지 업로드
   - 카카오 맵 연동 (주소 검색)
   - 영업시간 설정

5. **검색 페이지**
   - 고급 검색 폼
   - 지도 뷰 (카카오 맵)
   - 리스트 뷰

#### 변환 대상 JSP
- `restaurant-list.jsp`
- `restaurant-detail.jsp`
- `add-restaurant.jsp`
- `advanced-search.jsp`
- `search-map.jsp`

#### 검증 기준
- [ ] 목록 조회 및 필터링 동작
- [ ] 상세 페이지 정보 표시
- [ ] 레스토랑 등록 폼 제출 성공
- [ ] 이미지 업로드 및 미리보기
- [ ] 카카오 맵 연동 정상 동작

---

## 📝 Phase 4: 리뷰 시스템 마이그레이션 (2주)

**우선순위**: ⭐⭐

### 4.1 백엔드 리뷰 API

#### 작업 목록
1. **Review 엔티티 및 DTO**
   - Review, ReviewComment 모델
   - DTO 설계

2. **ReviewService**
   - 리뷰 CRUD
   - 댓글 관리
   - 좋아요 기능
   - 신고 기능
   - 키워드 추출 (JSON 처리)

3. **ReviewController**
   - `GET /api/reviews` - 목록 (레스토랑별, 사용자별)
   - `POST /api/reviews` - 작성
   - `PUT /api/reviews/{id}` - 수정
   - `DELETE /api/reviews/{id}` - 삭제
   - `POST /api/reviews/{id}/like` - 좋아요
   - `POST /api/reviews/{id}/comments` - 댓글 작성
   - `POST /api/reviews/{id}/report` - 신고

#### 변환 대상 코드
- `controller/ReviewServlet.java`
- `service/ReviewService.java`
- `dao/ReviewDAO.java`

#### 검증 기준
- [ ] 리뷰 CRUD 정상 동작
- [ ] 별점 및 키워드 저장
- [ ] 댓글 작성/조회
- [ ] 좋아요 기능

---

### 4.2 프론트엔드 리뷰 기능

#### 작업 목록
1. **리뷰 작성 컴포넌트**
   - 별점 UI
   - 키워드 선택
   - 이미지 업로드
   - 텍스트 에디터

2. **리뷰 목록 컴포넌트**
   - 리뷰 카드
   - 댓글 표시
   - 좋아요 버튼
   - 신고 기능

3. **내 리뷰 관리 페이지**
   - 작성한 리뷰 목록
   - 수정/삭제

#### 변환 대상 JSP
- `review-list.jsp`
- `my-reviews.jsp`
- `edit-review.jsp`

#### 검증 기준
- [ ] 리뷰 작성 및 제출
- [ ] 이미지 업로드
- [ ] 댓글 인터랙션
- [ ] 실시간 좋아요 업데이트

---

## 🗓️ Phase 5: 예약 시스템 마이그레이션 (3주)

**우선순위**: ⭐⭐⭐ (최우선)
**이유**: 비즈니스 핵심 기능

### 5.1 백엔드 예약 API

#### 작업 목록
1. **Reservation 엔티티 및 상태 관리**
   - Reservation 모델
   - ReservationStatus enum (PENDING, CONFIRMED, CANCELLED 등)
   - ReservationTable 연동

2. **ReservationService**
   - 예약 생성 (가용성 체크)
   - 예약 조회 (사용자별, 레스토랑별)
   - 예약 승인/거부 (비즈니스)
   - 예약 취소
   - 블랙아웃 데이트 체크
   - 테이블 자동 배정

3. **ReservationController**
   - `POST /api/reservations` - 예약 생성
   - `GET /api/reservations` - 예약 목록
   - `GET /api/reservations/{id}` - 예약 상세
   - `PATCH /api/reservations/{id}/confirm` - 승인 (비즈니스)
   - `PATCH /api/reservations/{id}/cancel` - 취소
   - `GET /api/reservations/availability` - 가용 시간 조회

4. **알림 통합**
   - 예약 확정 시 이메일 발송
   - 예약 변경 시 알림

#### 변환 대상 코드
- `controller/ReservationServlet.java`
- `service/ReservationAutomationService.java`
- `dao/ReservationDAO.java`

#### 검증 기준
- [ ] 예약 생성 및 가용성 체크
- [ ] 예약 승인/거부 플로우
- [ ] 이메일 알림 발송
- [ ] 테이블 배정 로직

---

### 5.2 프론트엔드 예약 기능

#### 작업 목록
1. **예약 생성 페이지**
   - 날짜/시간 선택 (캘린더 UI)
   - 인원 수 선택
   - 가용 시간 표시
   - 요청 사항 입력

2. **내 예약 목록 페이지**
   - 예약 카드 (상태별 필터)
   - 예약 취소 기능
   - 예약 상세 모달

3. **예약 관리 페이지** (비즈니스)
   - 예약 요청 목록
   - 승인/거부 버튼
   - 테이블 배정 UI
   - 예약 통계

#### 변환 대상 JSP
- `create-reservation.jsp`
- `my-reservations.jsp`
- `business-reservation-management.jsp`
- `reservation-detail.jsp`

#### 검증 기준
- [ ] 예약 생성 플로우 완료
- [ ] 실시간 가용 시간 조회
- [ ] 예약 상태 업데이트
- [ ] 비즈니스 승인 처리

---

## 🛣️ Phase 6: 코스 시스템 마이그레이션 (3주)

**우선순위**: ⭐⭐

### 6.1 백엔드 코스 API

#### 작업 목록
1. **Course 엔티티**
   - Course, CourseStep 모델
   - Tag 연관 관계

2. **CourseService**
   - 코스 CRUD
   - 태그 관리
   - 코스 스텝 관리
   - AI 추천 통합

3. **CourseController**
   - `GET /api/courses` - 코스 목록
   - `POST /api/courses` - 코스 생성
   - `GET /api/courses/{id}` - 코스 상세
   - `PUT /api/courses/{id}` - 코스 수정
   - `DELETE /api/courses/{id}` - 코스 삭제

#### 변환 대상 코드
- `controller/CourseServlet.java`
- `service/CourseService.java`
- `dao/CommunityCourseDAO.java`

#### 검증 기준
- [ ] 코스 CRUD 동작
- [ ] 다단계 스텝 저장
- [ ] 태그 연동

---

### 6.2 프론트엔드 코스 기능

#### 작업 목록
1. **코스 생성 페이지**
   - 다단계 폼
   - 지도 연동 (경로 표시)
   - 이미지 업로드

2. **코스 목록 페이지**
   - 그리드 레이아웃
   - 태그 필터링

3. **코스 상세 페이지**
   - 스텝별 정보
   - 지도 경로 표시
   - 예약 버튼

#### 변환 대상 JSP
- `create-course.jsp`
- `course-list.jsp`
- `course-detail.jsp`

#### 검증 기준
- [ ] 코스 생성 완료
- [ ] 지도 경로 표시
- [ ] 스텝 순서 관리

---

## 💳 Phase 7: 결제 시스템 마이그레이션 (2주)

**우선순위**: ⭐⭐⭐

### 7.1 백엔드 결제 API

#### 작업 목록
1. **PaymentService**
   - 카카오페이 연동
   - 네이버페이 연동
   - 결제 준비/승인/취소

2. **PaymentController**
   - `POST /api/payments/prepare` - 결제 준비
   - `POST /api/payments/approve` - 결제 승인
   - `POST /api/payments/cancel` - 결제 취소

#### 변환 대상 코드
- `service/payment/KakaoPayService.java`
- `service/payment/NaverPayService.java`
- `controller/payment/*`

#### 검증 기준
- [ ] 카카오페이 결제 플로우
- [ ] 네이버페이 결제 플로우
- [ ] 결제 취소 처리

---

### 7.2 프론트엔드 결제 기능

#### 작업 목록
1. **결제 페이지**
   - 결제 수단 선택
   - 결제 정보 표시
   - PG사 리다이렉트

2. **결제 결과 페이지**
   - 성공/실패 표시
   - 예약 정보 연동

#### 변환 대상 JSP
- `payment-methods.jsp`
- `payment-result.jsp`

#### 검증 기준
- [ ] 결제 창 리다이렉트
- [ ] 결제 완료 콜백 처리
- [ ] 실패 시 재시도

---

## 👨‍💼 Phase 8: 관리자/비즈니스 대시보드 (3주)

**우선순위**: ⭐⭐

### 8.1 백엔드 관리자 API

#### 작업 목록
1. **AdminController**
   - 회원 관리 API
   - 레스토랑 관리 API
   - 통계 API
   - 신고 관리 API

2. **BusinessController**
   - 대시보드 통계 API
   - 예약 관리 API
   - 리뷰 관리 API
   - 메뉴 관리 API

#### 변환 대상 코드
- `controller/Admin*Servlet.java`
- `controller/Business*Servlet.java`
- `service/AdminService.java`

#### 검증 기준
- [ ] 관리자 권한 체크
- [ ] 통계 데이터 조회
- [ ] 회원 관리 기능

---

### 8.2 프론트엔드 대시보드

#### 작업 목록
1. **관리자 대시보드**
   - 통계 차트 (Chart.js)
   - 회원 목록
   - 신고 관리

2. **비즈니스 대시보드**
   - 예약 캘린더
   - 매출 통계
   - 리뷰 관리

#### 변환 대상 JSP
- `admin-dashboard.jsp`
- `business-dashboard.jsp`
- `admin-member-management.jsp`

#### 검증 기준
- [ ] 대시보드 차트 표시
- [ ] 관리 기능 동작
- [ ] 권한별 접근 제어

---

## 🔔 Phase 9: 알림/소셜 기능 마이그레이션 (2주)

**우선순위**: ⭐

### 9.1 백엔드 알림 API

#### 작업 목록
1. **NotificationService**
   - 이메일 알림
   - 텔레그램 알림
   - 웹 푸시 알림 (선택)

2. **SocialController**
   - 팔로우/언팔로우 API
   - 피드 API
   - 좋아요 API

#### 변환 대상 코드
- `service/NotificationService.java`
- `service/TelegramService.java`
- `controller/FollowServlet.java`

#### 검증 기준
- [ ] 이메일 발송 성공
- [ ] 텔레그램 메시지 발송
- [ ] 팔로우 기능 동작

---

### 9.2 프론트엔드 알림/소셜

#### 작업 목록
1. **알림 센터**
   - 알림 목록
   - 읽음 처리
   - 실시간 업데이트 (WebSocket 선택)

2. **피드 페이지**
   - 팔로우한 사용자 활동
   - 무한 스크롤

#### 변환 대상 JSP
- `notifications.jsp`
- `feed.jsp`
- `follow-list.jsp`

#### 검증 기준
- [ ] 알림 표시
- [ ] 피드 조회
- [ ] 팔로우 인터랙션

---

## 🚀 Phase 10: 배포 및 최적화 (2주)

**우선순위**: ⭐⭐⭐

### 10.1 프로덕션 빌드

#### 작업 목록
1. **Spring Boot 프로덕션 설정**
   - 환경 변수 분리
   - 로깅 최적화
   - 캐싱 전략

2. **React 프로덕션 빌드**
   - 코드 스플리팅
   - 번들 최적화
   - 환경 변수 관리

3. **통합 배포**
   - Spring Boot에서 React 빌드 서빙
   - Maven 플러그인 설정
   - Docker 이미지 생성 (선택)

#### 검증 기준
- [ ] 프로덕션 빌드 성공
- [ ] 성능 최적화 확인
- [ ] 배포 스크립트 동작

---

### 10.2 성능 최적화

#### 작업 목록
1. **백엔드 최적화**
   - DB 쿼리 최적화
   - 캐싱 (Redis 선택)
   - API 응답 압축

2. **프론트엔드 최적화**
   - 이미지 최적화 (lazy loading)
   - 코드 스플리팅
   - 캐싱 전략

#### 검증 기준
- [ ] Lighthouse 스코어 80 이상
- [ ] API 응답 시간 < 500ms
- [ ] 번들 크기 최적화

---

## 📊 전체 타임라인

```
┌─────────────────────────────────────────────────────────────────┐
│                     마이그레이션 타임라인                          │
└─────────────────────────────────────────────────────────────────┘

Week 1-2   : Phase 1 - 프로젝트 기반 구축
             ├─ Spring Boot 초기 설정
             └─ React 초기 설정

Week 3-4   : Phase 2 - 인증/권한 시스템
             ├─ JWT 인증 구현
             └─ 소셜 로그인 연동

Week 5-7   : Phase 3 - 레스토랑 도메인
             ├─ 레스토랑 API 구현
             └─ 레스토랑 UI 구현

Week 8-9   : Phase 4 - 리뷰 시스템
             ├─ 리뷰 API 구현
             └─ 리뷰 UI 구현

Week 10-12 : Phase 5 - 예약 시스템
             ├─ 예약 API 구현
             ├─ 예약 UI 구현
             └─ 결제 연동

Week 13-15 : Phase 6 - 코스 시스템
             ├─ 코스 API 구현
             └─ 코스 UI 구현

Week 16-17 : Phase 7 - 결제 시스템
             ├─ 카카오/네이버페이 연동
             └─ 결제 UI 구현

Week 18-20 : Phase 8 - 관리자/비즈니스
             ├─ 관리자 대시보드
             └─ 비즈니스 대시보드

Week 21-22 : Phase 9 - 알림/소셜
             ├─ 알림 시스템
             └─ 소셜 기능

Week 23-24 : Phase 10 - 배포/최적화
             ├─ 프로덕션 빌드
             ├─ 성능 최적화
             └─ 최종 테스트
```

**총 예상 기간**: 약 6개월 (24주)

---

## 🎯 우선순위별 작업 순서

### 최우선 (⭐⭐⭐)
1. **Phase 1**: 프로젝트 기반 구축 → 모든 작업의 기반
2. **Phase 2**: 인증/권한 시스템 → 모든 기능의 전제 조건
3. **Phase 3**: 레스토랑 도메인 → 핵심 비즈니스 로직
4. **Phase 5**: 예약 시스템 → 수익 모델의 핵심
5. **Phase 7**: 결제 시스템 → 수익 실현
6. **Phase 10**: 배포/최적화 → 실제 운영 준비

### 중요 (⭐⭐)
7. **Phase 4**: 리뷰 시스템 → 사용자 경험 중요
8. **Phase 6**: 코스 시스템 → 차별화 기능
9. **Phase 8**: 관리자/비즈니스 대시보드 → 운영 효율

### 일반 (⭐)
10. **Phase 9**: 알림/소셜 기능 → 부가 기능

---

## 📝 체크리스트

### 프로젝트 시작 전
- [ ] 팀 구성 및 역할 분담
- [ ] 개발 환경 준비 (IDE, Node.js, Java, DB)
- [ ] Git 브랜치 전략 수립
- [ ] 코드 리뷰 프로세스 정의
- [ ] 이슈 트래킹 시스템 준비 (GitHub Issues/Jira)

### 각 Phase 완료 후
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 수행
- [ ] API 문서 업데이트
- [ ] 코드 리뷰 완료
- [ ] 배포 스크립트 업데이트

### 최종 완료 전
- [ ] 전체 시스템 통합 테스트
- [ ] 성능 테스트 (부하 테스트)
- [ ] 보안 검토
- [ ] 사용자 매뉴얼 작성
- [ ] 데이터 마이그레이션 계획 수립

---

## 🛠️ 기술 스택 요약

### 백엔드
- **Framework**: Spring Boot 2.7.18
- **Language**: Java 11
- **ORM**: MyBatis 3.5
- **Database**: MariaDB 10.x
- **Security**: Spring Security + JWT
- **API Docs**: SpringDoc OpenAPI (Swagger)
- **Build Tool**: Maven

### 프론트엔드
- **Framework**: React 18
- **Language**: JavaScript (ES6+)
- **Routing**: React Router v6
- **State Management**: React Query + Context API / Zustand
- **HTTP Client**: Axios
- **Styling**: Tailwind CSS
- **Build Tool**: Create React App / Vite (선택)

### DevOps
- **Version Control**: Git
- **CI/CD**: GitHub Actions
- **Container**: Docker (선택)
- **Monitoring**: Spring Actuator + Prometheus (선택)

---

## 📚 참고 자료

### Spring Boot
- [Spring Boot 공식 문서](https://spring.io/projects/spring-boot)
- [MyBatis Spring Boot Starter](https://mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure/)
- [Spring Security JWT](https://spring.io/guides/tutorials/spring-boot-oauth2/)

### React
- [React 공식 문서](https://react.dev/)
- [React Router](https://reactrouter.com/)
- [TanStack Query (React Query)](https://tanstack.com/query/latest)
- [Tailwind CSS](https://tailwindcss.com/)

### 마이그레이션 패턴
- [Strangler Fig Pattern](https://martinfowler.com/bliki/StranglerFigApplication.html)
- [API First Design](https://swagger.io/resources/articles/adopting-an-api-first-approach/)

---

## 🔄 롤백 전략

각 Phase 완료 시 태그를 생성하여 문제 발생 시 롤백 가능하도록 준비

```bash
# Phase 완료 시
git tag -a phase-1-complete -m "Phase 1: 프로젝트 기반 구축 완료"
git push origin phase-1-complete

# 롤백이 필요한 경우
git checkout phase-1-complete
```

---

## 📞 문의 및 이슈

- **프로젝트 관리**: GitHub Issues 활용
- **긴급 이슈**: Slack 채널 운영
- **주간 회의**: 매주 월요일 10:00 (진행 상황 공유)

---

**문서 버전**: 1.0
**최종 수정일**: 2025-10-22
**작성자**: Claude Code
