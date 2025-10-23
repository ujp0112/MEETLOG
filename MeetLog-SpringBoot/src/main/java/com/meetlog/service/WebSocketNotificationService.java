package com.meetlog.service;

import com.meetlog.model.Notification;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

/**
 * WebSocket 실시간 알림 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WebSocketNotificationService {

    private final SimpMessagingTemplate messagingTemplate;

    /**
     * 특정 사용자에게 실시간 알림 전송
     *
     * @param userId 알림 받을 사용자 ID
     * @param notification 알림 객체
     */
    public void sendNotificationToUser(Long userId, Notification notification) {
        try {
            // /user/{userId}/queue/notifications 경로로 메시지 전송
            messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/notifications",
                notification
            );
            log.info("Sent real-time notification to user {}: {}", userId, notification.getTitle());
        } catch (Exception e) {
            log.error("Failed to send real-time notification to user {}: {}", userId, e.getMessage());
        }
    }

    /**
     * 모든 사용자에게 브로드캐스트 (공지사항 등)
     *
     * @param message 브로드캐스트 메시지
     */
    public void broadcastMessage(String message) {
        try {
            messagingTemplate.convertAndSend("/topic/announcements", message);
            log.info("Broadcast message: {}", message);
        } catch (Exception e) {
            log.error("Failed to broadcast message: {}", e.getMessage());
        }
    }

    /**
     * 특정 사용자의 읽지 않은 알림 수 전송
     *
     * @param userId 사용자 ID
     * @param unreadCount 읽지 않은 알림 수
     */
    public void sendUnreadCount(Long userId, int unreadCount) {
        try {
            messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/unread-count",
                unreadCount
            );
            log.info("Sent unread count to user {}: {}", userId, unreadCount);
        } catch (Exception e) {
            log.error("Failed to send unread count to user {}: {}", userId, e.getMessage());
        }
    }
}
