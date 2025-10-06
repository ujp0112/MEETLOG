package controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.BusinessQnA;
import model.User;
import service.BusinessQnAService;

public class BusinessInquiriesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BusinessQnAService businessQnAService = new BusinessQnAService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            List<BusinessQnA> qnaList = businessQnAService.getQnAByOwnerId(user.getId());

            int totalInquiries = qnaList.size();
            int pendingInquiries = (int) qnaList.stream()
                    .filter(qna -> "PENDING".equalsIgnoreCase(qna.getStatus()))
                    .count();
            int answeredInquiries = (int) qnaList.stream()
                    .filter(qna -> {
                        String status = qna.getStatus();
                        return "ANSWERED".equalsIgnoreCase(status) || "RESOLVED".equalsIgnoreCase(status)
                                || "CLOSED".equalsIgnoreCase(status);
                    })
                    .count();

            List<Map<String, Object>> inquiryViews = qnaList.stream().map(qna -> {
                Map<String, Object> view = new HashMap<>();
                view.put("id", qna.getId());
                String title = qna.getRestaurantName() != null && !qna.getRestaurantName().isBlank()
                        ? qna.getRestaurantName() + " 문의"
                        : qna.getQuestion();
                view.put("title", title);
                view.put("content", qna.getQuestion());
                view.put("userName", qna.getUserName());
                view.put("userEmail", qna.getUserEmail());
                view.put("status", qna.getStatus());
                view.put("answer", qna.getAnswer());
                view.put("createdAt", qna.getCreatedAt() != null ? Timestamp.valueOf(qna.getCreatedAt()) : null);
                view.put("answeredAt", qna.getAnsweredAt() != null ? Timestamp.valueOf(qna.getAnsweredAt()) : null);
                return view;
            }).collect(Collectors.toList());

            request.setAttribute("inquiries", inquiryViews);
            request.setAttribute("totalInquiries", totalInquiries);
            request.setAttribute("pendingInquiries", pendingInquiries);
            request.setAttribute("answeredInquiries", answeredInquiries);

            request.getRequestDispatcher("/WEB-INF/views/business-inquiries.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "문의 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
