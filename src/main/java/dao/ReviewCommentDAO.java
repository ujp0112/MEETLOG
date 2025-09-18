package dao;

import model.ReviewComment;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

/**
 * 리뷰 댓글 시스템을 위한 DAO 클래스
 */
public class ReviewCommentDAO {
    private static final String NAMESPACE = "dao.ReviewCommentDAO";

    /**
     * 댓글 생성
     */
    public int createComment(ReviewComment comment) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".createComment", comment);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 댓글 수정
     */
    public int updateComment(ReviewComment comment) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".updateComment", comment);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 댓글 삭제
     */
    public int deleteComment(int commentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".deleteComment", commentId);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 리뷰의 댓글 목록 조회 (계층 구조)
     */
    public List<ReviewComment> getCommentsByReviewId(int reviewId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getCommentsByReviewId", reviewId);
        }
    }

    /**
     * 사용자의 댓글 목록 조회
     */
    public List<ReviewComment> getCommentsByUserId(int userId, int limit, int offset) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit, "offset", offset);
            return sqlSession.selectList(NAMESPACE + ".getCommentsByUserId", params);
        }
    }

    /**
     * 댓글 상세 조회
     */
    public ReviewComment getCommentById(int commentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getCommentById", commentId);
        }
    }

    /**
     * 댓글 좋아요
     */
    public int likeComment(int commentId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("commentId", commentId, "userId", userId);
            int result = sqlSession.insert(NAMESPACE + ".likeComment", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 댓글 좋아요 취소
     */
    public int unlikeComment(int commentId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("commentId", commentId, "userId", userId);
            int result = sqlSession.delete(NAMESPACE + ".unlikeComment", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 댓글 좋아요 여부 확인
     */
    public boolean isCommentLiked(int commentId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("commentId", commentId, "userId", userId);
            Integer count = sqlSession.selectOne(NAMESPACE + ".isCommentLiked", params);
            return count != null && count > 0;
        }
    }

    /**
     * 댓글 수 조회
     */
    public int getCommentCount(int reviewId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getCommentCount", reviewId);
        }
    }
}
