package service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

import com.fasterxml.jackson.databind.ObjectMapper;

import adapter.KoBertAdapter;
import dao.UserVectorDAO;
import model.Review;
import model.UserVectorRecord;
import service.port.RecommendationPort;

/**
 * 사용자 리뷰 기반 벡터 캐싱 및 비동기 업데이트 서비스.
 */
public class UserVectorService {

    private static final int MAX_REVIEW_SAMPLE = 20;
    private static final UserVectorService INSTANCE = new UserVectorService();

    private final ExecutorService executor;
    private final Set<Integer> pendingUsers = ConcurrentHashMap.newKeySet();
    private final ReviewService reviewService = new ReviewService();
    private final RecommendationPort recommendationPort = new KoBertAdapter();
    private final UserVectorDAO userVectorDAO = new UserVectorDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private UserVectorService() {
        this.executor = Executors.newSingleThreadExecutor(new ThreadFactory() {
            @Override
            public Thread newThread(Runnable r) {
                Thread thread = new Thread(r, "user-vector-worker");
                thread.setDaemon(true);
                return thread;
            }
        });
    }

    public static UserVectorService getInstance() {
        return INSTANCE;
    }

    /**
     * 비동기 벡터 업데이트를 요청합니다. 동일 사용자에 대해 중복 큐잉되지 않습니다.
     */
    public void requestVectorUpdate(int userId) {
        if (userId <= 0) {
            return;
        }
        if (!pendingUsers.add(userId)) {
            return; // 이미 처리 중
        }
        userVectorDAO.markProcessing(userId);
        executor.submit(() -> {
            try {
                double[] vector = computeVectorInternal(userId);
                if (vector == null) {
                    userVectorDAO.markEmpty(userId);
                } else {
                    userVectorDAO.saveVector(userId, objectMapper.writeValueAsString(vector));
                }
            } catch (Exception e) {
                userVectorDAO.markFailure(userId, truncateMessage(e.getMessage()));
            } finally {
                pendingUsers.remove(userId);
            }
        });
    }

    /**
     * 즉시 사용자 벡터를 계산합니다. 실패 시 null 반환.
     */
    public double[] computeVectorNow(int userId) {
        try {
            double[] vector = computeVectorInternal(userId);
            if (vector == null) {
                userVectorDAO.markEmpty(userId);
            } else {
                userVectorDAO.saveVector(userId, objectMapper.writeValueAsString(vector));
            }
            return vector;
        } catch (Exception e) {
            userVectorDAO.markFailure(userId, truncateMessage(e.getMessage()));
            return null;
        }
    }

    /**
     * 캐시에 저장된 사용자 벡터를 반환합니다.
     */
    public double[] getCachedVector(int userId) {
        UserVectorRecord record = userVectorDAO.findByUserId(userId);
        return record != null ? record.getVector() : null;
    }

    /**
     * 캐시된 벡터를 우선 반환하고, 없으면 즉시 계산 후 저장합니다.
     */
    public double[] getOrComputeVector(int userId) {
        double[] cached = getCachedVector(userId);
        if (cached != null) {
            return cached;
        }
        return computeVectorNow(userId);
    }

    private double[] computeVectorInternal(int userId) {
        List<Review> recentReviews = reviewService.getRecentReviews(userId, MAX_REVIEW_SAMPLE);
        if (recentReviews == null || recentReviews.isEmpty()) {
            return null;
        }

        List<double[]> vectors = new ArrayList<>();
        Integer dimension = null;
        for (Review review : recentReviews) {
            if (review == null) {
                continue;
            }
            StringBuilder sb = new StringBuilder();
            if (review.getContent() != null) {
                sb.append(review.getContent());
            }
            if (review.getKeywords() != null && !review.getKeywords().isEmpty()) {
                if (sb.length() > 0) {
                    sb.append('\n');
                }
                sb.append(String.join(", ", review.getKeywords()));
            }
            if (sb.length() == 0) {
                continue;
            }
            double[] vector = recommendationPort.getVectorFromText(sb.toString());
            if (vector != null) {
                if (dimension == null) {
                    dimension = vector.length;
                }
                if (dimension == vector.length) {
                    vectors.add(vector);
                }
            }
        }

        if (vectors.isEmpty() || dimension == null) {
            return null;
        }

        double[] accumulator = new double[dimension];
        for (double[] vector : vectors) {
            for (int i = 0; i < dimension; i++) {
                accumulator[i] += vector[i];
            }
        }
        double scale = 1.0 / vectors.size();
        for (int i = 0; i < dimension; i++) {
            accumulator[i] *= scale;
        }
        return accumulator;
    }

    private String truncateMessage(String message) {
        if (message == null) {
            return null;
        }
        if (message.length() <= 300) {
            return message;
        }
        return message.substring(0, 300);
    }
}
