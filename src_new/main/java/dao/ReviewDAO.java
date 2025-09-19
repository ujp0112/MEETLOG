package dao;

import model.Review;
import model.ReviewInfo;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class ReviewDAO {
    private static final String NAMESPACE = "dao.ReviewDAO";

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

    // [추가] MypageServlet을 위한 메서드
    public List<Review> findRecentByUserId(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentByUserId", params);
        }
    }

    public int insert(Review review) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", review);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int delete(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".delete", id);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int likeReview(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".likeReview", id);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }
}