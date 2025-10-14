package service;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.CourseCommentDAO;
import dao.CourseCommentLikeDAO;
import model.CourseComment;
import util.MyBatisSqlSessionFactory;

public class CourseCommentService {

    private final CourseCommentDAO courseCommentDAO = new CourseCommentDAO();
    private final CourseCommentLikeDAO courseCommentLikeDAO = new CourseCommentLikeDAO();
    private static final DateTimeFormatter DISPLAY_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    public List<CourseComment> getCommentsByCourse(int courseId) {
        List<CourseComment> comments = courseCommentDAO.findByCourseId(courseId);
        comments.forEach(this::applyDisplayFormatting);
        return comments;
    }

    public CourseComment addComment(int courseId, int userId, String content) {
        CourseComment comment = new CourseComment();
        comment.setCourseId(courseId);
        comment.setUserId(userId);
        comment.setContent(content);

        int result = courseCommentDAO.insert(comment);
        if (result > 0) {
            CourseComment saved = courseCommentDAO.findById(comment.getId());
            applyDisplayFormatting(saved);
            return saved;
        }
        return null;
    }

    public boolean deleteComment(int commentId, int userId) {
        return courseCommentDAO.softDelete(commentId, userId) > 0;
    }

    public boolean updateComment(int commentId, int userId, String content) {
        return courseCommentDAO.update(commentId, userId, content) > 0;
    }

    private void applyDisplayFormatting(CourseComment comment) {
        if (comment == null) {
            return;
        }
        if (comment.getCreatedAt() != null) {
            comment.setCreatedAtFormatted(comment.getCreatedAt().format(DISPLAY_FORMAT));
        }
    }
    /**
     * 특정 사용자가 특정 댓글에 좋아요를 눌렀는지 확인
     * @param commentId 확인할 댓글 ID
     * @param userId 확인할 사용자 ID
     * @return 좋아요를 눌렀으면 true, 아니면 false
     */
	public boolean isCommentLiked(int commentId, int userId) {
		Map<String, Object> params = new HashMap<>();
		params.put("commentId", commentId);
		params.put("userId", userId);
		return courseCommentLikeDAO.checkLike(params) != null;
	}

    /**
     * [추가] 댓글 좋아요 토글 (추가/취소) 및 트랜잭션 관리
     * @param commentId 좋아요를 누른 댓글 ID
     * @param userId 좋아요를 누른 사용자 ID
     * @return isLiked (좋아요 상태), likeCount (최신 좋아요 수)
     */
    public Map<String, Object> toggleCommentLike(int commentId, int userId) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        try {
            Map<String, Object> result = new HashMap<>();
            Map<String, Object> params = new HashMap<>();
            params.put("commentId", commentId);
            params.put("userId", userId);

            // 1. 사용자가 이미 좋아요를 눌렀는지 확인
            Integer likeId = courseCommentLikeDAO.checkLike(sqlSession, params);
            boolean isLiked;

            if (likeId == null) {
                // 2a. 좋아요 추가
                courseCommentLikeDAO.addLike(sqlSession, params);
                sqlSession.update("dao.CourseCommentDAO.incrementLikes", commentId); // 파라미터는 commentId
                isLiked = true;
            } else {
                // 2b. 좋아요 취소
                courseCommentLikeDAO.removeLike(sqlSession, params);
                sqlSession.update("dao.CourseCommentDAO.decrementLikes", commentId); // 파라미터는 commentId
                isLiked = false;
            }

            // 3. 최신 좋아요 수 조회
            int likeCount = sqlSession.selectOne("dao.CourseCommentDAO.getLikeCount", commentId);

            sqlSession.commit();

            result.put("isLiked", isLiked);
            result.put("likeCount", likeCount);
            return result;
        } catch (Exception e) {
            sqlSession.rollback();
            e.printStackTrace();
            throw new RuntimeException("댓글 좋아요 처리 중 오류가 발생했습니다.", e);
        } finally {
            sqlSession.close();
        }
    }
}
