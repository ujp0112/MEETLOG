# MeetLog Spring Boot API

## 프로젝트 정보

- **이름**: MeetLog Spring Boot REST API
- **버전**: 1.0.0
- **Java**: 11
- **Spring Boot**: 2.7.18
- **빌드 도구**: Maven
- **데이터베이스**: MariaDB 10.x

## 빌드 및 실행

### 사전 요구사항

- Java JDK 11 이상
- MariaDB 10.x (포트 3306)
- 데이터베이스 `meetlog` 생성

### 빌드

```bash
# Maven이 설치된 경우
mvn clean package

# Maven Wrapper 사용 (권장)
./mvnw clean package
```

### 실행

```bash
# 개발 환경
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# JAR 파일 실행
java -jar target/MeetLog-SpringBoot-1.0.0.jar --spring.profiles.active=dev
```

### API 문서

애플리케이션 실행 후 아래 URL에서 API 문서를 확인할 수 있습니다:

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI JSON**: http://localhost:8080/api-docs

### Health Check

```bash
curl http://localhost:8080/api/health
```

## 프로젝트 구조

```
src/main/java/com/meetlog/
├── MeetLogApplication.java   # 메인 애플리케이션
├── config/                    # 설정 클래스
│   ├── SecurityConfig.java    # Spring Security 설정
│   ├── SwaggerConfig.java     # Swagger/OpenAPI 설정
│   └── WebConfig.java         # Web MVC 설정
├── controller/                # REST 컨트롤러
├── service/                   # 비즈니스 로직
├── repository/                # 데이터 접근 레이어
├── model/                     # Entity 모델
├── dto/                       # Data Transfer Objects
├── exception/                 # 예외 처리
├── security/                  # 보안 관련 (JWT 등)
├── util/                      # 유틸리티
└── typehandler/               # MyBatis TypeHandler

src/main/resources/
├── application.yml            # 기본 설정
├── application-dev.yml        # 개발 환경 설정
├── application-prod.yml       # 프로덕션 환경 설정
├── mybatis-config.xml         # MyBatis 설정
├── mappers/                   # MyBatis Mapper XML
└── erpMappers/                # ERP Mapper XML
```

## 환경 변수

### 개발 환경

```bash
export SPRING_PROFILES_ACTIVE=dev
```

### 프로덕션 환경 (필수 설정)

```bash
export SPRING_PROFILES_ACTIVE=prod
export DB_URL=jdbc:mariadb://your-db-host:3306/meetlog
export DB_USERNAME=your-username
export DB_PASSWORD=your-password
export JWT_SECRET=your-secret-key-min-256-bits
export MAIL_USERNAME=your-email@gmail.com
export MAIL_PASSWORD=your-app-password
```

## 다음 단계

- **Phase 2**: JWT 인증 시스템 구현
- **Phase 3**: 레스토랑 도메인 API 구현
- **Phase 4**: 리뷰 시스템 API 구현
- **Phase 5**: 예약 시스템 API 구현

## 참고 문서

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [MyBatis Spring Boot Starter](https://mybatis.org/spring-boot-starter/)
- [SpringDoc OpenAPI](https://springdoc.org/)
