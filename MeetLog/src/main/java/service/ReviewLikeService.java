package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import dao.ReviewDAO; // ReviewDAO 임포트
import dao.ReviewLikeDAO;
import model.Review; // Review 모델 임포트
import model.User;
import util.MyBatisSqlSessionFactory;

public class ReviewLikeService {

    private final ReviewLikeDAO reviewLikeDAO = new ReviewLikeDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO(); // ReviewDAO 추가

    /**
     * [최종 수정] 좋아요를 토글하고, 최신 상태와 개수를 Map으로 반환하는 단일 메서드
     * @return Map<String, Object> - "isLiked" (boolean), "newLikeCount" (int) 포함
     */
    public Map<String, Object> toggleLike(int userId, int reviewId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 1. [안전장치] 리뷰가 실제로 존재하는지 먼저 확인합니다.
                Review review = reviewDAO.findById(reviewId);
                if (review == null) {
                    throw new RuntimeException("존재하지 않는 리뷰입니다.");
                }

                Map<String, Object> params = new HashMap<>();
                params.put("userId", userId);
                params.put("reviewId", reviewId);

                // 2. 현재 좋아요를 눌렀는지 확인
                boolean isAlreadyLiked = reviewLikeDAO.isLikedByUser(params) > 0;
                
                // 3. 좋아요/취소 DB 작업 수행
                if (isAlreadyLiked) {
                    reviewLikeDAO.deleteLike(session, params); // 좋아요 취소
                } else {
                    reviewLikeDAO.insertLike(session, params); // 좋아요 추가
                }
                
                // 4. reviews 테이블의 likes 카운트도 업데이트
                int change = isAlreadyLiked ? -1 : 1;
                Map<String, Object> countParams = new HashMap<>();
                countParams.put("reviewId", reviewId);
                countParams.put("change", change);
                reviewDAO.updateLikeCount(session, countParams); // likes 컬럼 업데이트
                
                session.commit(); // 모든 DB 작업을 한번에 커밋
                
                // 5. 최종 결과를 Map에 담아 반환
                Map<String, Object> result = new HashMap<>();
                result.put("isLiked", !isAlreadyLiked); // 상태가 반전되었으므로 !isAlreadyLiked
                result.put("newLikeCount", review.getLikes() + change);
                return result;

            } catch (Exception e) {
                session.rollback(); // 에러 발생 시 롤백
                e.printStackTrace();
                throw new RuntimeException("좋아요 처리 중 오류가 발생했습니다.", e);
            }
        }
    }

    public boolean isLikedByUser(int userId, int reviewId) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("reviewId", reviewId);
        return reviewLikeDAO.isLikedByUser(params) > 0;
    }
    
    public List<User> getUsersWhoLikedReview(int reviewId) {
        return reviewLikeDAO.findUsersWhoLikedReview(reviewId);
    }
}