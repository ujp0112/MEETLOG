package service;

import dao.RecommendationDAO;
import model.Restaurant;
import model.RestaurantRecommendation;
import model.SimilarUser;
import model.UserPreference;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 개인화 추천 시스템을 위한 서비스 클래스
 * 협업 필터링, 콘텐츠 기반 필터링, 하이브리드 추천을 제공합니다.
 */
public class RecommendationService {
    
    private RecommendationDAO recommendationDAO = new RecommendationDAO();

    /**
     * 사용자 취향 분석 및 저장
     */
    public void analyzeUserPreferences(int userId) {
        try {
            // 1. 사용자의 리뷰 패턴 분석
            List<Map<String, Object>> patterns = recommendationDAO.getUserReviewPatterns(userId);
            
            // 2. 각 패턴에 대해 선호도 점수 계산
            for (Map<String, Object> pattern : patterns) {
                String category = (String) pattern.get("category");
                Integer priceRange = (Integer) pattern.get("price_range");
                String atmosphere = (String) pattern.get("atmosphere");
                Double avgRating = ((Number) pattern.get("avg_rating")).doubleValue();
                Integer reviewCount = ((Number) pattern.get("review_count")).intValue();
                
                // 선호도 점수 계산 (평점과 리뷰 수를 고려)
                double preferenceScore = calculatePreferenceScore(avgRating, reviewCount);
                
                // 사용자 취향 데이터 저장
                UserPreference preference = new UserPreference(
                    userId, category, priceRange, atmosphere, preferenceScore
                );
                preference.setReviewCount(reviewCount);
                
                recommendationDAO.upsertUserPreference(preference);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("사용자 취향 분석 중 오류 발생: " + e.getMessage());
        }
    }

    /**
     * 협업 필터링 기반 추천
     */
    public List<RestaurantRecommendation> getCollaborativeRecommendations(int userId, int limit) {
        try {
            // 1. 비슷한 취향의 사용자들 찾기
            List<SimilarUser> similarUsers = recommendationDAO.findSimilarUsers(userId, 10);
            
            if (similarUsers.isEmpty()) {
                return getFallbackRecommendations(limit);
            }
            
            // 2. 비슷한 사용자들의 ID 추출
            List<Integer> similarUserIds = similarUsers.stream()
                .map(SimilarUser::getUserId)
                .collect(Collectors.toList());
            
            // 3. 비슷한 사용자들이 좋아한 맛집들 조회
            List<Restaurant> restaurants = recommendationDAO.getRestaurantsLikedBySimilarUsers(
                similarUserIds, userId, limit
            );
            
            // 4. 추천 결과 생성
            return restaurants.stream()
                .map(restaurant -> {
                    double score = calculateCollaborativeScore(restaurant, similarUsers);
                    String reason = "비슷한 취향의 사용자들이 좋아한 맛집";
                    return new RestaurantRecommendation(restaurant, score, reason);
                })
                .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            e.printStackTrace();
            return getFallbackRecommendations(limit);
        }
    }

    /**
     * 콘텐츠 기반 필터링 추천
     */
    public List<RestaurantRecommendation> getContentBasedRecommendations(int restaurantId, int limit) {
        try {
            // 1. 비슷한 특성을 가진 맛집들 찾기
            List<Restaurant> restaurants = recommendationDAO.findSimilarRestaurants(restaurantId, limit);
            
            // 2. 추천 결과 생성
            return restaurants.stream()
                .map(restaurant -> {
                    double score = calculateContentBasedScore(restaurantId, restaurant);
                    String reason = "비슷한 특성을 가진 맛집";
                    return new RestaurantRecommendation(restaurant, score, reason);
                })
                .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            e.printStackTrace();
            return getFallbackRecommendations(limit);
        }
    }

    /**
     * 하이브리드 추천 (협업 + 콘텐츠 기반)
     */
    public List<RestaurantRecommendation> getHybridRecommendations(int userId, int limit) {
        try {
            // 1. 협업 필터링 결과 (가중치 0.6)
            List<RestaurantRecommendation> collaborative = getCollaborativeRecommendations(userId, limit * 2);
            collaborative.forEach(rec -> rec.setRecommendationScore(rec.getRecommendationScore() * 0.6));
            
            // 2. 사용자 취향 기반 추천 (가중치 0.4)
            List<RestaurantRecommendation> preferenceBased = getPreferenceBasedRecommendations(userId, limit * 2);
            preferenceBased.forEach(rec -> rec.setRecommendationScore(rec.getRecommendationScore() * 0.4));
            
            // 3. 결과 합치기 및 중복 제거
            Map<Integer, RestaurantRecommendation> combined = new HashMap<>();
            
            collaborative.forEach(rec -> {
                int restaurantId = rec.getRestaurant().getId();
                if (combined.containsKey(restaurantId)) {
                    // 기존 점수와 합산
                    double newScore = combined.get(restaurantId).getRecommendationScore() + rec.getRecommendationScore();
                    combined.get(restaurantId).setRecommendationScore(newScore);
                } else {
                    combined.put(restaurantId, rec);
                }
            });
            
            preferenceBased.forEach(rec -> {
                int restaurantId = rec.getRestaurant().getId();
                if (combined.containsKey(restaurantId)) {
                    // 기존 점수와 합산
                    double newScore = combined.get(restaurantId).getRecommendationScore() + rec.getRecommendationScore();
                    combined.get(restaurantId).setRecommendationScore(newScore);
                } else {
                    combined.put(restaurantId, rec);
                }
            });
            
            // 4. 최종 결과 정렬 및 반환
            return combined.values().stream()
                .sorted((a, b) -> Double.compare(b.getRecommendationScore(), a.getRecommendationScore()))
                .limit(limit)
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            e.printStackTrace();
            return getFallbackRecommendations(limit);
        }
    }

    /**
     * 사용자 취향 기반 추천
     */
    public List<RestaurantRecommendation> getPreferenceBasedRecommendations(int userId, int limit) {
        try {
            // 1. 사용자 취향 조회
            List<UserPreference> preferences = recommendationDAO.getUserPreferences(userId);
            
            if (preferences.isEmpty()) {
                return getFallbackRecommendations(limit);
            }
            
            // 2. 가장 선호도가 높은 취향으로 맛집 검색
            UserPreference topPreference = preferences.get(0);
            List<Restaurant> restaurants = recommendationDAO.getRestaurantsByPreferences(topPreference, limit);
            
            // 3. 추천 결과 생성
            return restaurants.stream()
                .map(restaurant -> {
                    double score = topPreference.getPreferenceScore();
                    String reason = String.format("당신이 선호하는 %s 맛집", topPreference.getCategory());
                    return new RestaurantRecommendation(restaurant, score, reason);
                })
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            e.printStackTrace();
            return getFallbackRecommendations(limit);
        }
    }

    /**
     * 대체 추천 (인기 맛집)
     */
    public List<RestaurantRecommendation> getFallbackRecommendations(int limit) {
        try {
            List<Restaurant> restaurants = recommendationDAO.getPopularRestaurants(limit);
            return restaurants.stream()
                .map(restaurant -> {
                    double score = 0.5; // 기본 점수
                    String reason = "인기 맛집";
                    return new RestaurantRecommendation(restaurant, score, reason);
                })
                .collect(Collectors.toList());
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 선호도 점수 계산
     */
    private double calculatePreferenceScore(double avgRating, int reviewCount) {
        // 평점을 0-1 범위로 정규화 (1-5점 -> 0-1)
        double normalizedRating = (avgRating - 1) / 4.0;
        
        // 리뷰 수에 따른 가중치 (리뷰가 많을수록 신뢰도 높음)
        double reviewWeight = Math.min(reviewCount / 10.0, 1.0);
        
        // 최종 점수 = 정규화된 평점 * 리뷰 가중치
        return normalizedRating * reviewWeight;
    }

    /**
     * 협업 필터링 점수 계산
     */
    private double calculateCollaborativeScore(Restaurant restaurant, List<SimilarUser> similarUsers) {
        // 비슷한 사용자들의 평균 유사도 점수
        return similarUsers.stream()
            .mapToDouble(SimilarUser::getSimilarityScore)
            .average()
            .orElse(0.0);
    }

    /**
     * 콘텐츠 기반 점수 계산
     */
    private double calculateContentBasedScore(int originalRestaurantId, Restaurant targetRestaurant) {
        // 간단한 유사도 계산 (실제로는 더 복잡한 알고리즘 사용 가능)
        double score = 0.0;
        
        // 여기서는 기본적인 매칭 점수만 계산
        // 실제 구현에서는 더 정교한 유사도 계산이 필요
        score += 0.3; // 기본 점수
        
        return Math.min(score, 1.0);
    }
}
