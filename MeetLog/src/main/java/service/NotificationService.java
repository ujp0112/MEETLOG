package service;

import java.util.List;
import model.Notification;
import dao.NotificationDAO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

public class NotificationService {
    private NotificationDAO notificationDAO = new NotificationDAO();
    
    /**
     * 사용자별 알림 목록 조회
     */
    public List<Notification> getNotificationsByUserId(int userId) {
        return notificationDAO.findByUserId(userId);
    }
    
    /**
     * 알림 읽음 처리
     */
    public boolean markAsRead(int notificationId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = notificationDAO.markAsRead(notificationId, userId, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 모든 알림 읽음 처리
     */
    public boolean markAllAsRead(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = notificationDAO.markAllAsRead(userId, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 알림 삭제
     */
    public boolean deleteNotification(int notificationId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = notificationDAO.delete(notificationId, userId, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 새 알림 생성
     */
    public boolean createNotification(Notification notification) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = notificationDAO.insert(notification, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 읽지 않은 알림 수 조회
     */
    public long getUnreadCount(int userId) {
        return notificationDAO.getUnreadCount(userId);
    }
}