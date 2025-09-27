package service;

import java.time.format.DateTimeFormatter;
import java.util.List;

import dao.CourseCommentDAO;
import model.CourseComment;

public class CourseCommentService {

    private final CourseCommentDAO courseCommentDAO = new CourseCommentDAO();
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

    private void applyDisplayFormatting(CourseComment comment) {
        if (comment == null) {
            return;
        }
        if (comment.getCreatedAt() != null) {
            comment.setCreatedAtFormatted(comment.getCreatedAt().format(DISPLAY_FORMAT));
        }
    }
}
