# KoBERT Vectorization API Server

`skt/kobert-base-v1` 모델을 사용하여 한국어 텍스트를 768차원의 의미 벡터(Embedding Vector)로 변환하는 간단한 FastAPI 서버입니다. Java 기반의 `MEETLOG` 추천 시스템에서 사용할 목적으로 개발되었습니다.

## 주요 기능 (Features)

- **텍스트 벡터화 API**: 입력된 텍스트를 KoBERT 모델을 통해 숫자 벡터로 변환합니다.
- **FastAPI 기반**: 현대적이고 빠른 Python 웹 프레임워크인 FastAPI를 사용합니다.
- **하드웨어 가속**: Apple Silicon(MPS) 또는 NVIDIA GPU(CUDA)를 자동으로 감지하여 빠른 추론 속도를 제공합니다.

---

## 실행 환경 (Prerequisites)

- Python 3.8 이상
- `pip` (Python 패키지 관리자)

---

## 설치 및 설정 (Installation & Setup)

1.  **프로젝트 클론 (Clone Repository)**
    ```bash
    git clone [저장소 주소]
    cd kobert-api-server
    ```

2.  **가상환경 생성 및 활성화 (Create & Activate Virtual Environment)**
    ```bash
    # 가상환경 생성
    python3 -m venv venv

    # 가상환경 활성화 (macOS/Linux)
    source venv/bin/activate
    # 가상환경 활성화 (Windows)
    venv\Scripts\activate
    ```

3.  **필수 라이브러리 설치 (Install Dependencies)**
    ```bash
    pip install -r requirements.txt
    ```

---

## 서버 실행 (Running the Server)

아래 명령어를 실행하여 API 서버를 시작합니다.

```bash
uvicorn main:app --reload
```

서버가 정상적으로 시작되면 다음과 같은 로그가 터미널에 나타납니다.

```
INFO:     Uvicorn running on [http://127.0.0.1:8000](http://127.0.0.1:8000) (Press CTRL+C to quit)
INFO:     Started reloader process [xxxxx]
INFO:     Started server process [xxxxx]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

---

## API 사용법 (API Usage)

### 텍스트 벡터 변환 (`POST /vectorize`)

지정한 텍스트를 768차원의 벡터로 변환합니다.

- **URL**: `http://127.0.0.1:8000/vectorize`
- **Method**: `POST`
- **Content-Type**: `application/json`

#### 요청 예시 (Request Example)

`curl`을 사용한 요청 예시입니다.

```bash
curl -X 'POST' \
  '[http://127.0.0.1:8000/vectorize](http://127.0.0.1:8000/vectorize)' \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "이 레스토랑 분위기가 정말 좋네요."
  }'
```

#### 성공 응답 예시 (Success Response Example)

```json
{
  "text": "이 레스토랑 분위기가 정말 좋네요.",
  "vector": [
    0.123456789,
    -0.987654321,
    ... 
    // 768개의 float 숫자로 이루어진 리스트
  ]
}
```