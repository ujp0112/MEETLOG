package service;

import dao.ReviewDAO;
import model.Review;
import model.ReviewInfo;
import java.util.List;

public class ReviewService {
    private ReviewDAO reviewDAO = new ReviewDAO();
    
    /**
     * 모든 리뷰 조회
     */
    public List<Review> findAll() {
        return reviewDAO.findAll();
    }
    
    /**
     * ID로 리뷰 조회
     */
    public Review findById(int id) {
        return reviewDAO.findById(id);
    }
    
    /**
     * 음식점별 리뷰 조회
     */
    public List<Review> getReviewsByRestaurantId(int restaurantId) {
        return reviewDAO.findByRestaurantId(restaurantId);
    }
    
    /**
     * 사용자별 리뷰 조회
     */
    public List<Review> getReviewsByUserId(int userId) {
        return reviewDAO.findByUserId(userId);
    }
    
    /**
     * 리뷰 추가
     */
    public boolean addReview(Review review) {
        return reviewDAO.insert(review) > 0;
    }
    
    /**
     * 리뷰 수정
     */
    public boolean updateReview(Review review) {
        return reviewDAO.update(review) > 0;
    }
    
    /**
     * 리뷰 삭제
     */
    public boolean deleteReview(int id) {
        return reviewDAO.delete(id) > 0;
    }
    
    /**
     * 최근 리뷰 조회 (사업자용)
     */
    public List<Review> getRecentReviewsByOwnerId(int ownerId, int limit) {
        return reviewDAO.findRecentReviewsByOwnerId(ownerId, limit);
    }
    
    /**
     * 최근 리뷰 정보 조회 (ReviewInfo 타입)
     */
    public List<ReviewInfo> getRecentReviewsWithInfo(int limit) {
        return reviewDAO.findRecentReviewsWithInfo(limit);
    }
    
    /**
     * 고급 검색을 위한 리뷰 검색
     */
    public List<Review> searchReviews(java.util.Map<String, Object> searchParams) {
        return reviewDAO.findAll(); // 임시로 모든 리뷰 반환
    }
}