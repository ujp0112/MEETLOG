package model;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * 피드 화면에서 사용할 활동 데이터 DTO
 */
public class Activity {
    private String activityType; // REVIEW, COURSE, COLUMN
    private int userId;
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

    private int likeCount;
    private int commentCount;
    private String targetUrl;

    private Date createdAt;

    public Activity() {
    }

    // FeedItem으로부터 Activity 생성하는 생성자
    public Activity(FeedItem feedItem) {
        this.userId = feedItem.getUserId();
        this.userNickname = feedItem.getUserNickname();
        this.userProfileImage = feedItem.getUserProfileImage();
        // createdAt은 서블릿에서 변환 후 설정
        this.contentId = feedItem.getTargetId();

        // actionType을 activityType으로 변환
        String actionType = feedItem.getActionType();
        if (actionType == null) {
            this.activityType = "UNKNOWN";
        } else if ("review".equalsIgnoreCase(actionType)) {
            this.activityType = "REVIEW";
        } else if ("course".equalsIgnoreCase(actionType)) {
            this.activityType = "COURSE";
        } else if ("column".equalsIgnoreCase(actionType)) {
            this.activityType = "COLUMN";
        } else {
            this.activityType = actionType.toUpperCase();
        }

        this.contentTitle = feedItem.getTargetName();
        this.contentDescription = feedItem.getContent();
        this.contentImage = feedItem.getTargetImage();
        this.likeCount = feedItem.getLikeCount();
        this.commentCount = feedItem.getCommentCount();
    }

    // Getters and Setters
    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public String getTargetUrl() {
        return targetUrl;
    }

    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }
}