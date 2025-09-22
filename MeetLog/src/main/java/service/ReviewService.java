package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import dao.ReviewDAO;
import model.Review;
import model.ReviewInfo;
import util.MyBatisSqlSessionFactory;

public class ReviewService {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    // --- Read Operations ---
    public List<Review> findAll() {
        return reviewDAO.findAll();
    }

    public Review findById(int id) {
        return reviewDAO.findById(id);
    }

    public List<ReviewInfo> getRecentReviewsWithInfo(int limit) {
        return reviewDAO.getRecentReviewsWithInfo(limit);
    }

    public List<Review> getRecentReviews(int limit) {
        return reviewDAO.findRecentReviews(limit);
    }

    public List<Review> getReviewsByRestaurantId(int restaurantId) {
        return reviewDAO.findByRestaurantId(restaurantId);
    }

    public List<Review> getReviewsByUserId(int userId) {
        return reviewDAO.findByUserId(userId);
    }

    public List<Review> getRecentReviews(int userId, int limit) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("limit", limit);
        return reviewDAO.findRecentByUserId(params);
    }

    public List<Review> searchReviews(Map<String, Object> searchParams) {
        return reviewDAO.findAll(); // 임시로 모든 리뷰 반환
    }

    // --- Write Operations with Service-Layer Transaction Management ---
    public boolean addReview(Review review) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reviewDAO.insert(sqlSession, review);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean updateReview(Review review) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reviewDAO.update(sqlSession, review);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean deleteReview(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reviewDAO.delete(sqlSession, id);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean likeReview(int reviewId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reviewDAO.likeReview(sqlSession, reviewId);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }
}