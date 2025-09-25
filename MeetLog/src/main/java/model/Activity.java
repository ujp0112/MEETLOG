package model;

import java.time.LocalDateTime;

/**
 * 피드 화면에서 사용할 활동 데이터 DTO
 */
public class Activity {
    private String activityType; // REVIEW, COURSE, COLUMN
    private String userNickname;
    private String userProfileImage;

    private String contentTitle;
    private String contentDescription;
    private String contentImage;
    private int contentId;

    // 리뷰 전용 속성
    private Double contentRating;
    private String contentLocation;
    private String restaurantName;

    private LocalDateTime createdAt;

    public Activity() {
    }

    // FeedItem으로부터 Activity 생성하는 생성자
    public Activity(FeedItem feedItem) {
        this.userNickname = feedItem.getUserNickname();
        this.userProfileImage = feedItem.getUserProfileImage();
        this.createdAt = feedItem.getCreatedAt();
        this.contentId = feedItem.getTargetId();

        // actionType을 activityType으로 변환
        if ("review".equalsIgnoreCase(feedItem.getActionType())) {
            this.activityType = "REVIEW";
        } else if ("course".equalsIgnoreCase(feedItem.getActionType())) {
            this.activityType = "COURSE";
        } else if ("column".equalsIgnoreCase(feedItem.getActionType())) {
            this.activityType = "COLUMN";
        } else {
            this.activityType = feedItem.getActionType().toUpperCase();
        }

        this.contentTitle = feedItem.getTargetName();
        this.contentDescription = feedItem.getContent();
        this.contentImage = feedItem.getTargetImage();
    }

    // Getters and Setters
    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
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

    public String getContentDescription() {
        return contentDescription;
    }

    public void setContentDescription(String contentDescription) {
        this.contentDescription = contentDescription;
    }

    public String getContentImage() {
        return contentImage;
    }

    public void setContentImage(String contentImage) {
        this.contentImage = contentImage;
    }

    public int getContentId() {
        return contentId;
    }

    public void setContentId(int contentId) {
        this.contentId = contentId;
    }

    public Double getContentRating() {
        return contentRating;
    }

    public void setContentRating(Double contentRating) {
        this.contentRating = contentRating;
    }

    public String getContentLocation() {
        return contentLocation;
    }

    public void setContentLocation(String contentLocation) {
        this.contentLocation = contentLocation;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}