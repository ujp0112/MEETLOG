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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Map<String, Object> jsonResponse = new HashMap<>();

        // 1. 로그인 여부 확인
        if (session == null || session.getAttribute("user") == null) { 
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "로그인이 필요합니다.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            User currentUser = (User) session.getAttribute("user");
            int followerId = currentUser.getId(); // 팔로우를 하는 사람 (나)
            int followingId = Integer.parseInt(request.getParameter("userId")); // 팔로우 대상

            // 2. 자기 자신을 팔로우하는 경우 방지
            if (followerId == followingId) {
                throw new IllegalArgumentException("자기 자신을 팔로우할 수 없습니다.");
            }
            
            // 3. 현재 팔로우 상태 확인
            boolean isCurrentlyFollowing = followService.isFollowing(followerId, followingId);

            // 4. 서비스 호출하여 팔로우 또는 언팔로우 처리
            boolean success;
            if (isCurrentlyFollowing) {
                success = followService.unfollowUser(followerId, followingId); // 언팔로우
            } else {
                success = followService.followUser(followerId, followingId); // 팔로우
            }

            if (success) {
                jsonResponse.put("status", "success");
                jsonResponse.put("isFollowing", !isCurrentlyFollowing); // 작업 후의 변경된 상태
            } else {
                throw new Exception("팔로우/언팔로우 작업에 실패했습니다.");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("status", "error");
            jsonResponse.put("message", e.getMessage());
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(jsonResponse));
    }
}