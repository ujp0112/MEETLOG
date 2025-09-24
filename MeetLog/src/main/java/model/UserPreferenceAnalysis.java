package model;

import java.util.HashMap;
import java.util.Map;

/**
 * 사용자 선호도 종합 분석 모델
 * 사용자의 모든 활동을 분석하여 선호도를 도출
 */
public class UserPreferenceAnalysis {
    private int userId;
    private Map<String, Integer> preferredCategories;      // 선호 카테고리
    private Map<String, Integer> locationPreferences;      // 지역 선호도
    private Map<String, Integer> timePreferences;          // 시간대 선호도
    private Map<Integer, Integer> ratingDistribution;      // 평점 분포
    private Map<String, Integer> monthlyPattern;           // 월별 활동 패턴

    // 계산된 선호도 점수들
    private Map<String, Double> categoryScores;
    private Map<String, Double> locationScores;
    private Map<String, Double> timeScores;

    private double overallActivityScore;    // 전체 활동 점수
    private String personalityType;         // 성향 타입 (예: 모험가, 신중파, 미식가 등)

    // 기본 생성자
    public UserPreferenceAnalysis() {
        this.preferredCategories = new HashMap<>();
        this.locationPreferences = new HashMap<>();
        this.timePreferences = new HashMap<>();
        this.ratingDistribution = new HashMap<>();
        this.monthlyPattern = new HashMap<>();
        this.categoryScores = new HashMap<>();
        this.locationScores = new HashMap<>();
        this.timeScores = new HashMap<>();
    }

    /**
     * 선호도 점수 계산
     */
    public void calculatePreferenceScores() {
        calculateCategoryScores();
        calculateLocationScores();
        calculateTimeScores();
        calculateOverallActivityScore();
        determinePersonalityType();
    }

    /**
     * 카테고리 선호도 점수 계산
     */
    private void calculateCategoryScores() {
        int totalVisits = preferredCategories.values().stream().mapToInt(Integer::intValue).sum();

        if (totalVisits > 0) {
            for (Map.Entry<String, Integer> entry : preferredCategories.entrySet()) {
                double score = (double) entry.getValue() / totalVisits * 100;
                categoryScores.put(entry.getKey(), score);
            }
        }
    }

    /**
     * 지역 선호도 점수 계산
     */
    private void calculateLocationScores() {
        int totalVisits = locationPreferences.values().stream().mapToInt(Integer::intValue).sum();

        if (totalVisits > 0) {
            for (Map.Entry<String, Integer> entry : locationPreferences.entrySet()) {
                double score = (double) entry.getValue() / totalVisits * 100;
                locationScores.put(entry.getKey(), score);
            }
        }
    }

    /**
     * 시간대 선호도 점수 계산
     */
    private void calculateTimeScores() {
        int totalVisits = timePreferences.values().stream().mapToInt(Integer::intValue).sum();

        if (totalVisits > 0) {
            for (Map.Entry<String, Integer> entry : timePreferences.entrySet()) {
                double score = (double) entry.getValue() / totalVisits * 100;
                timeScores.put(entry.getKey(), score);
            }
        }
    }

    /**
     * 전체 활동 점수 계산
     */
    private void calculateOverallActivityScore() {
        int totalReviews = preferredCategories.values().stream().mapToInt(Integer::intValue).sum();
        double avgRating = calculateAverageRating();

        // 활동량 + 평점 품질을 종합한 점수
        this.overallActivityScore = totalReviews * 10 + (avgRating * 20);
    }

    /**
     * 평균 평점 계산
     */
    private double calculateAverageRating() {
        int totalRatings = 0;
        int weightedSum = 0;

        for (Map.Entry<Integer, Integer> entry : ratingDistribution.entrySet()) {
            totalRatings += entry.getValue();
            weightedSum += entry.getKey() * entry.getValue();
        }

        return totalRatings > 0 ? (double) weightedSum / totalRatings : 0.0;
    }

    /**
     * 사용자 성향 타입 결정
     */
    private void determinePersonalityType() {
        double avgRating = calculateAverageRating();
        int totalVisits = preferredCategories.values().stream().mapToInt(Integer::intValue).sum();

        if (avgRating >= 4.5) {
            this.personalityType = "관대한 미식가";
        } else if (avgRating <= 3.0) {
            this.personalityType = "까다로운 심사관";
        } else if (totalVisits >= 50) {
            this.personalityType = "모험가";
        } else if (getTopCategory() != null && categoryScores.get(getTopCategory()) >= 60) {
            this.personalityType = "전문가";
        } else {
            this.personalityType = "탐험가";
        }
    }

    /**
     * 가장 선호하는 카테고리 반환
     */
    public String getTopPreferredCategory() {
        return getTopCategory();
    }

    private String getTopCategory() {
        return preferredCategories.entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(null);
    }

    /**
     * 방문 패턴 인사이트 생성
     */
    public String getVisitPatternInsight() {
        String topTime = timePreferences.entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("점심");

        return String.format("주로 %s 시간대에 맛집을 방문하시는군요.", topTime);
    }

    /**
     * 선호도 기반 추천 가중치 반환
     */
    public Map<String, Double> getRecommendationWeights() {
        Map<String, Double> weights = new HashMap<>();

        // 카테고리 가중치
        String topCategory = getTopCategory();
        if (topCategory != null) {
            weights.put("category_" + topCategory, 0.4);
        }

        // 지역 가중치
        String topLocation = locationPreferences.entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(null);

        if (topLocation != null) {
            weights.put("location_" + topLocation, 0.2);
        }

        // 시간대 가중치
        String topTime = timePreferences.entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(null);

        if (topTime != null) {
            weights.put("time_" + topTime, 0.1);
        }

        return weights;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Map<String, Integer> getPreferredCategories() {
        return preferredCategories;
    }

    public void setPreferredCategories(Map<String, Integer> preferredCategories) {
        this.preferredCategories = preferredCategories;
    }

    public Map<String, Integer> getLocationPreferences() {
        return locationPreferences;
    }

    public void setLocationPreferences(Map<String, Integer> locationPreferences) {
        this.locationPreferences = locationPreferences;
    }

    public Map<String, Integer> getTimePreferences() {
        return timePreferences;
    }

    public void setTimePreferences(Map<String, Integer> timePreferences) {
        this.timePreferences = timePreferences;
    }

    public Map<Integer, Integer> getRatingDistribution() {
        return ratingDistribution;
    }

    public void setRatingDistribution(Map<Integer, Integer> ratingDistribution) {
        this.ratingDistribution = ratingDistribution;
    }

    public Map<String, Integer> getMonthlyPattern() {
        return monthlyPattern;
    }

    public void setMonthlyPattern(Map<String, Integer> monthlyPattern) {
        this.monthlyPattern = monthlyPattern;
    }

    public Map<String, Double> getCategoryScores() {
        return categoryScores;
    }

    public Map<String, Double> getLocationScores() {
        return locationScores;
    }

    public Map<String, Double> getTimeScores() {
        return timeScores;
    }

    public double getOverallActivityScore() {
        return overallActivityScore;
    }

    public String getPersonalityType() {
        return personalityType;
    }

    @Override
    public String toString() {
        return "UserPreferenceAnalysis{" +
                "userId=" + userId +
                ", personalityType='" + personalityType + '\'' +
                ", overallActivityScore=" + overallActivityScore +
                ", topCategory='" + getTopCategory() + '\'' +
                '}';
    }
}