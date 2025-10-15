package model;

import java.time.LocalDateTime;

/**
 * 칼럼 댓글을 나타내는 모델 클래스
 */
public class ColumnComment {
    private int id;
    private int columnId;
    private int userId;
    private String author;
    private String profileImage;
    private String content;
    private int parentId; // 대댓글의 경우 부모 댓글 ID
    private int likeCount;
    private LocalDateTime createdAt;
    private boolean isActive;
    private boolean isLiked;

    public boolean getIsLiked() {
        return isLiked;
    }

    public void setIsLiked(boolean isLiked) {
        this.isLiked = isLiked;
    }

    public ColumnComment() {
        // Default constructor
    }

    public ColumnComment(int columnId, int userId, String author, String content) {
        this.columnId = columnId;
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

    public int getColumnId() {
        return columnId;
    }

    public void setColumnId(int columnId) {
        this.columnId = columnId;
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

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
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


    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}