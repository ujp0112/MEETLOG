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
            // [수정] JSON에서 reviewId를 String으로 받고, Integer로 파싱합니다.
            // 이렇게 하면 클라이언트에서 숫자로 보내든, 문자열로 보내든 모두 처리 가능합니다.
            String reviewIdStr = String.valueOf(payload.get("reviewId"));
            int reviewId = Integer.parseInt(reviewIdStr);

            // 좋아요 토글 로직을 호출하고 결과(Map)를 받음
            Map<String, Object> result = reviewLikeService.toggleLike(user.getId(), reviewId);
            
            // 성공 상태를 추가하여 최종 응답 생성
            result.put("status", "success"); 
            
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of("status", "error", "message", e.getMessage())));
        }
    }
}