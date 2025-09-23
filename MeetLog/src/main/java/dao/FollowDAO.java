package dao;

import model.Follow;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class FollowDAO {
    private static final String NAMESPACE = "dao.FollowDAO";
    
    /**
     * 팔로우 관계 생성
     */
    public int follow(int followerId, int followingId) {
        Map<String, Integer> params = new HashMap<>();
        params.put("followerId", followerId);
        params.put("followingId", followingId);
        
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".follow", params);
            sqlSession.commit();
            return result;
        }
    }
    
    /**
     * 팔로우 관계 해제
     */
    public int unfollow(int followerId, int followingId) {
        Map<String, Integer> params = new HashMap<>();
        params.put("followerId", followerId);
        params.put("followingId", followingId);
        
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".unfollow", params);
            sqlSession.commit();
            return result;
        }
    }
    
    /**
     * 팔로우 관계 확인
     */
    public boolean isFollowing(int followerId, int followingId) {
        Map<String, Integer> params = new HashMap<>();
        params.put("followerId", followerId);
        params.put("followingId", followingId);
        
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".isFollowing", params);
            return count != null && count > 0;
        }
    }
    
    /**
     * 사용자의 팔로잉 목록 조회
     */
    public List<Follow> getFollowings(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getFollowings", userId);
        }
    }
    
    /**
     * 사용자의 팔로워 목록 조회
     */
    public List<Follow> getFollowers(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getFollowers", userId);
        }
    }
    
    /**
     * 팔로잉 수 조회
     */
    public int getFollowingCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".getFollowingCount", userId);
            return count != null ? count : 0;
        }
    }
    
    /**
     * 팔로워 수 조회
     */
    public int getFollowerCount(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".getFollowerCount", userId);
            return count != null ? count : 0;
        }
    }
    
    /**
     * 사용자의 팔로잉 ID 목록 조회 (피드용)
     */
    public List<Integer> getFollowingIds(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getFollowingIds", userId);
        }
    }
}