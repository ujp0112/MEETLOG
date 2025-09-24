package util;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 애플리케이션 레벨 캐시 매니저
 * 메모리 기반 캐싱으로 성능 최적화
 */
public class CacheManager {

    private static CacheManager instance;
    private final ConcurrentHashMap<String, CacheEntry> cache;
    private final ScheduledExecutorService scheduler;

    // 캐시 설정
    private static final long DEFAULT_TTL = 300000; // 5분 (밀리초)
    private static final int CLEANUP_INTERVAL = 60; // 1분마다 정리
    private static final int MAX_CACHE_SIZE = 10000; // 최대 캐시 엔트리 수

    private CacheManager() {
        this.cache = new ConcurrentHashMap<>();
        this.scheduler = Executors.newSingleThreadScheduledExecutor();

        // 주기적 캐시 정리 작업
        scheduler.scheduleAtFixedRate(this::cleanupExpiredEntries,
            CLEANUP_INTERVAL, CLEANUP_INTERVAL, TimeUnit.SECONDS);
    }

    public static synchronized CacheManager getInstance() {
        if (instance == null) {
            instance = new CacheManager();
        }
        return instance;
    }

    /**
     * 캐시에 데이터 저장
     */
    public void put(String key, Object value) {
        put(key, value, DEFAULT_TTL);
    }

    /**
     * 캐시에 TTL과 함께 데이터 저장
     */
    public void put(String key, Object value, long ttlMillis) {
        if (cache.size() >= MAX_CACHE_SIZE) {
            // LRU 방식으로 오래된 항목 제거
            evictOldestEntry();
        }

        long expirationTime = System.currentTimeMillis() + ttlMillis;
        CacheEntry entry = new CacheEntry(value, expirationTime, System.currentTimeMillis());
        cache.put(key, entry);
    }

    /**
     * 캐시에서 데이터 조회
     */
    @SuppressWarnings("unchecked")
    public <T> T get(String key) {
        CacheEntry entry = cache.get(key);
        if (entry == null) {
            return null;
        }

        // 만료 검사
        if (entry.isExpired()) {
            cache.remove(key);
            return null;
        }

        // 액세스 시간 업데이트 (LRU 구현용)
        entry.updateLastAccessed();
        return (T) entry.getValue();
    }

    /**
     * 캐시에서 데이터 제거
     */
    public void remove(String key) {
        cache.remove(key);
    }

    /**
     * 패턴으로 캐시 무효화
     */
    public void invalidatePattern(String pattern) {
        cache.entrySet().removeIf(entry -> entry.getKey().contains(pattern));
    }

    /**
     * 전체 캐시 클리어
     */
    public void clear() {
        cache.clear();
    }

    /**
     * 캐시 통계 정보
     */
    public CacheStats getStats() {
        int totalEntries = cache.size();
        long totalMemory = cache.values().stream()
            .mapToLong(entry -> estimateSize(entry.getValue()))
            .sum();

        return new CacheStats(totalEntries, totalMemory);
    }

    /**
     * 만료된 엔트리 정리
     */
    private void cleanupExpiredEntries() {
        long currentTime = System.currentTimeMillis();
        cache.entrySet().removeIf(entry -> entry.getValue().isExpired(currentTime));
    }

    /**
     * 가장 오래된 엔트리 제거 (LRU)
     */
    private void evictOldestEntry() {
        String oldestKey = cache.entrySet().stream()
            .min((e1, e2) -> Long.compare(e1.getValue().getLastAccessed(), e2.getValue().getLastAccessed()))
            .map(entry -> entry.getKey())
            .orElse(null);

        if (oldestKey != null) {
            cache.remove(oldestKey);
        }
    }

    /**
     * 객체 크기 추정
     */
    private long estimateSize(Object obj) {
        if (obj == null) return 0;
        if (obj instanceof String) return ((String) obj).length() * 2; // UTF-16
        if (obj instanceof Number) return 8; // 평균적으로 8바이트
        return 100; // 기본 추정치
    }

    /**
     * 리소스 정리
     */
    public void shutdown() {
        scheduler.shutdown();
        cache.clear();
    }

    // ========== 내부 클래스들 ==========

    /**
     * 캐시 엔트리
     */
    private static class CacheEntry {
        private final Object value;
        private final long expirationTime;
        private volatile long lastAccessed;

        public CacheEntry(Object value, long expirationTime, long creationTime) {
            this.value = value;
            this.expirationTime = expirationTime;
            this.lastAccessed = creationTime;
        }

        public Object getValue() {
            return value;
        }

        public boolean isExpired() {
            return isExpired(System.currentTimeMillis());
        }

        public boolean isExpired(long currentTime) {
            return currentTime > expirationTime;
        }

        public long getLastAccessed() {
            return lastAccessed;
        }

        public void updateLastAccessed() {
            this.lastAccessed = System.currentTimeMillis();
        }
    }

    /**
     * 캐시 통계
     */
    public static class CacheStats {
        private final int totalEntries;
        private final long totalMemoryBytes;

        public CacheStats(int totalEntries, long totalMemoryBytes) {
            this.totalEntries = totalEntries;
            this.totalMemoryBytes = totalMemoryBytes;
        }

        public int getTotalEntries() {
            return totalEntries;
        }

        public long getTotalMemoryBytes() {
            return totalMemoryBytes;
        }

        public String getMemoryUsage() {
            if (totalMemoryBytes < 1024) {
                return totalMemoryBytes + " bytes";
            } else if (totalMemoryBytes < 1024 * 1024) {
                return String.format("%.2f KB", totalMemoryBytes / 1024.0);
            } else {
                return String.format("%.2f MB", totalMemoryBytes / (1024.0 * 1024.0));
            }
        }

        @Override
        public String toString() {
            return String.format("CacheStats{entries=%d, memory=%s}", totalEntries, getMemoryUsage());
        }
    }
}