package model;

import java.util.List;
import java.util.Map;

/**
 * 맛집 추천 결과를 담는 모델 클래스
 * 추천 시스템에서 반환되는 맛집 정보와 추천 이유를 포함합니다.
 */
public class RestaurantRecommendation {
    private Restaurant restaurant;
    private double recommendationScore; // 0.0 ~ 1.0 (추천 점수)
    private String recommendationReason; // 추천 이유
    private List<String> matchingFactors; // 매칭된 요소들 (카테고리, 가격대, 분위기 등)
    private boolean isPersonalized; // 개인화된 추천인지 여부

    // ML 기반 고도화 필드들
    private double predictedRating;     // ML 예측 평점 (1-5점)
    private double confidenceScore;     // 예측 신뢰도 (0-1)
    private String algorithmType;       // 사용된 알고리즘 (collaborative, content-based, hybrid, ml)
    private double trendScore;          // 트렌드 점수 (0-1)
    private double diversityScore;      // 다양성 점수 (0-1)
    private String userSegment;         // 사용자 세그먼트 (explorer, loyal, social 등)

    // 세부 점수들
    private double collaborativeScore;  // 협업 필터링 점수
    private double contentScore;        // 콘텐츠 기반 점수
    private double behaviorScore;       // 행동 패턴 점수
    private double socialScore;         // 소셜 영향 점수

    // 추천 메타데이터
    private long timestamp;             // 추천 생성 시점
    private String recommendationId;    // 추천 고유 ID
    private Map<String, Object> metadata; // 추가 메타데이터

    public RestaurantRecommendation() {
    }

    public RestaurantRecommendation(Restaurant restaurant, double recommendationScore, String recommendationReason) {
        this.restaurant = restaurant;
        this.recommendationScore = recommendationScore;
        this.recommendationReason = recommendationReason;
    }

    // Getters and Setters
    public Restaurant getRestaurant() {
        return restaurant;
    }

    public void setRestaurant(Restaurant restaurant) {
        this.restaurant = restaurant;
    }

    public double getRecommendationScore() {
        return recommendationScore;
    }

    public void setRecommendationScore(double recommendationScore) {
        this.recommendationScore = recommendationScore;
    }

    public String getRecommendationReason() {
        return recommendationReason;
    }

    public void setRecommendationReason(String recommendationReason) {
        this.recommendationReason = recommendationReason;
    }

    public List<String> getMatchingFactors() {
        return matchingFactors;
    }

    public void setMatchingFactors(List<String> matchingFactors) {
        this.matchingFactors = matchingFactors;
    }

    public boolean isPersonalized() {
        return isPersonalized;
    }

    public void setPersonalized(boolean personalized) {
        isPersonalized = personalized;
    }

    public String getReason() {
        return recommendationReason;
    }

    public void setReason(String reason) {
        this.recommendationReason = reason;
    }

    // ML 기반 고도화 필드들의 Getter/Setter
    public double getPredictedRating() {
        return predictedRating;
    }

    public void setPredictedRating(double predictedRating) {
        this.predictedRating = predictedRating;
    }

    public double getConfidenceScore() {
        return confidenceScore;
    }

    public void setConfidenceScore(double confidenceScore) {
        this.confidenceScore = confidenceScore;
    }

    public String getAlgorithmType() {
        return algorithmType;
    }

    public void setAlgorithmType(String algorithmType) {
        this.algorithmType = algorithmType;
    }

    public double getTrendScore() {
        return trendScore;
    }

    public void setTrendScore(double trendScore) {
        this.trendScore = trendScore;
    }

    public double getDiversityScore() {
        return diversityScore;
    }

    public void setDiversityScore(double diversityScore) {
        this.diversityScore = diversityScore;
    }

    public String getUserSegment() {
        return userSegment;
    }

    public void setUserSegment(String userSegment) {
        this.userSegment = userSegment;
    }

    public double getCollaborativeScore() {
        return collaborativeScore;
    }

    public void setCollaborativeScore(double collaborativeScore) {
        this.collaborativeScore = collaborativeScore;
    }

    public double getContentScore() {
        return contentScore;
    }

    public void setContentScore(double contentScore) {
        this.contentScore = contentScore;
    }

    public double getBehaviorScore() {
        return behaviorScore;
    }

    public void setBehaviorScore(double behaviorScore) {
        this.behaviorScore = behaviorScore;
    }

    public double getSocialScore() {
        return socialScore;
    }

    public void setSocialScore(double socialScore) {
        this.socialScore = socialScore;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public String getRecommendationId() {
        return recommendationId;
    }

    public void setRecommendationId(String recommendationId) {
        this.recommendationId = recommendationId;
    }

    public Map<String, Object> getMetadata() {
        return metadata;
    }

    public void setMetadata(Map<String, Object> metadata) {
        this.metadata = metadata;
    }

    @Override
    public String toString() {
        return "RestaurantRecommendation{" +
                "restaurant=" + (restaurant != null ? restaurant.getName() : "null") +
                ", recommendationScore=" + recommendationScore +
                ", predictedRating=" + predictedRating +
                ", algorithmType='" + algorithmType + '\'' +
                ", userSegment='" + userSegment + '\'' +
                '}';
    }
}
