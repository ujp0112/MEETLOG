package dao;

import model.ReviewComment;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class ReviewCommentDAO {
    private static final String NAMESPACE = "dao.ReviewCommentDAO";
    
    /**
     * 리뷰별 답글 목록 조회
     */
    public List<ReviewComment> findByReviewId(int reviewId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByReviewId", reviewId);
        }
    }
    
    /**
     * 리뷰 답글 상세 조회
     */
    public ReviewComment findById(int commentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", commentId);
        }
    }
    
    /**
     * 리뷰 답글 추가 (트랜잭션 포함)
     */
    public int insert(ReviewComment comment, SqlSession sqlSession) {
        return sqlSession.insert(NAMESPACE + ".insert", comment);
    }
    
    /**
     * 리뷰 답글 수정 (트랜잭션 포함)
     */
    public int update(ReviewComment comment, SqlSession sqlSession) {
        return sqlSession.update(NAMESPACE + ".update", comment);
    }
    
    /**
     * 리뷰 답글 삭제 (트랜잭션 포함)
     */
    public int delete(int commentId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".delete", commentId);
    }
}