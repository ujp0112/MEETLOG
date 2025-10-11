## ✅ Remaining Critical Work (최우선 미구현 목록)

- [ ] 결제 시스템 고도화: 예약금 외 일반 결제/쿠폰 결제 처리 미구현
      (쿠폰은 생성/발급 로직은 구현되어있는데 사용은 아직)
- [ ] 이메일 서비스 연동: 가입 인증, 비밀번호 찾기, 예약 안내 메일 없음
- [ ] 보안 취약점
  - [ ] `util/PasswordUtil` 테스트용 평문 비밀번호 허용 제거
  - [ ] CSRF 토큰 도입, HTTPS 강제 등 보안 강화 미적용
- [ ] 로깅/에러 처리 개선: `System.out.println`/`printStackTrace` 제거, SLF4J(Logback) 도입
- [ ] DEBUG 코드 제거: `controller/ColumnCommentServlet` 등 남은 디버깅 출력 정리
- [ ] 실시간 알림·SMS 알림 미구현 (알림 테이블만 존재) - (텔레그램으로 알림 가게?)
- [✔️] 예약 취소 시 사유 입력/저장 흐름 구현


---


  📊 프로젝트 완성도: 80-85%

  ✅ 완성된 핵심 기능

  1. 일반 사용자 (85% 완성)
    - 회원가입/로그인, 프로필 관리
    - 맛집 검색/상세보기 (카카오맵 연동)
    - 리뷰 작성/댓글/좋아요
    - 팔로우/피드/칼럼(블로그)
    - 코스 생성/공유/예약
    - 예약 시스템
    - 위시리스트
  2. 사업자 (80% 완성)
    - 사업자 등록/승인
    - 매장 관리/메뉴 관리
    - 예약 관리 (테이블 배정, 블랙아웃 날짜)
    - 리뷰 답변
    - Q&A 관리
    - 쿠폰 발급
    - 통계 대시보드
  3. 관리자 (75% 완성)
    - 회원/사업자 관리
    - 콘텐츠 모더레이션
    - 공지/이벤트/FAQ 관리
    - 통계 분석
  4. ERP 시스템 (70% 완성)
    - 본사/지점 구조
    - 재료/메뉴 관리
    - 재고 관리
    - 발주 시스템

  ---
  ⚠️ 부족한 핵심 기능 (실제 서비스 필수)

  🔴 CRITICAL (필수)

  1. 결제 시스템 없음
    - 예약금, 쿠폰 결제 불가
    - 👉 추천: Toss Payments, 카카오페이, 네이버페이 연동
  2. 이메일 서비스 미구현
    - 회원가입 인증, 비밀번호 찾기 시뮬레이션만 존재
    - 예약 확인 메일 없음
    - 👉 추천: SendGrid, AWS SES 연동
  3. 보안 취약점 🔒
    - PasswordUtil.java에 테스트용 하드코딩된 비밀번호 존재
  return "password123".equals(password) || "admin123".equals(password); // 삭제 필요!
    - CSRF 토큰 없음
    - HTTPS 강제 없음
    - 👉 즉시 수정 필요
  4. 로깅/에러 처리
    - 에러 발생 시 e.printStackTrace() 만 사용
    - 구조화된 로그 없음
    - 👉 추천: SLF4J + Logback 도입

  ---
  🟡 HIGH PRIORITY (UX 개선)

  5. 실시간 알림 없음
    - DB 테이블(notifications)은 있지만 실시간 푸시 없음
    - 👉 추천: WebSocket 또는 폴링 방식 구현
  6. SMS 알림 없음
    - 예약 확정 시 문자 없음
    - 👉 추천: Aligo, Coolsms 연동
  7. 모바일 최적화 부족
    - 복잡한 관리자 페이지, 코스 생성 페이지 모바일 미대응 가능성
    - 👉 추천: Chrome DevTools로 테스트 필요
  8. 파일 업로드 보안
    - 확장자만 체크, MIME 타입 검증 없음
    - 악성 파일 업로드 가능성
    - 👉 추천: 화이트리스트 방식, 파일 크기 제한

  ---
  🟢 MEDIUM PRIORITY (추가 기능)

  9. 소셜 로그인 없음
    - 카카오/네이버/구글 로그인 없음
    - 한국 사용자는 소셜 로그인 선호
  10. SEO 최적화 부족
    - 맛집/코스 페이지 서버사이드 렌더링 없음
    - Open Graph 메타태그 부족
  11. API 문서 없음
    - JSON 반환하는 API 서블릿들 문서화 안 됨

  ---
  🚀 확장하면 좋을 기능

  고가치 기능

  1. AI 추천 시스템
    - 사용자 리뷰/팔로우 기반 맞춤 추천
    - DB 준비됨: recommendation_metrics 테이블 존재
  2. 배달 연동
    - 배민, 쿠팡이츠 파트너십
  3. 포인트/리워드 프로그램
    - 리뷰/예약 시 포인트 적립
    - user_badges 테이블로 게이미피케이션 가능
  4. 그룹 다이닝
    - 단체 예약, 더치페이 계산기
  5. 영상 콘텐츠
    - 맛집 투어 영상, 셰프 인터뷰
    - restaurant_images 테이블에 type 필드 추가

  통합 가능성

  - 카카오톡 채널 (챗봇 CS)
  - 네이버 지도 API
  - 인스타그램 사진 임포트
  - Google My Business 동기화

  ---
  📋 우선순위 로드맵

  Phase 1: 프로덕션 준비 (0-3개월) - 필수

  | 작업           | 우선순위 | 소요시간 |
  |--------------|------|------|
  | 하드코딩 비밀번호 제거 | P0   | 1일   |
  | 이메일 서비스 연동   | P0   | 3일   |
  | 결제 연동 (Toss) | P0   | 2주   |
  | CSRF 보호 추가   | P0   | 2일   |
  | 로깅 프레임워크 도입  | P1   | 1일   |
  | 파일 업로드 검증    | P1   | 2일   |
  | HTTPS 강제     | P1   | 1일   |

  총 소요: 4-5주

  Phase 2: UX & 성능 (3-6개월)

  - 로딩 상태 UI 개선
  - 폼 검증 강화
  - DB 인덱스 최적화
  - Redis 캐싱
  - 모바일 대응 개선
  - 실시간 알림 (폴링)

  총 소요: 7-8주

  Phase 3: 성장 기능 (6-12개월)

  - AI 추천
  - 소셜 로그인
  - 영상 지원
  - 포인트 프로그램
  - 배달 연동

  ---
  🎯 결론

  강점

  ✅ 포괄적인 기능 (80-85% 완성)
  ✅ 체계적인 DB 설계 (61개 테이블)
  ✅ 깔끔한 아키텍처 (Servlet → Service → DAO)
  ✅ 다양한 사용자층 지원 (일반/사업자/관리자/ERP)

  약점

  ❌ 결제 미연동 (수익화 불가)
  ❌ 보안 취약점 (하드코딩 비밀번호 등)
  ❌ 이메일 서비스 없음
  ❌ 테스트 코드 0개
  ❌ 프로덕션 모니터링 부족

  권장사항

  Phase 1 완료 후 출시하세요.
  기능은 풍부하지만 결제/보안/이메일 문제로 실제 서비스 불가능합니다.
  4-5주 투자하면 프로덕션 준비 완료 가능합니다.


------------------------------------------------------

10/01
쿠폰 관리 페이지도 Q&A관리 페이지처럼 (ㅇ)
코스 생성/수정 시 태그 저장 기능 구현 (ㅇ)
썸네일 이미지 표시 문제 수정 (ㅇ)
코스 수정 페이지에서 기존 위치 데이터 지도에 표시 (ㅇ)
master.sql 스키마 에러 수정 (ㅇ)
CLAUDE.md 프로젝트 가이드 문서 작성 (ㅇ)

---

## 📋 10월 1일 이후 작업 계획 (프로젝트 전체 분석 결과 기반)

### 🚨 **CRITICAL - 즉시 수정 필요 (보안 취약점)**

#### 1. 인증/인가 보안 수정
- [ ] **예약 취소 권한 검증 추가** (ReservationServlet.java:393)
  - 현재: 다른 사용자의 예약도 취소 가능
  - 수정: 본인 예약만 취소하도록 userId 검증 로직 추가

- [ ] **리뷰 답글 권한 검증 추가** (ReviewService.java:177)
  - 현재: 누구나 사장님 답글 작성 가능
  - 수정: 해당 음식점 소유자만 답글 작성하도록 검증

- [ ] **AuthenticationFilter 범위 확장** (filter/AuthenticationFilter.java)
  - 현재: 일부 URL만 보호 (mypage, review/write 등)
  - 추가 필요:
    * `/business/*` - 비즈니스 대시보드 전체
    * `/admin/*` - 관리자 페이지 전체
    * `/hq/*`, `/branch/*` - ERP 기능 전체
  - 또는 역할별 필터 분리 (BusinessFilter, AdminFilter, ErpFilter)

#### 2. 파일 업로드 보안 강화
- [ ] **ColumnImageUploadServlet 보안 개선** (controller/ColumnImageUploadServlet.java)
  - 파일 타입 검증 (MIME 타입 + Magic Byte 확인)
  - 파일 크기 제한 (예: 10MB)
  - 안전한 파일명 생성 (현재 사용자 입력 파일명 사용)
  - 에러 메시지에서 스택 트레이스 제거

- [ ] **다른 업로드 서블릿도 동일하게 적용**
  - CourseServlet (썸네일 업로드)
  - RestaurantServlet (이미지 업로드)
  - ReviewImageUploadServlet

#### 3. 프로덕션 코드에서 디버그/테스트 코드 제거
- [ ] **web.xml에서 디버그 서블릿 제거**
  - TestServlet (`/test`) - DB 연결 테스트용
  - DebugServlet (`/debug`) - 디버그 데이터 생성용

- [ ] **백업 JSP 파일 삭제** (6개)
  - `review-management-old.jsp`
  - `review-management-new.jsp`
  - `review-management-v2.jsp`
  - `review-management-final.jsp`
  - `review-management.jsp.backup`
  - `sales-orders백업.jsp`

---

### 🔥 **HIGH PRIORITY - 이번 주 내 완료**

#### 4. 로깅 시스템 도입
- [ ] **의존성 추가** (pom.xml)
  ```xml
  <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
      <version>2.0.9</version>
  </dependency>
  <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-classic</artifactId>
      <version>1.4.11</version>
  </dependency>
  ```

- [ ] **logback.xml 설정 파일 생성** (src/main/resources/)
  - 로그 레벨: DEBUG (개발), INFO (운영)
  - 파일 로테이션 설정
  - 콘솔/파일 Appender 설정

- [ ] **System.out.println 대체** (152개 발견)
  - 우선순위 파일들:
    * CourseServlet.java (20개)
    * ColumnCommentServlet.java (8개)
    * BusinessReviewManagementServlet.java (8개)
    * BusinessQnAManagementServlet.java (8개)
  - 패턴:
    ```java
    // 변경 전
    System.out.println("Debug: " + value);

    // 변경 후
    private static final Logger logger = LoggerFactory.getLogger(ClassName.class);
    logger.debug("Debug: {}", value);
    ```

#### 5. 에러 핸들링 표준화
- [ ] **중앙 집중식 에러 처리 유틸 생성**
  - `util/ErrorHandler.java` 생성
  - JSON 에러 응답 표준화
  - 사용자 친화적 에러 메시지

- [ ] **printStackTrace() 제거** (124개 파일)
  - 로거로 대체: `logger.error("Error message", e);`
  - 클라이언트에 스택 트레이스 노출 방지

- [ ] **입력 검증 강화**
  - parseInt/parseDouble 래핑 (10개 서블릿)
  - 예시:
    ```java
    try {
        int id = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        return;
    }
    ```

#### 6. 트랜잭션 관리 추가
- [ ] **UserService - 사용자 등록 트랜잭션**
  - 사용자 생성 + 기본 스토리지 생성을 하나의 트랜잭션으로

- [ ] **RestaurantService - 음식점 등록 트랜잭션**
  - 음식점 정보 + 이미지 + 초기 설정을 하나의 트랜잭션으로

- [ ] **CouponService - 쿠폰 사용 트랜잭션**
  - 쿠폰 상태 업데이트 + 사용 로그 기록을 하나의 트랜잭션으로

- [ ] **ReservationService - 예약 처리 트랜잭션**
  - 예약 생성 + 테이블 할당 + 알림 발송을 하나의 트랜잭션으로

#### 7. 미완성 기능 처리
- [ ] **IntelligentRecommendationService 결정**
  - 옵션 A: 10개 stub 메소드 구현 (ML/데이터 분석 필요, 고난이도)
  - 옵션 B: 서비스 제거하고 기본 추천만 유지
  - 추천: 우선 옵션 B로 진행, 향후 필요시 재구현

- [ ] **ReservationSettingsService 검증 로직 완성** (Line 98)
  - ReservationSettingsNew 검증 업데이트

- [ ] **EventManagementService 이미지 업로드 완성** (Line 23)
  - 이벤트 이미지 처리 로직 구현

---

### ⚙️ **MEDIUM PRIORITY - 2주 내 완료**

#### 8. 데이터베이스 최적화
- [ ] **SELECT * 쿼리 수정** (31개 발견)
  - 명시적 컬럼 리스트로 변경
  - 성능 및 유지보수성 개선

- [ ] **쿠폰 스키마 마이그레이션 확인**
  - `coupon_table_update.sql` 적용 여부 확인
  - 미적용 시 실행 후 매퍼 업데이트

- [ ] **인덱스 분석 및 추가**
  - 자주 조회되는 컬럼에 인덱스 추가
  - 느린 쿼리 로그 분석 (EXPLAIN 사용)

#### 9. 단위 테스트 추가
- [ ] **JUnit 5 의존성 추가**
  ```xml
  <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>5.10.0</version>
      <scope>test</scope>
  </dependency>
  ```

- [ ] **Service 레이어 테스트 작성**
  - UserService 테스트
  - ReviewService 테스트
  - ReservationService 테스트
  - CourseService 테스트

- [ ] **DAO 레이어 테스트 작성**
  - 핵심 DAO부터 시작
  - H2 인메모리 DB 사용

#### 10. API 문서화
- [ ] **AJAX 엔드포인트 문서 작성**
  - 각 서블릿의 AJAX 요청/응답 형식 문서화
  - 예시:
    ```
    POST /course/like
    Request: { courseId: number, userId: number }
    Response: { success: boolean, likeCount: number }
    ```

#### 11. Rate Limiting 구현
- [ ] **RateLimitFilter 생성**
  - IP 기반 요청 제한
  - 공용 엔드포인트 보호 (리뷰 작성, 예약 등)
  - Redis 또는 간단한 메모리 기반 구현

---

### 🔧 **LOW PRIORITY - 다음 달**

#### 12. 코드 리팩토링
- [ ] **중복 코드 제거**
  - Path normalization 로직 → `util/PathUtils.java`
  - 세션 사용자 조회 → `util/SessionUtils.java`
  - JSON 응답 생성 → `util/JsonResponseUtils.java`

- [ ] **하드코딩 값 설정 파일로 이동**
  - DB 비밀번호 환경 변수로 관리
  - 업로드 경로 중앙 관리
  - Magic number 상수로 정의

#### 13. ERP 멀티테넌트 보안 감사
- [ ] **회사별 데이터 격리 확인**
  - 모든 ERP 쿼리에 company_id 조건 있는지 확인
  - 지점 사용자가 다른 지점 데이터 접근 불가 확인

#### 14. 성능 모니터링
- [ ] **애플리케이션 헬스체크 엔드포인트**
  - `/health` - DB 연결, 서버 상태 확인

- [ ] **슬로우 쿼리 모니터링**
  - MyBatis 플러그인 또는 DB 로그 활용

---

### 📊 **작업 우선순위 요약**

```
🚨 CRITICAL (즉시)
├─ 예약 취소 권한 검증
├─ 리뷰 답글 권한 검증
├─ AuthenticationFilter 확장
├─ 파일 업로드 보안
└─ 디버그 코드 제거

🔥 HIGH (이번 주)
├─ 로깅 시스템 도입
├─ 에러 핸들링 표준화
├─ 트랜잭션 관리 추가
└─ 미완성 기능 처리

⚙️ MEDIUM (2주)
├─ DB 최적화
├─ 단위 테스트
├─ API 문서화
└─ Rate Limiting

🔧 LOW (다음 달)
├─ 코드 리팩토링
├─ 보안 감사
└─ 성능 모니터링
```

---

### 📈 **진행 상황 체크리스트**

#### Week 1 (10/1 - 10/7)
- [ ] 보안 취약점 수정 완료 (4개)
- [ ] 디버그 코드 제거 완료
- [ ] 로깅 시스템 도입 시작

#### Week 2 (10/8 - 10/14)
- [ ] 로깅 시스템 완료 (152개 println 대체)
- [ ] 에러 핸들링 표준화 완료
- [ ] 트랜잭션 관리 추가 완료

#### Week 3 (10/15 - 10/21)
- [ ] DB 최적화 완료
- [ ] 단위 테스트 작성 시작
- [ ] API 문서화 시작

#### Week 4 (10/22 - 10/31)
- [ ] 단위 테스트 완료 (핵심 기능)
- [ ] Rate Limiting 구현
- [ ] 코드 리팩토링 시작

---

### 🎯 **최종 목표: Production-Ready 상태 달성**

**현재 상태:**
- 보안: 6/10 → 목표: 9/10
- 안정성: 6/10 → 목표: 9/10
- 유지보수성: 7/10 → 목표: 9/10
- 테스트 커버리지: 0% → 목표: 60%

**예상 완료: 11월 말**



---------------------------------------------
9월 5주차 todo list

**⚠️ 코드 품질 및 임시데이터 정리 (최우선)**

🔧 **임시데이터 제거 필요 서블릿**:   (🟢)  (🔺)  (❌)
  - FaqServlet.java, FaqManagementServlet.java
  - NoticeServlet.java, NoticeManagementServlet.java
  - InquiryManagementServlet.java
  - FeedbackManagementServlet.java
  - EmployeeManagementServlet.java
  - AlertServlet.java


📝 **TODO 항목 구현 필요**:
- IntelligentRecommendationService.java - 메트릭 저장 로직 (🔺)- 현재 선형 가중치 계산로직이라 학습모델 찾으면 넣어볼 예정?
- ReservationAutomationService.java - 자동화 기능 (🔺)
- ColumnCommentServlet.java - DEBUG 코드 제거
- 음식점 리뷰 평균점수 계산 로직
- 마이페이지 "내 칼럼" 표시 문제 (🟢)

🧹 **로깅 시스템**:
- 323개 파일의 System.out.println → SLF4J + Logback 대체

---

~~1.  MAVEN 제거 (ㅇ)
    이전에 java21 사용했을 때 썼던 maven 설정 전부 제거
    Spring, Firebase, Selenium 전부 사용 안하고 있어서 maven 제거해도 무방 ~~

2.  기능 완성
  - 사용자 피드 시스템 완성 (ㅇ)
  - 팔로우/언팔로우 기능 안정화 (ㅇ)
  - 리뷰, 칼럼, 코스 CRUD 완성 (ㅇ)
  - 비즈니스 회원 기능 완성 (△)

**🔥 우선순위 1: 핵심 기능 완성 (먼저 해야 할 것들)**

3. 지도 API 연동 (restaurant-detail 페이지가 완벽 구성 되고 main 페이지 구성이 완벽해진 이후에 진행) ⭐⭐⭐
  - 카카오맵 API 연동 (o)
  - 지도 api연동으로 음식점 검색에 api끌어다 쓰기 (o) //0930
  - 지도 api 사용해서 음식점 상세페이지에 정보 띄우기  (o) //0930
  - 위치 기반 음식점 검색 및 필터링  (o) //0930

4. 입점 업체 시스템 구축 ⭐⭐⭐
  - 입점 업체 vs 일반 업체 구분 로직 구현 (△) //지도로 검색만 됨 코스는 x
  - 입점 업체만 미트로그의 마크를 붙여줌 (△) //지도로 검색만 됨 코스는 x
  - 입점 업체는 현재 비즈니스 메뉴를 사용할 수 있음
  - 입점 업체가 아닐 경우 api로 연동만 되어서 음식점 상세페이지에 나올 정보만 표기함

5. TODO/FIXME 정리 ⭐⭐
  - IntelligentRecommendationService 메트릭 저장 로직 구현
  - BusinessQnADAO/Service 실제 DB 구현(ㅇ)
  - FollowService 사용자 정보 조회 로직 (ㅇ)
  - ColumnCommentServlet DEBUG 코드 제거

**🛠️ 우선순위 2: 사용성 및 안정성 개선**

6. 시스템 통합 테스트 ⭐⭐
  - 모든 기능 간 연동 확인
  - 에러 처리 및 예외 상황 대응
  - 전체 플로우 테스트

7. 사용성 개선 ⭐⭐
  - 로딩 상태 표시 강화
  - 알림 시스템 개선
  - 검색 및 필터링 개선
  - 사용자 경험 최적화

8. 디자인 마무리 ⭐
  - 일관된 디자인 시스템 적용 (대부분 완료)
  - 반응형 디자인 최적화 (대부분 완료)
  - 애니메이션 및 인터랙션 개선

**⚡ 우선순위 3: 성능 및 품질 개선 (시간 있을 때)**

9. 로깅 시스템 도입 ⭐
  - SLF4J + Logback 도입
  - 현재 323개 파일에서 System.out.println 대체
  - 로그 레벨별 분류 (DEBUG, INFO, WARN, ERROR)
  - 파일 로테이션 및 운영 환경 로그 관리

10. 데이터베이스 최적화 ⭐
  - 인덱스 분석 및 최적화
  - 쿼리 성능 분석 및 개선
  - 커넥션 풀 튜닝

**🔒 우선순위 4: 고급 기능 (선택사항)**

11. 보안 강화 (선택사항)
  - 설정 파일 보안
    * api.properties, config.properties 민감 정보 암호화
    * 환경별 설정 분리 (개발/운영)
    * API 키 관리 시스템 구축
  - 입력 검증 강화
    * SQL Injection 방지 강화
    * XSS 방지 필터 추가
    * CSRF 토큰 체계적 적용

12. 캐싱 시스템 (선택사항)
  - Redis 도입 검토
  - 자주 조회되는 데이터 캐싱 (음식점 정보, 메뉴 등)
  - 세션 클러스터링

13. 시스템 모니터링 (선택사항)
  - API 표준화
    * RESTful API 가이드라인 정립
    * 일관된 응답 형식 (JSON 표준)
    * API 문서화 (Swagger 도입 검토)
  - 모니터링 시스템
    * 애플리케이션 성능 모니터링 (APM)
    * 비즈니스 메트릭 대시보드
    * 실시간 알림 시스템 고도화



09/27
코스 댓글 기능 추가(ㅇ)
코스 찜 기능 구현 (ㅇ)
코스 좋아요 기능 구현(ㅇ)

칼럼이나 리뷰, 코스 생성 시 db feed_items에 연동 되는지 확인(ㅇ)
wishlist 페이지에 기본 폴더로 "내 찜 목록" 기본 폴더로 만들고 모든 사용자 공통으로 해두기(ㅇ)


09/28
음식점 예약 설정 기능 구현 (ㅇ)
- 음식점 관리자가 예약 설정하는 페이지
  - 예약 가능 시간 설정
  - 예약 가능 날짜 설정
  - 예약 가능 인원 설정
  - 예약 자동/수동 수락 설정


09/29
1. 음식점 예약 설정한대로 예약할 수 있게 구현 (ㅇ)
2. 마이페이지
  - 내가 받은 쿠폰 목록 페이지 생성(o)
  - 마이페이지에서 내가 받은 쿠폰 확인할 수 있도록 "내 쿠폰" 요소 추가(o)
  - 마이페이지에서 내가 쓴 칼럼 개수는 뜨는데 mypage/columns의 내 칼럼에서는 내가 쓴 칼럼이 안뜸(△)
  - 마이페이지에서 "만든 코스" 개수 뜨는 요소 추가(o)
  - 마이페이지에서 "내 리뷰", "내 칼럼" 처럼 "내 코스"로 이동할 수 있게 요소 추가(o)
3. 비즈니스 메뉴 쿠폰 (ㅇ)
  - coupon-management페이지에 내가 만든 쿠폰 목록이 뜨지 않음 db랑 연동
4. 비즈니스 코멘트 (△)
  - business/review-management에서 답글을 달았을 때 해당 음식점 사장님이 단 댓글이니까 바로 그페이지에서 떠야함
  - 해당 음식점 사장님이 댓글을 달고 나면 business/review-management페이지에서 해당 댓글의 우 상단에 체크기능을 넣어서 해결 완료된 댓글을 피드에서 사라지도록 해야함
5. Q&A도 같은 로직으로 (△)

6. 임시데이터가 들어있는 서블릿, jsp 들 찾기 및 코드에 작성된 todo 찾기(ㅇ)







음식점 리뷰 점수 음식점에 평균으로 들어갈 수 있게 수정, 음식점 상세 페이지에서 예약 가능 시간 선택(restaurant-detail페이지 완성 이후 예정)
