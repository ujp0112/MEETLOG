package model;

import java.time.LocalDateTime;

/**
 * 피드 활동 모델 클래스
 */
public class FeedActivity {
    private int activityId;
    private int userId;
    private String activityType; // REVIEW, COURSE, COLUMN
    private int contentId; // 실제 콘텐츠의 ID
    private LocalDateTime createdAt;
    
    // 사용자 정보
    private String userNickname;
    private String userProfileImage;
    
    // 콘텐츠 정보
    private String contentTitle;
    private String contentImage;
    private String contentDescription;
    private String contentLocation; // 음식점용
    private Double contentRating; // 리뷰용
    private String restaurantName; // 리뷰용

    public FeedActivity() {
    }

    public FeedActivity(int userId, String activityType, int contentId) {
        this.userId = userId;
        this.activityType = activityType;
        this.contentId = contentId;
    }

    // Getters and Setters
    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public int getContentId() {
        return contentId;
    }

    public void setContentId(int contentId) {
        this.contentId = contentId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }

    public String getUserProfileImage() {
        return userProfileImage;
    }

    public void setUserProfileImage(String userProfileImage) {
        this.userProfileImage = userProfileImage;
    }

    public String getContentTitle() {
        return contentTitle;
    }

    public void setContentTitle(String contentTitle) {
        this.contentTitle = contentTitle;
    }

    public String getContentImage() {
        return contentImage;
    }

    public void setContentImage(String contentImage) {
        this.contentImage = contentImage;
    }

    public String getContentDescription() {
        return contentDescription;
    }

    public void setContentDescription(String contentDescription) {
        this.contentDescription = contentDescription;
    }

    public String getContentLocation() {
        return contentLocation;
    }

    public void setContentLocation(String contentLocation) {
        this.contentLocation = contentLocation;
    }

    public Double getContentRating() {
        return contentRating;
    }

    public void setContentRating(Double contentRating) {
        this.contentRating = contentRating;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }
}
