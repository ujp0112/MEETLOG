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
import model.ReviewReply;
import service.ReviewService;

@WebServlet("/business/review/reply")
public class BusinessReviewReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ObjectMapper objectMapper = new ObjectMapper();
    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            // JSON 요청 파싱
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuffer.append(line);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> requestData = objectMapper.readValue(jsonBuffer.toString(), Map.class);

            Object reviewIdObj = requestData.get("reviewId");
            String content = (String) requestData.get("content");

            if (reviewIdObj == null || content == null || content.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "필수 정보가 누락되었습니다.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(objectMapper.writeValueAsString(result));
                return;
            }

            int reviewId = Integer.parseInt(reviewIdObj.toString());

            // 리뷰 답글 생성
            ReviewReply reply = new ReviewReply();
            reply.setReviewId(reviewId);
            reply.setContent(content.trim());
            reply.setBusinessUserId(user.getId());
            reply.setCreatedAt(new java.util.Date());

            // 답글 저장
            boolean success = reviewService.addReviewReply(reply);

            if (success) {
                result.put("success", true);
                result.put("message", "답글이 성공적으로 등록되었습니다.");

                // 클라이언트에서 사용할 답글 정보
                Map<String, Object> replyData = new HashMap<>();
                replyData.put("id", reply.getId());
                replyData.put("content", reply.getContent());
                replyData.put("createdAt", "방금 전");
                replyData.put("businessUserName", user.getName());

                result.put("reply", replyData);
                result.put("timestamp", System.currentTimeMillis());
            } else {
                result.put("success", false);
                result.put("message", "답글 등록에 실패했습니다.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "리뷰 ID는 숫자여야 합니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}