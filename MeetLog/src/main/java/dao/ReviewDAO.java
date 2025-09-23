package dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import model.Review;
import model.ReviewInfo;
import util.MyBatisSqlSessionFactory;

public class ReviewDAO {
    private static final String NAMESPACE = "dao.ReviewDAO";

    public List<Review> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
        }
    }

    public Review findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", id);
        }
    }

    public List<ReviewInfo> getRecentReviewsWithInfo(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getRecentReviewsWithInfo", limit);
        }
    }

    public List<Review> findRecentReviews(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentReviews", limit);
        }
    }

    public List<Review> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }

    public List<Review> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
        }
    }

    public List<Review> findRecentByUserId(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentByUserId", params);
        }
    }

    public List<Review> findRecentReviewsByOwnerId(int ownerId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            java.util.Map<String, Object> params = new java.util.HashMap<>();
            params.put("ownerId", ownerId);
            params.put("limit", limit);
            return sqlSession.selectList(NAMESPACE + ".findRecentReviewsByOwnerId", params);
        }
    }

    public int insert(SqlSession session, Review review) {
        return session.insert(NAMESPACE + ".insert", review);
    }

    public int update(SqlSession session, Review review) {
        return session.update(NAMESPACE + ".update", review);
    }

    public int delete(SqlSession session, int id) {
        return session.delete(NAMESPACE + ".delete", id);
    }

    public int likeReview(SqlSession session, int id) {
        return session.update(NAMESPACE + ".likeReview", id);
    }
    
    /**
     * 특정 사용자의 최근 리뷰 조회 (피드용)
     */
    public List<Review> getRecentReviewsByUser(int userId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            java.util.Map<String, Object> params = new java.util.HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);
            return sqlSession.selectList(NAMESPACE + ".getRecentReviewsByUser", params);
        }
    }
    
    /**
     * 특정 사용자의 리뷰 개수 조회
     */
    public int getReviewCountByUser(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".getReviewCountByUser", userId);
            return count != null ? count : 0;
        }
    }
}