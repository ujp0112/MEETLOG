package service;

import dao.AdminStatisticsDAO;
import dao.RecommendationDAO;
import model.*;
import service.port.RecommendationPort; // ✨ 구체 클래스가 아닌 '포트(인터페이스)'를 import
import service.UserVectorService;

import dto.RestaurantPopularity;

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
    private final UserVectorService userVectorService = UserVectorService.getInstance();

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
            double[] userVector = userVectorService.getOrComputeVector(userId);
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
        // 1. 사용자의 '취향 벡터' 생성 (캐시 기반)
        double[] userPreferenceVector = userVectorService.getOrComputeVector(userId);
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

    private List<String> extractTopTimeSlots(Map<String, Integer> timePatterns) {
        if (timePatterns == null || timePatterns.isEmpty()) {
            return List.of("점심", "저녁");
        }

        return timePatterns.entrySet().stream()
            .sorted((a, b) -> Integer.compare(b.getValue(), a.getValue()))
            .limit(3)
            .map(Map.Entry::getKey)
            .collect(Collectors.toList());
    }

    private Map<String, Double> calculateTrendingCategories(LocalDateTime start, LocalDateTime end) {
        Map<String, Double> scores = new HashMap<>();

        try {
            List<Restaurant> recent = Optional.ofNullable(recommendationDAO.getRecentRestaurants(60)).orElse(List.of());
            List<Restaurant> popular = Optional.ofNullable(recommendationDAO.getPopularRestaurants(60)).orElse(List.of());

            for (Restaurant restaurant : recent) {
                if (restaurant == null || restaurant.getCategory() == null) continue;
                double baseScore = 1.2;
                baseScore += Math.min(Math.max(restaurant.getRating(), 0.0), 5.0) / 5.0;
                baseScore += Math.min(Math.max(restaurant.getReviewCount(), 0), 200) / 200.0;
                scores.merge(restaurant.getCategory(), baseScore, Double::sum);
            }

            for (Restaurant restaurant : popular) {
                if (restaurant == null || restaurant.getCategory() == null) continue;
                double baseScore = 1.0;
                baseScore += Math.min(Math.max(restaurant.getRating(), 0.0), 5.0) / 6.0;
                scores.merge(restaurant.getCategory(), baseScore, Double::sum);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (scores.isEmpty()) {
            return Map.of(
                "한식", 0.4,
                "일식", 0.3,
                "양식", 0.2,
                "중식", 0.1
            );
        }

        double maxScore = scores.values().stream().mapToDouble(Double::doubleValue).max().orElse(1.0);
        return scores.entrySet().stream()
            .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
            .collect(Collectors.toMap(
                Map.Entry::getKey,
                entry -> Math.max(0.05, Math.min(1.0, entry.getValue() / maxScore)),
                (a, b) -> a,
                LinkedHashMap::new
            ));
    }

    private List<Restaurant> findRisingStarRestaurants(LocalDateTime start, LocalDateTime end) {
        Set<Integer> seen = new HashSet<>();
        List<Restaurant> rising = new ArrayList<>();

        try {
            AdminStatisticsDAO statisticsDAO = new AdminStatisticsDAO();
            List<RestaurantPopularity> topThisWeek = statisticsDAO.getTopRestaurantsThisWeek(15);

            if (topThisWeek != null) {
                for (RestaurantPopularity popularity : topThisWeek) {
                    if (popularity == null) continue;
                    int restaurantId = popularity.getRestaurantId();
                    if (seen.contains(restaurantId)) continue;

                    Restaurant restaurant = recommendationDAO.getRestaurantById(restaurantId);
                    if (restaurant != null) {
                        double growth = popularity.getReservationGrowthRate() != null
                            ? popularity.getReservationGrowthRate().doubleValue()
                            : 0.0;
                        double rating = popularity.getRating() != null ? popularity.getRating().doubleValue() : restaurant.getRating();

                        if (growth > 0.1 || rating >= 4.0) {
                            rising.add(restaurant);
                            seen.add(restaurantId);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (rising.size() < 10) {
            List<Restaurant> recent = Optional.ofNullable(recommendationDAO.getRecentRestaurants(20)).orElse(List.of());
            for (Restaurant restaurant : recent) {
                if (restaurant == null || seen.contains(restaurant.getId())) continue;
                if (restaurant.getReviewCount() > 10 && restaurant.getRating() >= 4.2) {
                    rising.add(restaurant);
                    seen.add(restaurant.getId());
                }
                if (rising.size() >= 10) break;
            }
        }

        return rising;
    }

    private Map<String, List<String>> analyzeLocationTrends(LocalDateTime start, LocalDateTime end) {
        Map<String, Map<String, Integer>> counts = new HashMap<>();

        List<Restaurant> candidates = new ArrayList<>();
        candidates.addAll(Optional.ofNullable(recommendationDAO.getPopularRestaurants(80)).orElse(List.of()));
        candidates.addAll(Optional.ofNullable(recommendationDAO.getRecentRestaurants(80)).orElse(List.of()));

        for (Restaurant restaurant : candidates) {
            if (restaurant == null) continue;
            String location = Optional.ofNullable(restaurant.getLocation()).orElse("기타");
            String category = Optional.ofNullable(restaurant.getCategory()).orElse("기타");

            counts.computeIfAbsent(location, key -> new HashMap<>())
                .merge(category, 1, Integer::sum);
        }

        Map<String, List<String>> result = new HashMap<>();
        for (Map.Entry<String, Map<String, Integer>> entry : counts.entrySet()) {
            List<String> topCategories = entry.getValue().entrySet().stream()
                .sorted((a, b) -> Integer.compare(b.getValue(), a.getValue()))
                .limit(5)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
            result.put(entry.getKey(), topCategories);
        }

        return result;
    }

    private Map<String, Map<String, Double>> analyzeTimeBasedTrends(LocalDateTime start, LocalDateTime end) {
        Map<String, Double> trendingCategories = calculateTrendingCategories(start, end);
        if (trendingCategories.isEmpty()) {
            return new HashMap<>();
        }

        Map<String, Map<String, Double>> timeTrends = new LinkedHashMap<>();
        Map<String, Double> slotWeights = Map.of(
            "아침", 0.6,
            "브런치", 0.75,
            "점심", 1.0,
            "저녁", 1.0,
            "야식", 0.8
        );

        for (Map.Entry<String, Double> slot : slotWeights.entrySet()) {
            double slotMultiplier = slot.getValue();
            Map<String, Double> categoryScores = new LinkedHashMap<>();

            int index = 0;
            for (Map.Entry<String, Double> categoryEntry : trendingCategories.entrySet()) {
                double decay = 1.0 - (index * 0.08);
                double score = categoryEntry.getValue() * slotMultiplier * Math.max(decay, 0.5);
                categoryScores.put(categoryEntry.getKey(), Math.max(0.05, Math.min(1.0, score)));
                index++;
                if (index >= 5) break;
            }

            timeTrends.put(slot.getKey(), categoryScores);
        }

        return timeTrends;
    }

    private Map<String, Integer> analyzeSocialBuzz(LocalDateTime start, LocalDateTime end) {
        Map<String, Double> trendingCategories = calculateTrendingCategories(start, end);
        List<Restaurant> risingStars = findRisingStarRestaurants(start, end);

        Map<String, Integer> buzz = new LinkedHashMap<>();
        int baseWeight = 500;
        int index = 0;
        for (Map.Entry<String, Double> entry : trendingCategories.entrySet()) {
            int weight = (int) Math.round(baseWeight * entry.getValue() * (1 - index * 0.1));
            buzz.put("#" + entry.getKey(), Math.max(80, weight));
            index++;
            if (index >= 6) break;
        }

        int restaurantWeight = 400;
        for (Restaurant restaurant : risingStars) {
            if (restaurant == null || restaurant.getName() == null) continue;
            buzz.put(restaurant.getName(), Math.max(60, restaurantWeight));
            restaurantWeight = Math.max(80, restaurantWeight - 40);
        }

        buzz.putIfAbsent("#미식기행", 120);
        buzz.putIfAbsent("#신상맛집", 140);

        return buzz;
    }

    private List<RestaurantRecommendation> getEnhancedCollaborativeRecommendations(int userId, UserBehaviorPattern pattern, int limit) {
        List<SimilarUser> similarUsers = Optional.ofNullable(recommendationDAO.findSimilarUsers(userId, Math.max(limit * 3, 12))).orElse(List.of());
        if (similarUsers.isEmpty()) {
            return new ArrayList<>();
        }

        List<Integer> similarUserIds = similarUsers.stream()
            .map(SimilarUser::getUserId)
            .distinct()
            .collect(Collectors.toList());

        List<Restaurant> restaurants = Optional.ofNullable(
            recommendationDAO.getRestaurantsLikedBySimilarUsers(similarUserIds, userId, Math.max(limit * 3, 30))
        ).orElse(List.of());

        if (restaurants.isEmpty()) {
            return new ArrayList<>();
        }

        double maxSimilarity = similarUsers.stream().mapToDouble(SimilarUser::getSimilarityScore).max().orElse(1.0);
        double averageSimilarityBoost = similarUsers.stream()
            .filter(user -> user.getSimilarityScore() > 0 && user.getCommonReviews() > 0)
            .mapToDouble(user -> user.getSimilarityScore() / maxSimilarity)
            .average()
            .orElse(0.6);
        Map<String, Double> categoryAffinity = pattern != null && pattern.getCategoryAffinities() != null
            ? pattern.getCategoryAffinities()
            : Map.of();
        Map<String, Double> locationAffinity = pattern != null && pattern.getLocationAffinities() != null
            ? pattern.getLocationAffinities()
            : Map.of();

        Map<Integer, RestaurantRecommendation> aggregated = new LinkedHashMap<>();

        for (Restaurant restaurant : restaurants) {
            if (restaurant == null) continue;

            double similarityBoost = averageSimilarityBoost;

            double categoryScore = categoryAffinity.getOrDefault(restaurant.getCategory(), 0.2);
            double locationScore = locationAffinity.getOrDefault(restaurant.getLocation(), 0.1);
            double ratingScore = Math.min(Math.max(restaurant.getRating(), 0.0), 5.0) / 5.0;

            double finalScore = (similarityBoost * 0.45) + (ratingScore * 0.3) + (categoryScore * 0.15) + (locationScore * 0.1);
            finalScore = Math.max(0.1, Math.min(1.0, finalScore));

            RestaurantRecommendation recommendation = new RestaurantRecommendation();
            recommendation.setRestaurant(restaurant);
            recommendation.setRecommendationScore(finalScore);
            recommendation.setPredictedRating(Math.max(restaurant.getRating(), 4.0));
            recommendation.setPersonalized(true);

            List<String> factors = new ArrayList<>();
            factors.add("비슷한 회원 추천");
            if (categoryAffinity.containsKey(restaurant.getCategory())) {
                factors.add("선호 카테고리 일치");
            }
            if (locationAffinity.containsKey(restaurant.getLocation())) {
                factors.add("선호 지역 일치");
            }
            recommendation.setMatchingFactors(factors);

            String reason = String.format("비슷한 취향의 회원들이 자주 찾은 맛집 (예상 평점 %.1f)", recommendation.getPredictedRating());
            recommendation.setReason(reason);

            aggregated.put(restaurant.getId(), recommendation);
        }

        return aggregated.values().stream()
            .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    private List<RestaurantRecommendation> getBehaviorBasedRecommendations(UserBehaviorPattern pattern, int limit) {
        if (pattern == null) {
            return new ArrayList<>();
        }

        Map<String, Double> categoryAffinity = Optional.ofNullable(pattern.getCategoryAffinities()).orElse(Map.of());
        Map<String, Double> locationAffinity = Optional.ofNullable(pattern.getLocationAffinities()).orElse(Map.of());
        Map<String, Integer> pricePreference = Optional.ofNullable(pattern.getPreferredPriceRanges()).orElse(Map.of());

        List<UserPreference> storedPreferences = Optional.ofNullable(
            recommendationDAO.getUserPreferences(pattern.getUserId())
        ).orElse(List.of());

        Map<Integer, RestaurantRecommendation> aggregated = new LinkedHashMap<>();

        for (UserPreference preference : storedPreferences) {
            if (preference == null) continue;
            List<Restaurant> matchedRestaurants = Optional.ofNullable(
                recommendationDAO.getRestaurantsByPreferences(preference, Math.max(limit, 10))
            ).orElse(List.of());

            for (Restaurant restaurant : matchedRestaurants) {
                if (restaurant == null) continue;

                double categoryScore = categoryAffinity.getOrDefault(restaurant.getCategory(), 0.2);
                double locationScore = locationAffinity.getOrDefault(restaurant.getLocation(), 0.2);
                double priceScore = pricePreference.isEmpty() ? 0.15 : pricePreference.entrySet().stream()
                    .filter(entry -> entry.getKey().equalsIgnoreCase("high") && restaurant.getPriceRange() >= 4
                        || entry.getKey().equalsIgnoreCase("medium") && restaurant.getPriceRange() == 3
                        || entry.getKey().equalsIgnoreCase("low") && restaurant.getPriceRange() <= 2)
                    .mapToDouble(entry -> Math.min(entry.getValue() / 10.0, 0.3)).sum();

                double preferenceScore = Math.max(preference.getPreferenceScore(), 0.3);
                double finalScore = (preferenceScore * 0.4) + (categoryScore * 0.3) + (locationScore * 0.2) + (priceScore * 0.1);
                finalScore = Math.max(0.05, Math.min(1.0, finalScore));

                RestaurantRecommendation recommendation = aggregated.computeIfAbsent(restaurant.getId(), id -> {
                    RestaurantRecommendation rec = new RestaurantRecommendation();
                    rec.setRestaurant(restaurant);
                    rec.setMatchingFactors(new ArrayList<>());
                    rec.setPredictedRating(Math.max(restaurant.getRating(), 3.8));
                    rec.setPersonalized(true);
                    return rec;
                });

                recommendation.setRecommendationScore(Math.max(recommendation.getRecommendationScore(), finalScore));

                List<String> factors = recommendation.getMatchingFactors();
                if (!factors.contains("사용자 선호 패턴")) {
                    factors.add("사용자 선호 패턴");
                }
                if (categoryAffinity.containsKey(restaurant.getCategory()) && !factors.contains("카테고리 선호 일치")) {
                    factors.add("카테고리 선호 일치");
                }
                if (locationAffinity.containsKey(restaurant.getLocation()) && !factors.contains("지역 선호 일치")) {
                    factors.add("지역 선호 일치");
                }

                recommendation.setReason("회원님의 행동 패턴과 가장 잘 맞는 맛집");
            }
        }

        if (aggregated.size() < limit) {
            List<Restaurant> fallback = Optional.ofNullable(recommendationDAO.getUnvisitedRestaurants(pattern.getUserId(), limit * 2)).orElse(List.of());
            for (Restaurant restaurant : fallback) {
                if (restaurant == null || aggregated.containsKey(restaurant.getId())) continue;

                double categoryScore = categoryAffinity.getOrDefault(restaurant.getCategory(), 0.3);
                double locationScore = locationAffinity.getOrDefault(restaurant.getLocation(), 0.2);
                double finalScore = Math.max(0.1, Math.min(1.0, (categoryScore * 0.6) + (locationScore * 0.4)));

                RestaurantRecommendation recommendation = new RestaurantRecommendation();
                recommendation.setRestaurant(restaurant);
                recommendation.setRecommendationScore(finalScore);
                recommendation.setPersonalized(true);
                recommendation.setPredictedRating(Math.max(restaurant.getRating(), 3.7));
                recommendation.setMatchingFactors(new ArrayList<>(List.of("새로운 탐험 후보")));
                recommendation.setReason("선호 지역/카테고리에 기반한 새로운 탐험지");

                aggregated.put(restaurant.getId(), recommendation);
                if (aggregated.size() >= limit) break;
            }
        }

        return aggregated.values().stream()
            .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    private List<RestaurantRecommendation> fuseRecommendations(List<RestaurantRecommendation> collab, List<RestaurantRecommendation> content, List<RestaurantRecommendation> behavior, int limit) {
        Map<Integer, RestaurantRecommendation> fused = new LinkedHashMap<>();

        java.util.function.BiConsumer<List<RestaurantRecommendation>, Double> mergeSource = (sourceList, weight) -> {
            if (sourceList == null) return;
            for (RestaurantRecommendation source : sourceList) {
                if (source == null || source.getRestaurant() == null) continue;

                int restaurantId = source.getRestaurant().getId();
                double weightedScore = Math.max(0.0, Math.min(1.0, source.getRecommendationScore())) * weight;

                RestaurantRecommendation aggregated = fused.computeIfAbsent(restaurantId, id -> {
                    RestaurantRecommendation copy = new RestaurantRecommendation();
                    copy.setRestaurant(source.getRestaurant());
                    copy.setMatchingFactors(new ArrayList<>());
                    copy.setPersonalized(source.isPersonalized());
                    copy.setPredictedRating(source.getPredictedRating());
                    copy.setReason(source.getReason() != null ? source.getReason() : "추천");
                    return copy;
                });

                aggregated.setRecommendationScore(
                    Math.min(1.2, aggregated.getRecommendationScore() + weightedScore)
                );

                if (source.getPredictedRating() > aggregated.getPredictedRating()) {
                    aggregated.setPredictedRating(source.getPredictedRating());
                }

                if (source.getMatchingFactors() != null) {
                    List<String> factors = aggregated.getMatchingFactors();
                    for (String factor : source.getMatchingFactors()) {
                        if (factor != null && !factors.contains(factor)) {
                            factors.add(factor);
                        }
                    }
                }

                if (source.getReason() != null && !aggregated.getReason().contains(source.getReason())) {
                    aggregated.setReason(aggregated.getReason() + " + " + source.getReason());
                }
            }
        };

        mergeSource.accept(collab, 0.45);
        mergeSource.accept(content, 0.35);
        mergeSource.accept(behavior, 0.25);

        return fused.values().stream()
            .peek(this::normalizeScore)
            .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    private List<RestaurantRecommendation> generateTrendBasedRecommendations(TrendAnalysis trend, UserBehaviorPattern pattern, int limit) {
        if (trend == null) {
            return new ArrayList<>();
        }

        Map<String, Double> trendingCategories = Optional.ofNullable(trend.getTrendingCategories()).orElse(calculateTrendingCategories(LocalDateTime.now().minusDays(7), LocalDateTime.now()));
        Map<String, Map<String, Double>> timeTrends = Optional.ofNullable(trend.getTimeBasedTrends()).orElse(analyzeTimeBasedTrends(LocalDateTime.now().minusDays(7), LocalDateTime.now()));
        Map<String, Integer> socialBuzz = Optional.ofNullable(trend.getSocialBuzz()).orElse(analyzeSocialBuzz(LocalDateTime.now().minusDays(7), LocalDateTime.now()));

        Map<String, Double> categoryAffinity = pattern != null && pattern.getCategoryAffinities() != null
            ? pattern.getCategoryAffinities()
            : Map.of();
        Map<String, Double> locationAffinity = pattern != null && pattern.getLocationAffinities() != null
            ? pattern.getLocationAffinities()
            : Map.of();
        List<String> preferredTimeSlots = pattern != null && pattern.getPreferredTimeSlots() != null
            ? pattern.getPreferredTimeSlots()
            : List.of();

        List<Restaurant> candidates = new ArrayList<>();
        candidates.addAll(Optional.ofNullable(trend.getRisingStars()).orElse(List.of()));
        candidates.addAll(Optional.ofNullable(recommendationDAO.getPopularRestaurants(limit * 3)).orElse(List.of()));

        Map<Integer, RestaurantRecommendation> aggregated = new LinkedHashMap<>();
        double maxBuzz = socialBuzz.values().stream().mapToInt(Integer::intValue).max().orElse(200);

        for (Restaurant restaurant : candidates) {
            if (restaurant == null || restaurant.getCategory() == null) continue;

            double categoryTrendScore = trendingCategories.getOrDefault(restaurant.getCategory(), 0.2);
            double locationTrendScore = 0.0;
            if (trend.getLocationTrends() != null) {
                List<String> locationCategories = trend.getLocationTrends().getOrDefault(restaurant.getLocation(), List.of());
                if (locationCategories.contains(restaurant.getCategory())) {
                    locationTrendScore = 0.6 / (locationCategories.indexOf(restaurant.getCategory()) + 1);
                }
            }

            double timeTrendScore = 0.0;
            for (String timeSlot : preferredTimeSlots) {
                Map<String, Double> slotData = timeTrends.get(timeSlot);
                if (slotData != null) {
                    timeTrendScore = Math.max(timeTrendScore, slotData.getOrDefault(restaurant.getCategory(), 0.0));
                }
            }

            double socialScore = socialBuzz.entrySet().stream()
                .filter(entry -> entry.getKey().contains(restaurant.getName()) || entry.getKey().contains(restaurant.getCategory()))
                .mapToDouble(entry -> entry.getValue() / (double) maxBuzz)
                .max().orElse(0.0);

            double userAffinity = Math.max(categoryAffinity.getOrDefault(restaurant.getCategory(), 0.15),
                locationAffinity.getOrDefault(restaurant.getLocation(), 0.1));

            double trendSensitivity = pattern != null ? Math.max(pattern.getTrendSensitivity(), 0.2) : 0.3;

            double finalScore = (categoryTrendScore * 0.45)
                + (locationTrendScore * 0.15)
                + (timeTrendScore * 0.1)
                + (socialScore * 0.1)
                + (userAffinity * 0.15)
                + (trendSensitivity * 0.05);

            finalScore = Math.max(0.05, Math.min(1.0, finalScore));

            RestaurantRecommendation recommendation = aggregated.computeIfAbsent(restaurant.getId(), id -> {
                RestaurantRecommendation rec = new RestaurantRecommendation();
                rec.setRestaurant(restaurant);
                rec.setMatchingFactors(new ArrayList<>());
                return rec;
            });

            recommendation.setRecommendationScore(Math.max(recommendation.getRecommendationScore(), finalScore));
            recommendation.setPredictedRating(Math.max(restaurant.getRating(), 4.1));

            List<String> factors = recommendation.getMatchingFactors();
            if (!factors.contains("실시간 트렌드")) {
                factors.add("실시간 트렌드");
            }
            if (preferredTimeSlots.isEmpty()) {
                factors.add("시간대 인기 반영");
            } else {
                for (String slot : preferredTimeSlots) {
                    if (!factors.contains(slot + " 추천")) {
                        factors.add(slot + " 추천");
                    }
                }
            }

            StringBuilder reason = new StringBuilder("이번 주 트렌드 기반 추천");
            if (categoryTrendScore > 0.5) {
                reason.append(" + 인기 카테고리");
            }
            if (locationTrendScore > 0.3) {
                reason.append(" + 지역 트렌드");
            }
            if (userAffinity > 0.2) {
                reason.append(" + 선호도 반영");
            }
            recommendation.setReason(reason.toString());
        }

        return aggregated.values().stream()
            .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
            .limit(limit)
            .collect(Collectors.toList());
    }
}
