package model;

import java.time.LocalDateTime;

/**
 * 팔로우 관계를 나타내는 모델 클래스
 */
public class Follow {
    private int id;
    private int followerId; // 팔로우하는 사용자
    private int followingId; // 팔로우받는 사용자
    private LocalDateTime createdAt;
    private boolean isActive;

    public Follow() {
    }

    public Follow(int followerId, int followingId) {
        this.followerId = followerId;
        this.followingId = followingId;
        this.isActive = true;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFollowerId() {
        return followerId;
    }

    public void setFollowerId(int followerId) {
        this.followerId = followerId;
    }

    public int getFollowingId() {
        return followingId;
    }

    public void setFollowingId(int followingId) {
        this.followingId = followingId;
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
