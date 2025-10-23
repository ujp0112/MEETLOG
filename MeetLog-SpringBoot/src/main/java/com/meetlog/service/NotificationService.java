package com.meetlog.service;

import com.meetlog.dto.notification.NotificationDto;
import com.meetlog.model.Notification;
import com.meetlog.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 알림 서비스
 */
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final WebSocketNotificationService webSocketNotificationService;

    /**
     * 사용자 알림 목록 조회
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getNotifications(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        List<NotificationDto> notifications = notificationRepository
                .findByUserId(userId, offset, size);

        int unreadCount = notificationRepository.countUnreadByUserId(userId);
        int totalCount = notificationRepository.countByUserId(userId);

        return Map.of(
            "notifications", notifications,
            "unreadCount", unreadCount,
            "totalCount", totalCount,
            "page", page,
            "size", size
        );
    }

    /**
     * 읽지 않은 알림 수 조회
     */
    @Transactional(readOnly = true)
    public int getUnreadCount(Long userId) {
        return notificationRepository.countUnreadByUserId(userId);
    }

    /**
     * 알림 생성
     */
    @Transactional
    public Notification createNotification(Long userId, String type, String title,
                                          String content, String actionUrl, Long actorId) {
        Notification notification = Notification.builder()
                .userId(userId)
                .type(type)
                .title(title)
                .content(content)
                .actionUrl(actionUrl)
                .actorId(actorId)
                .isRead(false)
                .build();

        notificationRepository.insert(notification);

        // 실시간 알림 전송
        try {
            webSocketNotificationService.sendNotificationToUser(userId, notification);
        } catch (Exception e) {
            // WebSocket 전송 실패해도 알림은 저장되어야 함
            System.err.println("Failed to send real-time notification: " + e.getMessage());
        }

        return notification;
    }

    /**
     * 알림 읽음 처리
     */
    @Transactional
    public void markAsRead(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findById(notificationId);
        if (notification == null) {
            throw new RuntimeException("Notification not found");
        }
        if (!notification.getUserId().equals(userId)) {
            throw new RuntimeException("No permission");
        }

        notificationRepository.markAsRead(notificationId, LocalDateTime.now());
    }

    /**
     * 모든 알림 읽음 처리
     */
    @Transactional
    public void markAllAsRead(Long userId) {
        notificationRepository.markAllAsRead(userId, LocalDateTime.now());
    }

    /**
     * 알림 삭제
     */
    @Transactional
    public void deleteNotification(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findById(notificationId);
        if (notification == null) {
            throw new RuntimeException("Notification not found");
        }
        if (!notification.getUserId().equals(userId)) {
            throw new RuntimeException("No permission");
        }

        notificationRepository.delete(notificationId);
    }

    /**
     * 팔로우 알림 생성
     */
    @Transactional
    public void notifyFollow(Long followerId, Long followingId, String followerName) {
        createNotification(
            followingId,
            "follow",
            "새 팔로워",
            followerName + "님이 회원님을 팔로우하기 시작했습니다.",
            "/users/" + followerId,
            followerId
        );
    }

    /**
     * 좋아요 알림 생성
     */
    @Transactional
    public void notifyLike(Long actorId, Long targetUserId, String actorName,
                          String contentType, Long contentId) {
        createNotification(
            targetUserId,
            "like",
            "새 좋아요",
            actorName + "님이 회원님의 " + contentType + "을(를) 좋아합니다.",
            getContentUrl(contentType, contentId),
            actorId
        );
    }

    /**
     * 댓글 알림 생성
     */
    @Transactional
    public void notifyComment(Long actorId, Long targetUserId, String actorName,
                             String contentType, Long contentId) {
        createNotification(
            targetUserId,
            "comment",
            "새 댓글",
            actorName + "님이 회원님의 " + contentType + "에 댓글을 남겼습니다.",
            getContentUrl(contentType, contentId),
            actorId
        );
    }

    /**
     * 리뷰 알림 생성 (레스토랑 사업자용)
     */
    @Transactional
    public void notifyReview(Long actorId, Long restaurantOwnerId, String actorName,
                            Long restaurantId) {
        createNotification(
            restaurantOwnerId,
            "review",
            "새 리뷰",
            actorName + "님이 회원님의 레스토랑에 리뷰를 남겼습니다.",
            "/restaurants/" + restaurantId,
            actorId
        );
    }

    /**
     * 예약 알림 생성 (레스토랑 사업자용)
     */
    @Transactional
    public void notifyReservation(Long actorId, Long restaurantOwnerId, String actorName,
                                 Long restaurantId) {
        createNotification(
            restaurantOwnerId,
            "reservation",
            "새 예약",
            actorName + "님이 회원님의 레스토랑에 예약을 신청했습니다.",
            "/reservations/" + restaurantId,
            actorId
        );
    }

    /**
     * 오래된 알림 삭제 (배치용)
     */
    @Transactional
    public int deleteOldNotifications(int days) {
        return notificationRepository.deleteOldNotifications(days);
    }

    /**
     * 컨텐츠 URL 생성
     */
    private String getContentUrl(String contentType, Long contentId) {
        switch (contentType) {
            case "review":
            case "리뷰":
                return "/reviews/" + contentId;
            case "column":
            case "칼럼":
                return "/columns/" + contentId;
            case "course":
            case "코스":
                return "/courses/" + contentId;
            default:
                return "/";
        }
    }
}
