package model;

import java.util.Map;

/**
 * 리뷰 작성 패턴 모델
 * 사용자의 리뷰 작성 습관과 패턴을 분석
 */
public class ReviewPattern {
    private int totalReviews;           // 총 리뷰 수
    private double averageRating;       // 평균 평점
    private double averageLength;       // 평균 리뷰 길이
    private Map<Integer, Integer> ratingDistribution;  // 평점별 분포 (1~5점)
    private Map<String, Integer> reviewFrequency;      // 리뷰 빈도 (월별)
    private Map<String, Double> sentimentScores;       // 감정 점수 (긍정/부정/중립)
    private boolean isDetailedReviewer;                // 상세 리뷰어 여부
    private boolean isRegularReviewer;                 // 정기 리뷰어 여부
    private double reviewQualityScore;                 // 리뷰 품질 점수

    // 리뷰 특성
    private boolean usesPhotos;         // 사진 첨부 여부
    private boolean providesDetails;    // 상세 정보 제공 여부
    private boolean followsTrends;      // 트렌드 반영 여부

    // 기본 생성자
    public ReviewPattern() {}

    // 리뷰 품질 점수 계산
    public void calculateQualityScore() {
        double score = 0.0;

        // 리뷰 수 기반 점수 (많을수록 높음, 최대 0.3)
        score += Math.min(totalReviews / 100.0, 0.3);

        // 평균 길이 기반 점수 (적당한 길이가 좋음, 최대 0.2)
        if (averageLength >= 50 && averageLength <= 300) {
            score += 0.2;
        } else if (averageLength >= 30) {
            score += 0.1;
        }

        // 평점 분포의 다양성 (최대 0.2)
        if (ratingDistribution != null && ratingDistribution.size() >= 3) {
            score += 0.2;
        }

        // 정기성 (최대 0.15)
        if (isRegularReviewer) {
            score += 0.15;
        }

        // 상세도 (최대 0.15)
        if (providesDetails) {
            score += 0.15;
        }

        this.reviewQualityScore = Math.min(score, 1.0);
    }

    // 리뷰어 타입 판정
    public String getReviewerType() {
        if (totalReviews >= 50 && isDetailedReviewer && reviewQualityScore >= 0.7) {
            return "전문 리뷰어";
        } else if (totalReviews >= 20 && isRegularReviewer) {
            return "활발한 리뷰어";
        } else if (isDetailedReviewer && averageLength >= 100) {
            return "상세 리뷰어";
        } else if (totalReviews >= 10) {
            return "일반 리뷰어";
        } else {
            return "초보 리뷰어";
        }
    }

    // 리뷰 신뢰도 계산
    public double getReviewReliability() {
        double reliability = 0.0;

        // 리뷰 수 기반 신뢰도
        reliability += Math.min(totalReviews / 50.0, 0.4);

        // 평점 분산도 (너무 편향되지 않은 평점 분포)
        if (ratingDistribution != null) {
            double variance = calculateRatingVariance();
            if (variance > 0.5 && variance < 2.0) { // 적당한 분산
                reliability += 0.3;
            }
        }

        // 정기성
        if (isRegularReviewer) {
            reliability += 0.2;
        }

        // 품질 점수
        reliability += reviewQualityScore * 0.1;

        return Math.min(reliability, 1.0);
    }

    // 평점 분산 계산
    private double calculateRatingVariance() {
        if (ratingDistribution == null || ratingDistribution.isEmpty()) {
            return 0.0;
        }

        double mean = averageRating;
        double variance = 0.0;
        int totalCount = ratingDistribution.values().stream().mapToInt(Integer::intValue).sum();

        for (Map.Entry<Integer, Integer> entry : ratingDistribution.entrySet()) {
            int rating = entry.getKey();
            int count = entry.getValue();
            double probability = (double) count / totalCount;
            variance += probability * Math.pow(rating - mean, 2);
        }

        return variance;
    }

    // Getters and Setters
    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public double getAverageLength() {
        return averageLength;
    }

    public void setAverageLength(double averageLength) {
        this.averageLength = averageLength;
    }

    public Map<Integer, Integer> getRatingDistribution() {
        return ratingDistribution;
    }

    public void setRatingDistribution(Map<Integer, Integer> ratingDistribution) {
        this.ratingDistribution = ratingDistribution;
    }

    public Map<String, Integer> getReviewFrequency() {
        return reviewFrequency;
    }

    public void setReviewFrequency(Map<String, Integer> reviewFrequency) {
        this.reviewFrequency = reviewFrequency;
    }

    public Map<String, Double> getSentimentScores() {
        return sentimentScores;
    }

    public void setSentimentScores(Map<String, Double> sentimentScores) {
        this.sentimentScores = sentimentScores;
    }

    public boolean isDetailedReviewer() {
        return isDetailedReviewer;
    }

    public void setDetailedReviewer(boolean detailedReviewer) {
        isDetailedReviewer = detailedReviewer;
    }

    public boolean isRegularReviewer() {
        return isRegularReviewer;
    }

    public void setRegularReviewer(boolean regularReviewer) {
        isRegularReviewer = regularReviewer;
    }

    public double getReviewQualityScore() {
        return reviewQualityScore;
    }

    public void setReviewQualityScore(double reviewQualityScore) {
        this.reviewQualityScore = reviewQualityScore;
    }

    public boolean isUsesPhotos() {
        return usesPhotos;
    }

    public void setUsesPhotos(boolean usesPhotos) {
        this.usesPhotos = usesPhotos;
    }

    public boolean isProvidesDetails() {
        return providesDetails;
    }

    public void setProvidesDetails(boolean providesDetails) {
        this.providesDetails = providesDetails;
    }

    public boolean isFollowsTrends() {
        return followsTrends;
    }

    public void setFollowsTrends(boolean followsTrends) {
        this.followsTrends = followsTrends;
    }

    @Override
    public String toString() {
        return "ReviewPattern{" +
                "totalReviews=" + totalReviews +
                ", averageRating=" + averageRating +
                ", averageLength=" + averageLength +
                ", reviewQualityScore=" + reviewQualityScore +
                ", reviewerType='" + getReviewerType() + '\'' +
                '}';
    }
}