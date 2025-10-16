package dao;

import model.ColumnComment;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class ColumnCommentDAO {
    private static final String NAMESPACE = "dao.ColumnCommentDAO";

    /**
     * 칼럼별 댓글 목록 조회
     */
    public List<ColumnComment> findByColumnId(int columnId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByColumnId", columnId);
        }
    }

    /**
     * 칼럼 댓글 상세 조회
     */
    public ColumnComment findById(int commentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", commentId);
        }
    }

    /**
     * 칼럼 댓글 추가 (트랜잭션 포함)
     */
    public int insert(ColumnComment comment, SqlSession sqlSession) {
        return sqlSession.insert(NAMESPACE + ".insert", comment);
    }

    /**
     * 칼럼 댓글 수정 (트랜잭션 포함)
     */
    public int update(ColumnComment comment, SqlSession sqlSession) {
        return sqlSession.update(NAMESPACE + ".update", comment);
    }

    /**
     * 칼럼 댓글 삭제 (트랜잭션 포함)
     */
    public int delete(int commentId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".delete", commentId);
    }

    /**
     * 칼럼 댓글 수 조회
     */
    public int getCommentCount(int columnId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".getCommentCount", columnId);
            return count != null ? count : 0;
        }
    }

    /**
     * 댓글 좋아요 여부 확인
     */
    public boolean isCommentLikedByUser(int commentId, int userId, SqlSession sqlSession) {
        java.util.Map<String, Integer> params = new java.util.HashMap<>();
        params.put("commentId", commentId);
        params.put("userId", userId);
        Integer count = sqlSession.selectOne(NAMESPACE + ".isCommentLikedByUser", params);
        return count != null && count > 0;
    }

    /**
     * 댓글 좋아요 추가
     */
    public int addCommentLike(int commentId, int userId, SqlSession sqlSession) {
        java.util.Map<String, Integer> params = new java.util.HashMap<>();
        params.put("commentId", commentId);
        params.put("userId", userId);
        return sqlSession.insert(NAMESPACE + ".addCommentLike", params);
    }

    /**
     * 댓글 좋아요 취소
     */
    public int removeCommentLike(int commentId, int userId, SqlSession sqlSession) {
        java.util.Map<String, Integer> params = new java.util.HashMap<>();
        params.put("commentId", commentId);
        params.put("userId", userId);
        return sqlSession.delete(NAMESPACE + ".removeCommentLike", params);
    }

    /**
     * 댓글 좋아요 수 조회
     */
    public int getCommentLikeCount(int commentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".getCommentLikeCount", commentId);
            return count != null ? count : 0;
        }
    }
}