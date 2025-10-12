# MEETLOG

Java 11 기반 JSP/Servlet 애플리케이션.

## 배포 자동화 개요

프로젝트 루트에 배포용 스크립트와 GitHub Actions 워크플로가 추가되어 있습니다.

- `scripts/build-war.sh`  
  - `lib/`에 있는 의존 JAR을 포함해 소스를 컴파일하고 `build/deploy/MeetLog.war`를 생성합니다.  
  - 요구 사항: JDK 11 이상, `rsync`, `jar`.
- `scripts/deploy-war.sh`  
  - 생성된 WAR을 지정한 Tomcat 서버로 `scp` 전송하고, 서비스 중단→배포→기동까지 원격에서 처리합니다.  
  - 요구 사항: `ssh`, `scp`, 원격 서버 접근 권한.
- `.github/workflows/deploy.yml`  
  - `main` 브랜치 푸시 및 수동 실행 시 동작합니다.  
  - 워크플로는 빌드 잡에서 WAR을 만들고, 이어지는 배포 잡에서 동일 스크립트를 호출합니다.

## 로컬 배포 플로우

1. JDK 11 이상이 설치되어 있고 `javac`/`jar`가 PATH에 노출되어 있는지 확인합니다.
2. `scripts/build-war.sh` 실행 → `build/deploy/MeetLog.war` 생성 확인.
3. 로컬 Tomcat 실행만 필요하다면 `TOMCAT_HOME`을 Tomcat 설치 경로로 지정하고 `scripts/run-local.sh`를 실행하세요. (예: `export TOMCAT_HOME=/usr/local/opt/tomcat@9/libexec` 또는 `export TOMCAT_HOME=/Users/사용자명/apache-tomcat-9.0.109`).
   - 스크립트가 Tomcat을 중지하려 할 때 이미 꺼져 있다면 `Connection refused` 로그가 뜰 수 있지만 무시해도 됩니다.
   - 로그는 `$TOMCAT_HOME/logs/catalina.out`에서 확인할 수 있습니다.
4. 원격 서버로 전송하려면 필요한 환경 변수를 설정하고 `scripts/deploy-war.sh` 실행.

필수 환경 변수:

- `DEPLOY_HOST` – 원격 서버 주소 (예: `prod.example.com`)
- `DEPLOY_USER` – SSH 사용자 (Tomcat을 중지/시작할 권한 필요)
- `DEPLOY_TARGET_DIR` – Tomcat `webapps` 디렉터리 경로 (예: `/opt/tomcat/webapps`)

선택 환경 변수(없으면 기본값 사용):

- `DEPLOY_PORT` – SSH 포트 (기본 22)
- `REMOTE_WAR_NAME` – 원격에 배포할 WAR 파일명 (기본 `MeetLog.war`)
- `REMOTE_CONTEXT_NAME` – 전개 디렉터리 이름 (기본 `REMOTE_WAR_NAME`에서 `.war` 제거)
- `TOMCAT_SERVICE` – `systemctl` 서비스 이름 (기본 `tomcat`, 빈 값이면 stop/start 생략)
- `REMOTE_USE_SUDO` – `systemctl`/`rm`/`mv`에 `sudo` 사용 여부 (`1` 기본)
- `REMOTE_OWNER` / `REMOTE_GROUP` – WAR 소유자/그룹 지정
- `SSH_KEY_PATH` – SSH 프라이빗 키 경로 (없으면 에이전트/기본 키 사용)
- `SSH_OPTIONS` – 추가 SSH 옵션 문자열 (예: `-o StrictHostKeyChecking=no`)

## GitHub Actions 설정

`.github/workflows/deploy.yml`은 다음 시크릿을 기대합니다.

필수:

- `DEPLOY_HOST`
- `DEPLOY_USER`
- `DEPLOY_KEY` – OpenSSH 형식의 개인 키
- `DEPLOY_TARGET_DIR`

선택:

- `DEPLOY_PORT`
- `REMOTE_WAR_NAME`
- `REMOTE_CONTEXT_NAME`
- `TOMCAT_SERVICE`
- `REMOTE_OWNER`
- `REMOTE_GROUP`
- `SSH_OPTIONS`

원격 서버 측 준비 사항:

- Tomcat이 `DEPLOY_TARGET_DIR`에 WAR 교체만으로 재배포되도록 설정되어 있어야 합니다.
- `DEPLOY_USER`는 해당 디렉터리 쓰기 권한과 `systemctl`(또는 동등) 실행 권한을 가져야 합니다. 비밀번호 없는 `sudo`를 권장합니다.
- 첫 연결 시 호스트 키를 검증하기 위해 `ssh-keyscan`이 사용되므로 방화벽에서 SSH 포트를 허용해야 합니다.

필요에 따라 워크플로의 트리거 브랜치, 환경 이름, 시스템 제어 명령 등을 자유롭게 수정해 주세요.

## 로컬 서비스를 외부에서 보기 (선택)

Quick Tunnel 용도로 `cloudflared`를 실행하면 로컬 Tomcat을 임시 HTTPS 주소로 노출할 수 있습니다.

```bash
cloudflared tunnel --url http://127.0.0.1:8080
```

- 실행 후 `https://<무작위>.trycloudflare.com` 주소가 출력되며, 해당 URL로 접근하면 `http://127.0.0.1:8080/MeetLog`가 프록시됩니다.
- Cloudflare 계정 없이 쓰는 Quick Tunnel은 실험용이라 언제든 종료될 수 있고, 인증·방화벽이 없으므로 민감한 데이터는 공유하지 않는 것이 좋습니다.
- 프로세스를 종료하면 터널이 닫힙니다. 보다 안정적인 공유가 필요하면 Cloudflare 계정으로 named tunnel을 만들고 `~/.cloudflared/config.yml`을 구성하세요.
