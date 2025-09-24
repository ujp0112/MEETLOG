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
import util.AsyncTaskProcessor;
import util.CacheManager;
import util.ConnectionPoolManager;
import util.QueryOptimizer;

/**
 * 시스템 성능 모니터링 API
 * 캐시, 연결 풀, 쿼리, 비동기 작업 성능 통계 제공
 */
@WebServlet("/admin/performance")
public class SystemPerformanceServlet extends HttpServlet {
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

        // 관리자 권한 확인 (실제 구현에서는 ADMIN 권한 체크)
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }

        try {
            Map<String, Object> performanceData = new HashMap<>();

            // 1. 캐시 통계
            CacheManager.CacheStats cacheStats = CacheManager.getInstance().getStats();
            Map<String, Object> cacheData = new HashMap<>();
            cacheData.put("totalEntries", cacheStats.getTotalEntries());
            cacheData.put("totalMemoryBytes", cacheStats.getTotalMemoryBytes());
            cacheData.put("memoryUsage", cacheStats.getMemoryUsage());
            performanceData.put("cache", cacheData);

            // 2. 연결 풀 통계
            ConnectionPoolManager.PoolStats poolStats = ConnectionPoolManager.getInstance().getStats();
            Map<String, Object> poolData = new HashMap<>();
            poolData.put("availableConnections", poolStats.getAvailableConnections());
            poolData.put("activeConnections", poolStats.getActiveConnections());
            poolData.put("maxConnections", poolStats.getMaxConnections());
            poolData.put("totalConnections", poolStats.getTotalConnections());
            poolData.put("usagePercentage", poolStats.getUsagePercentage());
            performanceData.put("connectionPool", poolData);

            // 3. 비동기 작업 통계
            AsyncTaskProcessor.TaskStats taskStats = AsyncTaskProcessor.getInstance().getStats();
            Map<String, Object> taskData = new HashMap<>();
            taskData.put("totalSubmitted", taskStats.getTotalSubmitted());
            taskData.put("totalCompleted", taskStats.getTotalCompleted());
            taskData.put("successfulTasks", taskStats.getSuccessfulTasks());
            taskData.put("failedTasks", taskStats.getFailedTasks());
            taskData.put("activeTasks", taskStats.getActiveTasks());
            taskData.put("queuedTasks", taskStats.getQueuedTasks());
            taskData.put("successRate", taskStats.getSuccessRate());
            performanceData.put("asyncTasks", taskData);

            // 4. 쿼리 통계 (상위 10개)
            Map<String, QueryOptimizer.QueryStats> allQueryStats = QueryOptimizer.getInstance().getAllQueryStats();
            Map<String, Object> queryData = new HashMap<>();

            allQueryStats.entrySet().stream()
                .sorted((e1, e2) -> Long.compare(e2.getValue().getExecutionCount(), e1.getValue().getExecutionCount()))
                .limit(10)
                .forEach(entry -> {
                    QueryOptimizer.QueryStats stats = entry.getValue();
                    Map<String, Object> statData = new HashMap<>();
                    statData.put("executionCount", stats.getExecutionCount());
                    statData.put("averageExecutionTime", stats.getAverageExecutionTime());
                    statData.put("maxExecutionTime", stats.getMaxExecutionTime());
                    statData.put("minExecutionTime", stats.getMinExecutionTime());
                    statData.put("totalExecutionTime", stats.getTotalExecutionTime());
                    queryData.put(entry.getKey(), statData);
                });
            performanceData.put("topQueries", queryData);

            // 5. JVM 메모리 정보
            Runtime runtime = Runtime.getRuntime();
            Map<String, Object> memoryData = new HashMap<>();
            memoryData.put("totalMemory", runtime.totalMemory());
            memoryData.put("freeMemory", runtime.freeMemory());
            memoryData.put("usedMemory", runtime.totalMemory() - runtime.freeMemory());
            memoryData.put("maxMemory", runtime.maxMemory());
            memoryData.put("availableProcessors", runtime.availableProcessors());
            performanceData.put("jvm", memoryData);

            // 6. 시스템 시간 정보
            performanceData.put("timestamp", System.currentTimeMillis());
            performanceData.put("uptime", System.currentTimeMillis()); // 실제로는 서버 시작 시간에서 계산

            result.put("success", true);
            result.put("data", performanceData);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "성능 데이터 조회 중 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        if (user == null) {
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
            String action = (String) requestData.get("action");

            if ("clearCache".equals(action)) {
                // 캐시 클리어
                CacheManager.getInstance().clear();
                result.put("success", true);
                result.put("message", "캐시가 성공적으로 클리어되었습니다.");

            } else if ("resetQueryStats".equals(action)) {
                // 쿼리 통계 리셋
                QueryOptimizer.getInstance().resetQueryStats();
                result.put("success", true);
                result.put("message", "쿼리 통계가 성공적으로 리셋되었습니다.");

            } else if ("forceGC".equals(action)) {
                // 가비지 컬렉션 실행
                long beforeGC = Runtime.getRuntime().freeMemory();
                System.gc();
                long afterGC = Runtime.getRuntime().freeMemory();

                result.put("success", true);
                result.put("message", "가비지 컬렉션이 실행되었습니다.");
                result.put("freedMemory", afterGC - beforeGC);

            } else if ("invalidateCache".equals(action)) {
                // 특정 패턴의 캐시 무효화
                String pattern = (String) requestData.get("pattern");
                if (pattern != null && !pattern.trim().isEmpty()) {
                    QueryOptimizer.getInstance().invalidateCache(pattern);
                    result.put("success", true);
                    result.put("message", "패턴 '" + pattern + "'의 캐시가 무효화되었습니다.");
                } else {
                    result.put("success", false);
                    result.put("message", "무효화할 캐시 패턴을 지정해주세요.");
                }

            } else {
                result.put("success", false);
                result.put("message", "지원하지 않는 액션입니다: " + action);
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "요청 처리 중 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}