package dao;

import model.Notification;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

/**
 * 알림 시스템을 위한 DAO 클래스
 */
public class NotificationDAO {
    private static final String NAMESPACE = "dao.NotificationDAO";

    /**
     * 알림 생성
     */
    public int createNotification(Notification notification) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".createNotification", notification);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 사용자의 알림 목록 조회
     */
    public List<Notification> getUserNotifications(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getUserNotifications", params);
        }
    }

    /**
     * 읽지 않은 알림 수 조회
     */
    public int getUnreadNotificationCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getUnreadNotificationCount", userId);
        }
    }

    /**
     * 알림 읽음 처리
     */
    public int markAsRead(int notificationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".markAsRead", notificationId);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 사용자의 모든 알림 읽음 처리
     */
    public int markAllAsRead(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".markAllAsRead", userId);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 알림 삭제
     */
    public int deleteNotification(int notificationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".deleteNotification", notificationId);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 오래된 알림 삭제 (30일 이상)
     */
    public int deleteOldNotifications(int days) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".deleteOldNotifications", days);
            sqlSession.commit();
            return result;
        }
    }
}
