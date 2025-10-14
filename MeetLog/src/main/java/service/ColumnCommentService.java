package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.ColumnComment;
import dao.ColumnCommentDAO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

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
     * 특정 사용자가 특정 댓글에 좋아요를 눌렀는지 확인
     * @param commentId 확인할 댓글 ID
     * @param userId 확인할 사용자 ID
     * @return 좋아요를 눌렀으면 true, 아니면 false
     */
    public boolean isCommentLiked(int commentId, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("commentId", commentId);
            params.put("userId", userId);
            Integer likeId = sqlSession.selectOne("dao.CommentLikeDAO.checkLike", params);
            return likeId != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 댓글 좋아요 토글 (추가/취소) 및 트랜잭션 관리
     * @param commentId 좋아요를 누른 댓글 ID
     * @param userId 좋아요를 누른 사용자 ID
     * @return isLiked (좋아요 상태), likeCount (최신 좋아요 수)
     */
    public Map<String, Object> toggleCommentLike(int commentId, int userId) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        Map<String, Object> result = new HashMap<>();
        boolean isLiked;

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("commentId", commentId);
            params.put("userId", userId);

            // 1. 사용자가 이미 좋아요를 눌렀는지 확인
            Integer likeId = sqlSession.selectOne("dao.CommentLikeDAO.checkLike", params);

            if (likeId == null) {
                // 2a. 좋아요 추가
                sqlSession.insert("dao.CommentLikeDAO.addLike", params);
                sqlSession.update("dao.ColumnCommentDAO.incrementLikes", commentId);
                isLiked = true;
            } else {
                // 2b. 좋아요 취소
                sqlSession.delete("dao.CommentLikeDAO.removeLike", params);
                sqlSession.update("dao.ColumnCommentDAO.decrementLikes", commentId);
                isLiked = false;
            }

            // 3. 최신 좋아요 수 조회
            int likeCount = sqlSession.selectOne("dao.ColumnCommentDAO.getLikeCount", commentId);

            sqlSession.commit(); // 모든 작업이 성공하면 커밋

            result.put("isLiked", isLiked);
            result.put("likeCount", likeCount);

        } catch (Exception e) {
            sqlSession.rollback(); // 오류 발생 시 롤백
            e.printStackTrace();
            throw new RuntimeException("댓글 좋아요 처리 중 오류가 발생했습니다.", e);
        } finally {
            sqlSession.close();
        }
        return result;
    }
}