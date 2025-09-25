package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.User;
import model.ColumnComment;
import service.ColumnCommentService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/column/comment/like")
public class ColumnCommentLikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ColumnCommentService columnCommentService = new ColumnCommentService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            out.print(gson.toJson(result));
            return;
        }

        String commentIdStr = request.getParameter("commentId");
        if (commentIdStr == null || commentIdStr.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "댓글 ID가 필요합니다.");
            out.print(gson.toJson(result));
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        SqlSession sqlSession = null;
        try {
            int commentId = Integer.parseInt(commentIdStr);
            sqlSession = MyBatisSqlSessionFactory.getSqlSession();

            // 이미 좋아요 했는지 확인
            Map<String, Object> params = new HashMap<>();
            params.put("commentId", commentId);
            params.put("userId", userId);

            Integer existingLike = sqlSession.selectOne("dao.CommentLikeDAO.checkLike", params);

            if (existingLike != null) {
                // 좋아요 취소
                sqlSession.delete("dao.CommentLikeDAO.removeLike", params);
                sqlSession.update("dao.ColumnCommentDAO.decrementLikes", commentId);
                sqlSession.commit();

                ColumnComment comment = columnCommentService.getCommentById(commentId);
                result.put("success", true);
                result.put("message", "좋아요가 취소되었습니다.");
                result.put("likeCount", comment != null ? comment.getLikeCount() : 0);
                result.put("isLiked", false);
            } else {
                // 좋아요 추가
                sqlSession.insert("dao.CommentLikeDAO.addLike", params);
                sqlSession.update("dao.ColumnCommentDAO.incrementLikes", commentId);
                sqlSession.commit();

                ColumnComment comment = columnCommentService.getCommentById(commentId);
                result.put("success", true);
                result.put("message", "좋아요가 반영되었습니다.");
                result.put("likeCount", comment != null ? comment.getLikeCount() : 1);
                result.put("isLiked", true);
            }

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "잘못된 댓글 ID입니다.");
        } catch (Exception e) {
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }

        out.print(gson.toJson(result));
        out.flush();
    }
}