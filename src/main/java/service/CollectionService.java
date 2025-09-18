package service;

import dao.CollectionDAO;
import dao.FeedDAO;
import model.Collection;
import model.FeedItem;
import model.Restaurant;
import java.util.List;

/**
 * 맛집 컬렉션 시스템을 위한 서비스 클래스
 */
public class CollectionService {
    
    private CollectionDAO collectionDAO = new CollectionDAO();
    private FeedDAO feedDAO = new FeedDAO();

    /**
     * 컬렉션 생성
     */
    public boolean createCollection(Collection collection) {
        try {
            int result = collectionDAO.createCollection(collection);
            
            if (result > 0) {
                // 피드에 컬렉션 생성 활동 추가
                createCollectionFeedItem(collection);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 컬렉션 수정
     */
    public boolean updateCollection(Collection collection) {
        try {
            int result = collectionDAO.updateCollection(collection);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 컬렉션 삭제
     */
    public boolean deleteCollection(int collectionId) {
        try {
            int result = collectionDAO.deleteCollection(collectionId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 사용자의 컬렉션 목록 조회
     */
    public List<Collection> getUserCollections(int userId, int limit, int offset) {
        try {
            return collectionDAO.getUserCollections(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 공개 컬렉션 목록 조회
     */
    public List<Collection> getPublicCollections(int limit, int offset) {
        try {
            return collectionDAO.getPublicCollections(limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 컬렉션 상세 조회
     */
    public Collection getCollectionById(int collectionId) {
        try {
            return collectionDAO.getCollectionById(collectionId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 컬렉션에 맛집 추가
     */
    public boolean addRestaurantToCollection(int collectionId, int restaurantId) {
        try {
            int result = collectionDAO.addRestaurantToCollection(collectionId, restaurantId);
            
            if (result > 0) {
                // 컬렉션의 맛집 수 업데이트
                updateCollectionRestaurantCount(collectionId);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 컬렉션에서 맛집 제거
     */
    public boolean removeRestaurantFromCollection(int collectionId, int restaurantId) {
        try {
            int result = collectionDAO.removeRestaurantFromCollection(collectionId, restaurantId);
            
            if (result > 0) {
                // 컬렉션의 맛집 수 업데이트
                updateCollectionRestaurantCount(collectionId);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 컬렉션의 맛집 목록 조회
     */
    public List<Restaurant> getCollectionRestaurants(int collectionId) {
        try {
            return collectionDAO.getCollectionRestaurants(collectionId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 컬렉션 좋아요
     */
    public boolean likeCollection(int collectionId, int userId) {
        try {
            int result = collectionDAO.likeCollection(collectionId, userId);
            
            if (result > 0) {
                // 컬렉션의 좋아요 수 업데이트
                updateCollectionLikeCount(collectionId);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 컬렉션 좋아요 취소
     */
    public boolean unlikeCollection(int collectionId, int userId) {
        try {
            int result = collectionDAO.unlikeCollection(collectionId, userId);
            
            if (result > 0) {
                // 컬렉션의 좋아요 수 업데이트
                updateCollectionLikeCount(collectionId);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 컬렉션 좋아요 여부 확인
     */
    public boolean isCollectionLiked(int collectionId, int userId) {
        try {
            return collectionDAO.isCollectionLiked(collectionId, userId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 인기 컬렉션 조회
     */
    public List<Collection> getPopularCollections(int limit) {
        try {
            return collectionDAO.getPopularCollections(limit);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 컬렉션 피드 아이템 생성
     */
    private void createCollectionFeedItem(Collection collection) {
        try {
            FeedItem feedItem = new FeedItem();
            feedItem.setUserId(collection.getUserId());
            feedItem.setUserNickname("사용자"); // 실제로는 DB에서 조회
            feedItem.setActionType("collection");
            feedItem.setContent("새로운 컬렉션을 만들었습니다: " + collection.getName());
            feedItem.setTargetType("collection");
            feedItem.setTargetId(collection.getId());
            feedItem.setTargetName(collection.getName());
            feedItem.setTargetImage(collection.getCoverImage());
            
            feedDAO.createFeedItem(feedItem);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 컬렉션의 맛집 수 업데이트
     */
    private void updateCollectionRestaurantCount(int collectionId) {
        try {
            List<Restaurant> restaurants = collectionDAO.getCollectionRestaurants(collectionId);
            Collection collection = collectionDAO.getCollectionById(collectionId);
            
            if (collection != null) {
                collection.setRestaurantCount(restaurants.size());
                collectionDAO.updateCollection(collection);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 컬렉션의 좋아요 수 업데이트
     */
    private void updateCollectionLikeCount(int collectionId) {
        try {
            // TODO: 실제 좋아요 수를 계산하여 업데이트
            // 현재는 간단히 구현
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
