package service;

import java.util.List;
import model.ColumnComment;
import dao.ColumnCommentDAO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

public class ColumnCommentService {
    private ColumnCommentDAO columnCommentDAO = new ColumnCommentDAO();

    /**
     * 칼럼 댓글 추가 (트랜잭션 포함)
     */
    public boolean addColumnComment(ColumnComment comment, SqlSession sqlSession) {
        try {
            return columnCommentDAO.insert(comment, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 칼럼 댓글 추가 (자동 트랜잭션)
     */
    public boolean addColumnComment(ColumnComment comment) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = columnCommentDAO.insert(comment, sqlSession) > 0;
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
     * 칼럼 댓글 수정 (트랜잭션 포함)
     */
    public boolean updateColumnComment(ColumnComment comment, SqlSession sqlSession) {
        try {
            return columnCommentDAO.update(comment, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 칼럼 댓글 수정 (자동 트랜잭션)
     */
    public boolean updateColumnComment(ColumnComment comment) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = columnCommentDAO.update(comment, sqlSession) > 0;
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
     * 칼럼 댓글 삭제 (트랜잭션 포함)
     */
    public boolean deleteColumnComment(int commentId, SqlSession sqlSession) {
        try {
            return columnCommentDAO.delete(commentId, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 칼럼 댓글 삭제 (자동 트랜잭션)
     */
    public boolean deleteColumnComment(int commentId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = columnCommentDAO.delete(commentId, sqlSession) > 0;
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
     * 칼럼별 댓글 목록 조회
     */
    public List<ColumnComment> getCommentsByColumnId(int columnId) {
        return columnCommentDAO.findByColumnId(columnId);
    }

    /**
     * 칼럼 댓글 상세 조회
     */
    public ColumnComment getCommentById(int commentId) {
        return columnCommentDAO.findById(commentId);
    }

    /**
     * 칼럼 댓글 수 조회
     */
    public int getCommentCount(int columnId) {
        return columnCommentDAO.getCommentCount(columnId);
    }

    /**
     * 댓글 좋아요 토글 (이미 좋아요면 취소, 아니면 추가)
     * @return 좋아요 상태 (true: 좋아요됨, false: 좋아요 취소됨)
     */
    public boolean toggleCommentLike(int commentId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            // 기존 좋아요 확인
            boolean isLiked = columnCommentDAO.isCommentLikedByUser(commentId, userId, sqlSession);

            if (isLiked) {
                // 좋아요 취소
                columnCommentDAO.removeCommentLike(commentId, userId, sqlSession);
                sqlSession.commit();
                return false;
            } else {
                // 좋아요 추가
                columnCommentDAO.addCommentLike(commentId, userId, sqlSession);
                sqlSession.commit();
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 댓글 좋아요 수 조회
     */
    public int getCommentLikeCount(int commentId) {
        return columnCommentDAO.getCommentLikeCount(commentId);
    }
}