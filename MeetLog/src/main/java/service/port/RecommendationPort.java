package service.port;
/**
 * 추천 도메인에서 외부 서버(AI 모델, 데이터 소스 등)와 통신하기 위한 포트
 */
public interface RecommendationPort {
    
    /**
     * 주어진 텍스트를 의미 벡터로 변환합니다.
     * @param text 변환할 텍스트
     * @return 768차원의 double 배열 벡터, 실패 시 null 또는 Optional.empty()
     */
    public double[] getVectorFromText(String text);
    
    // 필요하다면 다른 기능 계약을 추가할 수 있습니다.
    // 예: List<double[]> getVectorsFromTexts(List<String> texts);
}
