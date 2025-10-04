package service;

import dao.RecommendationDAO;
import model.*;
import service.port.RecommendationPort; // ✨ 구체 클래스가 아닌 '포트(인터페이스)'를 import

import java.util.*;
import java.util.stream.Collectors;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

/**
 * 지능형 추천 시스템 서비스
 * ML 기반 평점 예측, 실시간 트렌드 분석, 사용자 행동 패턴 학습을 통한 고도화된 추천 시스템.
 * 외부 AI 모델과는 RecommendationPort를 통해 통신하여 결합도를 낮춤.
 */
public class IntelligentRecommendationService {

    // --- 의존성 ---
    private final RecommendationDAO recommendationDAO;
    private final UserAnalyticsService userAnalyticsService;
    private final RecommendationPort recommendationPort;
    private final dao.RecommendationMetricDAO metricDAO;

    // --- 추천 성능 지표 ---
    private static final double TREND_WEIGHT = 0.15;      // 트렌드 가중치
    private static final double BEHAVIOR_WEIGHT = 0.25;   // 행동 패턴 가중치
    private static final double COLLABORATIVE_WEIGHT = 0.35; // 협업 필터링 가중치
    private static final double CONTENT_WEIGHT = 0.25;    // 콘텐츠 기반 가중치

    /**
     * ✨ 생성자를 통해 외부에서 의존성을 주입(Dependency Injection)받습니다.
     * 이로써 IntelligentRecommendationService는 KoBERT의 존재를 전혀 알지 못하게 됩니다.
     */
    public IntelligentRecommendationService(RecommendationDAO recommendationDAO,
                                          UserAnalyticsService userAnalyticsService,
                                          RecommendationPort recommendationPort,
                                          dao.RecommendationMetricDAO metricDAO) {
        this.recommendationDAO = recommendationDAO;
        this.userAnalyticsService = userAnalyticsService;
        this.recommendationPort = recommendationPort;
        this.metricDAO = metricDAO;
    }

    /**
     * 지능형 하이브리드 추천 (ML + KoBERT 기반)
     */
    public List<RestaurantRecommendation> getIntelligentRecommendations(int userId, int limit) {
        try {
            // 1. 사용자 행동 패턴 분석
            UserBehaviorPattern behaviorPattern = analyzeBehaviorPattern(userId);

            // 2. 실시간 트렌드 데이터 조회
            TrendAnalysis trendData = analyzeCurrentTrends();

            // 3. 개인화된 추천 생성
            List<RestaurantRecommendation> personalizedRecs = generatePersonalizedRecommendations(
                userId, behaviorPattern, limit * 2
            );

            // 4. 트렌드 기반 추천 생성
            List<RestaurantRecommendation> trendRecs = generateTrendBasedRecommendations(
                trendData, behaviorPattern, limit
            );

            // 5. ML 기반 점수 예측 및 가중치 적용
            List<RestaurantRecommendation> finalRecs = applyMLScoring(
                personalizedRecs, trendRecs, behaviorPattern, userId
            );

            // 6. 다양성 보장 및 최적화
            finalRecs = ensureDiversity(finalRecs, limit);

            // 7. 추천 성능 로깅
            logRecommendationMetrics(userId, finalRecs);

            return finalRecs;

        } catch (Exception e) {
            e.printStackTrace();
            return getFallbackIntelligentRecommendations(userId, limit);
        }
    }

    /**
     * 사용자 행동 패턴 분석
     */
    private UserBehaviorPattern analyzeBehaviorPattern(int userId) {
        UserBehaviorPattern pattern = new UserBehaviorPattern();
        pattern.setUserId(userId);

        try {
            // 최근 30일간의 활동 데이터 분석
            LocalDateTime thirtyDaysAgo = LocalDateTime.now().minus(30, ChronoUnit.DAYS);

            // 1. 방문 시간대 패턴 분석
            Map<String, Integer> timePatterns = userAnalyticsService.getTimePatterns(userId, thirtyDaysAgo);
            pattern.setPreferredTimeSlots(extractTopTimeSlots(timePatterns));

            // 2. 카테고리 선호도 분석
            Map<String, Double> categoryPrefs = userAnalyticsService.getCategoryPreferences(userId, thirtyDaysAgo);
            pattern.setCategoryAffinities(categoryPrefs);

            // 3. 가격대 패턴 분석
            Map<String, Integer> pricePatterns = userAnalyticsService.getPriceRangePatterns(userId, thirtyDaysAgo);
            pattern.setPreferredPriceRanges(pricePatterns);

            // 4. 지역 선호도 분석
            Map<String, Double> locationPrefs = userAnalyticsService.getLocationPreferences(userId, thirtyDaysAgo);
            pattern.setLocationAffinities(locationPrefs);

            // 5. 리뷰 패턴 분석 (평점 분포, 리뷰 길이 등)
            ReviewPattern reviewPattern = userAnalyticsService.getReviewPattern(userId, thirtyDaysAgo);
            pattern.setReviewPattern(reviewPattern);

            // 6. 소셜 활동 패턴 (팔로우, 좋아요 등)
            SocialPattern socialPattern = userAnalyticsService.getSocialPattern(userId, thirtyDaysAgo);
            pattern.setSocialPattern(socialPattern);

        } catch (Exception e) {
            e.printStackTrace();
            // 기본 패턴으로 설정
            pattern = getDefaultBehaviorPattern(userId);
        }

        return pattern;
    }

    /**
     * 실시간 트렌드 분석
     */
    private TrendAnalysis analyzeCurrentTrends() {
        TrendAnalysis trend = new TrendAnalysis();

        try {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime lastWeek = now.minus(7, ChronoUnit.DAYS);

            // 1. 실시간 인기 카테고리
            Map<String, Double> trendingCategories = calculateTrendingCategories(lastWeek, now);
            trend.setTrendingCategories(trendingCategories);

            // 2. 급상승 맛집 분석
            List<Restaurant> risingStars = findRisingStarRestaurants(lastWeek, now);
            trend.setRisingStars(risingStars);

            // 3. 지역별 트렌드
            Map<String, List<String>> locationTrends = analyzeLocationTrends(lastWeek, now);
            trend.setLocationTrends(locationTrends);

            // 4. 시간대별 인기 패턴
            Map<String, Map<String, Double>> timeBasedTrends = analyzeTimeBasedTrends(lastWeek, now);
            trend.setTimeBasedTrends(timeBasedTrends);

            // 5. 소셜 미디어 버즈 분석 (해시태그, 언급 등)
            Map<String, Integer> socialBuzz = analyzeSocialBuzz(lastWeek, now);
            trend.setSocialBuzz(socialBuzz);

        } catch (Exception e) {
            e.printStackTrace();
            trend = getDefaultTrend();
        }

        return trend;
    }

    /**
     * 개인화된 추천 생성
     */
    private List<RestaurantRecommendation> generatePersonalizedRecommendations(
            int userId, UserBehaviorPattern pattern, int limit) {

        List<RestaurantRecommendation> recommendations = new ArrayList<>();

        try {
            // 1. 협업 필터링 기반 추천 (개선된 알고리즘)
            List<RestaurantRecommendation> collaborativeRecs = getEnhancedCollaborativeRecommendations(
                userId, pattern, limit
            );

            // 2. 딥러닝 기반 콘텐츠 추천
            List<RestaurantRecommendation> contentRecs = getDeepLearningContentRecommendations(
                userId, pattern, limit
            );

            // 3. 행동 패턴 기반 추천
            List<RestaurantRecommendation> behaviorRecs = getBehaviorBasedRecommendations(
                pattern, limit
            );

            // 4. 추천 결과 융합
            // 현재는 콘텐츠 기반 추천만 반환하지만, 향후 다른 추천들과 융합 가능
            // recommendations = fuseRecommendations(collaborativeRecs, contentRecs, behaviorRecs, limit);
            recommendations.addAll(contentRecs);

        } catch (Exception e) {
            System.err.println("개인화 추천 생성 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }

        return recommendations;
    }

    /**
     * ML 기반 점수 예측 및 가중치 적용
     */
    private List<RestaurantRecommendation> applyMLScoring(
            List<RestaurantRecommendation> personalizedRecs,
            List<RestaurantRecommendation> trendRecs,
            UserBehaviorPattern pattern,
            int userId) {

        Map<Integer, RestaurantRecommendation> combined = new HashMap<>();

        // 1. 개인화 추천에 ML 점수 적용
        for (RestaurantRecommendation rec : personalizedRecs) {
            double mlScore = predictRatingWithML(userId, rec.getRestaurant(), pattern);
            double personalizedScore = rec.getRecommendationScore() * 0.7 + mlScore * 0.3;

            rec.setRecommendationScore(personalizedScore);
            rec.setPredictedRating(mlScore * 5.0); // 1-5점 척도로 변환

            combined.put(rec.getRestaurant().getId(), rec);
        }

        // 2. 트렌드 추천에 가중치 적용
        for (RestaurantRecommendation rec : trendRecs) {
            int restaurantId = rec.getRestaurant().getId();
            double trendScore = rec.getRecommendationScore() * TREND_WEIGHT;

            if (combined.containsKey(restaurantId)) {
                // 기존 점수와 트렌드 점수 결합
                RestaurantRecommendation existing = combined.get(restaurantId);
                double combinedScore = existing.getRecommendationScore() + trendScore;
                existing.setRecommendationScore(combinedScore);

                // 트렌드 정보 추가
                String newReason = existing.getReason() + " + 실시간 트렌드";
                existing.setReason(newReason);
            } else {
                rec.setRecommendationScore(trendScore);
                combined.put(restaurantId, rec);
            }
        }

        // 3. 최종 점수 정규화 및 정렬
        return combined.values().stream()
            .peek(this::normalizeScore)
            .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
            .collect(Collectors.toList());
    }

    private double predictRatingWithML(int userId, Restaurant restaurant, UserBehaviorPattern pattern) {
        try {
            // 특성 벡터 생성
            Map<String, Double> features = createFeatureVector(userId, restaurant, pattern);

            // 간단한 선형 회귀 모델 (실제로는 학습된 모델의 가중치를 사용)
            double prediction = calculateLinearPrediction(features);

            // 예측 점수가 0~1 범위를 벗어날 수 있으므로 클리핑
            return Math.max(0.0, Math.min(1.0, prediction));

        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시, 중간값 반환
            return 0.5;
        }
    }

    /**
     * 다양성 보장 알고리즘
     */
    private List<RestaurantRecommendation> ensureDiversity(
            List<RestaurantRecommendation> recommendations, int limit) {

        List<RestaurantRecommendation> diversified = new ArrayList<>();
        Set<String> seenCategories = new HashSet<>();
        Set<String> seenLocations = new HashSet<>();

        // 1차: 높은 점수 + 다양성 우선
        for (RestaurantRecommendation rec : recommendations) {
            if (diversified.size() >= limit) break;

            Restaurant restaurant = rec.getRestaurant();
            String category = restaurant.getCategory();
            String location = restaurant.getLocation();

            // 카테고리와 지역 다양성 체크
            if (!seenCategories.contains(category) || !seenLocations.contains(location)) {
                diversified.add(rec);
                seenCategories.add(category);
                seenLocations.add(location);
            }
        }

        // 2차: 남은 슬롯을 높은 점수 순으로 채움
        for (RestaurantRecommendation rec : recommendations) {
            if (diversified.size() >= limit) break;
            if (!diversified.contains(rec)) {
                diversified.add(rec);
            }
        }

        return diversified;
    }

    // ========== Helper Methods ==========

    private Map<String, Double> createFeatureVector(int userId, Restaurant restaurant, UserBehaviorPattern pattern) {
        Map<String, Double> features = new HashMap<>();

        // 사용자 특성
        features.put("user_review_count", (double) pattern.getReviewPattern().getTotalReviews());
        features.put("user_avg_rating", pattern.getReviewPattern().getAverageRating());

        // 맛집 특성
        features.put("restaurant_rating", restaurant.getRating());
        features.put("restaurant_review_count", (double) restaurant.getReviewCount());
        features.put("restaurant_price_range", (double) restaurant.getPriceRange());

        // 기존 매칭 특성
        features.put("category_affinity", pattern.getCategoryAffinities().getOrDefault(restaurant.getCategory(), 0.0));
        features.put("location_affinity", pattern.getLocationAffinities().getOrDefault(restaurant.getLocation(), 0.0));

        // KoBERT 기반 '의미 유사도' 신규 피처 추가
        try {
            List<String> userReviews = recommendationDAO.findRecentPositiveReviewsByUserId(userId, 5);
            List<double[]> userVectors = userReviews.stream()
                .map(recommendationPort::getVectorFromText)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
            double[] userVector = calculateAverageVector(userVectors);

            double[] restaurantVector = recommendationDAO.getRestaurantContentVectorById(restaurant.getId());

            if (userVector != null && restaurantVector != null) {
                features.put("semantic_similarity", calculateCosineSimilarity(userVector, restaurantVector));
            } else {
                features.put("semantic_similarity", 0.0);
            }
        } catch (Exception e) {
            features.put("semantic_similarity", 0.0);
        }

        return features;
    }

    private double calculateLinearPrediction(Map<String, Double> features) {
        // 간단한 선형 회귀 가중치 (실제로는 학습된 모델 사용)
        Map<String, Double> weights = Map.of(
            "user_review_count", 0.1,
            "user_avg_rating", 0.2,
            "restaurant_rating", 0.3,
            "restaurant_review_count", 0.1,
            "restaurant_price_range", 0.05,
            "category_affinity", 0.15,
            "location_affinity", 0.1,
            "semantic_similarity", 0.35 // 의미 유사도에 높은 가중치 부여
        );

        double prediction = 0.0;
        for (Map.Entry<String, Double> feature : features.entrySet()) {
            double weight = weights.getOrDefault(feature.getKey(), 0.0);
            prediction += feature.getValue() * weight;
        }

        return prediction;
    }

    private void normalizeScore(RestaurantRecommendation rec) {
        double score = rec.getRecommendationScore();
        // 0-1 범위로 정규화
        rec.setRecommendationScore(Math.max(0.0, Math.min(1.0, score)));
    }

    private void logRecommendationMetrics(int userId, List<RestaurantRecommendation> recommendations) {
        try {
            // 추천 성능 메트릭 계산
            int recommendationCount = recommendations.size();
            double avgScore = recommendations.stream()
                .mapToDouble(RestaurantRecommendation::getRecommendationScore)
                .average().orElse(0.0);

            // 다양성 메트릭
            Set<String> categories = recommendations.stream()
                .map(rec -> rec.getRestaurant().getCategory())
                .collect(Collectors.toSet());
            int categoryDiversity = categories.size();

            // 메트릭 객체 생성
            RecommendationMetric metric = new RecommendationMetric(
                userId, recommendationCount, avgScore, categoryDiversity
            );

            // DB에 메트릭 저장
            int result = this.metricDAO.insertMetric(metric);

            if (result > 0 && metric.getId() > 0) {
                // 추천 항목 상세 저장
                metricDAO.insertRecommendationItems(metric.getId(), recommendations);
                System.out.println("추천 메트릭 저장 완료: userId=" + userId + ", metricId=" + metric.getId());
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("메트릭 저장 실패: " + e.getMessage());
        }
    }

    // =================================================================
    // 벡터 계산을 위한 헬퍼(Helper) 메소드들
    // =================================================================

    private double[] calculateAverageVector(List<double[]> vectors) {
        if (vectors == null || vectors.isEmpty()) return null;
        int vectorSize = vectors.get(0).length;
        double[] averageVector = new double[vectorSize];
        for (double[] vector : vectors) {
            for (int i = 0; i < vectorSize; i++) {
                averageVector[i] += vector[i];
            }
        }
        for (int i = 0; i < vectorSize; i++) {
            averageVector[i] /= vectors.size();
        }
        return averageVector;
    }

    private double calculateCosineSimilarity(double[] vecA, double[] vecB) {
        if (vecA == null || vecB == null || vecA.length != vecB.length) return 0.0;
        double dotProduct = 0.0;
        double normA = 0.0;
        double normB = 0.0;
        for (int i = 0; i < vecA.length; i++) {
            dotProduct += vecA[i] * vecB[i];
            normA += Math.pow(vecA[i], 2);
            normB += Math.pow(vecB[i], 2);
        }
        if (normA == 0 || normB == 0) return 0.0;
        return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
    }

    /**
     * 딥러닝(KoBERT) 기반 콘텐츠 추천
     * 사용자의 리뷰 취향과 맛집의 리뷰 콘텐츠 간의 의미적 유사도를 기반으로 추천합니다.
     */
    private List<RestaurantRecommendation> getDeepLearningContentRecommendations(
            int userId, UserBehaviorPattern pattern, int limit) {
        // 1. 사용자의 '취향 벡터' 생성 (최근 긍정 리뷰 기반)
        List<String> userPositiveReviews = recommendationDAO.findRecentPositiveReviewsByUserId(userId, 10);
        if (userPositiveReviews.isEmpty()) return new ArrayList<>();

        List<double[]> userReviewVectors = userPositiveReviews.stream()
                .map(recommendationPort::getVectorFromText) // ✨ 주입받은 포트를 통해 벡터 변환
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        double[] userPreferenceVector = calculateAverageVector(userReviewVectors);
        if (userPreferenceVector == null) return new ArrayList<>();

        // 2. (사전 계산된) 맛집들의 콘텐츠 벡터와 유사도 계산
        Map<Integer, double[]> restaurantContentVectors = recommendationDAO.getAllRestaurantContentVectors();

        // 3. 유사도 기반 추천 목록 생성
        return restaurantContentVectors.entrySet().stream()
            .map(entry -> {
                double similarity = calculateCosineSimilarity(userPreferenceVector, entry.getValue());
                Restaurant restaurant = recommendationDAO.getRestaurantById(entry.getKey());
                if (restaurant != null) {
                    return new RestaurantRecommendation(restaurant, similarity, "회원님의 리뷰 취향과 유사한 맛집");
                }
                return null;
            })
            .filter(Objects::nonNull)
            .filter(rec -> rec.getRecommendationScore() > 0.7) // 임계값은 실험을 통해 조정
            .sorted(Comparator.comparingDouble(RestaurantRecommendation::getRecommendationScore).reversed())
            .limit(limit)
            .collect(Collectors.toList());
    }

    // ========== Fallback and Default Methods ==========

    private List<RestaurantRecommendation> getFallbackIntelligentRecommendations(int userId, int limit) {
        // 기본 추천 시스템으로 폴백
        RecommendationService basicService = new RecommendationService();
        return basicService.getHybridRecommendations(userId, limit);
    }

    private UserBehaviorPattern getDefaultBehaviorPattern(int userId) {
        UserBehaviorPattern pattern = new UserBehaviorPattern();
        pattern.setUserId(userId);

        // 기본값 설정
        pattern.setCategoryAffinities(Map.of("한식", 0.3, "중식", 0.2, "일식", 0.2, "양식", 0.3));
        pattern.setLocationAffinities(Map.of("강남", 0.3, "홍대", 0.2, "이태원", 0.2, "명동", 0.3));
        pattern.setPreferredTimeSlots(List.of("점심", "저녁"));

        return pattern;
    }

    private TrendAnalysis getDefaultTrend() {
        TrendAnalysis trend = new TrendAnalysis();

        // 기본 트렌드 데이터
        trend.setTrendingCategories(Map.of("한식", 0.4, "일식", 0.3, "양식", 0.2, "중식", 0.1));
        trend.setRisingStars(new ArrayList<>());

        return trend;
    }

    // TODO: 다음 메서드들 구현 필요
    private List<String> extractTopTimeSlots(Map<String, Integer> timePatterns) { return new ArrayList<>(); }
    private Map<String, Double> calculateTrendingCategories(LocalDateTime start, LocalDateTime end) { return new HashMap<>(); }
    private List<Restaurant> findRisingStarRestaurants(LocalDateTime start, LocalDateTime end) { return new ArrayList<>(); }
    private Map<String, List<String>> analyzeLocationTrends(LocalDateTime start, LocalDateTime end) { return new HashMap<>(); }
    private Map<String, Map<String, Double>> analyzeTimeBasedTrends(LocalDateTime start, LocalDateTime end) { return new HashMap<>(); }
    private Map<String, Integer> analyzeSocialBuzz(LocalDateTime start, LocalDateTime end) { return new HashMap<>(); }
    private List<RestaurantRecommendation> getEnhancedCollaborativeRecommendations(int userId, UserBehaviorPattern pattern, int limit) { return new ArrayList<>(); }
    private List<RestaurantRecommendation> getBehaviorBasedRecommendations(UserBehaviorPattern pattern, int limit) { return new ArrayList<>(); }
    private List<RestaurantRecommendation> fuseRecommendations(List<RestaurantRecommendation> collab, List<RestaurantRecommendation> content, List<RestaurantRecommendation> behavior, int limit) { return new ArrayList<>(); }
    private List<RestaurantRecommendation> generateTrendBasedRecommendations(TrendAnalysis trend, UserBehaviorPattern pattern, int limit) { return new ArrayList<>(); }
}