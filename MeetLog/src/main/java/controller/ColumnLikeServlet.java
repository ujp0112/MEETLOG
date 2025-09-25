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
import service.ColumnService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/column/like")
public class ColumnLikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ColumnService columnService = new ColumnService();
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

        try {
            // JSON으로 받은 columnId 처리
            String contentType = request.getContentType();
            int columnId;

            if (contentType != null && contentType.contains("application/json")) {
                // JSON 데이터 파싱
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = request.getReader().readLine()) != null) {
                    sb.append(line);
                }
                Map<String, Object> jsonData = gson.fromJson(sb.toString(), Map.class);
                columnId = ((Double) jsonData.get("columnId")).intValue();
            } else {
                // form-data로 받은 경우
                columnId = Integer.parseInt(request.getParameter("columnId"));
            }

            User user = (User) session.getAttribute("user");
            int userId = user.getId();

            // 좋아요 상태 토글 처리
            SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            try {
                // 이미 좋아요 했는지 확인
                Map<String, Object> params = new HashMap<>();
                params.put("columnId", columnId);
                params.put("userId", userId);

                Integer existingLike = sqlSession.selectOne("dao.ColumnLikeDAO.checkLike", params);

                if (existingLike != null) {
                    // 좋아요 취소
                    sqlSession.delete("dao.ColumnLikeDAO.removeLike", params);
                    sqlSession.update("dao.ColumnDAO.decrementLikes", columnId);
                    sqlSession.commit();

                    model.Column column = columnService.getColumnById(columnId);
                    result.put("success", true);
                    result.put("message", "좋아요가 취소되었습니다.");
                    result.put("likes", column.getLikes());
                    result.put("isLiked", false);
                } else {
                    // 좋아요 추가
                    sqlSession.insert("dao.ColumnLikeDAO.addLike", params);
                    sqlSession.update("dao.ColumnDAO.incrementLikes", columnId);
                    sqlSession.commit();

                    model.Column column = columnService.getColumnById(columnId);
                    result.put("success", true);
                    result.put("message", "좋아요가 반영되었습니다.");
                    result.put("likes", column.getLikes());
                    result.put("isLiked", true);
                }
            } catch (Exception e) {
                sqlSession.rollback();
                throw e;
            } finally {
                sqlSession.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }

        out.print(gson.toJson(result));
        out.flush();
    }
}