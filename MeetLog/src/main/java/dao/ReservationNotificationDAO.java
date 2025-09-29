package dao;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import model.ReservationNotification;
import util.MyBatisSqlSessionFactory;

/**
 * 예약 알림 데이터 접근 객체
 */
public class ReservationNotificationDAO {

    /**
     * 특정 예약의 알림 목록 조회
     */
    public List<ReservationNotification> findByReservationId(int reservationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationNotificationMapper.findByReservationId", reservationId);
        }
    }

    /**
     * 알림 상태별 목록 조회
     */
    public List<ReservationNotification> findByStatus(ReservationNotification.NotificationStatus status) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationNotificationMapper.findByStatus", status.name());
        }
    }

    /**
     * 발송 대기 중인 알림 목록 조회
     */
    public List<ReservationNotification> findPendingNotifications() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationNotificationMapper.findPendingNotifications");
        }
    }

    /**
     * 특정 기간의 알림 목록 조회
     */
    public List<ReservationNotification> findByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);

            return sqlSession.selectList("ReservationNotificationMapper.findByDateRange", params);
        }
    }

    /**
     * 알림 유형별 목록 조회
     */
    public List<ReservationNotification> findByNotificationType(ReservationNotification.NotificationType notificationType) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationNotificationMapper.findByNotificationType", notificationType.name());
        }
    }

    /**
     * 특정 수신자의 알림 목록 조회
     */
    public List<ReservationNotification> findByRecipient(String recipient) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationNotificationMapper.findByRecipient", recipient);
        }
    }

    /**
     * ID로 알림 조회
     */
    public ReservationNotification findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("ReservationNotificationMapper.findById", id);
        }
    }

    /**
     * 알림 추가
     */
    public int insert(ReservationNotification notification) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("ReservationNotificationMapper.insert", notification);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 알림 상태 업데이트
     */
    public int updateStatus(int id, ReservationNotification.NotificationStatus status) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            params.put("status", status.name());
            if (status == ReservationNotification.NotificationStatus.SENT) {
                params.put("sentAt", LocalDateTime.now());
            }

            int result = sqlSession.update("ReservationNotificationMapper.updateStatus", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 알림 발송 완료 처리
     */
    public int markAsSent(int id) {
        return updateStatus(id, ReservationNotification.NotificationStatus.SENT);
    }

    /**
     * 알림 발송 실패 처리
     */
    public int markAsFailed(int id) {
        return updateStatus(id, ReservationNotification.NotificationStatus.FAILED);
    }

    /**
     * 알림 삭제
     */
    public int delete(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete("ReservationNotificationMapper.delete", id);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 예약별 알림 일괄 추가
     */
    public int insertBatch(List<ReservationNotification> notifications) {
        if (notifications == null || notifications.isEmpty()) {
            return 0;
        }

        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int totalInserted = 0;
            for (ReservationNotification notification : notifications) {
                totalInserted += sqlSession.insert("ReservationNotificationMapper.insert", notification);
            }
            sqlSession.commit();
            return totalInserted;
        }
    }

    /**
     * 오래된 알림 정리 (30일 이상 된 완료/실패 알림 삭제)
     */
    public int cleanupOldNotifications(int daysToKeep) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("cutoffDate", LocalDateTime.now().minusDays(daysToKeep));

            int result = sqlSession.delete("ReservationNotificationMapper.cleanupOldNotifications", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 알림 발송 통계 조회
     */
    public Map<String, Object> getNotificationStats() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("ReservationNotificationMapper.getNotificationStats");
        }
    }

    /**
     * 특정 기간의 알림 발송 성공률 조회
     */
    public Map<String, Object> getSuccessRateByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);

            return sqlSession.selectOne("ReservationNotificationMapper.getSuccessRateByDateRange", params);
        }
    }

    /**
     * 알림 유형별 발송 통계 조회
     */
    public List<Map<String, Object>> getStatsByNotificationType() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationNotificationMapper.getStatsByNotificationType");
        }
    }

    /**
     * 실패한 알림 재발송 대상 조회 (지정된 시간 이후 재시도)
     */
    public List<ReservationNotification> findFailedNotificationsForRetry(int hoursAfterFailure) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("retryAfter", LocalDateTime.now().minusHours(hoursAfterFailure));

            return sqlSession.selectList("ReservationNotificationMapper.findFailedNotificationsForRetry", params);
        }
    }

    /**
     * 특정 예약의 최근 알림 발송 여부 확인
     */
    public boolean hasRecentNotification(int reservationId, ReservationNotification.NotificationType notificationType, int withinHours) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("reservationId", reservationId);
            params.put("notificationType", notificationType.name());
            params.put("since", LocalDateTime.now().minusHours(withinHours));

            Integer count = sqlSession.selectOne("ReservationNotificationMapper.countRecentNotifications", params);
            return count != null && count > 0;
        }
    }
}