package model;

import java.time.LocalDateTime;

public class RecommendationMetric {
    private int id;
    private int userId;
    private int recommendationCount;
    private double avgScore;
    private int categoryDiversity;
    private LocalDateTime timestamp;

    public RecommendationMetric() {
    }

    public RecommendationMetric(int userId, int recommendationCount, double avgScore, int categoryDiversity) {
        this.userId = userId;
        this.recommendationCount = recommendationCount;
        this.avgScore = avgScore;
        this.categoryDiversity = categoryDiversity;
        this.timestamp = LocalDateTime.now();
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

    public int getRecommendationCount() {
        return recommendationCount;
    }

    public void setRecommendationCount(int recommendationCount) {
        this.recommendationCount = recommendationCount;
    }

    public double getAvgScore() {
        return avgScore;
    }

    public void setAvgScore(double avgScore) {
        this.avgScore = avgScore;
    }

    public int getCategoryDiversity() {
        return categoryDiversity;
    }

    public void setCategoryDiversity(int categoryDiversity) {
        this.categoryDiversity = categoryDiversity;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}