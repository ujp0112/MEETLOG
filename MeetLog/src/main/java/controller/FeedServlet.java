package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.FeedItem;
import model.Activity;
import service.FeedService;
import service.FollowService;
import service.UserService;
import java.util.ArrayList;
import java.util.Date;
import java.time.ZoneId;

// web.xml에 이미 매핑되어 있으므로 @WebServlet 어노테이션 제거
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
                // 메인 피드 페이지 (자신의 활동 + 팔로우한 사용자들의 활동)
                List<Map<String, Object>> feedData = feedService.getMainFeedWithDetails(user.getId(), 20, 0);
                System.out.println("DEBUG 피드: 사용자 " + user.getId() + "의 메인 피드 아이템 수: " + feedData.size());

                // Map 데이터를 Activity로 변환
                List<Activity> activities = convertMapDataToActivities(feedData);
                System.out.println("DEBUG 피드: 변환된 Activity 수: " + activities.size());

                // 팔로잉/팔로워 인원 조회
                List<User> followingUsers = followService.getFollowingUsers(user.getId());
                List<User> followers = followService.getFollowers(user.getId());
                System.out.println("DEBUG 피드: 팔로잉 " + followingUsers.size() + "명, 팔로워 " + followers.size() + "명");

                // JSP에서 사용할 속성 설정
                request.setAttribute("activities", activities);
                request.setAttribute("hasActivities", !activities.isEmpty());
                request.setAttribute("followingCount", followingUsers.size());
                request.setAttribute("followerCount", followers.size());
                request.getRequestDispatcher("/WEB-INF/views/feed.jsp").forward(request, response);

            } else if (pathInfo.equals("/follow-list")) {
                // 팔로우 리스트 페이지
                List<User> followingUsers = followService.getFollowingUsers(user.getId());
                List<User> followers = followService.getFollowers(user.getId());
                
                // 각 팔로워에 대해 내가 팔로우하고 있는지 확인
                for (User follower : followers) {
                    boolean isFollowingBack = followService.isFollowing(user.getId(), follower.getId());
                    follower.setIsFollowing(isFollowingBack);
                }

                // 페이지 타입 결정 (기본값은 팔로잉)
                String pageType = request.getParameter("type");
                boolean isFollowingPage = !"followers".equals(pageType);
                
                request.setAttribute("followingUsers", followingUsers);
                request.setAttribute("followers", followers);
                request.setAttribute("isFollowingPage", isFollowingPage);
                request.getRequestDispatcher("/WEB-INF/views/follow-list.jsp").forward(request, response);

            } else if (pathInfo.startsWith("/user/")) {
                // 특정 사용자의 개별 피드 페이지
                String userIdStr = pathInfo.substring(6); // "/user/" 제거
                try {
                    int targetUserId = Integer.parseInt(userIdStr);

                    // 대상 사용자 정보 조회
                    UserService userService = new UserService();
                    User targetUser = userService.getUserById(targetUserId);

                    if (targetUser == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자를 찾을 수 없습니다.");
                        return;
                    }

                    // 대상 사용자의 활동 피드 조회
                    List<Map<String, Object>> userFeedData = feedService.getUserActivityFeedWithDetails(targetUserId, 20, 0);
                    List<Activity> userActivities = convertMapDataToActivities(userFeedData);

                    // 팔로우 관계 확인
                    boolean isFollowing = followService.isFollowing(user.getId(), targetUserId);
                    boolean isOwnProfile = (user.getId() == targetUserId);

                    // 대상 사용자의 팔로잉/팔로워 수 조회
                    List<User> targetFollowingUsers = followService.getFollowingUsers(targetUserId);
                    List<User> targetFollowers = followService.getFollowers(targetUserId);

                    // JSP에서 사용할 속성 설정
                    request.setAttribute("targetUser", targetUser);
                    request.setAttribute("activities", userActivities);
                    request.setAttribute("hasActivities", !userActivities.isEmpty());
                    request.setAttribute("followingCount", targetFollowingUsers.size());
                    request.setAttribute("followerCount", targetFollowers.size());
                    request.setAttribute("isFollowing", isFollowing);
                    request.setAttribute("isOwnProfile", isOwnProfile);

                    request.getRequestDispatcher("/WEB-INF/views/user-feed.jsp").forward(request, response);

                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 사용자 ID입니다.");
                }

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
        String pathInfo = request.getPathInfo();

        if ("/toggle-follow".equals(pathInfo)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
                return;
            }

            try {
                User user = (User) session.getAttribute("user");
                String action = request.getParameter("action");
                int targetUserId = Integer.parseInt(request.getParameter("targetUserId"));

                boolean success = false;
                if ("follow".equals(action)) {
                    success = followService.followUser(user.getId(), targetUserId);
                } else if ("unfollow".equals(action)) {
                    success = followService.unfollowUser(user.getId(), targetUserId);
                }

                if (success) {
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"작업을 완료할 수 없습니다.\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
            }
        } else {
            doGet(request, response);
        }
    }

    /**
     * FeedItem 목록을 Activity 목록으로 변환
     */
    private List<Activity> convertFeedItemsToActivities(List<FeedItem> feedItems) {
        List<Activity> activities = new ArrayList<>();
        String contextPath = getServletContext().getContextPath();

        for (FeedItem feedItem : feedItems) {
            Activity activity = new Activity(feedItem);

            // LocalDateTime을 Date로 변환
            if (feedItem.getCreatedAt() != null) {
                activity.setCreatedAt(Date.from(feedItem.getCreatedAt().atZone(ZoneId.systemDefault()).toInstant()));
            }

            // 활동 타입에 따라 targetUrl 설정
            String targetUrl = "";
            switch (activity.getActivityType()) {
                case "REVIEW":
                    // 리뷰는 음식점 상세 페이지의 리뷰 섹션으로 연결
                    // contentLocation에 음식점 ID를 저장해야 함 (현재는 FeedItem에서 제공되지 않으므로 추후 개선 필요)
                    break;
                case "COURSE":
                    targetUrl = contextPath + "/course/detail?id=" + activity.getContentId();
                    break;
                case "COLUMN":
                    targetUrl = contextPath + "/column/detail?id=" + activity.getContentId();
                    break;
            }
            activity.setTargetUrl(targetUrl);

            activities.add(activity);
        }

        return activities;
    }

    /**
     * Map 데이터를 Activity 목록으로 변환 (음식점 정보 포함)
     */
    private List<Activity> convertMapDataToActivities(List<Map<String, Object>> feedData) {
        List<Activity> activities = new ArrayList<>();
        String contextPath = getServletContext().getContextPath();

        for (Map<String, Object> data : feedData) {
            Activity activity = new Activity();
            
            // 기본 정보 설정
            activity.setUserId(((Number) data.get("userId")).intValue());
            activity.setUserNickname((String) data.get("userNickname"));
            activity.setUserProfileImage((String) data.get("userProfileImage"));
            activity.setActivityType((String) data.get("actionType"));
            activity.setContentId(((Number) data.get("targetId")).intValue());

            String rawTargetName = (String) data.get("targetName");
            if (rawTargetName != null && !rawTargetName.isBlank()) {
                activity.setContentTitle(rawTargetName);
            }

            String targetImage = (String) data.get("targetImage");
            if (targetImage != null && !targetImage.isBlank()) {
                activity.setContentImage(targetImage);
            }
            // 날짜 변환
            Object createdAtObj = data.get("createdAt");
            if (createdAtObj instanceof java.sql.Timestamp) {
                activity.setCreatedAt(new Date(((java.sql.Timestamp) createdAtObj).getTime()));
            }
            
            // 활동 타입에 따라 추가 정보 설정
            String activityType = activity.getActivityType();
            String targetUrl = "";
            
            switch (activityType) {
                case "REVIEW":
                    Object contentLocationObj = data.get("contentLocation");
                    if (contentLocationObj != null) {
                        String restaurantId = String.valueOf(((Number) contentLocationObj).intValue());
                        activity.setContentLocation(restaurantId);
                        targetUrl = contextPath + "/restaurant/detail/" + restaurantId + "#reviews";
                    }
                    activity.setRestaurantName((String) data.get("restaurantName"));
                    if (activity.getContentTitle() == null || activity.getContentTitle().isBlank()) {
                        activity.setContentTitle(activity.getRestaurantName());
                    }
                    break;
                case "COURSE":
                    targetUrl = contextPath + "/course/detail?id=" + activity.getContentId();
                    if (activity.getContentTitle() == null || activity.getContentTitle().isBlank()) {
                        activity.setContentTitle((String) data.get("targetName"));
                    }
                    break;
                case "COLUMN":
                    targetUrl = contextPath + "/column/detail?id=" + activity.getContentId();
                    if (activity.getContentTitle() == null || activity.getContentTitle().isBlank()) {
                        activity.setContentTitle((String) data.get("targetName"));
                    }
                    break;
                case "FOLLOW":
                    String followTarget = activity.getContentTitle();
                    if (followTarget == null || followTarget.isBlank()) {
                        followTarget = (String) data.get("targetName");
                    }
                    if (followTarget == null || followTarget.isBlank()) {
                        followTarget = "사용자";
                    }
                    activity.setContentTitle(followTarget);
                    activity.setContentDescription(followTarget + "님을 팔로우했습니다.");
                    targetUrl = contextPath + "/feed/user/" + activity.getContentId();
                    break;
            }

            activity.setTargetUrl(targetUrl);
            activities.add(activity);
        }

        return activities;
    }
}
