# KoBERT 기반 추천 시스템 사용 가이드

## 📋 개요

KoBERT(Korean BERT) 모델을 활용한 지능형 레스토랑 추천 시스템입니다. 사용자의 리뷰 취향과 레스토랑 콘텐츠 간의 의미적 유사도를 계산하여 개인화된 추천을 제공합니다.

## 🏗️ 아키텍처

```
Controller (RecommendationController)
    ↓
Service (IntelligentRecommendationService)
    ↓
Port (RecommendationPort 인터페이스)
    ↓
Adapter (KoBertAdapter) → FastAPI 서버 (http://127.0.0.1:8000)
```

### 주요 컴포넌트

1. **RecommendationPort**: KoBERT API 추상화 인터페이스
2. **KoBertAdapter**: 실제 FastAPI 서버 통신 구현체 (재시도 로직 포함)
3. **IntelligentRecommendationService**: 하이브리드 추천 알고리즘 (협업 필터링 + 콘텐츠 기반 + 트렌드)
4. **RecommendationDAO**: 벡터 데이터 영속성 관리

## 🚀 초기 설정

### 1. 데이터베이스 테이블 생성

```bash
mysql -u root -p7564 meetlog < /Users/sangwoolee/MEETLOG/MEETLOG/database/add_vectors_table.sql
```

생성된 테이블:
- `restaurant_vectors`: 레스토랑 콘텐츠 벡터 (768차원)
- `user_review_vectors`: 사용자 리뷰 벡터 캐시 (선택적)

### 2. KoBERT FastAPI 서버 실행

```bash
# 별도의 Python 가상환경에서 실행
cd /path/to/kobert-api
uvicorn main:app --host 127.0.0.1 --port 8000
```

서버 엔드포인트: `POST http://127.0.0.1:8000/vectorize`

요청 예시:
```json
{
  "text": "맛있는 한식당입니다. 된장찌개가 일품입니다."
}
```

응답 예시:
```json
{
  "vector": [0.123, -0.456, ..., 0.789]  // 768차원
}
```

### 3. 레스토랑 벡터 사전 계산 (필수)

추천 시스템이 작동하려면 **레스토랑 벡터가 DB에 사전 저장**되어 있어야 합니다.

```bash
# Maven 빌드 후 실행
mvn clean package
java -cp target/MeetLog.war util.VectorPrecomputeBatch 50
```

**파라미터**:
- `50`: 한 번에 처리할 레스토랑 수 (기본값)

**작동 방식**:
1. `restaurant_vectors` 테이블에 없는 레스토랑 조회
2. 각 레스토랑의 이름, 카테고리, 설명을 결합하여 텍스트 생성
3. KoBERT API로 벡터 변환 (재시도 3회, 지수 백오프)
4. DB에 저장

**예상 소요 시간**: 레스토랑 100개 기준 약 2-3분 (KoBERT API 응답 속도에 따라 변동)

## 📡 API 사용법

### 엔드포인트

```
GET /recommendations/intelligent?limit=10
```

### 요청 헤더
- **Cookie**: `JSESSIONID=...` (로그인 필수)

### 쿼리 파라미터
- `limit` (선택): 추천 개수 (기본값: 10, 최대: 100)

### 응답 예시

```json
[
  {
    "restaurant": {
      "id": 15,
      "name": "서울식당",
      "category": "한식",
      "rating": 4.5,
      "location": "강남구",
      "description": "전통 한식 전문점..."
    },
    "recommendationScore": 0.92,
    "predictedRating": 4.6,
    "reason": "회원님의 리뷰 취향과 유사한 맛집"
  },
  ...
]
```

### 에러 응답

```json
{
  "status": 401,
  "message": "로그인이 필요합니다."
}
```

**에러 코드**:
- `401 Unauthorized`: 세션 없음
- `404 Not Found`: 잘못된 경로
- `500 Internal Server Error`: 추천 생성 실패

## 🔄 추천 알고리즘 흐름

### 1단계: 사용자 행동 패턴 분석
- 최근 30일 리뷰 데이터 분석
- 선호 카테고리, 가격대, 시간대, 위치 추출

### 2단계: 실시간 트렌드 분석
- 최근 7일 급상승 레스토랑
- 지역별/시간대별 인기 트렌드

### 3단계: 개인화 추천 생성

#### A. 협업 필터링 (35% 가중치)
- 유사한 취향의 사용자가 좋아한 레스토랑

#### B. KoBERT 콘텐츠 기반 (25% 가중치)
1. 사용자의 최근 긍정 리뷰 10개 추출 (평점 4점 이상)
2. 각 리뷰 → KoBERT 벡터 변환
3. 평균 벡터 계산 (사용자 취향 벡터)
4. DB의 모든 레스토랑 벡터와 코사인 유사도 계산
5. 유사도 > 0.7인 레스토랑만 추천

#### C. 행동 패턴 기반 (25% 가중치)
- 사용자 선호 카테고리/가격대 매칭

### 4단계: ML 기반 점수 예측
- 선형 회귀 모델로 평점 예측
- 특성: 카테고리 친화도, 위치 친화도, **의미 유사도(35% 가중치)**

### 5단계: 트렌드 가중치 적용 (15%)
- 실시간 인기 레스토랑에 추가 점수

### 6단계: 다양성 보장
- 카테고리/지역 중복 제거
- 최종 N개 선정

## 🔧 성능 최적화

### 1. 벡터 캐싱
현재는 모든 레스토랑 벡터를 DB에서 조회합니다. 트래픽이 증가하면 다음 개선이 필요합니다:

```java
// ConcurrentHashMap으로 애플리케이션 레벨 캐싱
private static final Map<Integer, double[]> vectorCache = new ConcurrentHashMap<>();
```

또는 Redis 사용:
```
redis-cli
> HSET restaurant_vectors:123 vector "[0.1, 0.2, ...]"
```

### 2. 배치 벡터 계산 자동화
Cron 작업으로 새 레스토랑 자동 벡터화:

```bash
# 매일 오전 3시 실행
0 3 * * * java -cp /path/to/MeetLog.war util.VectorPrecomputeBatch 100
```

### 3. KoBERT API 부하 분산
- 다중 FastAPI 인스턴스 + Nginx 로드 밸런싱
- GPU 서버 사용 (CPU 대비 10배 이상 속도 향상)

## 🐛 문제 해결

### Q1: "KoBERT API 호출 3회 모두 실패"
**원인**: FastAPI 서버 미실행 또는 네트워크 문제

**해결**:
```bash
# 서버 상태 확인
curl http://127.0.0.1:8000/vectorize -X POST -H "Content-Type: application/json" -d '{"text":"테스트"}'

# 예상 응답: {"vector": [...]}
```

### Q2: 추천 결과가 비어있음
**원인**: 레스토랑 벡터 미계산 또는 사용자 리뷰 부족

**확인**:
```sql
-- 벡터가 저장된 레스토랑 수 확인
SELECT COUNT(*) FROM restaurant_vectors;

-- 사용자의 긍정 리뷰 수 확인
SELECT COUNT(*) FROM reviews WHERE user_id = 1 AND rating >= 4;
```

**해결**: VectorPrecomputeBatch 재실행

### Q3: 응답 속도 느림 (5초 이상)
**원인**: 벡터 유사도 계산 병목

**최적화**:
1. 레스토랑 수가 많으면 FAISS 벡터 DB 도입
2. 유사도 계산 병렬 처리:
   ```java
   restaurantVectors.entrySet().parallelStream()
       .map(entry -> calculateSimilarity(...))
   ```

## 📊 메트릭 추적

추천 성능은 자동으로 `recommendation_metrics` 테이블에 기록됩니다:

```sql
SELECT
    user_id,
    recommendation_count,
    average_score,
    category_diversity,
    created_at
FROM recommendation_metrics
ORDER BY created_at DESC
LIMIT 10;
```

**주요 지표**:
- `recommendation_count`: 생성된 추천 개수
- `average_score`: 평균 추천 점수
- `category_diversity`: 카테고리 다양성 (높을수록 좋음)

## 🚧 향후 개선 사항

1. **실시간 벡터 업데이트**: 레스토랑 정보 수정 시 자동 재계산
2. **A/B 테스팅**: KoBERT vs 기존 추천 성능 비교
3. **하이퍼파라미터 튜닝**: 가중치 최적화 (현재는 고정값)
4. **설명 가능성**: "이 레스토랑을 추천한 이유" 상세 제공
5. **벡터 압축**: 768차원 → 128차원 (PCA/AutoEncoder)

## 📞 문의

기술 문의: claude-code-recommendations@example.com
