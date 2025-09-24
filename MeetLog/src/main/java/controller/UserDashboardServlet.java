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

import com.fasterxml.jackson.databind.ObjectMapper;

import model.User;
import service.UserAnalyticsService;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserAnalyticsService analyticsService = new UserAnalyticsService();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 사용자 분석 데이터 조회
            Map<String, Object> analyticsData = getUserAnalytics(user.getId());

            // JSP에 데이터 전달
            request.setAttribute("visitedCount", analyticsData.get("visitedCount"));
            request.setAttribute("reviewCount", analyticsData.get("reviewCount"));
            request.setAttribute("avgRating", analyticsData.get("avgRating"));
            request.setAttribute("followerCount", analyticsData.get("followerCount"));

            request.getRequestDispatcher("/WEB-INF/views/user-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "대시보드 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Map<String, Object> result = new HashMap<>();

            switch (action) {
                case "getRealtimeStats":
                    result = getRealtimeUserStats(user.getId());
                    break;
                case "getRecommendations":
                    result = getPersonalizedRecommendations(user.getId());
                    break;
                case "getRecentActivities":
                    result = getRecentUserActivities(user.getId());
                    break;
                default:
                    result.put("error", "Unknown action");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }

            response.getWriter().write(objectMapper.writeValueAsString(result));

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> error = new HashMap<>();
            error.put("error", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(objectMapper.writeValueAsString(error));
        }
    }

    /**
     * 사용자 분석 데이터 조회
     */
    private Map<String, Object> getUserAnalytics(int userId) {
        Map<String, Object> data = new HashMap<>();

        try {
            // 실제로는 데이터베이스에서 조회하지만, 현재는 샘플 데이터로 시연
            data.put("visitedCount", 12);
            data.put("reviewCount", 28);
            data.put("avgRating", 4.2);
            data.put("followerCount", 15);

            // TODO: 실제 데이터베이스 쿼리로 교체
            /*
            data.put("visitedCount", analyticsService.getVisitedRestaurantCount(userId));
            data.put("reviewCount", analyticsService.getUserReviewCount(userId));
            data.put("avgRating", analyticsService.getUserAverageRating(userId));
            data.put("followerCount", analyticsService.getFollowerCount(userId));
            */

        } catch (Exception e) {
            e.printStackTrace();
            // 에러 시 기본값
            data.put("visitedCount", 0);
            data.put("reviewCount", 0);
            data.put("avgRating", 0.0);
            data.put("followerCount", 0);
        }

        return data;
    }

    /**
     * 실시간 사용자 통계 조회
     */
    private Map<String, Object> getRealtimeUserStats(int userId) {
        Map<String, Object> stats = new HashMap<>();

        try {
            // 시뮬레이션 데이터 (실제로는 DB에서 최신 데이터 조회)
            stats.put("newReviewCount", (int)(Math.random() * 5));
            stats.put("newFollowers", (int)(Math.random() * 3));
            stats.put("todayVisits", (int)(Math.random() * 2));

            // TODO: 실제 쿼리로 교체
            /*
            stats.put("newReviewCount", analyticsService.getTodayReviewCount(userId));
            stats.put("newFollowers", analyticsService.getTodayNewFollowers(userId));
            stats.put("todayVisits", analyticsService.getTodayVisitCount(userId));
            */

        } catch (Exception e) {
            e.printStackTrace();
            stats.put("error", "통계 조회 실패");
        }

        return stats;
    }

    /**
     * 개인화 추천 조회
     */
    private Map<String, Object> getPersonalizedRecommendations(int userId) {
        Map<String, Object> recommendations = new HashMap<>();

        try {
            // 시뮬레이션 추천 데이터
            recommendations.put("restaurants", java.util.Arrays.asList(
                createRecommendation("신사동 가라오케", "한식", "최근 한식 선호 패턴", 92),
                createRecommendation("이태원 피자집", "양식", "친구들과 함께하는 장소 선호", 88),
                createRecommendation("홍대 카페", "카페", "오후 시간대 방문 빈도 높음", 85)
            ));

            // TODO: 실제 추천 시스템 연동
            /*
            List<RestaurantRecommendation> recs = recommendationService.getHybridRecommendations(userId, 5);
            recommendations.put("restaurants", recs);
            */

        } catch (Exception e) {
            e.printStackTrace();
            recommendations.put("error", "추천 생성 실패");
        }

        return recommendations;
    }

    /**
     * 최근 사용자 활동 조회
     */
    private Map<String, Object> getRecentUserActivities(int userId) {
        Map<String, Object> activities = new HashMap<>();

        try {
            // 시뮬레이션 활동 데이터
            activities.put("activities", java.util.Arrays.asList(
                createActivity("review", "새로운 리뷰를 작성했습니다", "1시간 전", "⭐"),
                createActivity("visit", "맛집을 방문했습니다", "3시간 전", "📍"),
                createActivity("follow", "새로운 팔로워가 생겼습니다", "1일 전", "👥")
            ));

            // TODO: 실제 활동 로그 시스템 연동
            /*
            List<UserActivity> userActivities = analyticsService.getRecentActivities(userId, 10);
            activities.put("activities", userActivities);
            */

        } catch (Exception e) {
            e.printStackTrace();
            activities.put("error", "활동 조회 실패");
        }

        return activities;
    }

    /**
     * 추천 객체 생성 헬퍼
     */
    private Map<String, Object> createRecommendation(String name, String category, String reason, int score) {
        Map<String, Object> rec = new HashMap<>();
        rec.put("name", name);
        rec.put("category", category);
        rec.put("reason", reason);
        rec.put("score", score);
        return rec;
    }

    /**
     * 활동 객체 생성 헬퍼
     */
    private Map<String, Object> createActivity(String type, String content, String time, String icon) {
        Map<String, Object> activity = new HashMap<>();
        activity.put("type", type);
        activity.put("content", content);
        activity.put("time", time);
        activity.put("icon", icon);
        return activity;
    }
}