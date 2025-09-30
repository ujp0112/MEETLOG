  1. 메인 메트릭 테이블 (recommendation_metrics)

  - id: 메트릭 고유 ID (자동 증가)
  - user_id: 사용자 ID
  - recommendation_count: 추천된 맛집 개수
  - avg_score: 추천 점수 평균 (0.0 ~ 1.0)
  - category_diversity: 카테고리 다양성 (서로 다른 카테고리 수)
  - timestamp: 추천 생성 시간

  2. 상세 추천 항목 테이블 (recommendation_items)

  - id: 항목 고유 ID
  - metric_id: 메트릭 ID (외래키)
  - restaurant_id: 추천된 맛집 ID
  - recommendation_score: 개별 추천 점수
  - predicted_rating: ML로 예측한 평점
  - reason: 추천 이유 (예: "취향 기반", "트렌드 기반")

  3. 저장되는 데이터 예시

  사용자가 추천을 받을 때마다:
  - 전체 추천 세션 메트릭 1개 저장 (평균 점수, 다양성 등)
  - 개별 추천 맛집마다 상세 정보 저장 (점수, 예측 평점, 이유)

  활용 방법:
  - 추천 성능 분석 (평균 점수 추이)
  - 사용자별 추천 이력 추적
  - A/B 테스트 및 알고리즘 개선
  - 카테고리 다양성 모니터링