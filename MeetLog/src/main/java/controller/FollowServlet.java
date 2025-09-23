package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import model.Follow;
import service.FollowService;

@WebServlet("/follow/*")
public class FollowServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FollowService followService = new FollowService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // 팔로우 관리 메인 페이지 (팔로잉/팔로워 목록)
                showFollowPage(request, response, user.getId());
            } else if (pathInfo.startsWith("/following/")) {
                // 팔로잉 목록
                String userIdStr = pathInfo.substring("/following/".length());
                int userId = Integer.parseInt(userIdStr);
                showFollowingList(request, response, user.getId(), userId);
            } else if (pathInfo.startsWith("/followers/")) {
                // 팔로워 목록
                String userIdStr = pathInfo.substring("/followers/".length());
                int userId = Integer.parseInt(userIdStr);
                showFollowersList(request, response, user.getId(), userId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "팔로우 정보를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("toggle".equals(action)) {
                toggleFollow(request, response, user.getId());
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }
    
    private void showFollowPage(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        int followingCount = followService.getFollowingCount(userId);
        int followerCount = followService.getFollowerCount(userId);
        
        request.setAttribute("followingCount", followingCount);
        request.setAttribute("followerCount", followerCount);
        request.getRequestDispatcher("/WEB-INF/views/follow.jsp").forward(request, response);
    }
    
    private void showFollowingList(HttpServletRequest request, HttpServletResponse response, int currentUserId, int targetUserId) 
            throws ServletException, IOException {
        List<Follow> followings = followService.getFollowings(targetUserId);
        
        // 각 사용자에 대해 현재 사용자의 팔로우 상태 확인
        for (Follow follow : followings) {
            boolean isFollowing = followService.isFollowing(currentUserId, follow.getFollowingId());
            follow.setFollowerId(isFollowing ? 1 : 0); // 임시로 팔로우 상태 저장
        }
        
        request.setAttribute("followings", followings);
        request.setAttribute("targetUserId", targetUserId);
        request.setAttribute("isFollowingPage", true);
        request.getRequestDispatcher("/WEB-INF/views/follow-list.jsp").forward(request, response);
    }
    
    private void showFollowersList(HttpServletRequest request, HttpServletResponse response, int currentUserId, int targetUserId) 
            throws ServletException, IOException {
        List<Follow> followers = followService.getFollowers(targetUserId);
        
        // 각 사용자에 대해 현재 사용자의 팔로우 상태 확인
        for (Follow follow : followers) {
            boolean isFollowing = followService.isFollowing(currentUserId, follow.getFollowerId());
            follow.setFollowingId(isFollowing ? 1 : 0); // 임시로 팔로우 상태 저장
        }
        
        request.setAttribute("followers", followers);
        request.setAttribute("targetUserId", targetUserId);
        request.setAttribute("isFollowingPage", false);
        request.getRequestDispatcher("/WEB-INF/views/follow-list.jsp").forward(request, response);
    }
    
    private void toggleFollow(HttpServletRequest request, HttpServletResponse response, int followerId) 
            throws IOException {
        String followingIdStr = request.getParameter("followingId");
        
        if (followingIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"대상 사용자 ID가 필요합니다.\"}");
            return;
        }
        
        int followingId = Integer.parseInt(followingIdStr);
        
        if (followerId == followingId) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"자기 자신을 팔로우할 수 없습니다.\"}");
            return;
        }
        
        boolean wasFollowing = followService.isFollowing(followerId, followingId);
        boolean success = followService.toggleFollow(followerId, followingId);
        
        if (success) {
            boolean isNowFollowing = !wasFollowing;
            int followerCount = followService.getFollowerCount(followingId);
            
            response.setContentType("application/json");
            response.getWriter().write(String.format(
                "{\"success\": true, \"isFollowing\": %b, \"followerCount\": %d}", 
                isNowFollowing, followerCount
            ));
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"팔로우 처리에 실패했습니다.\"}");
        }
    }
}
