package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Follow 엔티티
 * 사용자 간 팔로우 관계
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Follow {
    private Long id;
    private Long followerId; // 팔로우하는 사람
    private Long followingId; // 팔로우 받는 사람
    private Boolean isActive;
    private LocalDateTime createdAt;

    // Helper methods
    public boolean isActive() {
        return isActive != null && isActive;
    }

    public void activate() {
        this.isActive = true;
    }

    public void deactivate() {
        this.isActive = false;
    }

    public boolean isMutualFollow(Follow other) {
        return this.followerId.equals(other.followingId)
            && this.followingId.equals(other.followerId);
    }
}
