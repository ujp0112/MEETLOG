package model;

import java.util.List;

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
}
