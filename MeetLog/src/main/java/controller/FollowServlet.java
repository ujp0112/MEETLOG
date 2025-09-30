package controller;

import java.io.IOException;
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
import service.FollowService;

@WebServlet("/user/follow")
public class FollowServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FollowService followService = new FollowService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"로그인이 필요합니다.\"}");
            return;
        }

        try {
            User currentUser = (User) session.getAttribute("user");
            int followerId = currentUser.getId();
            int followingId = Integer.parseInt(request.getParameter("userId"));

            // 자기 자신을 팔로우하는 경우 방지
            if (followerId == followingId) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"자기 자신을 팔로우할 수 없습니다.\"}");
                return;
            }
            
            // 현재 팔로우 상태 확인
            boolean isCurrentlyFollowing = followService.isFollowing(followerId, followingId);

            // 팔로우/언팔로우 토글
            if (isCurrentlyFollowing) {
                followService.unfollowUser(followerId, followingId);
            } else {
                followService.followUser(followerId, followingId);
            }

            // 최종 결과를 Map에 담아 JSON으로 반환
            Map<String, Object> result = new HashMap<>();
            result.put("status", "success");
            result.put("isFollowing", !isCurrentlyFollowing); // 상태가 반전되었으므로 !isCurrentlyFollowing
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"처리 중 오류가 발생했습니다.\"}");
            e.printStackTrace();
        }
    }
}