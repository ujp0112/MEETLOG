package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.User;
import model.BusinessQnA;
import service.BusinessQnAService;

@WebServlet("/business/qna/reply")
public class BusinessQnAReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if it's an AJAX request
        String contentType = request.getContentType();
        boolean isAjax = contentType != null && contentType.contains("application/json");

        if (isAjax) {
            handleAjaxRequest(request, response);
        } else {
            handleFormRequest(request, response);
        }
    }

    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response)
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
            // JSON 요청 파싱
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuffer.append(line);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> requestData = objectMapper.readValue(jsonBuffer.toString(), Map.class);

            Object qnaIdObj = requestData.get("qnaId");
            String answer = (String) requestData.get("answer");

            if (qnaIdObj == null || answer == null || answer.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "필수 정보가 누락되었습니다.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(objectMapper.writeValueAsString(result));
                return;
            }

            int qnaId = Integer.parseInt(qnaIdObj.toString());

            BusinessQnAService qnaService = new BusinessQnAService();

            // Q&A 답변 업데이트
            boolean success = qnaService.updateQnAAnswer(qnaId, answer.trim());

            if (success) {
                result.put("success", true);
                result.put("message", "답변이 등록되었습니다.");
                result.put("qnaId", qnaId);
                result.put("answer", answer.trim());
                result.put("status", "답변완료");
                result.put("timestamp", System.currentTimeMillis());
            } else {
                result.put("success", false);
                result.put("message", "답변 등록에 실패했습니다.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Q&A ID는 숫자여야 합니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }

    private void handleFormRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String qnaIdStr = request.getParameter("qnaId");
            String answer = request.getParameter("answer");

            if (qnaIdStr == null || answer == null || answer.trim().isEmpty()) {
                request.setAttribute("errorMessage", "필수 정보를 모두 입력해주세요.");
                request.getRequestDispatcher("/WEB-INF/views/business/qna-management.jsp").forward(request, response);
                return;
            }

            try {
                int qnaId = Integer.parseInt(qnaIdStr);

                BusinessQnAService qnaService = new BusinessQnAService();

                // Q&A 답변 업데이트
                boolean success = qnaService.updateQnAAnswer(qnaId, answer.trim());

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/business/qna-management?success=answer_added");
                } else {
                    request.setAttribute("errorMessage", "Q&A 답변 추가에 실패했습니다.");
                    request.getRequestDispatcher("/WEB-INF/views/business/qna-management.jsp").forward(request, response);
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Q&A ID는 숫자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/views/business/qna-management.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Q&A 답변 추가 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
