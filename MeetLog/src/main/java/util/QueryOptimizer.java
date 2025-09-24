package util;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 데이터베이스 쿼리 최적화 유틸리티
 * 쿼리 캐싱, 성능 모니터링, 배치 처리 등을 담당
 */
public class QueryOptimizer {

    private static QueryOptimizer instance;

    // 쿼리 성능 통계
    private final ConcurrentHashMap<String, QueryStats> queryStatsMap;
    private final CacheManager cacheManager;

    // 쿼리 캐시 TTL (밀리초)
    private static final long DEFAULT_QUERY_CACHE_TTL = 300000; // 5분
    private static final long STATS_CACHE_TTL = 600000; // 10분

    private QueryOptimizer() {
        this.queryStatsMap = new ConcurrentHashMap<>();
        this.cacheManager = CacheManager.getInstance();
    }

    public static synchronized QueryOptimizer getInstance() {
        if (instance == null) {
            instance = new QueryOptimizer();
        }
        return instance;
    }

    /**
     * 캐시된 쿼리 결과 조회
     */
    @SuppressWarnings("unchecked")
    public <T> T getCachedResult(String cacheKey) {
        return cacheManager.get(cacheKey);
    }

    /**
     * 쿼리 결과 캐싱
     */
    public void cacheResult(String cacheKey, Object result) {
        cacheManager.put(cacheKey, result, DEFAULT_QUERY_CACHE_TTL);
    }

    /**
     * 쿼리 결과 캐싱 (TTL 지정)
     */
    public void cacheResult(String cacheKey, Object result, long ttlMillis) {
        cacheManager.put(cacheKey, result, ttlMillis);
    }

    /**
     * 쿼리 실행 시간 기록
     */
    public void recordQuery(String queryId, long executionTimeMs) {
        queryStatsMap.computeIfAbsent(queryId, k -> new QueryStats(k))
                    .recordExecution(executionTimeMs);
    }

    /**
     * 쿼리 성능 통계 조회
     */
    public QueryStats getQueryStats(String queryId) {
        return queryStatsMap.get(queryId);
    }

    /**
     * 모든 쿼리 성능 통계 조회
     */
    public Map<String, QueryStats> getAllQueryStats() {
        return new HashMap<>(queryStatsMap);
    }

    /**
     * 캐시 키 생성
     */
    public String generateCacheKey(String operation, Object... params) {
        StringBuilder keyBuilder = new StringBuilder(operation);
        for (Object param : params) {
            keyBuilder.append("_").append(param != null ? param.toString() : "null");
        }
        return keyBuilder.toString();
    }

    /**
     * 특정 패턴의 캐시 무효화
     */
    public void invalidateCache(String pattern) {
        cacheManager.invalidatePattern(pattern);
    }

    /**
     * 캐시 통계 조회
     */
    public CacheManager.CacheStats getCacheStats() {
        return cacheManager.getStats();
    }

    /**
     * 쿼리 통계 초기화
     */
    public void resetQueryStats() {
        queryStatsMap.clear();
    }

    /**
     * 시스템 종료 시 리소스 정리
     */
    public void shutdown() {
        cacheManager.shutdown();
        queryStatsMap.clear();
    }

    /**
     * 쿼리 성능 통계 클래스
     */
    public static class QueryStats {
        private final String queryId;
        private final AtomicLong executionCount;
        private final AtomicLong totalExecutionTime;
        private volatile long maxExecutionTime;
        private volatile long minExecutionTime;
        private volatile long lastExecutionTime;

        public QueryStats(String queryId) {
            this.queryId = queryId;
            this.executionCount = new AtomicLong(0);
            this.totalExecutionTime = new AtomicLong(0);
            this.maxExecutionTime = 0;
            this.minExecutionTime = Long.MAX_VALUE;
            this.lastExecutionTime = System.currentTimeMillis();
        }

        public synchronized void recordExecution(long executionTimeMs) {
            executionCount.incrementAndGet();
            totalExecutionTime.addAndGet(executionTimeMs);
            lastExecutionTime = System.currentTimeMillis();

            if (executionTimeMs > maxExecutionTime) {
                maxExecutionTime = executionTimeMs;
            }

            if (executionTimeMs < minExecutionTime) {
                minExecutionTime = executionTimeMs;
            }
        }

        public String getQueryId() {
            return queryId;
        }

        public long getExecutionCount() {
            return executionCount.get();
        }

        public double getAverageExecutionTime() {
            long count = executionCount.get();
            return count > 0 ? (double) totalExecutionTime.get() / count : 0;
        }

        public long getMaxExecutionTime() {
            return maxExecutionTime;
        }

        public long getMinExecutionTime() {
            return minExecutionTime == Long.MAX_VALUE ? 0 : minExecutionTime;
        }

        public long getTotalExecutionTime() {
            return totalExecutionTime.get();
        }

        public long getLastExecutionTime() {
            return lastExecutionTime;
        }

        @Override
        public String toString() {
            return String.format("QueryStats{id='%s', count=%d, avg=%.2fms, max=%dms, min=%dms}",
                queryId, getExecutionCount(), getAverageExecutionTime(),
                getMaxExecutionTime(), getMinExecutionTime());
        }
    }

    /**
     * 배치 처리를 위한 유틸리티 메서드들
     */
    public static class BatchUtils {

        /**
         * 대용량 데이터 배치 처리
         */
        public static <T> void processBatch(java.util.List<T> items, int batchSize,
                java.util.function.Consumer<java.util.List<T>> processor) {

            for (int i = 0; i < items.size(); i += batchSize) {
                int endIndex = Math.min(i + batchSize, items.size());
                java.util.List<T> batch = items.subList(i, endIndex);
                processor.accept(batch);
            }
        }

        /**
         * 페이징 처리를 위한 LIMIT/OFFSET 계산
         */
        public static Map<String, Integer> calculatePagination(int page, int size) {
            int offset = (page - 1) * size;
            Map<String, Integer> pagination = new HashMap<>();
            pagination.put("limit", size);
            pagination.put("offset", offset);
            return pagination;
        }

        /**
         * IN 절 최적화를 위한 청크 분할
         */
        public static <T> java.util.List<java.util.List<T>> chunkList(java.util.List<T> list, int chunkSize) {
            java.util.List<java.util.List<T>> chunks = new java.util.ArrayList<>();

            for (int i = 0; i < list.size(); i += chunkSize) {
                int endIndex = Math.min(i + chunkSize, list.size());
                chunks.add(list.subList(i, endIndex));
            }

            return chunks;
        }
    }

    /**
     * 자주 사용되는 캐시 키 패턴들
     */
    public static class CacheKeys {
        public static final String USER_PREFIX = "user_";
        public static final String RESTAURANT_PREFIX = "restaurant_";
        public static final String RESERVATION_PREFIX = "reservation_";
        public static final String REVIEW_PREFIX = "review_";
        public static final String STATS_PREFIX = "stats_";

        public static String userKey(int userId) {
            return USER_PREFIX + userId;
        }

        public static String restaurantKey(int restaurantId) {
            return RESTAURANT_PREFIX + restaurantId;
        }

        public static String reservationKey(int reservationId) {
            return RESERVATION_PREFIX + reservationId;
        }

        public static String reviewKey(int reviewId) {
            return REVIEW_PREFIX + reviewId;
        }

        public static String statsKey(String type, int id) {
            return STATS_PREFIX + type + "_" + id;
        }
    }
}