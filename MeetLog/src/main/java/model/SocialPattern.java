package model;

import java.util.List;
import java.util.Map;

/**
 * 소셜 활동 패턴 모델
 * 사용자의 소셜 네트워크 활동과 영향력을 분석
 */
public class SocialPattern {
    private int followersCount;         // 팔로워 수
    private int followingCount;         // 팔로잉 수
    private int totalLikes;             // 총 좋아요 수
    private int totalShares;            // 총 공유 수
    private double engagementRate;      // 참여율
    private double influenceScore;      // 영향력 점수
    private boolean isInfluencer;       // 인플루언서 여부

    // 소셜 활동 지표
    private Map<String, Integer> activityByPlatform;    // 플랫폼별 활동량
    private List<String> frequentHashtags;              // 자주 사용하는 해시태그
    private Map<String, Double> networkClusters;        // 네트워크 클러스터 (관심사별)
    private double viralityScore;                       // 바이럴 점수
    private double trendAdoptionRate;                   // 트렌드 수용율

    // 소셜 관계 데이터
    private List<Integer> closeConnections;             // 긴밀한 연결 관계
    private Map<String, Integer> interactionPatterns;   // 상호작용 패턴
    private double reciprocityRate;                     // 상호 관계율

    // 기본 생성자
    public SocialPattern() {}

    // 영향력 점수 계산
    public void calculateInfluenceScore() {
        double score = 0.0;

        // 팔로워 수 기반 점수 (최대 0.3)
        score += Math.min(followersCount / 1000.0, 0.3);

        // 참여율 기반 점수 (최대 0.4)
        score += Math.min(engagementRate, 0.4);

        // 바이럴 점수 (최대 0.2)
        score += Math.min(viralityScore, 0.2);

        // 네트워크 다양성 (최대 0.1)
        if (networkClusters != null && networkClusters.size() >= 3) {
            score += 0.1;
        }

        this.influenceScore = Math.min(score, 1.0);

        // 인플루언서 판정
        this.isInfluencer = (influenceScore >= 0.7 && followersCount >= 500 && engagementRate >= 0.05);
    }

    // 소셜 타입 판정
    public String getSocialType() {
        if (isInfluencer) {
            return "인플루언서";
        } else if (followersCount >= 200 && engagementRate >= 0.03) {
            return "활발한 소셜러";
        } else if (engagementRate >= 0.05) {
            return "참여형 사용자";
        } else if (followingCount > followersCount * 2) {
            return "팔로워형 사용자";
        } else {
            return "일반 사용자";
        }
    }

    // 트렌드 민감도 계산
    public double getTrendSensitivity() {
        double sensitivity = 0.0;

        // 트렌드 수용률 (최대 0.4)
        sensitivity += Math.min(trendAdoptionRate, 0.4);

        // 해시태그 다양성 (최대 0.3)
        if (frequentHashtags != null && frequentHashtags.size() >= 5) {
            sensitivity += 0.3;
        } else if (frequentHashtags != null && frequentHashtags.size() >= 2) {
            sensitivity += 0.15;
        }

        // 플랫폼 다양성 (최대 0.2)
        if (activityByPlatform != null && activityByPlatform.size() >= 3) {
            sensitivity += 0.2;
        } else if (activityByPlatform != null && activityByPlatform.size() >= 2) {
            sensitivity += 0.1;
        }

        // 바이럴 점수 반영 (최대 0.1)
        sensitivity += Math.min(viralityScore * 0.1, 0.1);

        return Math.min(sensitivity, 1.0);
    }

    // 소셜 신뢰도 계산
    public double getSocialCredibility() {
        double credibility = 0.0;

        // 팔로워/팔로잉 비율 (균형잡힌 관계가 높은 점수)
        double followerRatio = followersCount > 0 ? (double) followingCount / followersCount : 0;
        if (followerRatio >= 0.3 && followerRatio <= 3.0) {
            credibility += 0.3;
        }

        // 상호 관계율 (최대 0.3)
        credibility += Math.min(reciprocityRate, 0.3);

        // 참여율 (최대 0.2)
        credibility += Math.min(engagementRate, 0.2);

        // 활동 지속성 (최대 0.2)
        if (activityByPlatform != null && !activityByPlatform.isEmpty()) {
            double avgActivity = activityByPlatform.values().stream()
                    .mapToInt(Integer::intValue)
                    .average()
                    .orElse(0.0);
            credibility += Math.min(avgActivity / 100.0, 0.2);
        }

        return Math.min(credibility, 1.0);
    }

    // Getters and Setters
    public int getFollowersCount() {
        return followersCount;
    }

    public void setFollowersCount(int followersCount) {
        this.followersCount = followersCount;
    }

    public int getFollowingCount() {
        return followingCount;
    }

    public void setFollowingCount(int followingCount) {
        this.followingCount = followingCount;
    }

    public int getTotalLikes() {
        return totalLikes;
    }

    public void setTotalLikes(int totalLikes) {
        this.totalLikes = totalLikes;
    }

    public int getTotalShares() {
        return totalShares;
    }

    public void setTotalShares(int totalShares) {
        this.totalShares = totalShares;
    }

    public double getEngagementRate() {
        return engagementRate;
    }

    public void setEngagementRate(double engagementRate) {
        this.engagementRate = engagementRate;
    }

    public double getInfluenceScore() {
        return influenceScore;
    }

    public void setInfluenceScore(double influenceScore) {
        this.influenceScore = influenceScore;
    }

    public boolean isInfluencer() {
        return isInfluencer;
    }

    public void setInfluencer(boolean influencer) {
        isInfluencer = influencer;
    }

    public Map<String, Integer> getActivityByPlatform() {
        return activityByPlatform;
    }

    public void setActivityByPlatform(Map<String, Integer> activityByPlatform) {
        this.activityByPlatform = activityByPlatform;
    }

    public List<String> getFrequentHashtags() {
        return frequentHashtags;
    }

    public void setFrequentHashtags(List<String> frequentHashtags) {
        this.frequentHashtags = frequentHashtags;
    }

    public Map<String, Double> getNetworkClusters() {
        return networkClusters;
    }

    public void setNetworkClusters(Map<String, Double> networkClusters) {
        this.networkClusters = networkClusters;
    }

    public double getViralityScore() {
        return viralityScore;
    }

    public void setViralityScore(double viralityScore) {
        this.viralityScore = viralityScore;
    }

    public double getTrendAdoptionRate() {
        return trendAdoptionRate;
    }

    public void setTrendAdoptionRate(double trendAdoptionRate) {
        this.trendAdoptionRate = trendAdoptionRate;
    }

    public List<Integer> getCloseConnections() {
        return closeConnections;
    }

    public void setCloseConnections(List<Integer> closeConnections) {
        this.closeConnections = closeConnections;
    }

    public Map<String, Integer> getInteractionPatterns() {
        return interactionPatterns;
    }

    public void setInteractionPatterns(Map<String, Integer> interactionPatterns) {
        this.interactionPatterns = interactionPatterns;
    }

    public double getReciprocityRate() {
        return reciprocityRate;
    }

    public void setReciprocityRate(double reciprocityRate) {
        this.reciprocityRate = reciprocityRate;
    }

    @Override
    public String toString() {
        return "SocialPattern{" +
                "followersCount=" + followersCount +
                ", followingCount=" + followingCount +
                ", engagementRate=" + engagementRate +
                ", influenceScore=" + influenceScore +
                ", isInfluencer=" + isInfluencer +
                ", socialType='" + getSocialType() + '\'' +
                '}';
    }
}