# Phase 6: 코스 시스템 마이그레이션 - 완료 현황

## 개요
JSP/Servlet 기반의 코스(Course) 시스템을 Spring Boot + React로 마이그레이션

**완료일**: 2025-10-22
**상태**: ✅ 100% 완료

---

## 1. 백엔드 구현 (Spring Boot)

### 1.1 Entity Layer
**파일 위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/model/`

#### ✅ Course.java (75 lines)
- 데이터베이스 `courses` 테이블과 매핑
- 필드:
  - `courseId` (PK)
  - `title`, `description`, `area`, `duration`
  - `price`, `maxParticipants`
  - `status` (PENDING, ACTIVE, COMPLETED, CANCELLED)
  - `type` (OFFICIAL, COMMUNITY)
  - `previewImage`, `authorId`, `createdAt`
- Helper Methods:
  - `isActive()`, `isPending()`, `isOfficialCourse()`, `isCommunityCourse()`
  - `isOwnedBy(userId)`, `canEdit(userId)`, `canCancel()`
  - `getTypeText()`, `getStatusText()`, `isFree()`, `hasLimit()`

#### ✅ CourseStep.java (61 lines)
- 데이터베이스 `course_steps` 테이블과 매핑
- 필드:
  - `stepId` (PK), `courseId` (FK)
  - `stepOrder`, `stepType`, `emoji`, `name`
  - `latitude`, `longitude`, `address`
  - `description`, `image`
  - `time` (소요 시간, 분), `cost` (예상 비용, 원)
- Helper Methods:
  - `hasLocation()`, `hasAddress()`, `hasImage()`
  - `isFree()`, `hasTime()`
  - `getTimeText()` (예: "2시간 30분")
  - `getCostText()` (예: "2만원")
  - `isValid()` (위치 정보 포함 여부 검증)

---

### 1.2 DTO Layer
**파일 위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/dto/course/`

#### ✅ CourseDto.java
- Course 응답 DTO
- 기본 필드 + 추가 정보:
  - `authorName`, `authorNickname`
  - `likesCount`, `commentsCount`, `reservationsCount`
  - `isLiked` (현재 사용자의 좋아요 여부)
  - `steps` (List<CourseStepDto>)
  - `tags` (List<String>)

#### ✅ CourseStepDto.java
- CourseStep 응답 DTO
- 모든 단계 정보 포함 (위치, 시간, 비용 등)

#### ✅ CourseCreateRequest.java
- 코스 생성/수정 요청 DTO
- Validation 포함:
  - `@NotBlank` title
  - `@Size` 제약 (title 255자, description 2000자 등)
  - `@Pattern` type (OFFICIAL|COMMUNITY)
  - `@NotEmpty` steps (최소 1개 이상)
- 내부 클래스: `CourseStepCreateRequest`
  - `@NotNull` latitude, longitude
  - `@DecimalMin/@DecimalMax` 위도/경도 범위 검증

#### ✅ CourseSearchRequest.java
- 코스 검색 요청 DTO
- 필터 옵션:
  - `keyword` (제목, 설명 검색)
  - `area`, `type`, `status`, `authorId`
  - `minPrice`, `maxPrice`
  - `tag` (태그 필터)
  - `sortBy`, `sortOrder`
  - `page`, `size` (페이징)

---

### 1.3 Repository Layer
**파일 위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/repository/`

#### ✅ CourseRepository.java (인터페이스)
MyBatis `@Mapper` 인터페이스, 주요 메서드:

**Course CRUD**:
- `findById(id)`, `findDtoById(id, userId)`
- `search(request, userId)`, `countSearch(request)`
- `insert(course)`, `update(course)`, `delete(id)`
- `updateStatus(id, status)`, `findByAuthorId(authorId, page, size)`

**CourseStep CRUD**:
- `findStepById(stepId)`, `findStepsByCourseId(courseId)`
- `insertStep(step)`, `updateStep(step)`, `deleteStep(stepId)`
- `deleteStepsByCourseId(courseId)`

**Tags**:
- `findTagsByCourseId(courseId)`, `findOrCreateTag(name)`
- `insertTag(name)`, `linkTag(courseId, tagId)`, `unlinkTags(courseId)`

**Likes**:
- `countLikes(courseId)`, `isLikedByUser(courseId, userId)`
- `insertLike(courseId, userId)`, `deleteLike(courseId, userId)`

**Statistics**:
- `countReservations(courseId)`, `countComments(courseId)`

#### ✅ CourseRepositoryMapper.xml (350+ lines)
**파일 위치**: `MeetLog-SpringBoot/src/main/resources/mappers/`

- **Result Maps**: `CourseResultMap`, `CourseDtoResultMap`, `CourseStepResultMap`
- **검색 쿼리**:
  - 동적 WHERE 절 (keyword, area, type, status, authorId, price 범위, tag)
  - JOIN: `users` (작성자 정보), 서브쿼리 (좋아요/댓글/예약 수)
  - 정렬: created_at/price/title, ASC/DESC
  - 페이징: LIMIT/OFFSET
- **태그 관리**: `tags` 테이블 + `course_tags` 다대다 조인
- **좋아요**: `course_likes` 테이블, `INSERT IGNORE` (중복 방지)

---

### 1.4 Service Layer
**파일 위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/service/`

#### ✅ CourseService.java (270+ lines)
주요 메서드:

1. **searchCourses(request, userId)**
   - 페이징 처리 (기본 page=1, size=10)
   - 각 코스의 steps와 tags 로드
   - 반환: `{ courses, currentPage, totalPages, totalCount, pageSize }`

2. **getCourse(id, userId)**
   - 단일 코스 상세 조회
   - steps, tags 포함
   - userId로 `isLiked` 판단

3. **getMyCourses(userId, page, size)**
   - 작성자별 코스 목록

4. **createCourse(request, userId)**
   - `@Transactional`
   - 코스 저장 → steps 저장 → tags 저장
   - tags: `findOrCreateTag()` 사용 (없으면 생성)

5. **updateCourse(id, request, userId)**
   - 권한 체크: `course.canEdit(userId)`
   - 기존 steps 삭제 후 재생성
   - 기존 tags 연결 삭제 후 재생성

6. **deleteCourse(id, userId)**
   - 권한 체크: `course.isOwnedBy(userId)`
   - CASCADE DELETE로 steps, tags, likes 자동 삭제

7. **updateStatus(id, status)** (관리자용)

8. **likeCourse(id, userId)**, **unlikeCourse(id, userId)**
   - 중복 체크 후 좋아요 추가/제거

---

### 1.5 Controller Layer
**파일 위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/controller/`

#### ✅ CourseController.java (140+ lines)
REST API 엔드포인트:

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/api/courses` | 코스 검색 | Optional |
| GET | `/api/courses/{id}` | 코스 상세 조회 | Optional |
| GET | `/api/courses/my` | 내 코스 목록 | Required |
| POST | `/api/courses` | 코스 생성 | Required |
| PUT | `/api/courses/{id}` | 코스 수정 | Required (owner) |
| DELETE | `/api/courses/{id}` | 코스 삭제 | Required (owner) |
| PATCH | `/api/courses/{id}/status` | 상태 변경 | Admin |
| POST | `/api/courses/{id}/like` | 좋아요 | Required |
| DELETE | `/api/courses/{id}/like` | 좋아요 취소 | Required |

**보안**:
- `@PreAuthorize("isAuthenticated()")` 인증 필요
- `@PreAuthorize("hasRole('ADMIN')")` 관리자 전용
- `CustomUserDetails`로 현재 사용자 정보 주입

**Swagger 문서화**:
- `@Tag(name = "Course")`
- `@Operation(summary = "...")`

---

## 2. 프론트엔드 구현 (React)

### 2.1 API Client
**파일 위치**: `meetlog-frontend/src/api/course.js`

#### ✅ courseAPI (60+ lines)
axios 기반 API 클라이언트:
- `search(params)` - 검색 (필터, 페이징)
- `getById(id)` - 상세 조회
- `getMyCourses(page, size)` - 내 코스
- `create(courseData)` - 생성
- `update(id, courseData)` - 수정
- `delete(id)` - 삭제
- `like(id)`, `unlike(id)` - 좋아요 토글

---

### 2.2 Components
**파일 위치**: `meetlog-frontend/src/components/course/`

#### ✅ CourseForm.jsx (420+ lines)
코스 생성/수정 폼 컴포넌트

**주요 기능**:
1. **기본 정보**:
   - 제목, 설명, 지역, 소요 시간
   - 가격, 최대 참가자, 타입 (OFFICIAL/COMMUNITY)

2. **태그 관리**:
   - 입력 필드 + 추가 버튼
   - Enter 키로 추가
   - 태그 삭제 기능 (×)

3. **코스 단계 관리**:
   - 동적 단계 추가/삭제
   - 각 단계별 입력:
     - 장소명, 이모지
     - 위도/경도 (필수)
     - 주소, 설명
     - 소요 시간 (분), 예상 비용 (원)
   - 순서 자동 재정렬 (삭제 시)

4. **Validation**:
   - 최소 1개 이상의 단계 필요
   - 위도/경도 필수 체크

5. **상태 관리**:
   - `loading` 상태 (저장 중 버튼 비활성화)
   - `error` 상태 (에러 메시지 표시)

#### ✅ CourseCard.jsx (190+ lines)
코스 카드 컴포넌트 (목록/그리드용)

**표시 정보**:
- **헤더**: 제목, 상태 뱃지, 타입 뱃지, 작성자
- **설명**: 설명 (최대 2줄, `line-clamp-2`)
- **정보 그리드**:
  - 지역, 소요 시간
  - 예상 비용 (steps의 cost 합계 또는 course.price)
  - 단계 수
- **경로 미리보기**:
  - 처음 5개 단계 (이모지 + 이름)
  - 화살표(→)로 연결
  - 5개 초과 시 "+N" 표시
- **태그**: `#태그` 형식 (파란색 뱃지)
- **통계**: 좋아요, 댓글, 예약 수

**인터랙션**:
- **좋아요 버튼**: ❤️/🤍 토글, 실시간 카운트 업데이트
- **작성자 전용**: 수정/삭제 버튼 (본인만 표시)

**헬퍼 함수**:
- `getStatusColor()`, `getStatusText()`, `getTypeText()`
- `formatTime()` (분 → "2시간 30분")
- `formatCost()` (원 → "2.5만원")

#### ✅ CourseList.jsx (130+ lines)
코스 목록 컴포넌트

**기능**:
1. **데이터 로딩**:
   - `useEffect`로 filters 변경 시 자동 재조회
   - 로딩 상태 표시
   - 빈 목록 안내 메시지

2. **페이징**:
   - 이전/다음 버튼
   - 페이지 번호 버튼 (현재 ±2 범위만 표시)
   - 중간 생략 표시 (`...`)
   - 전체 개수 표시

3. **CRUD 핸들러**:
   - `handleUpdate(course)` - 수정 (부모로 전달)
   - `handleDelete()` - 삭제 후 목록 새로고침

4. **props**:
   - `filters` - 검색/필터 조건 (keyword, area, type 등)

---

## 3. 데이터베이스 스키마

### 3.1 courses 테이블
```sql
CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL,
  `duration` varchar(100) DEFAULT NULL,
  `price` int(11) DEFAULT 0,
  `max_participants` int(11) DEFAULT 0,
  `status` enum('PENDING','ACTIVE','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `type` enum('OFFICIAL','COMMUNITY') DEFAULT 'COMMUNITY',
  `preview_image` varchar(1000) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 3.2 course_steps 테이블
```sql
CREATE TABLE `course_steps` (
  `step_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `step_order` int(11) NOT NULL DEFAULT 0,
  `step_type` varchar(100) DEFAULT NULL,
  `emoji` varchar(10) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL COMMENT '위도',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT '경도',
  `address` varchar(500) DEFAULT NULL COMMENT '주소',
  `description` text DEFAULT NULL,
  `image` varchar(1000) DEFAULT NULL,
  `time` int(11) DEFAULT 0 COMMENT '소요 시간 (분)',
  `cost` int(11) DEFAULT 0 COMMENT '예상 비용 (원)',
  PRIMARY KEY (`step_id`),
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `course_steps_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 3.3 관련 테이블
- **tags** - 태그 마스터 테이블 (tag_id, name)
- **course_tags** - 다대다 조인 테이블 (course_id, tag_id)
- **course_likes** - 좋아요 (course_id, user_id)
- **course_comments** - 댓글 (comment_id, course_id, user_id, content, like_count, is_active)
- **course_reservations** - 예약 (reservation_id, course_id, user_id, status, etc.)

---

## 4. 주요 기능 요약

### ✅ 코스 관리
- 코스 생성/수정/삭제 (작성자 권한 체크)
- 다단계 경로 구성 (위치, 시간, 비용 포함)
- 이미지, 태그 지원
- 상태 관리 (PENDING/ACTIVE/COMPLETED/CANCELLED)

### ✅ 검색 & 필터
- 키워드 검색 (제목, 설명)
- 지역, 타입, 상태, 작성자 필터
- 가격 범위 필터
- 태그 필터
- 정렬 (날짜/가격/제목, ASC/DESC)
- 페이징

### ✅ 소셜 기능
- 좋아요/좋아요 취소
- 댓글 (별도 시스템)
- 예약 (별도 시스템)

### ✅ 태그 시스템
- 다대다 관계 (course_tags)
- 자동 태그 생성 (findOrCreateTag)
- 프론트엔드에서 동적 추가/삭제

### ✅ 위치 기반
- 각 단계별 위도/경도 저장
- 주소 정보 저장
- 카카오맵 연동 준비 (프론트엔드)

---

## 5. 기술 스택

### Backend
- **Framework**: Spring Boot 2.7.18
- **ORM**: MyBatis 3.0.0
- **Database**: MariaDB
- **Security**: Spring Security + JWT
- **Validation**: javax.validation
- **Documentation**: SpringDoc OpenAPI (Swagger)

### Frontend
- **Framework**: React 18
- **HTTP Client**: Axios
- **Styling**: Tailwind CSS
- **State Management**: React Hooks (useState, useEffect)
- **Context**: AuthContext (인증)

---

## 6. 다음 단계 (Phase 7 이후)

### Phase 7: 결제 시스템
- 토스페이먼츠/카카오페이 연동
- 예치금(deposit) 처리
- 환불 로직

### Phase 8: 관리자/비즈니스 대시보드
- 통계 차트
- 코스 승인 시스템 (PENDING → ACTIVE)
- 예약 관리

### Phase 9: 알림/소셜 기능
- 실시간 알림
- 팔로우 시스템
- 피드 통합

### Phase 10: 배포/최적화
- Docker 컨테이너화
- CI/CD 파이프라인
- 성능 최적화 (쿼리, 캐싱)

---

## 7. 테스트 시나리오

### API 테스트 (Swagger)
1. **코스 생성**:
   - POST `/api/courses`
   - Body: title, description, steps (최소 1개), tags

2. **코스 검색**:
   - GET `/api/courses?keyword=강남&type=COMMUNITY&page=1`

3. **코스 좋아요**:
   - POST `/api/courses/{id}/like`
   - 재실행 시 "Already liked" 에러 확인

4. **내 코스 조회**:
   - GET `/api/courses/my`
   - Authorization 헤더 필요

### UI 테스트
1. CourseList 페이지에서 검색/필터 적용
2. CourseCard 클릭 → 상세 페이지 이동
3. 로그인 후 "새 코스 만들기" 버튼 클릭
4. CourseForm에서 단계 3개 추가 후 저장
5. 생성된 코스에서 좋아요 클릭 → 카운트 증가 확인

---

## 8. 완료 체크리스트

- [x] Course, CourseStep 엔티티 생성
- [x] DTO 생성 (CourseDto, CourseCreateRequest, CourseSearchRequest)
- [x] Repository 인터페이스 + MyBatis Mapper XML
- [x] CourseService 비즈니스 로직 (CRUD, 검색, 좋아요)
- [x] CourseController REST API (9개 엔드포인트)
- [x] 프론트엔드 API 클라이언트 (course.js)
- [x] CourseForm 컴포넌트 (생성/수정)
- [x] CourseCard 컴포넌트 (카드 표시)
- [x] CourseList 컴포넌트 (목록 + 페이징)
- [x] 태그 시스템 (다대다 관계)
- [x] 좋아요 기능
- [x] 검색/필터/정렬
- [x] 권한 체크 (작성자/관리자)

---

**완료!** Phase 6의 모든 작업이 성공적으로 완료되었습니다. 🎉

이제 MeetLog의 코스 시스템이 완전히 현대적인 Spring Boot + React 아키텍처로 마이그레이션되었습니다.
