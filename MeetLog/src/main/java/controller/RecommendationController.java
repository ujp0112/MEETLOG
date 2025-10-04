package controller;

import adapter.KoBertAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import dao.RecommendationDAO;
import dao.RecommendationMetricDAO;
import model.RestaurantRecommendation;
import service.IntelligentRecommendationService;
import service.UserAnalyticsService;
import service.port.RecommendationPort;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/recommendations/*")
public class RecommendationController extends HttpServlet {

    // ✨ 서비스 객체를 멤버 변수로 가짐
    private IntelligentRecommendationService recommendationService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        // ✨ 서블릿이 처음 초기화될 때, 필요한 객체들을 생성하고 조립(Wiring)합니다.
        RecommendationDAO recommendationDAO = new RecommendationDAO();
        UserAnalyticsService userAnalyticsService = new UserAnalyticsService();
        RecommendationPort recommendationPort = new KoBertAdapter();
        RecommendationMetricDAO metricDAO = new RecommendationMetricDAO();

        // 서비스에 실제 구현체를 주입하여 생성
        this.recommendationService = new IntelligentRecommendationService(
            recommendationDAO,
            userAnalyticsService,
            recommendationPort,
            metricDAO
        );

        // Gson 초기화 (LocalDateTime 직렬화 처리)
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>)
                (src, type, ctx) -> new com.google.gson.JsonPrimitive(src.toString()))
            .create();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = normalizePath(req.getPathInfo());

        // 세션에서 userId 추출
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            respondError(resp, HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // 라우팅
        if ("/intelligent".equals(path)) {
            handleIntelligentRecommendations(req, resp, userId);
        } else {
            respondError(resp, HttpServletResponse.SC_NOT_FOUND, "요청한 경로를 찾을 수 없습니다.");
        }
    }

    /**
     * 지능형 추천 엔드포인트
     */
    private void handleIntelligentRecommendations(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws IOException {
        try {
            // 요청 파라미터에서 limit 추출 (기본값: 10)
            int limit = 10;
            String limitParam = req.getParameter("limit");
            if (limitParam != null) {
                try {
                    limit = Integer.parseInt(limitParam);
                    if (limit < 1 || limit > 100) limit = 10; // 범위 제한
                } catch (NumberFormatException e) {
                    limit = 10;
                }
            }

            // 추천 서비스 호출
            List<RestaurantRecommendation> recommendations =
                recommendationService.getIntelligentRecommendations(userId, limit);

            // JSON 응답
            respondJson(resp, recommendations);

        } catch (Exception e) {
            e.printStackTrace();
            respondError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "추천 생성 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    // ========== Helper Methods ==========

    /**
     * 경로 정규화 (세미콜론, 후행 슬래시 제거)
     */
    private String normalizePath(String path) {
        if (path == null) return null;
        // Matrix parameters 제거 (;jsessionid=...)
        int semicolon = path.indexOf(';');
        if (semicolon != -1) path = path.substring(0, semicolon);
        // 후행 슬래시 제거
        while (path.endsWith("/") && path.length() > 1) {
            path = path.substring(0, path.length() - 1);
        }
        return path;
    }

    /**
     * JSON 응답 전송
     */
    private void respondJson(HttpServletResponse resp, Object data) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");
        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().write(gson.toJson(data));
    }

    /**
     * 에러 응답 전송
     */
    private void respondError(HttpServletResponse resp, int statusCode, String message) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");
        resp.setStatus(statusCode);
        resp.getWriter().write(gson.toJson(new ErrorResponse(statusCode, message)));
    }

    /**
     * 에러 응답 DTO
     */
    private static class ErrorResponse {
        private final int status;
        private final String message;

        public ErrorResponse(int status, String message) {
            this.status = status;
            this.message = message;
        }

        public int getStatus() { return status; }
        public String getMessage() { return message; }
    }
}