package util;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.atomic.AtomicLong;

import javax.servlet.http.HttpServletRequest;

/**
 * 통합 로그 관리 시스템
 * 애플리케이션 로그, 보안 로그, 성능 로그, 에러 로그를 체계적으로 관리
 */
public class LogManager {

    private static LogManager instance;

    private static final String LOG_DIR = "logs/";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // 로그 통계
    private final AtomicLong totalLogs = new AtomicLong(0);
    private final AtomicLong errorLogs = new AtomicLong(0);
    private final AtomicLong securityLogs = new AtomicLong(0);
    private final AtomicLong performanceLogs = new AtomicLong(0);

    // 메모리 로그 큐 (최근 1000개 로그)
    private final ConcurrentLinkedQueue<LogEntry> recentLogs = new ConcurrentLinkedQueue<>();
    private static final int MAX_RECENT_LOGS = 1000;

    private final AsyncTaskProcessor asyncProcessor;

    private LogManager() {
        this.asyncProcessor = AsyncTaskProcessor.getInstance();
        createLogDirectories();
    }

    public static synchronized LogManager getInstance() {
        if (instance == null) {
            instance = new LogManager();
        }
        return instance;
    }

    /**
     * 로그 디렉토리 생성
     */
    private void createLogDirectories() {
        try {
            java.io.File logDir = new java.io.File(LOG_DIR);
            if (!logDir.exists()) {
                logDir.mkdirs();
            }
        } catch (Exception e) {
            System.err.println("로그 디렉토리 생성 실패: " + e.getMessage());
        }
    }

    /**
     * 일반 정보 로그
     */
    public void logInfo(String message) {
        logInfo(null, message, null);
    }

    public void logInfo(String category, String message) {
        logInfo(category, message, null);
    }

    public void logInfo(String category, String message, HttpServletRequest request) {
        LogEntry entry = createLogEntry(LogLevel.INFO, category, message, request, null);
        processLog(entry);
    }

    /**
     * 에러 로그
     */
    public void logError(String message, Throwable throwable) {
        logError(null, message, null, throwable);
    }

    public void logError(String category, String message, HttpServletRequest request, Throwable throwable) {
        LogEntry entry = createLogEntry(LogLevel.ERROR, category, message, request, throwable);
        errorLogs.incrementAndGet();
        processLog(entry);
    }

    /**
     * 보안 관련 로그
     */
    public void logSecurity(String event, HttpServletRequest request) {
        logSecurity(event, request, null);
    }

    public void logSecurity(String event, HttpServletRequest request, String details) {
        LogEntry entry = createLogEntry(LogLevel.SECURITY, "SECURITY", event, request, null);
        if (details != null) {
            entry.setDetails(details);
        }
        securityLogs.incrementAndGet();
        processLog(entry);
    }

    /**
     * 성능 관련 로그
     */
    public void logPerformance(String operation, long duration) {
        logPerformance(operation, duration, null);
    }

    public void logPerformance(String operation, long duration, HttpServletRequest request) {
        String message = String.format("Operation: %s, Duration: %dms", operation, duration);
        LogEntry entry = createLogEntry(LogLevel.PERFORMANCE, "PERFORMANCE", message, request, null);
        entry.setDuration(duration);
        performanceLogs.incrementAndGet();
        processLog(entry);
    }

    /**
     * 사용자 활동 로그
     */
    public void logUserActivity(int userId, String activity, HttpServletRequest request) {
        String message = String.format("User %d: %s", userId, activity);
        LogEntry entry = createLogEntry(LogLevel.ACTIVITY, "USER_ACTIVITY", message, request, null);
        entry.setUserId(userId);
        processLog(entry);
    }

    /**
     * 로그 엔트리 생성
     */
    private LogEntry createLogEntry(LogLevel level, String category, String message,
                                  HttpServletRequest request, Throwable throwable) {
        LogEntry entry = new LogEntry();
        entry.setTimestamp(LocalDateTime.now());
        entry.setLevel(level);
        entry.setCategory(category != null ? category : "DEFAULT");
        entry.setMessage(message);
        entry.setThrowable(throwable);

        if (request != null) {
            entry.setIpAddress(SecurityUtils.getClientIP(request));
            entry.setUserAgent(SecurityUtils.getUserAgent(request));
            entry.setRequestUri(request.getRequestURI());
            entry.setMethod(request.getMethod());

            // 세션 정보
            if (request.getSession(false) != null) {
                entry.setSessionId(request.getSession().getId());
                Object user = request.getSession().getAttribute("user");
                if (user != null && user instanceof model.User) {
                    entry.setUserId(((model.User) user).getId());
                }
            }
        }

        return entry;
    }

    /**
     * 로그 처리
     */
    private void processLog(LogEntry entry) {
        totalLogs.incrementAndGet();

        // 메모리 큐에 추가
        addToRecentLogs(entry);

        // 비동기로 파일에 기록
        asyncProcessor.executeAsync(() -> writeLogToFile(entry));

        // 콘솔에 출력 (개발 환경)
        printToConsole(entry);
    }

    /**
     * 최근 로그 큐에 추가
     */
    private void addToRecentLogs(LogEntry entry) {
        recentLogs.offer(entry);

        // 큐 크기 제한
        while (recentLogs.size() > MAX_RECENT_LOGS) {
            recentLogs.poll();
        }
    }

    /**
     * 파일에 로그 기록
     */
    private void writeLogToFile(LogEntry entry) {
        try {
            String fileName = getLogFileName(entry.getLevel());
            String logLine = formatLogEntry(entry);

            try (FileWriter fw = new FileWriter(LOG_DIR + fileName, true);
                 PrintWriter pw = new PrintWriter(fw)) {
                pw.println(logLine);

                // 에러인 경우 스택 트레이스도 기록
                if (entry.getThrowable() != null) {
                    entry.getThrowable().printStackTrace(pw);
                }
            }
        } catch (IOException e) {
            System.err.println("로그 파일 작성 실패: " + e.getMessage());
        }
    }

    /**
     * 콘솔에 로그 출력
     */
    private void printToConsole(LogEntry entry) {
        String logLine = formatLogEntry(entry);

        if (entry.getLevel() == LogLevel.ERROR) {
            System.err.println(logLine);
            if (entry.getThrowable() != null) {
                entry.getThrowable().printStackTrace();
            }
        } else {
            System.out.println(logLine);
        }
    }

    /**
     * 로그 엔트리 포맷팅
     */
    private String formatLogEntry(LogEntry entry) {
        StringBuilder sb = new StringBuilder();
        sb.append("[").append(entry.getTimestamp().format(DATE_FORMATTER)).append("] ");
        sb.append("[").append(entry.getLevel()).append("] ");
        sb.append("[").append(entry.getCategory()).append("] ");
        sb.append(entry.getMessage());

        if (entry.getIpAddress() != null) {
            sb.append(" | IP: ").append(entry.getIpAddress());
        }

        if (entry.getRequestUri() != null) {
            sb.append(" | URI: ").append(entry.getMethod()).append(" ").append(entry.getRequestUri());
        }

        if (entry.getUserId() > 0) {
            sb.append(" | User: ").append(entry.getUserId());
        }

        if (entry.getDuration() > 0) {
            sb.append(" | Duration: ").append(entry.getDuration()).append("ms");
        }

        return sb.toString();
    }

    /**
     * 로그 파일명 생성
     */
    private String getLogFileName(LogLevel level) {
        String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        switch (level) {
            case ERROR:
                return "error-" + date + ".log";
            case SECURITY:
                return "security-" + date + ".log";
            case PERFORMANCE:
                return "performance-" + date + ".log";
            case ACTIVITY:
                return "activity-" + date + ".log";
            default:
                return "application-" + date + ".log";
        }
    }

    /**
     * 최근 로그 조회
     */
    public java.util.List<LogEntry> getRecentLogs(int limit) {
        return recentLogs.stream()
                .skip(Math.max(0, recentLogs.size() - limit))
                .collect(java.util.stream.Collectors.toList());
    }

    /**
     * 특정 레벨의 최근 로그 조회
     */
    public java.util.List<LogEntry> getRecentLogsByLevel(LogLevel level, int limit) {
        return recentLogs.stream()
                .filter(entry -> entry.getLevel() == level)
                .skip(Math.max(0, recentLogs.stream().mapToInt(e -> e.getLevel() == level ? 1 : 0).sum() - limit))
                .collect(java.util.stream.Collectors.toList());
    }

    /**
     * 로그 통계 조회
     */
    public LogStats getLogStats() {
        return new LogStats(
            totalLogs.get(),
            errorLogs.get(),
            securityLogs.get(),
            performanceLogs.get()
        );
    }

    /**
     * 로그 레벨 열거형
     */
    public enum LogLevel {
        INFO, ERROR, SECURITY, PERFORMANCE, ACTIVITY
    }

    /**
     * 로그 엔트리 클래스
     */
    public static class LogEntry {
        private LocalDateTime timestamp;
        private LogLevel level;
        private String category;
        private String message;
        private String details;
        private String ipAddress;
        private String userAgent;
        private String requestUri;
        private String method;
        private String sessionId;
        private int userId;
        private long duration;
        private Throwable throwable;

        // Getters and Setters
        public LocalDateTime getTimestamp() { return timestamp; }
        public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
        public LogLevel getLevel() { return level; }
        public void setLevel(LogLevel level) { this.level = level; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public String getDetails() { return details; }
        public void setDetails(String details) { this.details = details; }
        public String getIpAddress() { return ipAddress; }
        public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
        public String getUserAgent() { return userAgent; }
        public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
        public String getRequestUri() { return requestUri; }
        public void setRequestUri(String requestUri) { this.requestUri = requestUri; }
        public String getMethod() { return method; }
        public void setMethod(String method) { this.method = method; }
        public String getSessionId() { return sessionId; }
        public void setSessionId(String sessionId) { this.sessionId = sessionId; }
        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }
        public long getDuration() { return duration; }
        public void setDuration(long duration) { this.duration = duration; }
        public Throwable getThrowable() { return throwable; }
        public void setThrowable(Throwable throwable) { this.throwable = throwable; }
    }

    /**
     * 로그 통계 클래스
     */
    public static class LogStats {
        private final long totalLogs;
        private final long errorLogs;
        private final long securityLogs;
        private final long performanceLogs;

        public LogStats(long totalLogs, long errorLogs, long securityLogs, long performanceLogs) {
            this.totalLogs = totalLogs;
            this.errorLogs = errorLogs;
            this.securityLogs = securityLogs;
            this.performanceLogs = performanceLogs;
        }

        public long getTotalLogs() { return totalLogs; }
        public long getErrorLogs() { return errorLogs; }
        public long getSecurityLogs() { return securityLogs; }
        public long getPerformanceLogs() { return performanceLogs; }

        @Override
        public String toString() {
            return String.format("LogStats{total=%d, error=%d, security=%d, performance=%d}",
                totalLogs, errorLogs, securityLogs, performanceLogs);
        }
    }
}