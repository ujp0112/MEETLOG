package util;

import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 비동기 작업 처리를 위한 스레드 풀 매니저
 * 이메일 발송, 알림 처리, 데이터 집계 등 백그라운드 작업을 담당
 */
public class AsyncTaskProcessor {

    private static AsyncTaskProcessor instance;

    // 스레드 풀 설정
    private static final int CORE_POOL_SIZE = 5;
    private static final int MAX_POOL_SIZE = 20;
    private static final long KEEP_ALIVE_TIME = 60L; // seconds
    private static final int QUEUE_CAPACITY = 100;

    private final ThreadPoolExecutor executor;
    private final ScheduledExecutorService scheduler;

    // 작업 통계
    private final AtomicLong completedTasks;
    private final AtomicLong failedTasks;

    private volatile boolean isShutdown = false;

    private AsyncTaskProcessor() {
        // 메인 작업용 스레드 풀
        this.executor = new ThreadPoolExecutor(
            CORE_POOL_SIZE,
            MAX_POOL_SIZE,
            KEEP_ALIVE_TIME,
            TimeUnit.SECONDS,
            new ArrayBlockingQueue<>(QUEUE_CAPACITY),
            new TaskThreadFactory("AsyncTask"),
            new ThreadPoolExecutor.CallerRunsPolicy()
        );

        // 예약 작업용 스케줄러
        this.scheduler = Executors.newScheduledThreadPool(3,
            new TaskThreadFactory("ScheduledTask"));

        this.completedTasks = new AtomicLong(0);
        this.failedTasks = new AtomicLong(0);
    }

    public static synchronized AsyncTaskProcessor getInstance() {
        if (instance == null) {
            instance = new AsyncTaskProcessor();
        }
        return instance;
    }

    /**
     * 비동기 작업 실행
     */
    public Future<?> executeAsync(Runnable task) {
        if (isShutdown) {
            throw new RejectedExecutionException("AsyncTaskProcessor is shutdown");
        }

        return executor.submit(new TaskWrapper(task));
    }

    /**
     * 비동기 작업 실행 (결과 반환)
     */
    public <T> Future<T> executeAsync(Callable<T> task) {
        if (isShutdown) {
            throw new RejectedExecutionException("AsyncTaskProcessor is shutdown");
        }

        return executor.submit(new CallableWrapper<>(task));
    }

    /**
     * 지연된 작업 예약
     */
    public ScheduledFuture<?> scheduleTask(Runnable task, long delay, TimeUnit timeUnit) {
        if (isShutdown) {
            throw new RejectedExecutionException("AsyncTaskProcessor is shutdown");
        }

        return scheduler.schedule(new TaskWrapper(task), delay, timeUnit);
    }

    /**
     * 반복 작업 예약
     */
    public ScheduledFuture<?> scheduleAtFixedRate(Runnable task, long initialDelay,
            long period, TimeUnit timeUnit) {
        if (isShutdown) {
            throw new RejectedExecutionException("AsyncTaskProcessor is shutdown");
        }

        return scheduler.scheduleAtFixedRate(new TaskWrapper(task),
            initialDelay, period, timeUnit);
    }

    /**
     * 작업 통계 조회
     */
    public TaskStats getStats() {
        return new TaskStats(
            executor.getTaskCount(),
            executor.getCompletedTaskCount(),
            completedTasks.get(),
            failedTasks.get(),
            executor.getActiveCount(),
            executor.getQueue().size()
        );
    }

    /**
     * 시스템 종료
     */
    public void shutdown() {
        isShutdown = true;

        executor.shutdown();
        scheduler.shutdown();

        try {
            if (!executor.awaitTermination(30, TimeUnit.SECONDS)) {
                executor.shutdownNow();
            }

            if (!scheduler.awaitTermination(30, TimeUnit.SECONDS)) {
                scheduler.shutdownNow();
            }
        } catch (InterruptedException e) {
            executor.shutdownNow();
            scheduler.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }

    /**
     * 작업 래퍼 (통계 수집용)
     */
    private class TaskWrapper implements Runnable {
        private final Runnable task;

        public TaskWrapper(Runnable task) {
            this.task = task;
        }

        @Override
        public void run() {
            try {
                task.run();
                completedTasks.incrementAndGet();
            } catch (Exception e) {
                failedTasks.incrementAndGet();
                System.err.println("Async task failed: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * Callable 래퍼 (통계 수집용)
     */
    private class CallableWrapper<T> implements Callable<T> {
        private final Callable<T> task;

        public CallableWrapper(Callable<T> task) {
            this.task = task;
        }

        @Override
        public T call() throws Exception {
            try {
                T result = task.call();
                completedTasks.incrementAndGet();
                return result;
            } catch (Exception e) {
                failedTasks.incrementAndGet();
                throw e;
            }
        }
    }

    /**
     * 커스텀 스레드 팩토리
     */
    private static class TaskThreadFactory implements ThreadFactory {
        private final AtomicLong threadNumber = new AtomicLong(1);
        private final String namePrefix;

        public TaskThreadFactory(String namePrefix) {
            this.namePrefix = namePrefix + "-";
        }

        @Override
        public Thread newThread(Runnable r) {
            Thread t = new Thread(r, namePrefix + threadNumber.getAndIncrement());
            t.setDaemon(true); // 데몬 스레드로 설정
            t.setPriority(Thread.NORM_PRIORITY);
            return t;
        }
    }

    /**
     * 작업 통계
     */
    public static class TaskStats {
        private final long totalSubmitted;
        private final long totalCompleted;
        private final long successfulTasks;
        private final long failedTasks;
        private final int activeTasks;
        private final int queuedTasks;

        public TaskStats(long totalSubmitted, long totalCompleted,
                long successfulTasks, long failedTasks,
                int activeTasks, int queuedTasks) {
            this.totalSubmitted = totalSubmitted;
            this.totalCompleted = totalCompleted;
            this.successfulTasks = successfulTasks;
            this.failedTasks = failedTasks;
            this.activeTasks = activeTasks;
            this.queuedTasks = queuedTasks;
        }

        public long getTotalSubmitted() { return totalSubmitted; }
        public long getTotalCompleted() { return totalCompleted; }
        public long getSuccessfulTasks() { return successfulTasks; }
        public long getFailedTasks() { return failedTasks; }
        public int getActiveTasks() { return activeTasks; }
        public int getQueuedTasks() { return queuedTasks; }

        public double getSuccessRate() {
            return successfulTasks + failedTasks > 0 ?
                (double) successfulTasks / (successfulTasks + failedTasks) * 100 : 0;
        }

        @Override
        public String toString() {
            return String.format("TaskStats{submitted=%d, completed=%d, success=%d, failed=%d, " +
                "active=%d, queued=%d, successRate=%.1f%%}",
                totalSubmitted, totalCompleted, successfulTasks, failedTasks,
                activeTasks, queuedTasks, getSuccessRate());
        }
    }

    /**
     * 일반적인 비동기 작업들
     */
    public static class CommonTasks {

        /**
         * 이메일 발송 작업
         */
        public static Runnable emailTask(String to, String subject, String content) {
            return () -> {
                try {
                    // 실제 이메일 발송 로직
                    System.out.println("Sending email to: " + to);
                    System.out.println("Subject: " + subject);
                    Thread.sleep(1000); // 이메일 발송 시뮬레이션
                    System.out.println("Email sent successfully");
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("Email sending interrupted", e);
                }
            };
        }

        /**
         * 알림 발송 작업
         */
        public static Runnable notificationTask(int userId, String message) {
            return () -> {
                try {
                    // 실제 푸시 알림 발송 로직
                    System.out.println("Sending notification to user " + userId + ": " + message);
                    Thread.sleep(500); // 알림 발송 시뮬레이션
                    System.out.println("Notification sent successfully");
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("Notification sending interrupted", e);
                }
            };
        }

        /**
         * 데이터 집계 작업
         */
        public static Callable<String> dataAggregationTask(String type, int targetId) {
            return () -> {
                try {
                    // 실제 데이터 집계 로직
                    System.out.println("Aggregating " + type + " data for ID: " + targetId);
                    Thread.sleep(2000); // 집계 작업 시뮬레이션

                    // 캐시에 결과 저장
                    String cacheKey = "aggregation_" + type + "_" + targetId;
                    String result = "Aggregated data for " + type + " ID " + targetId;

                    CacheManager.getInstance().put(cacheKey, result);
                    System.out.println("Data aggregation completed and cached");

                    return result;
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("Data aggregation interrupted", e);
                }
            };
        }

        /**
         * 이미지 처리 작업
         */
        public static Runnable imageProcessingTask(String imagePath, String operation) {
            return () -> {
                try {
                    System.out.println("Processing image: " + imagePath + " with operation: " + operation);
                    Thread.sleep(3000); // 이미지 처리 시뮬레이션
                    System.out.println("Image processing completed");
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("Image processing interrupted", e);
                }
            };
        }

        /**
         * 로그 처리 작업
         */
        public static Runnable logProcessingTask(String logLevel, String message) {
            return () -> {
                try {
                    String timestamp = java.time.LocalDateTime.now().toString();
                    String logEntry = String.format("[%s] %s: %s", timestamp, logLevel, message);

                    // 실제 로그 파일 작성 또는 로그 시스템 전송
                    System.out.println("Processing log: " + logEntry);
                    Thread.sleep(100); // 로그 처리 시뮬레이션

                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("Log processing interrupted", e);
                }
            };
        }
    }
}