package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import model.User;
import service.ColumnCommentService;

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

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        try {
            // JSON 본문에서 commentId 읽기
            @SuppressWarnings("unchecked")
            Map<String, Object> requestBody = gson.fromJson(request.getReader(), Map.class);
            Object commentIdObj = requestBody.get("commentId");

            if (commentIdObj == null) {
                result.put("success", false);
                result.put("message", "댓글 ID가 필요합니다.");
                out.print(gson.toJson(result));
                return;
            }

            // commentId를 int로 변환
            int commentId = ((Number) commentIdObj).intValue();

            // 서비스 레이어를 통해 좋아요 토글 로직 처리
            boolean isLiked = columnCommentService.toggleCommentLike(commentId, userId);
            int likeCount = columnCommentService.getCommentLikeCount(commentId);

            result.put("success", true);
            result.put("isLiked", isLiked);
            result.put("likeCount", likeCount);
            result.put("message", isLiked ? "좋아요가 반영되었습니다." : "좋아요가 취소되었습니다.");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("success", false);
            result.put("message", "잘못된 댓글 ID입니다.");
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("success", false);
            result.put("message", "요청을 처리할 수 없습니다.");
        } catch (Exception e) { // 서비스 레이어에서 발생할 수 있는 모든 예외 처리
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }

        out.print(gson.toJson(result));
        out.flush();
    }
}