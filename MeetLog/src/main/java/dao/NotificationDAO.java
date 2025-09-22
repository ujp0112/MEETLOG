package dao;

import model.Notification;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class NotificationDAO {
    private static final String NAMESPACE = "dao.NotificationDAO";
    
    /**
     * 사용자별 알림 목록 조회
     */
    public List<Notification> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
        }
    }
    
    /**
     * 알림 읽음 처리 (트랜잭션 포함)
     */
    public int markAsRead(int notificationId, int userId, SqlSession sqlSession) {
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("id", notificationId);
        params.put("userId", userId);
        return sqlSession.update(NAMESPACE + ".markAsRead", params);
    }
    
    /**
     * 모든 알림 읽음 처리 (트랜잭션 포함)
     */
    public int markAllAsRead(int userId, SqlSession sqlSession) {
        return sqlSession.update(NAMESPACE + ".markAllAsRead", userId);
    }
    
    /**
     * 알림 삭제 (트랜잭션 포함)
     */
    public int delete(int notificationId, int userId, SqlSession sqlSession) {
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("id", notificationId);
        params.put("userId", userId);
        return sqlSession.delete(NAMESPACE + ".delete", params);
    }
    
    /**
     * 알림 생성 (트랜잭션 포함)
     */
    public int insert(Notification notification, SqlSession sqlSession) {
        return sqlSession.insert(NAMESPACE + ".insert", notification);
    }
    
    /**
     * 읽지 않은 알림 수 조회
     */
    public long getUnreadCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getUnreadCount", userId);
        }
    }
}