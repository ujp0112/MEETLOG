# MEETLOG 배포 실행 보고서

본 문서는 현재 저장소(`/Users/sangwoolee/MEETLOG/MEETLOG/MeetLog`)에 있는 MEETLOG 웹 애플리케이션을 운영 환경에 배포한다는 가정하에, 준비부터 검증까지 필요한 절차를 따라 할 수 있도록 정리한 보고서입니다. Maven 없이 수동 패키징하는 흐름을 기준으로 작성했습니다.

---

## 1. 프로젝트 및 환경 요약
- 애플리케이션 유형: Java 11 기반 JSP/Servlet + MyBatis 다이나믹 웹 프로젝트
- 배포 형태: WAR(또는 Tomcat Exploded 디렉터리)
- 소스 경로: `src/main/java`, 정적/뷰: `src/main/webapp`, 리소스: `src/main/resources`
- 컴파일 산출물: `build/classes`, 의존 라이브러리: `lib/*.jar`
- 데이터베이스: MariaDB (예시 DB명 `meetlog`)
- 외부 연동: Kakao, Naver, Google OAuth, Telegram 등(API 키 필요)

---

## 2. 서버 사전 준비 체크리스트
아래 항목을 운영 서버에서 순서대로 준비합니다.

1. OS 패치 및 사용자
   - 보안 업데이트 적용
   - 비밀번호 대신 SSH 키 기반 접속 구성
   - 배포/애플리케이션 전용 계정 생성(예: `meetlog`)
2. 필수 소프트웨어 설치
   - OpenJDK 11
   - Apache Tomcat 9.x
   - MariaDB 10.5 이상
   - `zip`, `unzip`, `tar`, `curl`, `rsync` 등 기본 도구
3. 서버 디렉터리 구조 예시
   - 애플리케이션: `/opt/meetlog/app`
   - 설정/비밀값: `/opt/meetlog/config`
   - 업로드 파일: `/opt/meetlog/uploads`
   - 로그: `/var/log/meetlog`
4. 방화벽·보안 그룹
   - 80/443(Nginx 등 프록시), 8080(Tomcat), 3306(DB) 등 외부 노출 포트를 정책에 맞춰 허용
   - DB는 가급적 내부망만 접근 허용
5. 시스템 서비스 준비
   - Tomcat을 `systemd` 서비스로 등록
   - 장애 시 자동 재시작 옵션 설정

---

## 3. 애플리케이션 설정 정리

### 3.1 민감정보 외부화
프로젝트 내 리소스 파일은 개발 기본값만 남기고, 운영 값은 서버에서 별도로 제공하도록 합니다.
- DB 접속 정보: `src/main/resources/db.properties`
- 파일 업로드 루트: `src/main/resources/config.properties`
- 외부 API 키: `src/main/resources/api.properties`
- 로그 설정: `src/main/resources/logback.xml`

운영 환경에서는 위 파일을 WAR 외부 경로(예: `/opt/meetlog/config`)에 두고, Tomcat 실행 시 JVM 옵션으로 경로를 주입합니다.

```bash
# /opt/tomcat/bin/setenv.sh 예시
JAVA_OPTS="$JAVA_OPTS -Dmeetlog.conf=/opt/meetlog/config"
JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=prod"
```

애플리케이션 코드에서는 `System.getProperty("meetlog.conf")` 등을 이용해 외부 파일을 읽도록 수정하거나, `WEB-INF/classes`에 심볼릭 링크를 두는 방식 중 한 가지를 선택합니다.

### 3.2 업로드/로그 디렉터리
- 운영 서버에서 `/opt/meetlog/uploads` 생성 후 Tomcat 실행 계정에게 읽기/쓰기 권한 부여
- `logback.xml`에서 파일 경로를 `/var/log/meetlog/meetlog.log` 등의 운영 경로로 변경
- 로그 로테이션 정책(예: logrotate) 등록

---

## 4. 데이터베이스 준비 절차

1. MariaDB 설치 및 보안 설정(`mysql_secure_installation`)
2. 운영 DB/계정 생성

```sql
CREATE DATABASE meetlog CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'meetlog'@'%' IDENTIFIED BY '강력한비밀번호';
GRANT ALL PRIVILEGES ON meetlog.* TO 'meetlog'@'%';
FLUSH PRIVILEGES;
```

3. 스키마 및 데이터 마이그레이션 적용
   - `database/master.sql`
   - `database/schema_updates.sql`
   - 기타 필요한 스크립트(`database/semi-erp.sql`, `database/erp_schema.sql` 등) 순으로 검토

```bash
mysql -u meetlog -p meetlog < database/master.sql
mysql -u meetlog -p meetlog < database/schema_updates.sql
```

4. 초기 운영 데이터를 삽입해야 한다면 별도 SQL 파일을 작성해 동일한 방식으로 적용
5. 정기 백업/복구 절차 문서화(MySQL Dump, PITR 등)

---

## 5. 로컬 빌드 및 검증

1. 최신 소스 동기화 후 클린 빌드
   - IDE에서 `Project Clean` 또는 `Rebuild`
   - 수동 빌드 스크립트 예시:

```bash
#!/bin/bash
cd /Users/sangwoolee/MEETLOG/MEETLOG/MeetLog
rm -rf build/classes
mkdir -p build/classes

find src/main/java -name "*.java" > sources.txt
javac \
  -encoding UTF-8 \
  -cp "lib/*:src/main/resources" \
  -d build/classes \
  @sources.txt

rm sources.txt
```

2. 단위 테스트 또는 기본 통합 테스트를 수동으로 실행(현재 프로젝트에 테스트 코드가 적을 가능성이 있으므로 주요 서비스 로직에 대한 간이 테스트 작성 권장)
3. 로컬 Tomcat(또는 IDE 내장 서버)에서 구동하여 핵심 기능 스모크 테스트

---

## 6. 배포 아티팩트(WAR) 구성

1. 임시 디렉터리 준비

```bash
DEPLOY_DIR=/Users/sangwoolee/MEETLOG/MEETLOG/MeetLog/deploy/MeetLog
rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR/WEB-INF/classes"
mkdir -p "$DEPLOY_DIR/WEB-INF/lib"
```

2. 웹 리소스 복사

```bash
cp -R src/main/webapp/* "$DEPLOY_DIR/"
```

3. 클래스 및 리소스 복사

```bash
cp -R build/classes/* "$DEPLOY_DIR/WEB-INF/classes/"
cp -R src/main/resources/* "$DEPLOY_DIR/WEB-INF/classes/"
```

4. 라이브러리 복사

```bash
cp lib/*.jar "$DEPLOY_DIR/WEB-INF/lib/"
```

5. WAR 패키징

```bash
cd /Users/sangwoolee/MEETLOG/MEETLOG/MeetLog/deploy
jar cvf MeetLog.war -C MeetLog .
```

6. 결과 검증
   - `jar tf MeetLog.war | head`로 구조 확인
   - `WEB-INF/lib` 및 `WEB-INF/classes`에 필요한 파일이 모두 포함됐는지 점검
   - 운영 환경 설정 파일은 제거했는지 또는 더미 값으로 교체했는지 확인

---

## 7. 운영 서버 배포 절차

1. 아티팩트/설정 전송

```bash
scp deploy/MeetLog.war user@server:/opt/meetlog/app/
scp -r config/prod/* user@server:/opt/meetlog/config/
```

2. Tomcat 준비
   - 기존 애플리케이션 중지: `sudo systemctl stop tomcat`
   - 업로드 경로 존재 확인: `/opt/meetlog/uploads`
   - 설정 파일 권한 조정: `chown -R tomcat:tomcat /opt/meetlog`

3. 배포 방법 선택
   - **WAR 배포**: `/opt/tomcat/webapps/MeetLog.war`로 복사 후 Tomcat 시작
   - **Exploded 배포**: `/opt/tomcat/conf/server.xml`에 `<Context path="" docBase="/opt/meetlog/app/MeetLog" />` 추가 후 디렉터리 구조 유지

4. Tomcat 재시작 및 로그 확인

```bash
sudo systemctl start tomcat
tail -f /opt/tomcat/logs/catalina.out
```

5. 리버스 프록시 사용 시 설정 예시(Nginx)

```nginx
server {
    listen 80;
    server_name meetlog.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080/;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
    }
}
```

---

## 8. 배포 후 검증 체크리스트

1. 헬스체크 및 주요 페이지 접근
   - `/login`, `/main`, 관리자 기능 등 핵심 화면
2. API 호출 테스트
   - 결제, 예약, 추천 등 주요 API 엔드포인트
3. 데이터베이스 확인
   - 신규/업데이트 데이터가 정상 반영되는지 확인
4. 로그 점검
   - `catalina.out`, 애플리케이션 로그, DB 로그
5. 외부 연동 테스트
   - Kakao/Naver 로그인, Telegram 알림 등 실 계정으로 검증
6. 모니터링/알림
   - 서버 자원 사용량(CPU, 메모리, 디스크)
   - 예외/에러 발생 시 알림 채널 슬랙·이메일·SMS 등 확인

체크리스트를 표 형태로 관리하면서 각 항목 완료 여부와 담당자를 기록하는 것을 권장합니다.

---

## 9. 운영 및 유지보수 사항

- **배포 자동화**: 추후 GitHub Actions 등으로 빌드/패키징/전송을 자동화하고, 성공 시 알림을 받도록 개선
- **롤백 전략**: 직전 버전 WAR 및 DB 백업을 보관하고, 문제가 생기면 즉시 되돌릴 수 있는 절차를 마련
- **보안 관리**: 비밀값은 비밀 관리 도구(예: AWS Secrets Manager, HashiCorp Vault) 사용 검토
- **로그/모니터링**: ELK/EFK 스택이나 클라우드 모니터링 도구로 중앙집중화
- **성능 관리**: JVM 힙 크기 조정, 커넥션 풀 설정, 캐시 구성 등을 주기적으로 점검
- **문서화**: 배포 이력, 설정 변경 사항, 비상 연락망 등을 공유 저장소(Wiki, Notion 등)에 정리

---

## 10. 부록

### 10.1 디렉터리 구조 개요

```
MeetLog/
├── build/classes              # 컴파일된 클래스
├── lib/                       # 외부 라이브러리 JAR
├── src/main/java              # Java 소스
├── src/main/resources         # 설정/리소스
├── src/main/webapp            # JSP, 정적 리소스, WEB-INF
└── database/                  # DB 스크립트
```

### 10.2 자주 사용하는 명령 모음

```bash
# WAR 압축 해제 확인
jar tf MeetLog.war | head

# Tomcat 로그 tail
tail -f /opt/tomcat/logs/catalina.out

# MariaDB 접속
mysql -h 127.0.0.1 -u meetlog -p meetlog

# 업로드 디렉터리 권한 설정
chown -R tomcat:tomcat /opt/meetlog/uploads
chmod 750 /opt/meetlog/uploads
```

### 10.3 문제 발생 시 대응 요령
- 서비스 비정상: Tomcat 로그에서 스택 트레이스 확인 후 필요 시 이전 WAR로 롤백
- DB 연결 오류: 방화벽, 계정 권한, `db.properties` 값 재확인
- 외부 API 실패: 해당 서비스 대시보드 및 인증 정보 확인, 재발급 여부 점검
- 업로드 실패: 업로드 경로 권한, 디스크 용량 확인

---

위 순서를 따라 진행하면 현재 프로젝트 상태에서 운영 배포를 수행할 수 있습니다. 실제 환경에 맞게 디렉터리나 계정 이름을 조정하고, 추가 요구사항(SSL, 무중단 배포, 컨테이너화 등)이 있다면 별도 절차를 확장하세요.
