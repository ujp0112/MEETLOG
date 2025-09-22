package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import model.Review;
import model.ReviewInfo;
import util.MyBatisSqlSessionFactory;

public class ReviewDAO {
    private static final String NAMESPACE = "review";

    /**
     * 모든 리뷰 조회
     */
    public List<Review> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
        }
    }

    /**
     * ID로 리뷰 조회
     */
    public Review findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", id);
        }
    }

    /**
     * 음식점 ID로 리뷰 목록 조회
     */
    public List<Review> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }

    /**
     * 사용자 ID로 리뷰 목록 조회
     */
    public List<Review> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
        }
    }

    /**
     * 리뷰 추가
     */
    public int insert(Review review) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", review);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 리뷰 수정
     */
    public int update(Review review) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".update", review);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 리뷰 삭제
     */
    public int delete(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".delete", id);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 특정 사업자의 음식점들에 대한 최근 리뷰를 가져옵니다.
     * @param ownerId 사업자 ID
     * @param limit 가져올 리뷰 개수
     * @return Review 객체의 리스트
     */
    public List<Review> findRecentReviewsByOwnerId(int ownerId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            java.util.Map<String, Object> params = new java.util.HashMap<>();
            params.put("ownerId", ownerId);
            params.put("limit", limit);
            return sqlSession.selectList(NAMESPACE + ".findRecentReviewsByOwnerId", params);
        }
    }
    
    /**
     * 최근 리뷰 조회
     */
    public List<Review> findRecentReviews(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentReviews", limit);
        }
    }
    
    /**
     * 최근 리뷰 정보 조회 (ReviewInfo 타입)
     */
    public List<ReviewInfo> findRecentReviewsWithInfo(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentReviewsWithInfo", limit);
        }
    }
}