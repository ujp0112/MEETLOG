package service;

import dao.FeedDAO;
import model.FeedItem;
import java.util.List;
import java.util.Map;

/**
 * 소셜 피드 시스템을 위한 서비스 클래스
 */
public class FeedService {
    
    private FeedDAO feedDAO = new FeedDAO();

    /**
     * 사용자의 피드 조회 (팔로우한 사용자들의 활동)
     */
    public List<FeedItem> getUserFeed(int userId, int limit, int offset) {
        try {
            return feedDAO.getUserFeed(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 특정 사용자의 피드 아이템들을 가져옴 (간편 메소드)
     */
    public List<FeedItem> getFeedItems(int userId) {
        return getUserFeed(userId, 20, 0); // 기본값: 20개, 첫 페이지
    }

    /**
     * 특정 사용자의 피드 아이템들을 상세 정보와 함께 가져옴 (Map 형태)
     */
    public List<Map<String, Object>> getFeedItemsWithDetails(int userId) {
        try {
            return feedDAO.getUserFeedWithDetails(userId, 20, 0);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 팔로우한 사용자들의 활동 피드 조회 (상세 정보 포함)
     */
    public List<Map<String, Object>> getFollowingFeedWithDetails(int userId, int limit, int offset) {
        try {
            return feedDAO.getUserFeedWithDetails(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 특정 사용자의 활동 피드 조회
     */
    public List<FeedItem> getUserActivityFeed(int userId, int limit, int offset) {
        try {
            return feedDAO.getUserActivityFeed(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 특정 사용자의 활동 피드 조회 (Map 형태 - 상세 정보 포함)
     */
    public List<Map<String, Object>> getUserActivityFeedWithDetails(int userId, int limit, int offset) {
        return getUserActivityFeedWithDetails(userId, limit, offset, true);
    }

    public List<Map<String, Object>> getUserActivityFeedWithDetails(int userId, int limit, int offset, boolean includeFollow) {
        try {
            return feedDAO.getUserActivityFeedWithDetails(userId, limit, offset, includeFollow);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 전체 공개 피드 조회
     */
    public List<FeedItem> getPublicFeed(int limit, int offset) {
        try {
            return feedDAO.getPublicFeed(limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 범용 피드 아이템 생성
     */
    public void createFeedItem(FeedItem feedItem) {
        try {
            feedDAO.createFeedItem(feedItem);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("피드 아이템 생성 실패", e);
        }
    }

    /**
     * 리뷰 작성 피드 아이템 생성
     */
    public void createReviewFeedItem(int userId, String userNickname, String userProfileImage, 
                                   int restaurantId, String restaurantName, String restaurantImage, 
                                   String reviewContent) {
        try {
            FeedItem feedItem = new FeedItem();
            feedItem.setUserId(userId);
            feedItem.setUserNickname(userNickname);
            feedItem.setUserProfileImage(userProfileImage);
            feedItem.setActionType("review");
            feedItem.setContent("새로운 리뷰를 작성했습니다: " + reviewContent);
            feedItem.setTargetType("restaurant");
            feedItem.setTargetId(restaurantId);
            feedItem.setTargetName(restaurantName);
            feedItem.setTargetImage(restaurantImage);
            
            feedDAO.createFeedItem(feedItem);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 컬렉션 생성 피드 아이템 생성
     */
    public void createCollectionFeedItem(int userId, String userNickname, String userProfileImage,
                                       int collectionId, String collectionName, String collectionImage) {
        try {
            FeedItem feedItem = new FeedItem();
            feedItem.setUserId(userId);
            feedItem.setUserNickname(userNickname);
            feedItem.setUserProfileImage(userProfileImage);
            feedItem.setActionType("collection");
            feedItem.setContent("새로운 컬렉션을 만들었습니다: " + collectionName);
            feedItem.setTargetType("collection");
            feedItem.setTargetId(collectionId);
            feedItem.setTargetName(collectionName);
            feedItem.setTargetImage(collectionImage);
            
            feedDAO.createFeedItem(feedItem);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 간단한 리뷰 피드 아이템 생성 (현재 DB 스키마에 맞춤)
     */
    public void createSimpleReviewFeedItem(int userId, int reviewId) {
        try {
            // 현재 DB 스키마에 맞는 간단한 피드 아이템 생성
            feedDAO.createSimpleFeedItem(userId, "REVIEW", reviewId);
            System.out.println("DEBUG: 간단한 리뷰 피드 아이템 생성 완료 - 사용자: " + userId + ", 리뷰: " + reviewId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 피드 아이템 생성 실패", e);
        }
    }

    /**
     * 음식점 정보를 포함한 리뷰 피드 아이템 생성
     */
    public void createSimpleReviewFeedItemWithRestaurant(int userId, int reviewId, int restaurantId) {
        try {
            // 현재 DB 스키마에서는 음식점 ID를 별도로 저장할 수 없으므로 기존 방식 사용
            // 추후 피드 조회 시 리뷰 테이블과 조인해서 음식점 정보를 가져올 예정
            feedDAO.createSimpleFeedItem(userId, "REVIEW", reviewId);
            System.out.println("DEBUG: 음식점 정보 포함 리뷰 피드 아이템 생성 완료 - 사용자: " + userId + ", 리뷰: " + reviewId + ", 음식점: " + restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 피드 아이템 생성 실패", e);
        }
    }

    /**
     * 간단한 칼럼 피드 아이템 생성 (현재 DB 스키마에 맞춤)
     */
    public void createSimpleColumnFeedItem(int userId, int columnId) {
        try {
            // 현재 DB 스키마에 맞는 간단한 피드 아이템 생성
            feedDAO.createSimpleFeedItem(userId, "COLUMN", columnId);
            System.out.println("DEBUG: 간단한 칼럼 피드 아이템 생성 완료 - 사용자: " + userId + ", 칼럼: " + columnId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("칼럼 피드 아이템 생성 실패", e);
        }
    }

    /**
     * 간단한 코스 피드 아이템 생성 (현재 DB 스키마에 맞춤)
     */
    public void createSimpleCourseFeedItem(int userId, int courseId) {
        try {
            // 현재 DB 스키마에 맞는 간단한 피드 아이템 생성
            feedDAO.createSimpleFeedItem(userId, "COURSE", courseId);
            System.out.println("DEBUG: 간단한 코스 피드 아이템 생성 완료 - 사용자: " + userId + ", 코스: " + courseId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("코스 피드 아이템 생성 실패", e);
        }
    }

    /**
     * 피드 아이템 삭제
     */
    public boolean deleteFeedItem(int feedItemId) {
        try {
            int result = feedDAO.deleteFeedItem(feedItemId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 사용자별 피드 아이템 수 조회
     */
    public int getUserFeedCount(int userId) {
        try {
            return feedDAO.getUserFeedCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 팔로우한 사용자들의 최근 활동 조회
     */
    public List<FeedItem> getFollowingActivity(int userId, int limit) {
        try {
            return feedDAO.getFollowingActivity(userId, limit);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 메인 피드 조회 (자신의 활동 + 팔로우한 사용자들의 활동)
     */
    public List<Map<String, Object>> getMainFeedWithDetails(int userId, int limit, int offset) {
        try {
            return feedDAO.getMainFeed(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
}
