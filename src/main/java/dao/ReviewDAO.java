package dao;

import model.Review;
import model.ReviewInfo; // ReviewInfo 모델 import
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class ReviewDAO {
    // DAO와 Mapper XML을 연결하는 고유한 이름
    private static final String NAMESPACE = "dao.ReviewDAO";

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

    public int insert(Review review) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", review);
            sqlSession.commit(); // 데이터 변경이 있으므로 commit() 호출
            return result;
        }
    }

    public int delete(int reviewId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".delete", reviewId);
            sqlSession.commit();
            return result;
        }
    }

    public int likeReview(int reviewId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".likeReview", reviewId);
            sqlSession.commit();
            return result;
        }
    }
    
    // --- 여기에 추가된 새로운 메소드 (수정 완료) ---
    /**
     * 최신 리뷰를 맛집 이름과 함께 가져옵니다. (MyBatis 버전)
     * @param limit 가져올 리뷰 개수
     * @return ReviewInfo 객체 리스트
     */
    public List<ReviewInfo> getRecentReviewsWithInfo(int limit) {
        // 1. MyBatis 세션을 엽니다.
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            // 2. Mapper XML의 쿼리를 호출합니다.
            return sqlSession.selectList(NAMESPACE + ".getRecentReviewsWithInfo", limit);
        }
        // 3. try-with-resources 구문이 자동으로 세션을 닫아줍니다.
    }
    
    /**
     * 특정 사업자의 음식점들에 대한 최근 리뷰를 가져옵니다.
     * @param ownerId 사업자 ID
     * @param limit 가져올 리뷰 개수
     * @return Review 객체의 리스트
     */
	public List<Review> findRecentReviewsByOwnerId(int ownerId, int limit) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findRecentReviewsByOwnerId", 
				new java.util.HashMap<String, Object>() {{
					put("ownerId", ownerId);
					put("limit", limit);
				}});
		}
	}
	
	/**
	 * 고급 검색을 위한 리뷰 검색
	 */
	public List<Review> searchReviews(java.util.Map<String, Object> searchParams) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".searchReviews", searchParams);
		}
	}
}