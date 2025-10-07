package controller;

import com.google.gson.Gson;
import model.User;
import service.ReportService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/review/report")
public class ReviewReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ReportService reportService = new ReportService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of(
                    "status", "error",
                    "message", "로그인이 필요합니다."
            )));
            return;
        }

        try {
            User user = (User) session.getAttribute("user");
            Map<String, Object> payload = gson.fromJson(request.getReader(), Map.class);

            if (payload == null || !payload.containsKey("reviewId")) {
                throw new IllegalArgumentException("리뷰 정보가 올바르지 않습니다.");
            }

            String reviewIdStr = String.valueOf(payload.get("reviewId"));
            int reviewId = Integer.parseInt(reviewIdStr);

            Object reasonObject = payload.get("reason");
            String reason = reasonObject != null ? reasonObject.toString().trim() : "";

            if (reason.isEmpty()) {
                throw new IllegalArgumentException("신고 사유를 입력해주세요.");
            }

            if (reason.length() > 500) {
                throw new IllegalArgumentException("신고 사유는 500자 이내로 작성해주세요.");
            }

            reportService.submitReviewReport(user.getId(), reviewId, reason);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(Map.of(
                    "status", "success",
                    "message", "신고가 접수되었습니다."
            )));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of(
                    "status", "error",
                    "message", "유효하지 않은 리뷰 정보입니다."
            )));
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of(
                    "status", "error",
                    "message", e.getMessage()
            )));
        } catch (IllegalStateException e) {
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            response.getWriter().write(gson.toJson(Map.of(
                    "status", "error",
                    "message", e.getMessage()
            )));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of(
                    "status", "error",
                    "message", "신고 처리 중 오류가 발생했습니다."
            )));
        }
    }
}

