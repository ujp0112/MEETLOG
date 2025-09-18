package service;

import dao.NotificationDAO;
import model.Notification;
import java.util.List;

/**
 * 알림 시스템을 위한 서비스 클래스
 */
public class NotificationService {
    
    private NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * 알림 생성
     */
    public boolean createNotification(Notification notification) {
        try {
            int result = notificationDAO.createNotification(notification);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 팔로우 알림 생성
     */
    public void createFollowNotification(int userId, String followerNickname) {
        try {
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setType("follow");
            notification.setTitle("새로운 팔로워");
            notification.setContent(followerNickname + "님이 당신을 팔로우했습니다");
            notification.setActionUrl("/user/" + userId);
            
            createNotification(notification);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 리뷰 좋아요 알림 생성
     */
    public void createReviewLikeNotification(int userId, String likerNickname, String restaurantName) {
        try {
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setType("like");
            notification.setTitle("리뷰에 좋아요");
            notification.setContent(likerNickname + "님이 " + restaurantName + " 리뷰에 좋아요를 눌렀습니다");
            notification.setActionUrl("/restaurant/detail/" + userId); // 실제로는 리뷰 ID 필요
            
            createNotification(notification);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 댓글 알림 생성
     */
    public void createCommentNotification(int userId, String commenterNickname, String restaurantName) {
        try {
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setType("comment");
            notification.setTitle("새로운 댓글");
            notification.setContent(commenterNickname + "님이 " + restaurantName + " 리뷰에 댓글을 남겼습니다");
            notification.setActionUrl("/restaurant/detail/" + userId); // 실제로는 리뷰 ID 필요
            
            createNotification(notification);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 컬렉션 좋아요 알림 생성
     */
    public void createCollectionLikeNotification(int userId, String likerNickname, String collectionName) {
        try {
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setType("collection");
            notification.setTitle("컬렉션에 좋아요");
            notification.setContent(likerNickname + "님이 " + collectionName + " 컬렉션에 좋아요를 눌렀습니다");
            notification.setActionUrl("/collection/" + userId); // 실제로는 컬렉션 ID 필요
            
            createNotification(notification);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 사용자의 알림 목록 조회
     */
    public List<Notification> getUserNotifications(int userId, int limit, int offset) {
        try {
            return notificationDAO.getUserNotifications(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 읽지 않은 알림 수 조회
     */
    public int getUnreadNotificationCount(int userId) {
        try {
            return notificationDAO.getUnreadNotificationCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 알림 읽음 처리
     */
    public boolean markAsRead(int notificationId) {
        try {
            int result = notificationDAO.markAsRead(notificationId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 사용자의 모든 알림 읽음 처리
     */
    public boolean markAllAsRead(int userId) {
        try {
            int result = notificationDAO.markAllAsRead(userId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 알림 삭제
     */
    public boolean deleteNotification(int notificationId) {
        try {
            int result = notificationDAO.deleteNotification(notificationId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 오래된 알림 정리 (30일 이상)
     */
    public boolean cleanupOldNotifications() {
        try {
            int result = notificationDAO.deleteOldNotifications(30);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
