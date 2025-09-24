package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.RestaurantRecommendation;
import model.User;
import model.UserPreferenceAnalysis;
import service.IntelligentRecommendationService;
import service.UserAnalyticsService;

@WebServlet("/api/recommendations/intelligent")
public class IntelligentRecommendationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IntelligentRecommendationService intelligentRecommendationService = new IntelligentRecommendationService();
    private UserAnalyticsService userAnalyticsService = new UserAnalyticsService();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            // 요청 파라미터 파싱
            String limitParam = request.getParameter("limit");
            String typeParam = request.getParameter("type");
            String locationParam = request.getParameter("location");
            String categoryParam = request.getParameter("category");

            int limit = limitParam != null ? Integer.parseInt(limitParam) : 10;
            String recommendationType = typeParam != null ? typeParam : "intelligent";

            // 지능형 추천 생성
            List<RestaurantRecommendation> recommendations = generateRecommendations(
                user.getId(), recommendationType, limit, locationParam, categoryParam
            );

            // 사용자 프로필 데이터 조회
            UserPreferenceAnalysis userProfile = userAnalyticsService.getUserPreferenceAnalysis(user.getId());

            // 추천 메타데이터 생성
            Map<String, Object> metadata = createRecommendationMetadata(recommendations, userProfile);

            // 성공 응답
            result.put("success", true);
            result.put("recommendations", recommendations);
            result.put("userProfile", userProfile);
            result.put("metadata", metadata);
            result.put("timestamp", System.currentTimeMillis());

            // 추천 로그 기록 (비동기)
            logRecommendationRequest(user.getId(), recommendationType, recommendations.size());

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "잘못된 파라미터입니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "추천 생성 중 오류가 발생했습니다: " + e.getMessage());
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

            switch (action) {
                case "feedback":
                    result = handleRecommendationFeedback(user.getId(), requestData);
                    break;
                case "refresh":
                    result = handleRecommendationRefresh(user.getId(), requestData);
                    break;
                case "analyze":
                    result = handleUserAnalysis(user.getId(), requestData);
                    break;
                default:
                    result.put("success", false);
                    result.put("message", "알 수 없는 액션입니다.");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "요청 처리 중 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }

    /**
     * 추천 타입에 따른 추천 생성
     */
    private List<RestaurantRecommendation> generateRecommendations(
            int userId, String type, int limit, String location, String category) {

        switch (type) {
            case "intelligent":
                return intelligentRecommendationService.getIntelligentRecommendations(userId, limit);
            case "trending":
                return generateTrendingRecommendations(userId, limit, location);
            case "personalized":
                return generatePersonalizedRecommendations(userId, limit, category);
            case "social":
                return generateSocialRecommendations(userId, limit);
            default:
                return intelligentRecommendationService.getIntelligentRecommendations(userId, limit);
        }
    }

    /**
     * 추천 메타데이터 생성
     */
    private Map<String, Object> createRecommendationMetadata(
            List<RestaurantRecommendation> recommendations, UserPreferenceAnalysis userProfile) {

        Map<String, Object> metadata = new HashMap<>();

        // 추천 다양성 점수
        double diversityScore = calculateDiversityScore(recommendations);
        metadata.put("diversityScore", diversityScore);

        // 알고리즘 분포
        Map<String, Long> algorithmDistribution = recommendations.stream()
            .collect(java.util.stream.Collectors.groupingBy(
                rec -> rec.getAlgorithmType() != null ? rec.getAlgorithmType() : "unknown",
                java.util.stream.Collectors.counting()
            ));
        metadata.put("algorithmDistribution", algorithmDistribution);

        // 평균 예측 평점
        double avgPredictedRating = recommendations.stream()
            .mapToDouble(RestaurantRecommendation::getPredictedRating)
            .average()
            .orElse(0.0);
        metadata.put("avgPredictedRating", avgPredictedRating);

        // 추천 세그먼트 정보
        metadata.put("userSegment", userProfile != null ? userProfile.getPersonalityType() : "unknown");
        metadata.put("topCategory", userProfile != null ? userProfile.getTopPreferredCategory() : "unknown");

        // 추천 세션 ID
        metadata.put("sessionId", UUID.randomUUID().toString());

        return metadata;
    }

    /**
     * 추천 피드백 처리
     */
    private Map<String, Object> handleRecommendationFeedback(int userId, Map<String, Object> requestData) {
        Map<String, Object> result = new HashMap<>();

        try {
            String recommendationId = (String) requestData.get("recommendationId");
            String feedbackType = (String) requestData.get("feedbackType"); // like, dislike, view, click
            Integer restaurantId = (Integer) requestData.get("restaurantId");

            // 피드백 데이터 저장 (학습용)
            saveFeedbackData(userId, recommendationId, feedbackType, restaurantId);

            // 실시간 모델 업데이트 (간단한 버전)
            updateUserPreferences(userId, restaurantId, feedbackType);

            result.put("success", true);
            result.put("message", "피드백이 성공적으로 처리되었습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "피드백 처리 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 추천 새로고침 처리
     */
    private Map<String, Object> handleRecommendationRefresh(int userId, Map<String, Object> requestData) {
        Map<String, Object> result = new HashMap<>();

        try {
            Integer limit = (Integer) requestData.getOrDefault("limit", 10);
            String type = (String) requestData.getOrDefault("type", "intelligent");

            // 새로운 추천 생성
            List<RestaurantRecommendation> recommendations = generateRecommendations(
                userId, type, limit, null, null
            );

            result.put("success", true);
            result.put("recommendations", recommendations);
            result.put("refreshedAt", System.currentTimeMillis());

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "추천 새로고침 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 사용자 분석 처리
     */
    private Map<String, Object> handleUserAnalysis(int userId, Map<String, Object> requestData) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 사용자 선호도 재분석
            UserPreferenceAnalysis analysis = userAnalyticsService.analyzeUserPreferences(userId);

            // 분석 결과와 인사이트 생성
            Map<String, Object> insights = generateUserInsights(analysis);

            result.put("success", true);
            result.put("analysis", analysis);
            result.put("insights", insights);
            result.put("analyzedAt", System.currentTimeMillis());

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "사용자 분석 중 오류가 발생했습니다.");
        }

        return result;
    }

    // ========== Helper Methods ==========

    private double calculateDiversityScore(List<RestaurantRecommendation> recommendations) {
        if (recommendations.isEmpty()) return 0.0;

        // 카테고리 다양성 계산
        long uniqueCategories = recommendations.stream()
            .map(rec -> rec.getRestaurant().getCategory())
            .distinct()
            .count();

        return (double) uniqueCategories / recommendations.size();
    }

    private void saveFeedbackData(int userId, String recommendationId, String feedbackType, Integer restaurantId) {
        // TODO: 피드백 데이터를 데이터베이스에 저장
        System.out.printf("피드백 저장: 사용자=%d, 추천=%s, 타입=%s, 맛집=%d%n",
            userId, recommendationId, feedbackType, restaurantId);
    }

    private void updateUserPreferences(int userId, Integer restaurantId, String feedbackType) {
        // TODO: 사용자 선호도 실시간 업데이트
        System.out.printf("선호도 업데이트: 사용자=%d, 맛집=%d, 피드백=%s%n",
            userId, restaurantId, feedbackType);
    }

    private void logRecommendationRequest(int userId, String type, int count) {
        // TODO: 추천 요청 로그 기록
        System.out.printf("추천 로그: 사용자=%d, 타입=%s, 개수=%d%n", userId, type, count);
    }

    private Map<String, Object> generateUserInsights(UserPreferenceAnalysis analysis) {
        Map<String, Object> insights = new HashMap<>();

        insights.put("personalityType", analysis.getPersonalityType());
        insights.put("topCategory", analysis.getTopPreferredCategory());
        insights.put("visitPattern", analysis.getVisitPatternInsight());
        insights.put("activityScore", analysis.getOverallActivityScore());

        return insights;
    }

    // TODO: 다음 메서드들 구현
    private List<RestaurantRecommendation> generateTrendingRecommendations(int userId, int limit, String location) {
        return intelligentRecommendationService.getIntelligentRecommendations(userId, limit);
    }

    private List<RestaurantRecommendation> generatePersonalizedRecommendations(int userId, int limit, String category) {
        return intelligentRecommendationService.getIntelligentRecommendations(userId, limit);
    }

    private List<RestaurantRecommendation> generateSocialRecommendations(int userId, int limit) {
        return intelligentRecommendationService.getIntelligentRecommendations(userId, limit);
    }
}