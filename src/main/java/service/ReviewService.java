package service;

import dao.ReviewDAO;
import model.Review;
import model.ReviewInfo; // ReviewInfo 모델을 import 합니다.
import java.util.List;

public class ReviewService {
	// IDE Cache Refresh - v2.0
	private ReviewDAO reviewDAO = new ReviewDAO();

    // --- 여기에 추가될 새로운 메소드 ---
    /**
     * 최신 리뷰 목록을 맛집 이름 정보와 함께 가져옵니다. (MainServlet용)
     * @param limit 가져올 리뷰 개수
     * @return ReviewInfo 객체의 리스트
     */
    public List<ReviewInfo> getRecentReviewsWithInfo(int limit) {
        // DAO에 있는 새로운 메소드를 그대로 호출해줍니다.
        return reviewDAO.getRecentReviewsWithInfo(limit);
    }
    
    // --- 기존 메소드들 (변경 없음) ---
    public List<Review> getRecentReviews(int limit) {
        return reviewDAO.findRecentReviews(limit);
    }

    public List<Review> getReviewsByRestaurantId(int restaurantId) {
        return reviewDAO.findByRestaurantId(restaurantId);
    }

    public List<Review> getReviewsByUserId(int userId) {
        return reviewDAO.findByUserId(userId);
    }

    public boolean addReview(Review review) {
        return reviewDAO.insert(review) > 0;
    }

    public boolean deleteReview(int reviewId) {
        return reviewDAO.delete(reviewId) > 0;
    }

    public boolean likeReview(int reviewId) {
        return reviewDAO.likeReview(reviewId) > 0;
    }
    
    /**
     * 특정 사업자의 음식점들에 대한 최근 리뷰를 가져옵니다.
     * @param ownerId 사업자 ID
     * @param limit 가져올 리뷰 개수
     * @return Review 객체의 리스트
     */
	public List<Review> getRecentReviewsByOwnerId(int ownerId, int limit) {
		return reviewDAO.findRecentReviewsByOwnerId(ownerId, limit);
	}
	
	/**
	 * 고급 검색을 위한 리뷰 검색
	 */
	public List<Review> searchReviews(java.util.Map<String, Object> searchParams) {
		return reviewDAO.searchReviews(searchParams);
	}
}