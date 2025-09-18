package dao;

import model.Follow;
import model.User;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

/**
 * 팔로우 시스템을 위한 DAO 클래스
 */
public class FollowDAO {
    private static final String NAMESPACE = "dao.FollowDAO";

    /**
     * 팔로우 관계 생성
     */
    public int followUser(int followerId, int followingId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("followerId", followerId, "followingId", followingId);
            int result = sqlSession.insert(NAMESPACE + ".followUser", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 팔로우 관계 삭제 (언팔로우)
     */
    public int unfollowUser(int followerId, int followingId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("followerId", followerId, "followingId", followingId);
            int result = sqlSession.update(NAMESPACE + ".unfollowUser", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 팔로우 관계 확인
     */
    public boolean isFollowing(int followerId, int followingId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("followerId", followerId, "followingId", followingId);
            Integer count = sqlSession.selectOne(NAMESPACE + ".isFollowing", params);
            return count != null && count > 0;
        }
    }

    /**
     * 사용자의 팔로워 목록 조회
     */
    public List<User> getFollowers(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getFollowers", params);
        }
    }

    /**
     * 사용자의 팔로잉 목록 조회
     */
    public List<User> getFollowing(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getFollowing", params);
        }
    }

    /**
     * 팔로워 수 조회
     */
    public int getFollowerCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getFollowerCount", userId);
        }
    }

    /**
     * 팔로잉 수 조회
     */
    public int getFollowingCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getFollowingCount", userId);
        }
    }

    /**
     * 팔로우 관계 조회
     */
    public Follow getFollow(int followerId, int followingId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("followerId", followerId, "followingId", followingId);
            return sqlSession.selectOne(NAMESPACE + ".getFollow", params);
        }
    }

    /**
     * 사용자의 팔로우 피드용 팔로잉 목록 (피드 생성용)
     */
    public List<Integer> getFollowingIds(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getFollowingIds", userId);
        }
    }
}
