package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import dao.ReviewDAO;
import model.Review;
import model.ReviewInfo;
import model.ReviewReply;
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

    public List<Review> getRecentReviewsByOwnerId(int ownerId, int limit) {
        return reviewDAO.findRecentReviewsByOwnerId(ownerId, limit);
    }

    public List<Review> searchReviews(Map<String, Object> searchParams) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("dao.ReviewDAO.searchReviews", searchParams);
        } catch (Exception e) {
            e.printStackTrace();
            return reviewDAO.findAll(); // 검색 실패 시 모든 리뷰 반환
        }
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

    // --- AJAX 기능을 위한 새로운 메서드들 ---

    /**
     * 리뷰 답글 추가 (AJAX용)
     */
    public boolean addReviewReply(ReviewReply reply) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reviewDAO.insertReviewReply(sqlSession, reply);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 최근 N분 이내의 비즈니스 사용자용 새 리뷰 조회
     */
    public List<Review> getRecentReviewsForBusiness(int businessUserId, int minutesAgo) {
        try {
            java.util.Date cutoffTime = new java.util.Date(System.currentTimeMillis() - (minutesAgo * 60 * 1000L));
            return reviewDAO.findRecentReviewsForBusiness(businessUserId, cutoffTime);
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * 답글이 필요한 리뷰 수 조회 (답글이 없는 리뷰)
     */
    public int getPendingReplyCount(int businessUserId) {
        try {
            return reviewDAO.getPendingReplyCount(businessUserId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}