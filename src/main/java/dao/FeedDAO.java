package dao;

import model.FeedItem;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

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
     * 사용자의 피드 조회 (팔로우한 사용자들의 활동)
     */
    public List<FeedItem> getUserFeed(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getUserFeed", params);
        }
    }

    /**
     * 특정 사용자의 활동 피드 조회
     */
    public List<FeedItem> getUserActivityFeed(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getUserActivityFeed", params);
        }
    }

    /**
     * 전체 공개 피드 조회 (인기 활동)
     */
    public List<FeedItem> getPublicFeed(int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getPublicFeed", params);
        }
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
            Map<String, Object> params = Map.of("userId", userId, "limit", limit);
            return sqlSession.selectList(NAMESPACE + ".getFollowingActivity", params);
        }
    }
}
