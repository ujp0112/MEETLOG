package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Notification 엔티티
 * 사용자 알림 정보
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Notification {
    private Long id;
    private Long userId;
    private String type; // follow, like, comment, review, reservation, etc.
    private String title;
    private String content;
    private String actionUrl; // 클릭 시 이동할 URL
    private Boolean isRead;
    private Long actorId; // 알림을 발생시킨 사용자 ID
    private Long referenceId; // 참조 ID (게시글, 댓글 등)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime readAt;

    // Helper methods
    public boolean isUnread() {
        return isRead == null || !isRead;
    }

    public void markAsRead() {
        this.isRead = true;
        this.readAt = LocalDateTime.now();
    }

    public boolean isFollow() {
        return "follow".equals(type);
    }

    public boolean isLike() {
        return "like".equals(type);
    }

    public boolean isComment() {
        return "comment".equals(type);
    }

    public boolean isReview() {
        return "review".equals(type);
    }

    public boolean isReservation() {
        return "reservation".equals(type);
    }

    public String getTypeText() {
        switch (type) {
            case "follow":
                return "팔로우";
            case "like":
                return "좋아요";
            case "comment":
                return "댓글";
            case "review":
                return "리뷰";
            case "reservation":
                return "예약";
            default:
                return type;
        }
    }
}
