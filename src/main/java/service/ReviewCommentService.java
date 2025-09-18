package service;

import dao.ReviewCommentDAO;
import model.ReviewComment;
import java.util.List;

/**
 * 리뷰 댓글 시스템을 위한 서비스 클래스
 */
public class ReviewCommentService {
    
    private ReviewCommentDAO reviewCommentDAO = new ReviewCommentDAO();

    /**
     * 댓글 생성
     */
    public boolean createComment(ReviewComment comment) {
        try {
            int result = reviewCommentDAO.createComment(comment);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 댓글 수정
     */
    public boolean updateComment(ReviewComment comment) {
        try {
            int result = reviewCommentDAO.updateComment(comment);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 댓글 삭제
     */
    public boolean deleteComment(int commentId) {
        try {
            int result = reviewCommentDAO.deleteComment(commentId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 리뷰의 댓글 목록 조회
     */
    public List<ReviewComment> getCommentsByReviewId(int reviewId) {
        try {
            return reviewCommentDAO.getCommentsByReviewId(reviewId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 사용자의 댓글 목록 조회
     */
    public List<ReviewComment> getCommentsByUserId(int userId, int limit, int offset) {
        try {
            return reviewCommentDAO.getCommentsByUserId(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 댓글 상세 조회
     */
    public ReviewComment getCommentById(int commentId) {
        try {
            return reviewCommentDAO.getCommentById(commentId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 댓글 좋아요
     */
    public boolean likeComment(int commentId, int userId) {
        try {
            int result = reviewCommentDAO.likeComment(commentId, userId);
            
            if (result > 0) {
                // 댓글의 좋아요 수 업데이트
                updateCommentLikeCount(commentId);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 댓글 좋아요 취소
     */
    public boolean unlikeComment(int commentId, int userId) {
        try {
            int result = reviewCommentDAO.unlikeComment(commentId, userId);
            
            if (result > 0) {
                // 댓글의 좋아요 수 업데이트
                updateCommentLikeCount(commentId);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 댓글 좋아요 여부 확인
     */
    public boolean isCommentLiked(int commentId, int userId) {
        try {
            return reviewCommentDAO.isCommentLiked(commentId, userId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 댓글 수 조회
     */
    public int getCommentCount(int reviewId) {
        try {
            return reviewCommentDAO.getCommentCount(reviewId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 댓글의 좋아요 수 업데이트
     */
    private void updateCommentLikeCount(int commentId) {
        try {
            // TODO: 실제 좋아요 수를 계산하여 업데이트
            // 현재는 간단히 구현
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
