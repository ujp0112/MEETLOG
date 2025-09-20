package model;

import java.util.Map;
import java.util.List;

public class ReviewStatistics {
    private int totalReviews;
    private double averageRating;
    private int fiveStarCount;
    private int fourStarCount;
    private int threeStarCount;
    private int twoStarCount;
    private int oneStarCount;
    private int totalLikes;
    private int totalComments;
    private Map<Integer, Integer> ratingDistribution;
    private List<Map<String, Object>> monthlyReviewCount;
    private List<Map<String, Object>> recentTrend;
    
    public ReviewStatistics() {
        // Default constructor
    }
    
    // Getters and Setters
    public int getTotalReviews() {
        return totalReviews;
    }
    
    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }
    
    public double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }
    
    public int getFiveStarCount() {
        return fiveStarCount;
    }
    
    public void setFiveStarCount(int fiveStarCount) {
        this.fiveStarCount = fiveStarCount;
    }
    
    public int getFourStarCount() {
        return fourStarCount;
    }
    
    public void setFourStarCount(int fourStarCount) {
        this.fourStarCount = fourStarCount;
    }
    
    public int getThreeStarCount() {
        return threeStarCount;
    }
    
    public void setThreeStarCount(int threeStarCount) {
        this.threeStarCount = threeStarCount;
    }
    
    public int getTwoStarCount() {
        return twoStarCount;
    }
    
    public void setTwoStarCount(int twoStarCount) {
        this.twoStarCount = twoStarCount;
    }
    
    public int getOneStarCount() {
        return oneStarCount;
    }
    
    public void setOneStarCount(int oneStarCount) {
        this.oneStarCount = oneStarCount;
    }
    
    public int getTotalLikes() {
        return totalLikes;
    }
    
    public void setTotalLikes(int totalLikes) {
        this.totalLikes = totalLikes;
    }
    
    public int getTotalComments() {
        return totalComments;
    }
    
    public void setTotalComments(int totalComments) {
        this.totalComments = totalComments;
    }
    
    public Map<Integer, Integer> getRatingDistribution() {
        return ratingDistribution;
    }
    
    public void setRatingDistribution(Map<Integer, Integer> ratingDistribution) {
        this.ratingDistribution = ratingDistribution;
    }
    
    public List<Map<String, Object>> getMonthlyReviewCount() {
        return monthlyReviewCount;
    }
    
    public void setMonthlyReviewCount(List<Map<String, Object>> monthlyReviewCount) {
        this.monthlyReviewCount = monthlyReviewCount;
    }
    
    public List<Map<String, Object>> getRecentTrend() {
        return recentTrend;
    }
    
    public void setRecentTrend(List<Map<String, Object>> recentTrend) {
        this.recentTrend = recentTrend;
    }
}
