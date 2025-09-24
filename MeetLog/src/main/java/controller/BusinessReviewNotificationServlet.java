package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.Review;
import model.User;
import service.ReviewService;

@WebServlet("/business/review/notifications")
public class BusinessReviewNotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ObjectMapper objectMapper = new ObjectMapper();
    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            result.put("success", false);
            result.put("message", "로그인이 필요하거나 권한이 없습니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }

        try {
            // 최근 5분 이내의 새로운 리뷰 조회
            List<Review> newReviews = reviewService.getRecentReviewsForBusiness(user.getId(), 5);

            // 답글이 필요한 총 리뷰 수
            int totalPendingReplies = reviewService.getPendingReplyCount(user.getId());

            result.put("success", true);
            result.put("newReviews", newReviews);
            result.put("newCount", newReviews.size());
            result.put("totalPending", totalPendingReplies);
            result.put("timestamp", System.currentTimeMillis());

            if (newReviews.size() > 0) {
                result.put("hasNewReviews", true);
                String message = newReviews.size() == 1 ?
                    "새로운 리뷰 1개가 등록되었습니다." :
                    String.format("새로운 리뷰 %d개가 등록되었습니다.", newReviews.size());
                result.put("message", message);
            } else {
                result.put("hasNewReviews", false);
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "알림 조회에 실패했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}