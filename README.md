# MEETLOG README

## 1. 프로젝트 개요
- **MEETLOG**는 맛집 탐색, 코스 추천, 예약, 결제, 리뷰, 커뮤니티 기능을 제공하는 복합 외식 플랫폼이다.
- 핵심 웹 애플리케이션은 `MeetLog/` 이하의 **Java 11 + JSP/Servlet + MyBatis** 구조로 작성되어 있으며, Tomcat 9 기준 WAR 배포를 전제로 한다.
- 별도 마이크로서비스인 `kobert-api-server/`는 **FastAPI + KoBERT 임베딩**을 제공하며, 추천 시스템이 외부 AI 의존성을 낮춘 포트/어댑터 구조(`service.port.RecommendationPort`, `adapter.KoBertAdapter`)로 설계되어 있다.
- 저장소에는 운영 스크립트, 배포 자동화(GitHub Actions), SQL 스키마·마이그레이션, 업로드 자산, ERP 서브모듈, 텔레그램·카카오페이·네이버페이 같은 외부 연동 요소가 함께 포함되어 있다.

## 2. 저장소 구조 요약
| 경로 | 설명 |
| --- | --- |
| `MeetLog/` | 메인 JSP/Servlet 애플리케이션. 소스(`src/`), 자원(`resources/`), JSP(`webapp/`), SQL(`database/`), 스크립트(`scripts/`), 의존 라이브러리(`lib/`)가 포함된다. |
| `kobert-api-server/` | KoBERT 기반 문장 임베딩 API(FastAPI). `main.py`, `requirements.txt`, `venv/`가 포함된다. |
| `Servers/` | Eclipse 기반 Tomcat 9 로컬 서버 설정. `server.xml`, `context.xml` 등 개발용 설정이 저장되어 있다. |
| `meetlog_uploads/` | 로컬 업로드 샘플 및 코스 썸네일이 저장된다. `config.properties`의 `upload.path` 기본값과 연동된다. |
| `mavenbackup/`, `MeetLog/maven_backup/` | Maven 프로젝트 백업(`pom.xml`, `target/`). 현재는 수동 관리 스크립트를 사용하지만 Maven 정보가 유지된다. |
| `deployment-report.md`, `recommendation_metrics.md`, `todo_list.md` | 배포 보고서, 추천 시스템 지표 정의, TODO 목록 등 추가 문서. |
| `MeetLog.zip`, `bin/`, `cookies.txt` 등 | 과거 산출물, 임시 파일. 필요 시 정리 대상. |

### 2.1 `MeetLog/` 내부 주요 디렉터리
- `src/main/java/`  
  - `controller/`, `controller/payment/`, `controller/telegram/` : 수십 개의 서블릿이 URL별 기능을 담당한다. 사용자·관리자·비즈니스·ERP·추천·알림 등 도메인별로 세분화돼 있으며, `web.xml`과 어노테이션(@WebServlet) 매핑이 혼재한다.
  - `service/`, `service/payment/`, `service/port/` : 비즈니스 로직 계층. 예) `IntelligentRecommendationService`, `ReservationAutomationService`, `KakaoPayService`, `UserVectorService`.
  - `dao/` : MyBatis 기반 데이터 접근 객체. 각 Mapper XML과 1:1 대응한다.
  - `model/`, `dto/`, `erpDto/` : 도메인 엔터티와 전달 객체. 추천, 예약, 쿠폰, 코스, ERP 자산 등 100여 개 클래스가 존재한다.
  - `adapter/` : 외부 서비스 포트 구현. 현재는 KoBERT API 어댑터가 있다.
  - `util/` : `AppConfig`, `EmailUtil`, `GooglePlacesUtil`, `VectorPrecomputeBatch` 등 공통 유틸 및 배치 실행기.
  - `filter/`, `listener/`, `typehandler/` : 인코딩·인증 필터, 텔레그램 폴링 리스너, JSON 타입핸들러 등이 포함된다.
- `src/main/resources/`  
  - `mybatis-config.xml`, `db.properties`, `config.properties`, `api.properties`.  
  - 다수의 Mapper XML(`mappers/`, `erpMappers/`)이 저장돼 있으며, 예약·리뷰·추천·ERP 영역별로 쿼리가 분리돼 있다.
  - `logback.xml`은 SLF4J 로그 설정을 정의한다.
- `src/main/webapp/`  
  - `WEB-INF/web.xml` : 서블릿 및 정적 리소스 매핑.  
  - `WEB-INF/views/` : 사용자·관리자·비즈니스·지점·코스·공통·에러 JSP.  
  - `css/`, `js/`, `img/` : 정적 자산. JavaScript는 `main-optimized.js`, `click-protection.js` 등으로 번들돼 있다.
- `database/`  
  - `master.sql`, `schema_updates.sql`, `migrations/*.sql`, `archive/*.sql`.  
  - `archive/MIGRATION_GUIDE.md`와 주요 단계별 SQL(사용자→맛집→리뷰 등)로 진화 과정을 기록한다.
- `scripts/`  
  - `build-war.sh` : Java 컴파일 후 `build/deploy/MeetLog.war` 생성.  
  - `run-local.sh` : `TOMCAT_HOME` 환경 변수 기반 로컬 Tomcat 배포.  
  - `deploy-war.sh` : 원격 Tomcat에 SCP, 서비스 중단/기동 자동화.
- `.github/workflows/deploy.yml` : GitHub Actions 빌드/배포 파이프라인. `MeetLog/scripts`와 동일 스크립트를 호출한다.
- `README_Deploy.md` : 스크립트 사용법과 Actions 시크릿 요구 사항을 정리한 문서.

## 3. 핵심 시스템 상세

### 3.1 MEETLOG 웹 애플리케이션
#### 3.1.1 기술 스택과 런타임
- **Java 11**, **JSP/Servlet 4.0**, **Tomcat 9**. WAR 아카이브로 배포한다.
- **MyBatis**(`util.MyBatisSqlSessionFactory`)를 통해 MariaDB(`db.properties`)와 연결한다.
- **SLF4J + Logback** 기반 로깅. 일부 서비스는 `System.out` 디버그 로그를 병행하므로 운영 시 정리 필요.
- **Lombok** 의존성 지정은 있으나 소스에 어노테이션 사용은 제한적이다.
- `lib/` 폴더에는 외부 JAR이 수동 배치돼 있으며 스크립트가 이를 포함해 컴파일한다.

#### 3.1.2 계층 구조
1. **프레젠테이션** : `controller.*` 서블릿이 HTTP 요청을 처리하고 JSP/JSON을 반환한다. `filter/EncodingFilter`, `filter/AuthenticationFilter`, `filter/AdminAuthenticationFilter` 등이 공통 전처리를 담당한다.
2. **서비스** : `service.*`가 도메인 로직을 캡슐화한다. 예약 자동화, 통계, 추천, 결제, 알림, 소셜 기능이 이 계층에 집중돼 있다.
3. **데이터 접근** : `dao.*` 클래스가 MyBatis `SqlSession`을 직접 호출한다. `typehandler.JsonArrayTypeHandler`로 JSON 필드를 배열로 자동 매핑한다.
4. **도메인 모델** : `model.*`, `dto.*`, `erpDto.*`가 DB 매핑과 화면 전달을 담당한다.
5. **유틸리티 및 설정** : `util.AppConfig`와 `util.AppConfigListener`가 `config.properties`, `api.properties`를 로딩해 애플리케이션 전역에서 접근 가능하도록 한다.

#### 3.1.3 주요 기능 도메인
- **사용자 계정 및 인증**
  - `controller.LoginServlet`, `RegisterServlet`, `FindAccountServlet`, `IdPwSearchServlet`.
  - `service.AuthService`는 계정 생성·조회, `service.SocialLoginService`, `util.GoogleLoginBO`, `NaverLoginBO`, `KakaoLoginBO`로 OAuth 연동을 처리한다.
  - 이메일 인증(`controller.EmailVerificationServlet`, `util.EmailUtil`)과 비밀번호 생성/암호화(`util.PasswordUtil`, `GeneratePassword`)가 포함된다.

- **맛집·콘텐츠 관리**
  - 맛집 목록/검색(`RestaurantServlet`, `AdvancedSearchServlet`, `NearbyReviewsServlet`, `SearchMapServlet`), 상세(`RestaurantDetailServlet`), 랭킹(`RestaurantRankApiServlet`), 이미지 업로드(`ImageServlet`, `ImageProxyServlet`).
  - 메뉴 관리(`MenuManagementServlet`, `AddMenuServlet`, `EditMenuServlet`), 코스 제작(`CourseServlet`, `CourseManagementServlet`, `CourseReservationServlet`)과 댓글(`CourseCommentService`).
  - 칼럼/피드(`ColumnServlet`, `FeedServlet`, `ColumnCommentServlet`, `ColumnLikeServlet`). `model.Column`, `model.FeedItem` 등이 뷰 모델을 제공한다.

- **리뷰 및 커뮤니티**
  - 리뷰 CRUD(`ReviewServlet`, `AddReviewCommentServlet`, `ReviewReplyServlet`, `ReviewLikeServlet`), 신고(`ReviewReportServlet`), 통계(`ReviewStatisticsServlet`).
  - 팔로우/피드(`FollowServlet`, `GetLikerListServlet`, `FeedService`), 찜/위시리스트(`WishlistServlet`).

- **예약·코스 운영**
  - 예약 신청 및 관리(`ReservationServlet`, `ReservationManagementServlet`, `ReservationStatisticsServlet`, `ReservationSettingsServlet`).
  - `ReservationAutomationService`는 블랙아웃 체크, 테이블 배정(`dao.RestaurantTableDAO`, `ReservationTableAssignmentDAO`), 자동 승인/거부, 알림(`NotificationService`)을 자동화한다.
  - 비즈니스 지점 메뉴/예약 관리(`BusinessMenuManagementServlet`, `BranchMenuServlet`, `BusinessReservationManagementServlet`).
  - 예약 알림/노티(`dao.ReservationNotificationDAO`, `model.ReservationNotification`).

- **결제**
  - `controller/payment/*` 서블릿과 `service/payment/*` 서비스가 카카오페이, 네이버페이를 처리한다.
  - `KakaoPayService`는 결제 준비/승인 API를 직접 호출하고 세션으로 `tid`를 관리한다.
  - `NaverPayService`는 샌드박스 API 호출 템플릿과 콜백 해석을 제공한다.
  - 결제 결과(`PaymentResultServlet`, `ManualConfirmServlet`)와 가상 승인 처리(`config.properties`의 Naver Pay 옵션) 로직이 포함된다.

- **추천 및 AI**
  - `RecommendationController`는 `/recommendations/intelligent` 라우트를 제공한다.
  - `IntelligentRecommendationService`는 사용자 행동 패턴(`UserAnalyticsService`), 실시간 트렌드(`TrendAnalysis`), 협업/콘텐츠 필터링(`RecommendationService`)을 통합하고 KoBERT 임베딩을 활용한다.
  - `UserVectorService`는 사용자 리뷰 코멘트를 KoBERT로 임베딩해 캐싱하며 비동기 백그라운드 큐를 가진다.
  - `util.VectorPrecomputeBatch`는 레스토랑 설명 벡터를 사전 계산하기 위한 CLI 유틸리티다.
  - 지표 로깅(`dao.RecommendationMetricDAO`, `recommendation_metrics.md`)을 통한 추천 품질 추적.

- **알림 및 통합**
  - 이메일 발송(`util.EmailUtil`, SMTP 설정)과 텔레그램 연동(`controller.telegram.TelegramLinkServlet`, `TelegramService`, `TelegramPollerService`, `listener.TelegramPollerListener`)을 포함한다.
  - 텔레그램 봇 토큰 발급, `/start` 명령어 온보딩, 메시지 발송/로그(`dao.TgLinkDAO`, `dao.TelegramMessageLogDAO`)를 전담한다.
  - `NotificationService`, `AlertServlet`, `SupportServlet` 등 다양한 알림·지원 채널이 존재한다.

- **관리자 및 비즈니스 콘솔**
  - 관리자 대시보드(`AdminDashboardServlet`), 회원/비즈니스/리포트/FAQ 관리, 통계(`AdminStatisticsService`, `StatisticsDashboardServlet`, `SupportStatisticsServlet`).
  - 비즈니스 사용자용 대시보드(`BusinessDashboardServlet`), QnA/문의(`BusinessQnAManagementServlet`, `InquiryManagementServlet`), 쿠폰(`CouponManagementServlet`, `CouponService`), 포인트(`PointService`).
  - ERP 전용 서블릿(`erpController.*`)과 DTO(`erpDto.*`)는 본사-지점 자재/주문/프로모션/공지 관리를 지원한다.

#### 3.1.4 프런트엔드 자산
- JSP는 `WEB-INF/views` 하위에서 레이아웃(`layout/`), 섹션(`views/sections/`), 도메인별 화면(`restaurant/`, `course/`, `branch/`, `admin/`, `business/`)으로 구조화돼 있다.
- 공통 태그 라이브러리는 `WEB-INF/tags/`에 정의돼 있으며, JSTL과 커스텀 태그를 혼합 사용한다.
- `js/` 디렉터리는 예약/알림/토스트 UI 스크립트를 제공하며, `css/`는 각 기능별 스타일을 정의한다.
- 정적 자산 매핑은 `web.xml`에서 `default` 서블릿으로 `/img/*`, `/css/*`, `/js/*`, `/uploads/*`를 지정한다.

#### 3.1.5 데이터 계층
- `db.properties`는 MariaDB 로컬 개발용 자격 증명이 하드코딩돼 있다. 운영에서는 환경 변수나 외부 비밀 관리로 치환해야 한다.
- `api.properties`에는 TinyMCE, Kakao, Naver, Google API 키와 SMTP 자격, 텔레그램 토큰 등이 평문 저장돼 있으므로 보안 조치가 필요하다.
- `mybatis-config.xml`은 `mapper.*` 네임스페이스를 스캔하며 캐시, 로깅, 타입핸들러 설정을 포함한다.
- `database/` 폴더에는 다음과 같은 SQL 자산이 있다.
  - `master.sql`, `semi-erp.sql` 등 전체 스키마 덤프.
  - `migrations/001_add_coupon_point_features.sql`, `002_add_telegram_integration.sql` 등 순차 마이그레이션.
  - `archive/`에는 세부 단계별 스키마 및 샘플 데이터, `MIGRATION_GUIDE.md`, `README.md`가 포함돼 과거 이력 추적이 가능하다.
  - `uploads/`는 SQL 업로드 스크립트와 샘플 이미지가 저장된다.

#### 3.1.6 배치 및 백그라운드 처리
- `listener.TelegramPollerListener`가 애플리케이션 기동 시 텔레그램 폴링 스레드를 데몬으로 실행한다.
- `util.VectorPrecomputeBatch`를 독립적으로 실행해 레스토랑 콘텐츠 벡터를 미리 계산/저장할 수 있다.
- `ReservationAutomationService`는 예약 이벤트를 자동 처리하며, 이메일/텔레그램 알림과 연동된다.

### 3.2 KoBERT Vectorization API (`kobert-api-server/`)
- `main.py`는 FastAPI 애플리케이션을 통해 `/vectorize` POST 엔드포인트를 제공한다.
  - PyTorch 디바이스를 자동 감지(MPS → CUDA → CPU)하고 `skt/kobert-base-v1` 모델을 로드한다.
  - 입력 텍스트를 토크나이징해 mean pooling으로 768차원 벡터를 생성한다.
- `requirements.txt`에는 `fastapi`, `uvicorn`, `transformers`, `torch` 등이 정의된다.
- 추천 서비스(`adapter.KoBertAdapter`)는 표준 HTTP 클라이언트로 해당 API를 호출하며 3회 재시도 및 지수 백오프를 구현한다.
- `venv/`는 로컬 가상환경이 포함돼 있으나 배포 환경에서는 새 가상환경을 구성하는 것이 권장된다.

### 3.3 배포 및 인프라 구성
- `scripts/build-war.sh` : JDK 11, `rsync`, `jar`를 요구한다. 소스/리소스를 컴파일해 `build/deploy/` 아래 WAR을 만든다.
- `scripts/deploy-war.sh` : 환경 변수(`DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_TARGET_DIR` 등)를 사용해 원격 Tomcat에 WAR을 전송하고 서비스 중지→교체→기동을 수행한다.
- `scripts/run-local.sh` : 로컬에서 `TOMCAT_HOME`을 지정하면 Tomcat 종료/배포/기동을 자동화한다.
- `.github/workflows/deploy.yml` : `main` 브랜치 푸시 또는 수동 실행 시 빌드→아티팩트 업로드→원격 배포 단계를 수행한다. SSH 키(`DEPLOY_KEY`)와 서버 정보가 시크릿으로 요구된다.
- `Servers/Tomcat v9.0 Server at localhost-config/` : Eclipse WTP 기반 개발 서버 설정. 운영과 별도로 관리된다.

### 3.4 기타 문서 및 자산
- `README_Deploy.md` : 배포 스크립트 사용법 및 GitHub Actions 시크릿 요구사항 상세.
- `deployment-report.md` : 배포 현황 리포트.
- `recommendation_metrics.md` : 추천 품질 측정 지표 정의.
- `todo_list.md` : 향후 작업 항목 추적.
- `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` : AI 도구 사용 기록 및 가이드.
- `MeetLog/찐찐찐막.drawio`, `JSP정의서.xlsx` : 설계 다이어그램 및 JSP 정의 문서.
- `MEETLOG_요구사항정의서.docx` : 요구사항 정의 문서.

## 4. 개발 및 실행 가이드

### 4.1 선행 설치
1. **Java Development Kit 11** 이상. `javac`, `jar`가 PATH에 포함돼야 한다.
2. **Apache Tomcat 9** (로컬 테스트용). `scripts/run-local.sh` 사용 시 `TOMCAT_HOME` 설정 필요.
3. **MariaDB 10.x** 또는 호환 DB. `db.properties` 설정에 맞춰 인스턴스를 준비한다.
4. **Python 3.10+** (KoBERT 서버용). `pip install -r kobert-api-server/requirements.txt`.
5. **Node.js/프런트 빌드 도구는 사용되지 않음**. JSP가 서버에서 렌더링한다.

### 4.2 데이터베이스 준비
1. 데이터베이스 생성: `CREATE DATABASE meetlog DEFAULT CHARACTER SET utf8mb4;`.
2. 초기 스키마: `database/master.sql` 또는 `database/archive/master.sql` 실행.
3. 추가 스키마/데이터: `database/schema_updates.sql`과 `database/migrations/*.sql`을 순차 적용. ERP, 추천, 텔레그램 기능은 해당 마이그레이션을 반드시 포함해야 한다.
4. 샘플 데이터가 필요하면 `database/archive/sample_data.sql`, `unified_sample_data.sql` 등을 선택적으로 임포트한다.

### 4.3 설정 파일
- `src/main/resources/db.properties` : DB URL, 사용자, 비밀번호. 운영에서는 파일 대신 환경 변수 주입 또는 외부 설정 서버 사용을 권장한다.
- `src/main/resources/config.properties` : 업로드 경로(`upload.path`), Naver Pay 기본 설정.
- `src/main/resources/api.properties` : TinyMCE, Kakao, Naver, Google API 키와 SMTP, 텔레그램 토큰. 현재 저장소에 평문으로 존재하므로 즉시 회수 및 보안 저장 필요.
- `util.AppConfig`와 `util.AppConfigListener`가 애플리케이션 기동 시 위 속성을 로딩해 ServletContext와 정적 접근 메서드에 주입한다.

### 4.4 KoBERT API 서버 실행
```bash
cd kobert-api-server
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```
- 모델 최초 로드에 시간이 걸리며, 실행 중 GPU/MPS 사용 가능 여부가 로그에 표시된다.
- `adapter.KoBertAdapter`는 기본 URL을 `http://127.0.0.1:8000/vectorize`로 가정하므로 네트워크 환경에 맞게 수정하거나 리버스 프록시를 구성한다.

### 4.5 MEETLOG 애플리케이션 빌드 및 실행
1. `MeetLog/scripts/build-war.sh` 실행 → `MeetLog/build/deploy/MeetLog.war` 생성 확인.
2. 로컬 Tomcat 배포: `export TOMCAT_HOME=/path/to/tomcat` 후 `MeetLog/scripts/run-local.sh` 실행.  
   - 스크립트는 Tomcat 종료→WAR 복사→기동을 자동으로 수행한다.
   - 접속 주소: `http://127.0.0.1:8080/MeetLog`.
3. 원격 배포: 필요한 환경 변수를 설정(`DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_TARGET_DIR` 등)하고 `MeetLog/scripts/deploy-war.sh` 실행.
4. GitHub Actions 활용: `main` 브랜치에 푸시하면 `Build & Deploy` 워크플로가 빌드 및 원격 배포를 수행한다.

### 4.6 기타 운영 고려 사항
- **업로드 디렉터리** : `config.properties`의 `upload.path` 경로(`../meetlog_uploads/`)가 존재하고 Tomcat에서 쓰기 권한이 있는지 확인한다.
- **텔레그램 폴러** : 봇 토큰과 콜백 주소가 유효해야 하며 외부 네트워크 접근이 허용돼야 한다.
- **이메일 SMTP** : Gmail 앱 비밀번호(`mail.smtp.password`)를 사용 중이므로 IAM 안전성 확보 필요.
- **로그** : `logback.xml` 로테이션/레벨을 환경에 맞게 조정한다. 현재 `System.out.println` 디버그 로그가 다수 존재해 운영에서는 로그 정리 권장.
- **테스트** : `src/test/`가 비어 있으므로 JUnit 기반 단위 테스트/통합 테스트 도입이 필요하다.

## 5. 아키텍처 및 주요 흐름

### 5.1 요청-응답 계층 흐름
1. 클라이언트 요청 → `controller.*` 서블릿 (`@WebServlet` 또는 `web.xml` 매핑).
2. 인증/권한 필터 → `EncodingFilter`, `AuthenticationFilter`, `AdminAuthenticationFilter`.
3. 서비스 계층 → 도메인별 Service 클래스가 트랜잭션/비즈니스 로직 수행.
4. DAO → `dao.*`가 MyBatis Mapper 호출, SQL은 `src/main/resources/mappers/*.xml`에 정의.
5. 응답 → JSP 렌더링 또는 JSON(`Gson`, `Jackson`), REST API는 주로 `/api/`, `/recommendations/`, `/telegram/` 경로에서 JSON 반환.

### 5.2 추천 시스템 데이터 흐름
1. 사용자 행동 데이터 수집 → `UserAnalyticsService`, `RecommendationDAO`.
2. 콘텐츠 벡터 → `VectorPrecomputeBatch` 또는 요청 시 `KoBertAdapter`가 FastAPI 서비스 호출.
3. 사용자 벡터 → `UserVectorService`가 리뷰 텍스트 기반 임베딩을 계산, `UserVectorDAO`에 저장.
4. `IntelligentRecommendationService` → 행동 패턴/트렌드/협업/콘텐츠 점수를 가중 통합, 다양성 확보(`ensureDiversity`) 후 추천 결과 반환.
5. 추천 지표 → `RecommendationMetricDAO`가 노출률·클릭률 등 지표를 기록하고 `recommendation_metrics.md` 기준으로 분석 가능.

### 5.3 결제 처리 흐름
1. `PaymentMethodServlet`에서 사용자가 결제 수단을 선택한다.
2. 카카오페이: `KakaoPayService.buildPaymentRequest`가 Ready API 호출 → 세션에 `tid` 저장 → 사용자를 `next_redirect_pc_url`로 이동 → `KakaoPayCallbackServlet`이 `pg_token` 수신 → `approvePayment` 호출 → `PaymentResultServlet`이 성공/실패 처리 후 예약 상태 업데이트.
3. 네이버페이: `NaverPayService`가 결제 창 호출 및 콜백 파싱 → `PaymentConfirmResult` 반환 → 예약 상태 변경 및 알림 발송.
4. 실패/취소 시 `ManualConfirmServlet` 또는 알림 서비스가 후속 조치를 안내한다.

### 5.4 알림 및 텔레그램 연동 흐름
1. 사용자가 `/telegram/link` POST 호출 → `TelegramLinkServlet`이 토큰 발급 및 딥링크 제공.
2. 사용자가 텔레그램 봇에서 `/start <token>` 실행 → `TelegramPollerService`가 업데이트 수신 → `TgLinkDAO.activateByToken`으로 상태를 `ACTIVE`로 변경 → 환영 메시지 발송.
3. 예약 확정/변경 등 이벤트 발생 → `NotificationService` 또는 `TelegramService.sendMessageToUser` 호출 → 텔레그램/이메일/웹 알림 발송.
4. 실패/차단 → `TelegramMessageLogDAO`가 상태(`STATUS_FAILED`, `STATUS_BLOCKED`) 기록 후 관리자 대응 가능.

## 6. 품질 및 보안 고려사항
- **비밀정보 관리** : `api.properties`, `db.properties`에 저장된 자격 증명은 즉시 외부 비밀 저장소(.env, AWS Secrets Manager 등)로 이전하고, 버전 관리에서는 제거하거나 암호화(예: git-crypt)해야 한다.
- **불필요 아티팩트** : `.class`, `target/`, `build/`, `MeetLog.zip`, `venv/` 등 빌드 결과물이 저장소에 포함돼 있다. 정리 및 `.gitignore` 업데이트를 권장한다.
- **로그 민감도** : `System.out.println` 디버그 출력과 평문 오류 메시지를 SLF4J Logger로 통일하고 민감 정보 노출이 없도록 점검한다.
- **동시성** : `UserVectorService`는 단일 스레드 실행 풀을 사용해 큐에 적재한다. 대량 사용자 처리 시 스레드 풀 튜닝 및 장애 대응 로직을 보강해야 한다.
- **백그라운드 스레드** : 텔레그램 폴러는 데몬 스레드로 실행되므로 애플리케이션 종료 시 정상 종료 여부를 모니터링해야 한다.
- **테스트 미비** : `src/test/`가 비어 있고 통합 테스트 자동화가 없다. JDBC, 서블릿 모킹, 추천 알고리즘 검증 등 테스트 도입을 권장한다.
- **보안 필터** : 관리자 페이지 접근(`AdminAuthenticationFilter`)과 일반 사용자 로그인(`LoginFilter`)이 있으나 CSRF/XSS 대응은 JSP와 자바스크립트 레이어에서 추가 검증이 필요하다.

## 7. 참고 자료 및 후속 작업
- **추가 문서** : `MeetLog/README_Deploy.md`, `deployment-report.md`, `recommendation_metrics.md`, `todo_list.md`, `database/archive/MIGRATION_GUIDE.md` 등을 확인해 운영 절차와 데이터 마이그레이션 이력을 파악할 수 있다.
- **데이터 자산** : `meetlog_uploads/`, `database/uploads/`는 실제 이미지·CSV 등을 포함하므로 개인정보, 저작권 검토 필요.
- **ERP 연동** : `erpController`, `erpService`, `erpDto`가 분리돼 있으나 `semi-erp.sql`과 맞춰 사용해야 한다.
- **향후 개선 제안**
  1. 설정 분리: Spring Boot 또는 외부 설정 서버 도입, 비밀 정보 분리.
  2. 빌드 시스템 정비: Maven/Gradle로 재정비하고 `lib/` 수동 관리 제거.
  3. 테스트 자동화 및 CI 확장: JUnit, Selenium, API 테스트 추가.
  4. 추천 시스템 모니터링: `RecommendationMetricDAO` 기반 대시보드 구현.
  5. 정적 자산 빌드 파이프라인: Webpack/Vite 등 도입 시 프런트엔드 유지보수성 향상 가능.

이 문서는 저장소 구조와 주요 코드베이스를 빠르게 파악하고 유지보수·운영 계획을 수립하기 위한 기술 보고서이며, 새로운 협업자가 프로젝트 전반을 이해하는 초석으로 활용할 수 있다.

이 문서는 Claude Code로 구조와 주요 베이스 코드를 통해 정리하였습니다.








------------------------------------------------------------------------------------------

# MEETLOG README (English)

## 1. Project Overview

* **MEETLOG** is an integrated dining platform that provides restaurant discovery, course recommendations, reservations, payments, reviews, and community features.
* The core web application under `MeetLog/` is built with **Java 11 + JSP/Servlet + MyBatis**, packaged as a WAR file for **Tomcat 9** deployment.
* The separate microservice `kobert-api-server/` provides **FastAPI + KoBERT embeddings**, designed with a **Port/Adapter architecture** (`service.port.RecommendationPort`, `adapter.KoBertAdapter`) to reduce external AI dependencies.
* The repository includes deployment scripts, GitHub Actions automation, SQL schemas and migrations, uploaded assets, ERP submodules, and integrations with Telegram, KakaoPay, and NaverPay.

## 2. Repository Structure Summary

| Path                                                                | Description                                                                                                                                                                   |
| ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MeetLog/`                                                          | Main JSP/Servlet web application. Includes source (`src/`), resources (`resources/`), JSP views (`webapp/`), SQL (`database/`), scripts (`scripts/`), and libraries (`lib/`). |
| `kobert-api-server/`                                                | KoBERT-based embedding API using FastAPI. Includes `main.py`, `requirements.txt`, and virtual environment (`venv/`).                                                          |
| `Servers/`                                                          | Eclipse Tomcat 9 local server configuration (`server.xml`, `context.xml`).                                                                                                    |
| `meetlog_uploads/`                                                  | Local uploads and course thumbnails. Linked to `config.properties` (`upload.path`).                                                                                           |
| `mavenbackup/`, `MeetLog/maven_backup/`                             | Maven backup (`pom.xml`, `target/`) for manual build management.                                                                                                              |
| `deployment-report.md`, `recommendation_metrics.md`, `todo_list.md` | Deployment reports, recommendation metric definitions, and TODO lists.                                                                                                        |
| `MeetLog.zip`, `bin/`, `cookies.txt`                                | Legacy or temporary files — candidates for cleanup.                                                                                                                           |

### 2.1 Inside `MeetLog/`

* **`src/main/java/`**:

  * `controller/`, `controller/payment/`, `controller/telegram/`: Servlets for user, admin, business, ERP, and recommendation domains.
  * `service/`, `service/payment/`, `service/port/`: Business logic layer (e.g., `IntelligentRecommendationService`, `ReservationAutomationService`, `KakaoPayService`).
  * `dao/`: MyBatis DAOs corresponding to Mapper XMLs.
  * `model/`, `dto/`, `erpDto/`: Domain entities and DTOs for users, courses, coupons, ERP assets, etc.
  * `adapter/`: External service adapters (e.g., KoBERT API).
  * `util/`: Common utilities such as `AppConfig`, `EmailUtil`, `GooglePlacesUtil`, and batch jobs.
  * `filter/`, `listener/`, `typehandler/`: Encoding/auth filters, Telegram listeners, and JSON type handlers.

* **`src/main/resources/`**:

  * `mybatis-config.xml`, `db.properties`, `config.properties`, `api.properties`.
  * Mapper XMLs under `mappers/` and `erpMappers/`, separated by domain.
  * `logback.xml` defines SLF4J logging configuration.

* **`src/main/webapp/`**:

  * `WEB-INF/web.xml` for servlet mappings.
  * `WEB-INF/views/`: JSP views for user, admin, business, and error pages.
  * `css/`, `js/`, `img/`: Static resources (e.g., `main-optimized.js`, `click-protection.js`).

* **`database/`**:

  * Contains `master.sql`, migration files, and archives with SQL evolution history.

* **`scripts/`**:

  * `build-war.sh`: Builds WAR under `build/deploy/`.
  * `run-local.sh`: Local Tomcat deployment.
  * `deploy-war.sh`: Remote deployment automation.

* **`.github/workflows/deploy.yml`**: GitHub Actions CI/CD pipeline for build and deploy.

* **`README_Deploy.md`**: Instructions for deployment scripts and required secrets.

## 3. Core Systems

### 3.1 MEETLOG Web Application

#### 3.1.1 Tech Stack and Runtime

* **Java 11**, **JSP/Servlet 4.0**, **Tomcat 9**, deployed as a WAR archive.
* **MyBatis** (`util.MyBatisSqlSessionFactory`) connects to **MariaDB**.
* **SLF4J + Logback** for logging.
* **Lombok** dependency included but minimally used.
* External libraries stored in `lib/`, compiled via custom scripts.

#### 3.1.2 Layered Architecture

1. **Presentation**: `controller.*` Servlets handle HTTP requests and return JSP/JSON responses. Filters handle encoding and authentication.
2. **Service**: Encapsulates domain logic (reservations, payments, recommendations, notifications).
3. **DAO**: MyBatis data access classes using `SqlSession`.
4. **Model/DTO**: Domain and data transfer objects.
5. **Utilities**: Global configuration and helpers via `util.AppConfig`.

#### 3.1.3 Domain Features

* **Authentication**: Login, registration, password recovery, and social logins (Google/Naver/Kakao OAuth).
* **Restaurant Management**: CRUD for restaurants, menus, rankings, and courses.
* **Review & Community**: CRUD for reviews, comments, likes, and reports.
* **Reservations**: Automated approval, table assignment, and notifications.
* **Payments**: KakaoPay and NaverPay integrations with callbacks and manual confirmation.
* **Recommendations**: Hybrid model combining behavioral data, KoBERT embeddings, and trend analysis.
* **Notifications**: Email, Telegram bot, and web alerts.
* **Admin/Business Console**: Dashboards, reports, statistics, and ERP integration.

#### 3.1.4 Frontend Assets

* JSPs organized by domain under `WEB-INF/views`.
* JSTL + custom taglibs under `WEB-INF/tags/`.
* Static resources served under `/img/*`, `/css/*`, `/js/*`, `/uploads/*`.

#### 3.1.5 Data Layer

* `db.properties` stores DB credentials (should use environment variables in production).
* `api.properties` contains API keys and tokens (must be secured).
* `mybatis-config.xml` configures mappers and handlers.

#### 3.1.6 Batch & Background Tasks

* `TelegramPollerListener`: Daemon thread for polling.
* `VectorPrecomputeBatch`: CLI for precomputing restaurant vectors.
* `ReservationAutomationService`: Handles automated reservation workflows.

### 3.2 KoBERT Vectorization API (`kobert-api-server/`)

* FastAPI app exposing `/vectorize` endpoint.
* Loads `skt/kobert-base-v1` model with MPS/CUDA/CPU auto-detection.
* Generates 768-dim mean-pooled embeddings.
* Adapter retries API calls with exponential backoff.

### 3.3 Deployment & Infrastructure

* `build-war.sh`: Builds WAR.
* `deploy-war.sh`: Deploys WAR to remote Tomcat with environment variables.
* `run-local.sh`: Automates local Tomcat stop→deploy→start.
* GitHub Actions workflow automates CI/CD with SSH secrets.

### 3.4 Additional Assets

* `README_Deploy.md`, `deployment-report.md`, `recommendation_metrics.md`, `todo_list.md`.
* AI integration guides: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`.
* Design artifacts: `찐찐찐막.drawio`, `JSP정의서.xlsx`, `MEETLOG_요구사항정의서.docx`.

## 4. Development & Execution Guide

### 4.1 Prerequisites

1. JDK 11+
2. Apache Tomcat 9
3. MariaDB 10.x
4. Python 3.10+ (for KoBERT server)
5. Node.js not required (server-rendered JSP)

### 4.2 Database Setup

1. Create DB: `CREATE DATABASE meetlog DEFAULT CHARACTER SET utf8mb4;`
2. Import base schema: `database/master.sql`
3. Apply updates: `database/schema_updates.sql` and `migrations/*.sql`
4. Import sample data if needed.

### 4.3 Configuration Files

* `db.properties`: Database credentials.
* `config.properties`: Upload paths and Naver Pay settings.
* `api.properties`: API keys (must be secured externally).
* `AppConfig` auto-loads these on startup.

### 4.4 Running the KoBERT API Server

```bash
cd kobert-api-server
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

* Logs display GPU/MPS usage detection.
* Default endpoint: `http://127.0.0.1:8000/vectorize`.

### 4.5 Building and Running MEETLOG

1. Run `scripts/build-war.sh` → verify `build/deploy/MeetLog.war`.
2. Local run: `export TOMCAT_HOME=/path/to/tomcat && scripts/run-local.sh`.
3. Remote deploy: set `DEPLOY_HOST`, `DEPLOY_USER`, etc., and run `deploy-war.sh`.
4. GitHub Actions: Push to `main` to trigger build & deploy.

### 4.6 Operational Notes

* Ensure upload path permissions.
* Telegram bot must have valid token and open network access.
* SMTP credentials require secure management.
* Adjust `logback.xml` levels and remove `System.out` logs.
* Introduce JUnit-based testing (none currently present).

## 5. Architecture & Flow

### 5.1 Request Flow

1. HTTP request → `controller.*` servlet.
2. Filter processing (encoding, authentication).
3. Service layer executes business logic.
4. DAO executes MyBatis queries.
5. JSP or JSON response returned.

### 5.2 Recommendation Data Flow

1. User actions collected via `UserAnalyticsService`.
2. Restaurant vectors generated via KoBERT.
3. User vectors updated asynchronously.
4. `IntelligentRecommendationService` merges scores and ensures diversity.
5. Metrics logged in `RecommendationMetricDAO`.

### 5.3 Payment Flow

1. User selects method.
2. KakaoPay: Ready API → redirect → callback → approval.
3. NaverPay: API call → callback → status update.
4. Failures handled by manual confirmation or alerts.

### 5.4 Notification & Telegram Flow

1. User requests `/telegram/link`.
2. Bot activation via `/start <token>`.
3. Reservation events trigger alerts via `NotificationService`.
4. Failures logged via `TelegramMessageLogDAO`.

## 6. Quality & Security Considerations

* **Secrets Management**: Move credentials to environment variables or secret managers.
* **Artifacts Cleanup**: Exclude build results and virtual envs via `.gitignore`.
* **Logging**: Replace plain prints with structured logging.
* **Concurrency**: Tune thread pools for recommendation services.
* **Daemon Threads**: Ensure graceful shutdown of background listeners.
* **Testing**: Add unit and integration tests.
* **Security**: Improve CSRF/XSS protections.

## 7. References & Future Work

* **Documents**: `README_Deploy.md`, `deployment-report.md`, `recommendation_metrics.md`, `MIGRATION_GUIDE.md`.
* **Data Assets**: Review uploads for privacy or copyright issues.
* **ERP Integration**: Use `semi-erp.sql` schema alignment.

### Recommended Improvements

1. **Config Separation**: Adopt Spring Boot or external config servers.
2. **Build System**: Transition to Maven/Gradle fully.
3. **Testing & CI**: Add automated tests.
4. **Recommendation Monitoring**: Build dashboard from metric logs.
5. **Frontend Pipeline**: Introduce Webpack/Vite for better maintenance.

---

This document provides a comprehensive technical overview of MEETLOG, enabling new collaborators to quickly understand the repository structure, architecture, and operational procedures for further development and maintenance.
