package model;

import java.time.LocalDateTime;

/**
 * 팔로우 관계 모델 클래스
 */
public class Follow {
    private int followId;
    private int followerId; // 팔로우하는 사용자 ID
    private int followingId; // 팔로우당하는 사용자 ID
    private LocalDateTime createdAt;
    
    // 조인된 사용자 정보
    private String followerNickname;
    private String followerProfileImage;
    private String followingNickname;
    private String followingProfileImage;

    public Follow() {
    }

    public Follow(int followerId, int followingId) {
        this.followerId = followerId;
        this.followingId = followingId;
    }

    // Getters and Setters
    public int getFollowId() {
        return followId;
    }

    public void setFollowId(int followId) {
        this.followId = followId;
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

    public String getFollowerNickname() {
        return followerNickname;
    }

    public void setFollowerNickname(String followerNickname) {
        this.followerNickname = followerNickname;
    }

    public String getFollowerProfileImage() {
        return followerProfileImage;
    }

    public void setFollowerProfileImage(String followerProfileImage) {
        this.followerProfileImage = followerProfileImage;
    }

    public String getFollowingNickname() {
        return followingNickname;
    }

    public void setFollowingNickname(String followingNickname) {
        this.followingNickname = followingNickname;
    }

    public String getFollowingProfileImage() {
        return followingProfileImage;
    }

    public void setFollowingProfileImage(String followingProfileImage) {
        this.followingProfileImage = followingProfileImage;
    }
}