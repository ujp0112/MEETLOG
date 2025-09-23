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
import model.FeedActivity;
import service.FeedService;
import service.FollowService;

@WebServlet("/feed")
public class FeedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedService feedService = new FeedService();
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
        
        try {
            // 페이징 파라미터
            String pageStr = request.getParameter("page");
            int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
            int pageSize = 10; // 한 페이지에 보여줄 활동 수
            int offset = (page - 1) * pageSize;
            
            // 팔로우 피드 조회
            List<FeedActivity> activities = feedService.getFollowFeed(user.getId(), pageSize, offset);
            
            // 팔로우 통계
            int followingCount = followService.getFollowingCount(user.getId());
            int followerCount = followService.getFollowerCount(user.getId());
            
            // 총 활동 수 (페이징용)
            int totalActivities = feedService.getFeedCount(user.getId());
            int totalPages = (int) Math.ceil((double) totalActivities / pageSize);
            
            // 데이터 설정
            request.setAttribute("activities", activities);
            request.setAttribute("followingCount", followingCount);
            request.setAttribute("followerCount", followerCount);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("hasActivities", !activities.isEmpty());
            
            request.getRequestDispatcher("/WEB-INF/views/feed.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "피드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
