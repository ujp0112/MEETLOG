package model;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 실시간 트렌드 분석 모델
 * 현재 인기 카테고리, 급상승 맛집, 지역별 트렌드 등을 분석
 */
public class TrendAnalysis {
    private Map<String, Double> trendingCategories;              // 인기 카테고리 (카테고리명 -> 트렌드 점수)
    private List<Restaurant> risingStars;                        // 급상승 맛집 목록
    private Map<String, List<String>> locationTrends;           // 지역별 트렌드 (지역 -> 인기 카테고리 목록)
    private Map<String, Map<String, Double>> timeBasedTrends;   // 시간대별 트렌드 (시간대 -> 카테고리별 인기도)
    private Map<String, Integer> socialBuzz;                    // 소셜 미디어 버즈 (키워드 -> 언급 횟수)
    private LocalDateTime analysisTime;                         // 분석 시점
    private double overallTrendScore;                           // 전체 트렌드 점수

    // 트렌드 세부 지표
    private TrendMetrics weeklyMetrics;      // 주간 트렌드 지표
    private TrendMetrics monthlyMetrics;     // 월간 트렌드 지표
    private List<TrendEvent> recentEvents;   // 최근 트렌드 이벤트

    // 기본 생성자
    public TrendAnalysis() {
        this.analysisTime = LocalDateTime.now();
    }

    // 매개변수 생성자
    public TrendAnalysis(LocalDateTime analysisTime) {
        this.analysisTime = analysisTime;
    }

    // 트렌드 점수 계산 메서드
    public double calculateTrendScore(String category, String location) {
        double categoryScore = trendingCategories.getOrDefault(category, 0.0);
        double locationScore = 0.0;

        if (locationTrends.containsKey(location)) {
            List<String> locationCategories = locationTrends.get(location);
            if (locationCategories.contains(category)) {
                locationScore = 1.0 / (locationCategories.indexOf(category) + 1); // 순위 기반 점수
            }
        }

        return (categoryScore * 0.7) + (locationScore * 0.3);
    }

    // 시간대별 트렌드 점수 조회
    public double getTimeBasedTrendScore(String timeSlot, String category) {
        if (timeBasedTrends.containsKey(timeSlot)) {
            return timeBasedTrends.get(timeSlot).getOrDefault(category, 0.0);
        }
        return 0.0;
    }

    // 소셜 버즈 점수 조회
    public int getSocialBuzzScore(String keyword) {
        return socialBuzz.getOrDefault(keyword.toLowerCase(), 0);
    }

    // 급상승 맛집 여부 확인
    public boolean isRisingStar(int restaurantId) {
        return risingStars.stream()
                .anyMatch(restaurant -> restaurant.getId() == restaurantId);
    }

    // Getters and Setters
    public Map<String, Double> getTrendingCategories() {
        return trendingCategories;
    }

    public void setTrendingCategories(Map<String, Double> trendingCategories) {
        this.trendingCategories = trendingCategories;
    }

    public List<Restaurant> getRisingStars() {
        return risingStars;
    }

    public void setRisingStars(List<Restaurant> risingStars) {
        this.risingStars = risingStars;
    }

    public Map<String, List<String>> getLocationTrends() {
        return locationTrends;
    }

    public void setLocationTrends(Map<String, List<String>> locationTrends) {
        this.locationTrends = locationTrends;
    }

    public Map<String, Map<String, Double>> getTimeBasedTrends() {
        return timeBasedTrends;
    }

    public void setTimeBasedTrends(Map<String, Map<String, Double>> timeBasedTrends) {
        this.timeBasedTrends = timeBasedTrends;
    }

    public Map<String, Integer> getSocialBuzz() {
        return socialBuzz;
    }

    public void setSocialBuzz(Map<String, Integer> socialBuzz) {
        this.socialBuzz = socialBuzz;
    }

    public LocalDateTime getAnalysisTime() {
        return analysisTime;
    }

    public void setAnalysisTime(LocalDateTime analysisTime) {
        this.analysisTime = analysisTime;
    }

    public double getOverallTrendScore() {
        return overallTrendScore;
    }

    public void setOverallTrendScore(double overallTrendScore) {
        this.overallTrendScore = overallTrendScore;
    }

    public TrendMetrics getWeeklyMetrics() {
        return weeklyMetrics;
    }

    public void setWeeklyMetrics(TrendMetrics weeklyMetrics) {
        this.weeklyMetrics = weeklyMetrics;
    }

    public TrendMetrics getMonthlyMetrics() {
        return monthlyMetrics;
    }

    public void setMonthlyMetrics(TrendMetrics monthlyMetrics) {
        this.monthlyMetrics = monthlyMetrics;
    }

    public List<TrendEvent> getRecentEvents() {
        return recentEvents;
    }

    public void setRecentEvents(List<TrendEvent> recentEvents) {
        this.recentEvents = recentEvents;
    }

    @Override
    public String toString() {
        return "TrendAnalysis{" +
                "analysisTime=" + analysisTime +
                ", overallTrendScore=" + overallTrendScore +
                ", risingStarsCount=" + (risingStars != null ? risingStars.size() : 0) +
                ", trendingCategoriesCount=" + (trendingCategories != null ? trendingCategories.size() : 0) +
                '}';
    }

    // 내부 클래스들
    public static class TrendMetrics {
        private double growthRate;
        private double volatility;
        private int totalEngagement;
        private Map<String, Double> categoryGrowth;

        // 생성자, getter, setter 생략...
        public double getGrowthRate() { return growthRate; }
        public void setGrowthRate(double growthRate) { this.growthRate = growthRate; }
        public double getVolatility() { return volatility; }
        public void setVolatility(double volatility) { this.volatility = volatility; }
        public int getTotalEngagement() { return totalEngagement; }
        public void setTotalEngagement(int totalEngagement) { this.totalEngagement = totalEngagement; }
        public Map<String, Double> getCategoryGrowth() { return categoryGrowth; }
        public void setCategoryGrowth(Map<String, Double> categoryGrowth) { this.categoryGrowth = categoryGrowth; }
    }

    public static class TrendEvent {
        private String eventType;
        private String description;
        private LocalDateTime timestamp;
        private double impact;

        // 생성자, getter, setter 생략...
        public String getEventType() { return eventType; }
        public void setEventType(String eventType) { this.eventType = eventType; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public LocalDateTime getTimestamp() { return timestamp; }
        public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
        public double getImpact() { return impact; }
        public void setImpact(double impact) { this.impact = impact; }
    }
}