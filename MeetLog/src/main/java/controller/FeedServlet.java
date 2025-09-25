package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.FeedItem;
import service.FeedService;
import service.FollowService;

public class FeedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FeedService feedService = new FeedService();
    private final FollowService followService = new FollowService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirectUrl=" + request.getRequestURI());
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // 메인 피드 페이지
                List<FeedItem> feedItems = feedService.getFeedItems(user.getId());
                request.setAttribute("feedItems", feedItems);
                request.getRequestDispatcher("/WEB-INF/views/feed.jsp").forward(request, response);

            } else if (pathInfo.equals("/follow-list")) {
                // 팔로우 리스트 페이지
                List<User> followingUsers = followService.getFollowingUsers(user.getId());
                List<User> followers = followService.getFollowers(user.getId());

                request.setAttribute("followingUsers", followingUsers);
                request.setAttribute("followers", followers);
                request.getRequestDispatcher("/WEB-INF/views/follow-list.jsp").forward(request, response);

            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "피드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}