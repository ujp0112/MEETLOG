package controller;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import model.User;
import service.ReviewLikeService;

@WebServlet("/review/like")
public class ReviewLikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReviewLikeService reviewLikeService = new ReviewLikeService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"로그인이 필요합니다.\"}");
            return;
        }

        try {
            User user = (User) session.getAttribute("user");
            Map<String, Object> payload = gson.fromJson(request.getReader(), Map.class);
            int reviewId = ((Double) payload.get("reviewId")).intValue();

            // [최종 수정] 새로 만든 단일 메서드를 호출하여 결과(Map)를 받음
            Map<String, Object> result = reviewLikeService.toggleLike(user.getId(), reviewId);
            
            // 결과에 "status":"success"를 추가하여 최종 응답 생성
            result.put("status", "success");
            
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // 클라이언트에게 에러 메시지를 전달
            String errorMessage = "{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}";
            response.getWriter().write(errorMessage);
        }
    }
}