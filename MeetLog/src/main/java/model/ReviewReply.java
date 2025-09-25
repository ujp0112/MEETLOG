package model;

import java.util.Date;

/**
 * 리뷰 답글 모델
 * 비즈니스 사용자가 고객 리뷰에 답글을 작성할 때 사용
 */
public class ReviewReply {
    private int id;
    private int reviewId;           // 답글이 달린 리뷰 ID
    private int businessUserId;     // 답글 작성한 비즈니스 사용자 ID
    private String content;         // 답글 내용
    private Date createdAt;         // 작성일시
    private Date updatedAt;         // 수정일시
    private boolean isDeleted;      // 삭제 여부

    // 조인용 필드들
    private String businessUserName;  // 답글 작성자 이름
    private String restaurantName;    // 음식점 이름

    // 기본 생성자
    public ReviewReply() {
        this.createdAt = new Date();
        this.isDeleted = false;
    }

    // 매개변수 생성자
    public ReviewReply(int reviewId, int businessUserId, String content) {
        this();
        this.reviewId = reviewId;
        this.businessUserId = businessUserId;
        this.content = content;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getBusinessUserId() {
        return businessUserId;
    }

    public void setBusinessUserId(int businessUserId) {
        this.businessUserId = businessUserId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public String getBusinessUserName() {
        return businessUserName;
    }

    public void setBusinessUserName(String businessUserName) {
        this.businessUserName = businessUserName;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    @Override
    public String toString() {
        return "ReviewReply{" +
                "id=" + id +
                ", reviewId=" + reviewId +
                ", businessUserId=" + businessUserId +
                ", content='" + content + '\'' +
                ", createdAt=" + createdAt +
                ", businessUserName='" + businessUserName + '\'' +
                '}';
    }
}