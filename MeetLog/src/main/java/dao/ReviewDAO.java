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

	// 리뷰 목록을 가져올 때 이미지도 함께 가져오도록 수정됩니다.
	public List<Review> findByRestaurantId(int restaurantId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
		}
	}
	public List<Review> findByRestaurantId(Map<String, Object> params) {
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
	        return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", params);
	    }
	}
	public int updateLikeCount(SqlSession session, Map<String, Object> params) {
	    return session.update(NAMESPACE + ".updateLikeCount", params);
	}
	
	public void addReply(SqlSession session, Map<String, Object> params) {
	    session.update(NAMESPACE + ".addReply", params);
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

	// [수정] 리뷰 기본 정보를 저장하는 메소드
	public int insertReview(SqlSession session, Review review) {
		return session.insert(NAMESPACE + ".insertReview", review);
	}

	// [추가] 리뷰 이미지 목록을 저장하는 메소드
	public int insertReviewImages(SqlSession session, Map<String, Object> params) {
		return session.insert(NAMESPACE + ".insertReviewImages", params);
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
	
	public void incrementLikes(SqlSession session, int reviewId) {
	    session.update(NAMESPACE + ".incrementLikes", reviewId);
	}

	public void decrementLikes(SqlSession session, int reviewId) {
	    session.update(NAMESPACE + ".decrementLikes", reviewId);
	}
}