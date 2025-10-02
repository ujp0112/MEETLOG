package controller;

import model.Feedback;
import service.FeedbackService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import util.AdminSessionUtils;

public class FeedbackManagementServlet extends HttpServlet {
    private final FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
            request.setAttribute("feedbacks", feedbacks);

            request.getRequestDispatcher("/WEB-INF/views/admin-feedback-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "피드백 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"관리자 권한이 필요합니다.\"}");
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Action이 필요합니다.\"}");
                return;
            }

            response.setContentType("application/json; charset=UTF-8");

            switch (action) {
                case "delete":
                    handleDeleteFeedback(request, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"지원하지 않는 액션입니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    private void handleDeleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = feedbackService.deleteFeedback(id);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"피드백이 삭제되었습니다.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"피드백 삭제에 실패했습니다.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"올바른 ID를 입력해주세요.\"}");
        }
    }
}