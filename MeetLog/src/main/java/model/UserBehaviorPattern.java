package model;

import java.util.List;
import java.util.Map;

/**
 * 사용자 행동 패턴 모델
 * ML 기반 추천 시스템에서 사용자의 행동 패턴을 분석하고 저장
 */
public class UserBehaviorPattern {
    private int userId;
    private Map<String, Double> categoryAffinities;      // 카테고리별 선호도
    private Map<String, Double> locationAffinities;      // 지역별 선호도
    private List<String> preferredTimeSlots;             // 선호 시간대
    private Map<String, Integer> preferredPriceRanges;   // 가격대 선호도
    private ReviewPattern reviewPattern;                  // 리뷰 작성 패턴
    private SocialPattern socialPattern;                  // 소셜 활동 패턴

    // 행동 점수들
    private double explorationScore;    // 새로운 맛집 탐험 성향
    private double loyaltyScore;        // 단골 맛집 선호 성향
    private double socialInfluence;     // 소셜 영향 수용도
    private double trendSensitivity;    // 트렌드 민감도

    // 기본 생성자
    public UserBehaviorPattern() {}

    // 매개변수 생성자
    public UserBehaviorPattern(int userId) {
        this.userId = userId;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Map<String, Double> getCategoryAffinities() {
        return categoryAffinities;
    }

    public void setCategoryAffinities(Map<String, Double> categoryAffinities) {
        this.categoryAffinities = categoryAffinities;
    }

    public Map<String, Double> getLocationAffinities() {
        return locationAffinities;
    }

    public void setLocationAffinities(Map<String, Double> locationAffinities) {
        this.locationAffinities = locationAffinities;
    }

    public List<String> getPreferredTimeSlots() {
        return preferredTimeSlots;
    }

    public void setPreferredTimeSlots(List<String> preferredTimeSlots) {
        this.preferredTimeSlots = preferredTimeSlots;
    }

    public Map<String, Integer> getPreferredPriceRanges() {
        return preferredPriceRanges;
    }

    public void setPreferredPriceRanges(Map<String, Integer> preferredPriceRanges) {
        this.preferredPriceRanges = preferredPriceRanges;
    }

    public ReviewPattern getReviewPattern() {
        return reviewPattern;
    }

    public void setReviewPattern(ReviewPattern reviewPattern) {
        this.reviewPattern = reviewPattern;
    }

    public SocialPattern getSocialPattern() {
        return socialPattern;
    }

    public void setSocialPattern(SocialPattern socialPattern) {
        this.socialPattern = socialPattern;
    }

    public double getExplorationScore() {
        return explorationScore;
    }

    public void setExplorationScore(double explorationScore) {
        this.explorationScore = explorationScore;
    }

    public double getLoyaltyScore() {
        return loyaltyScore;
    }

    public void setLoyaltyScore(double loyaltyScore) {
        this.loyaltyScore = loyaltyScore;
    }

    public double getSocialInfluence() {
        return socialInfluence;
    }

    public void setSocialInfluence(double socialInfluence) {
        this.socialInfluence = socialInfluence;
    }

    public double getTrendSensitivity() {
        return trendSensitivity;
    }

    public void setTrendSensitivity(double trendSensitivity) {
        this.trendSensitivity = trendSensitivity;
    }

    @Override
    public String toString() {
        return "UserBehaviorPattern{" +
                "userId=" + userId +
                ", categoryAffinities=" + categoryAffinities +
                ", locationAffinities=" + locationAffinities +
                ", explorationScore=" + explorationScore +
                ", loyaltyScore=" + loyaltyScore +
                '}';
    }
}