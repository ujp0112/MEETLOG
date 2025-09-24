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

import model.BusinessQnA;
import model.User;
import service.BusinessQnAService;

@WebServlet("/business/qna/notifications")
public class BusinessQnANotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ObjectMapper objectMapper = new ObjectMapper();

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
            result.put("message", "로그인이 필요합니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }

        try {
            BusinessQnAService qnaService = new BusinessQnAService();

            // 최근 5분 이내의 새로운 Q&A 조회 (실제로는 DB 쿼리로 구현)
            List<BusinessQnA> newQnAs = qnaService.getRecentUnansweredQnAs(user.getId(), 5);

            // 답변 대기 중인 총 Q&A 수
            int totalPendingCount = qnaService.getUnansweredQnACount(user.getId());

            result.put("success", true);
            result.put("newQnAs", newQnAs);
            result.put("newCount", newQnAs.size());
            result.put("totalPending", totalPendingCount);
            result.put("timestamp", System.currentTimeMillis());

            if (newQnAs.size() > 0) {
                result.put("hasNewAlerts", true);
                result.put("alertMessage", newQnAs.size() + "개의 새로운 문의가 있습니다.");
            } else {
                result.put("hasNewAlerts", false);
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