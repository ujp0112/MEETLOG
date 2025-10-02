package dao;

import model.FeedItem;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * 소셜 피드 시스템을 위한 DAO 클래스
 */
public class FeedDAO {
    private static final String NAMESPACE = "dao.FeedDAO";

    /**
     * 피드 아이템 생성
     */
    public int createFeedItem(FeedItem feedItem) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".createFeedItem", feedItem);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 간단한 피드 아이템 생성 (현재 DB 스키마에 맞춤)
     */
    public int createSimpleFeedItem(int userId, String feedType, int contentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("feedType", feedType);
            params.put("contentId", contentId);
            int result = sqlSession.insert(NAMESPACE + ".createSimpleFeedItem", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 사용자의 피드 조회 (팔로우한 사용자들의 활동)
     */
    public List<FeedItem> getUserFeed(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            params.put("offset", offset);
            List<Map<String, Object>> results = sqlSession.selectList(NAMESPACE + ".getUserFeed", params);
            return convertMapListToFeedItems(results);
        }
    }

    /**
     * 사용자의 피드 조회 (Map 형태로 반환 - 음식점 정보 포함)
     */
    public List<Map<String, Object>> getUserFeedWithDetails(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            params.put("offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getUserFeed", params);
        }
    }

    /**
     * 특정 사용자의 활동 피드 조회
     */
    public List<FeedItem> getUserActivityFeed(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            params.put("offset", offset);
            List<Map<String, Object>> results = sqlSession.selectList(NAMESPACE + ".getUserActivityFeed", params);
            return convertMapListToFeedItems(results);
        }
    }

    /**
     * 특정 사용자의 활동 피드 조회 (Map 형태로 반환 - 상세 정보 포함)
     */
    public List<Map<String, Object>> getUserActivityFeedWithDetails(int userId, int limit, int offset, boolean includeFollow) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            params.put("offset", offset);
            params.put("includeFollow", includeFollow);
            return sqlSession.selectList(NAMESPACE + ".getUserActivityFeed", params);
        }
    }

    /**
     * 전체 공개 피드 조회 (인기 활동)
     */
    public List<FeedItem> getPublicFeed(int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("limit", limit);
            params.put("offset", offset);
            List<Map<String, Object>> results = sqlSession.selectList(NAMESPACE + ".getPublicFeed", params);
            return convertMapListToFeedItems(results);
        }
    }

    /**
     * Map 결과를 FeedItem 리스트로 변환
     */
    private List<FeedItem> convertMapListToFeedItems(List<Map<String, Object>> results) {
        List<FeedItem> feedItems = new ArrayList<>();
        for (Map<String, Object> result : results) {
            FeedItem item = new FeedItem();
            item.setId(((Number) result.get("id")).intValue());
            item.setUserId(((Number) result.get("userId")).intValue());
            item.setUserNickname((String) result.get("userNickname"));
            item.setUserProfileImage((String) result.get("userProfileImage"));
            item.setActionType((String) result.get("actionType"));
            item.setTargetId(((Number) result.get("targetId")).intValue());
            
            // 리뷰의 경우 음식점 정보 설정
            if ("REVIEW".equals(result.get("actionType"))) {
                Object contentLocationObj = result.get("contentLocation");
                if (contentLocationObj != null) {
                    // contentLocation에 음식점 ID 저장
                    item.setTargetName(String.valueOf(((Number) contentLocationObj).intValue()));
                }
                // restaurantName은 Activity 변환 시 사용
            }
            
            // Timestamp를 LocalDateTime으로 변환
            Object createdAtObj = result.get("createdAt");
            if (createdAtObj instanceof java.sql.Timestamp) {
                item.setCreatedAt(((java.sql.Timestamp) createdAtObj).toLocalDateTime());
            }

            Object targetNameObj = result.get("targetName");
            if (targetNameObj instanceof String) {
                item.setTargetName((String) targetNameObj);
            }

            Object targetImageObj = result.get("targetImage");
            if (targetImageObj instanceof String) {
                item.setTargetImage((String) targetImageObj);
            }

            Object restaurantNameObj = result.get("restaurantName");
            if (restaurantNameObj instanceof String && item.getTargetName() == null) {
                item.setTargetName((String) restaurantNameObj);
            }

            // 기본값 설정
            item.setContent("활동");
            item.setTargetType(item.getActionType().toLowerCase());
            item.setActive(true);

            feedItems.add(item);
        }
        return feedItems;
    }

    /**
     * 피드 아이템 삭제
     */
    public int deleteFeedItem(int feedItemId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".deleteFeedItem", feedItemId);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 사용자별 피드 아이템 수 조회
     */
    public int getUserFeedCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getUserFeedCount", userId);
        }
    }

    /**
     * 팔로우한 사용자들의 최근 활동 조회
     */
    public List<FeedItem> getFollowingActivity(int userId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            List<Map<String, Object>> results = sqlSession.selectList(NAMESPACE + ".getFollowingActivity", params);
            return convertMapListToFeedItems(results);
        }
    }

    /**
     * 메인 피드 조회 (자신의 활동 + 팔로우한 사용자들의 활동)
     */
    public List<Map<String, Object>> getMainFeed(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            params.put("offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getMainFeed", params);
        }
    }
}
