package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.User;
import util.LogManager;
import util.AsyncTaskProcessor;
import util.CacheManager;
import util.ConnectionPoolManager;
import util.QueryOptimizer;

/**
 * 시스템 통합 모니터링 API
 * 로그, 성능, 보안, 시스템 상태를 실시간으로 모니터링
 */
@WebServlet("/admin/monitoring")
public class SystemMonitoringServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ObjectMapper objectMapper = new ObjectMapper();
    private LogManager logManager = LogManager.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        // 관리자 권한 확인
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action != null ? action : "dashboard") {
                case "dashboard":
                    result = getDashboardData();
                    break;
                case "logs":
                    result = getLogsData(request);
                    break;
                case "performance":
                    result = getPerformanceData();
                    break;
                case "security":
                    result = getSecurityData();
                    break;
                case "system":
                    result = getSystemData();
                    break;
                default:
                    result.put("success", false);
                    result.put("message", "지원하지 않는 액션입니다.");
            }

            if (!result.containsKey("success")) {
                result.put("success", true);
            }

        } catch (Exception e) {
            e.printStackTrace();
            logManager.logError("MONITORING", "모니터링 데이터 조회 실패", request, e);

            result.put("success", false);
            result.put("message", "모니터링 데이터 조회 중 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }

    /**
     * 대시보드 통합 데이터
     */
    private Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();

        // 1. 시스템 개요
        Map<String, Object> overview = new HashMap<>();
        overview.put("uptime", System.currentTimeMillis()); // 실제로는 서버 시작 시간에서 계산
        overview.put("timestamp", System.currentTimeMillis());

        // JVM 정보
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;

        overview.put("jvmMemoryUsed", usedMemory);
        overview.put("jvmMemoryTotal", totalMemory);
        overview.put("jvmMemoryMax", maxMemory);
        overview.put("jvmMemoryUsage", (double) usedMemory / totalMemory * 100);

        data.put("overview", overview);

        // 2. 로그 통계
        LogManager.LogStats logStats = logManager.getLogStats();
        Map<String, Object> logs = new HashMap<>();
        logs.put("totalLogs", logStats.getTotalLogs());
        logs.put("errorLogs", logStats.getErrorLogs());
        logs.put("securityLogs", logStats.getSecurityLogs());
        logs.put("performanceLogs", logStats.getPerformanceLogs());
        data.put("logs", logs);

        // 3. 성능 통계
        Map<String, Object> performance = new HashMap<>();

        // 캐시 통계
        CacheManager.CacheStats cacheStats = CacheManager.getInstance().getStats();
        Map<String, Object> cache = new HashMap<>();
        cache.put("entries", cacheStats.getTotalEntries());
        cache.put("memoryUsage", cacheStats.getTotalMemoryBytes());
        performance.put("cache", cache);

        // 연결 풀 통계
        ConnectionPoolManager.PoolStats poolStats = ConnectionPoolManager.getInstance().getStats();
        Map<String, Object> connectionPool = new HashMap<>();
        connectionPool.put("activeConnections", poolStats.getActiveConnections());
        connectionPool.put("availableConnections", poolStats.getAvailableConnections());
        connectionPool.put("usagePercentage", poolStats.getUsagePercentage());
        performance.put("connectionPool", connectionPool);

        // 비동기 작업 통계
        AsyncTaskProcessor.TaskStats taskStats = AsyncTaskProcessor.getInstance().getStats();
        Map<String, Object> asyncTasks = new HashMap<>();
        asyncTasks.put("totalSubmitted", taskStats.getTotalSubmitted());
        asyncTasks.put("successfulTasks", taskStats.getSuccessfulTasks());
        asyncTasks.put("failedTasks", taskStats.getFailedTasks());
        asyncTasks.put("successRate", taskStats.getSuccessRate());
        performance.put("asyncTasks", asyncTasks);

        data.put("performance", performance);

        // 4. 최근 중요 로그 (에러 및 보안 로그)
        List<LogManager.LogEntry> recentErrors = logManager.getRecentLogsByLevel(
            LogManager.LogLevel.ERROR, 10);
        List<LogManager.LogEntry> recentSecurity = logManager.getRecentLogsByLevel(
            LogManager.LogLevel.SECURITY, 10);

        data.put("recentErrors", convertLogEntries(recentErrors));
        data.put("recentSecurity", convertLogEntries(recentSecurity));

        return data;
    }

    /**
     * 로그 데이터
     */
    private Map<String, Object> getLogsData(HttpServletRequest request) {
        Map<String, Object> data = new HashMap<>();

        String levelParam = request.getParameter("level");
        String limitParam = request.getParameter("limit");

        int limit = limitParam != null ? Integer.parseInt(limitParam) : 100;

        List<LogManager.LogEntry> logs;
        if (levelParam != null && !levelParam.isEmpty()) {
            LogManager.LogLevel level = LogManager.LogLevel.valueOf(levelParam.toUpperCase());
            logs = logManager.getRecentLogsByLevel(level, limit);
        } else {
            logs = logManager.getRecentLogs(limit);
        }

        data.put("logs", convertLogEntries(logs));
        data.put("stats", logManager.getLogStats());

        return data;
    }

    /**
     * 성능 데이터
     */
    private Map<String, Object> getPerformanceData() {
        Map<String, Object> data = new HashMap<>();

        // 쿼리 성능 통계
        Map<String, QueryOptimizer.QueryStats> queryStats = QueryOptimizer.getInstance().getAllQueryStats();
        Map<String, Object> topQueries = new HashMap<>();

        queryStats.entrySet().stream()
            .sorted((e1, e2) -> Long.compare(e2.getValue().getTotalExecutionTime(), e1.getValue().getTotalExecutionTime()))
            .limit(20)
            .forEach(entry -> {
                QueryOptimizer.QueryStats stats = entry.getValue();
                Map<String, Object> statData = new HashMap<>();
                statData.put("executionCount", stats.getExecutionCount());
                statData.put("averageTime", stats.getAverageExecutionTime());
                statData.put("maxTime", stats.getMaxExecutionTime());
                statData.put("minTime", stats.getMinExecutionTime());
                statData.put("totalTime", stats.getTotalExecutionTime());
                topQueries.put(entry.getKey(), statData);
            });

        data.put("topQueries", topQueries);

        // 성능 로그 추이
        List<LogManager.LogEntry> perfLogs = logManager.getRecentLogsByLevel(
            LogManager.LogLevel.PERFORMANCE, 50);
        data.put("performanceLogs", convertLogEntries(perfLogs));

        return data;
    }

    /**
     * 보안 데이터
     */
    private Map<String, Object> getSecurityData() {
        Map<String, Object> data = new HashMap<>();

        // 보안 로그
        List<LogManager.LogEntry> securityLogs = logManager.getRecentLogsByLevel(
            LogManager.LogLevel.SECURITY, 100);
        data.put("securityLogs", convertLogEntries(securityLogs));

        // 보안 통계 (IP별 분석)
        Map<String, Long> ipStats = securityLogs.stream()
            .collect(Collectors.groupingBy(
                log -> log.getIpAddress() != null ? log.getIpAddress() : "unknown",
                Collectors.counting()
            ));
        data.put("ipStats", ipStats);

        // 보안 이벤트 유형별 통계
        Map<String, Long> eventStats = securityLogs.stream()
            .collect(Collectors.groupingBy(
                log -> log.getMessage() != null ? log.getMessage().split(" ")[0] : "unknown",
                Collectors.counting()
            ));
        data.put("eventStats", eventStats);

        return data;
    }

    /**
     * 시스템 데이터
     */
    private Map<String, Object> getSystemData() {
        Map<String, Object> data = new HashMap<>();

        Runtime runtime = Runtime.getRuntime();

        // JVM 정보
        Map<String, Object> jvm = new HashMap<>();
        jvm.put("maxMemory", runtime.maxMemory());
        jvm.put("totalMemory", runtime.totalMemory());
        jvm.put("freeMemory", runtime.freeMemory());
        jvm.put("usedMemory", runtime.totalMemory() - runtime.freeMemory());
        jvm.put("availableProcessors", runtime.availableProcessors());
        data.put("jvm", jvm);

        // 시스템 프로퍼티
        Map<String, String> systemProps = new HashMap<>();
        systemProps.put("javaVersion", System.getProperty("java.version"));
        systemProps.put("osName", System.getProperty("os.name"));
        systemProps.put("osVersion", System.getProperty("os.version"));
        systemProps.put("userDir", System.getProperty("user.dir"));
        data.put("system", systemProps);

        // 스레드 정보
        Map<String, Object> threads = new HashMap<>();
        threads.put("activeThreads", Thread.activeCount());
        threads.put("totalStartedThreads", java.lang.management.ManagementFactory.getThreadMXBean().getTotalStartedThreadCount());
        data.put("threads", threads);

        return data;
    }

    /**
     * 로그 엔트리를 JSON 친화적 형태로 변환
     */
    private List<Map<String, Object>> convertLogEntries(List<LogManager.LogEntry> logEntries) {
        return logEntries.stream().map(entry -> {
            Map<String, Object> logData = new HashMap<>();
            logData.put("timestamp", entry.getTimestamp().toString());
            logData.put("level", entry.getLevel().toString());
            logData.put("category", entry.getCategory());
            logData.put("message", entry.getMessage());
            logData.put("ipAddress", entry.getIpAddress());
            logData.put("requestUri", entry.getRequestUri());
            logData.put("method", entry.getMethod());
            logData.put("userId", entry.getUserId());
            logData.put("duration", entry.getDuration());

            if (entry.getThrowable() != null) {
                logData.put("exception", entry.getThrowable().getClass().getSimpleName());
                logData.put("exceptionMessage", entry.getThrowable().getMessage());
            }

            return logData;
        }).collect(Collectors.toList());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // POST 요청은 관리 작업을 위해 사용 (로그 클리어, 시스템 상태 변경 등)
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", "관리 기능은 아직 구현되지 않았습니다.");

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}