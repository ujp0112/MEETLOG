package com.meetlog.repository;

import com.meetlog.dto.notification.NotificationDto;
import com.meetlog.model.Notification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Notification Repository Interface
 * 알림 관리용 MyBatis 매퍼
 */
@Mapper
public interface NotificationRepository {

    /**
     * ID로 알림 조회
     */
    Notification findById(@Param("id") Long id);

    /**
     * 사용자별 알림 목록 조회 (페이징)
     */
    List<NotificationDto> findByUserId(@Param("userId") Long userId,
                                        @Param("offset") int offset,
                                        @Param("limit") int limit);

    /**
     * 읽지 않은 알림 수
     */
    int countUnreadByUserId(@Param("userId") Long userId);

    /**
     * 전체 알림 수
     */
    int countByUserId(@Param("userId") Long userId);

    /**
     * 알림 생성
     */
    int insert(Notification notification);

    /**
     * 알림 읽음 처리
     */
    int markAsRead(@Param("id") Long id, @Param("readAt") LocalDateTime readAt);

    /**
     * 모든 알림 읽음 처리
     */
    int markAllAsRead(@Param("userId") Long userId, @Param("readAt") LocalDateTime readAt);

    /**
     * 알림 삭제
     */
    int delete(@Param("id") Long id);

    /**
     * 오래된 알림 일괄 삭제 (배치용)
     */
    int deleteOldNotifications(@Param("days") int days);

    /**
     * 특정 타입/참조 ID로 알림 존재 여부 확인
     */
    boolean existsByTypeAndReference(@Param("userId") Long userId,
                                      @Param("type") String type,
                                      @Param("referenceId") Long referenceId);
}
