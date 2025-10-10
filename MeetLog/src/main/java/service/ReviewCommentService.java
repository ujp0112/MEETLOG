package service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import dao.ReviewCommentDAO;
import model.ReviewComment;
import util.MyBatisSqlSessionFactory;

public class ReviewCommentService {
    private ReviewCommentDAO reviewCommentDAO = new ReviewCommentDAO();
    private static final Logger log = LoggerFactory.getLogger(ReviewCommentService.class);
    
    /**
     * 리뷰 답글 추가 (트랜잭션 포함)
     */
    public boolean addReviewComment(ReviewComment comment, SqlSession sqlSession) {
        try {
            return reviewCommentDAO.insert(comment, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 리뷰 답글 추가 (자동 트랜잭션)
     */
    public boolean addReviewComment(ReviewComment comment) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = reviewCommentDAO.insert(comment, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 리뷰 답글 수정 (트랜잭션 포함)
     */
    public boolean updateReviewComment(ReviewComment comment, SqlSession sqlSession) {
        try {
            return reviewCommentDAO.update(comment, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 리뷰 답글 수정 (자동 트랜잭션)
     */
    public boolean updateReviewComment(ReviewComment comment) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = reviewCommentDAO.update(comment, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 리뷰 답글 삭제 (트랜잭션 포함)
     */
    public boolean deleteReviewComment(int commentId, SqlSession sqlSession) {
        try {
            return reviewCommentDAO.delete(commentId, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 리뷰 답글 삭제 (자동 트랜잭션)
     */
    public boolean deleteReviewComment(int commentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = reviewCommentDAO.delete(commentId, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 리뷰별 답글 목록 조회
     */
    public List<ReviewComment> getCommentsByReviewId(int reviewId) {
        return reviewCommentDAO.findByReviewId(reviewId);
    }
    
    /**
     * 리뷰 답글 상세 조회
     */
    public ReviewComment getCommentById(int commentId) {
        return reviewCommentDAO.findById(commentId);
    }

    /**
     * 해결 완료 상태 업데이트 (자동 트랜잭션)
     */
    public boolean updateResolvedStatus(int commentId, boolean isResolved) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = reviewCommentDAO.updateResolvedStatus(commentId, isResolved, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
