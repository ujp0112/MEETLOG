package model;

import java.time.LocalDateTime;

/**
 * 리뷰 댓글을 나타내는 모델 클래스
 */
public class ReviewComment {
    // IDE Cache Refresh - v2.0
    private int id;
    private int reviewId;
    private int userId;
    private String author;
    private String profileImage;
    private String content;
    private int parentId; // 대댓글의 경우 부모 댓글 ID
    private int likeCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isActive;
    private boolean isOwnerReply;

    public ReviewComment() {
        // Default constructor
    }

    public ReviewComment(int reviewId, int userId, String author, String content) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.author = author;
        this.content = content;
        this.isActive = true;
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

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public boolean isOwnerReply() {
        return isOwnerReply;
    }

    public void setIsOwnerReply(boolean isOwnerReply) {
        this.isOwnerReply = isOwnerReply;
    }

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}
}
