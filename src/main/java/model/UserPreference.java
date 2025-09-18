package model;

import java.time.LocalDateTime;

/**
 * 사용자 취향 분석을 위한 모델 클래스
 * 사용자의 맛집 선호도를 분석하고 저장하는 데 사용됩니다.
 */
public class UserPreference {
    private int id;
    private int userId;
    private String category; // 한식, 양식, 일식, 중식, 카페 등
    private int priceRange; // 1: ~1만원, 2: 1-2만원, 3: 2-4만원, 4: 4만원+
    private String atmosphere; // 데이트, 비즈니스, 가족, 혼밥, 친구모임
    private double preferenceScore; // 0.0 ~ 1.0 (선호도 점수)
    private int reviewCount; // 해당 카테고리/가격대/분위기에 대한 리뷰 수
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public UserPreference() {
    }

    public UserPreference(int userId, String category, int priceRange, String atmosphere, double preferenceScore) {
        this.userId = userId;
        this.category = category;
        this.priceRange = priceRange;
        this.atmosphere = atmosphere;
        this.preferenceScore = preferenceScore;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getPriceRange() {
        return priceRange;
    }

    public void setPriceRange(int priceRange) {
        this.priceRange = priceRange;
    }

    public String getAtmosphere() {
        return atmosphere;
    }

    public void setAtmosphere(String atmosphere) {
        this.atmosphere = atmosphere;
    }

    public double getPreferenceScore() {
        return preferenceScore;
    }

    public void setPreferenceScore(double preferenceScore) {
        this.preferenceScore = preferenceScore;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
