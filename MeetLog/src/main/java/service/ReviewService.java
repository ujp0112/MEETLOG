package service;

import dao.ReviewDAO;
import model.Review;
import model.ReviewInfo; 
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class ReviewService {
    private ReviewDAO reviewDAO = new ReviewDAO();

    public List<ReviewInfo> getRecentReviewsWithInfo(int limit) {
        return reviewDAO.getRecentReviewsWithInfo(limit);
    }
    
    // [복원] ReviewServlet을 위한 메서드 (사이트 전체 최신 리뷰)
    public List<Review> getRecentReviews(int limit) {
        return reviewDAO.findRecentReviews(limit);
    }
    
    // [유지] MypageServlet을 위한 메서드 (특정 사용자의 최신 리뷰)
    public List<Review> getRecentReviews(int userId, int limit) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("limit", limit);
        return reviewDAO.findRecentByUserId(params); 
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
}