package com.meetlog.dto.notification;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 알림 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationDto {
    private Long id;
    private Long userId;
    private String type; // follow, like, comment, review, reservation
    private String title;
    private String content;
    private String actionUrl;
    private Boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;

    // 알림을 발생시킨 사용자 정보
    private Long actorId;
    private String actorName;
    private String actorNickname;
    private String actorProfileImage;
}
