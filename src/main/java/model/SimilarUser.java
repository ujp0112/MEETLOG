package model;

/**
 * 비슷한 취향의 사용자 정보를 담는 모델 클래스
 * 협업 필터링에서 사용됩니다.
 */
public class SimilarUser {
    private int userId;
    private String nickname;
    private double similarityScore; // 0.0 ~ 1.0 (유사도 점수)
    private int commonReviews; // 공통 리뷰 수
    private double averageRatingDifference; // 평균 평점 차이

    public SimilarUser() {
    }

    public SimilarUser(int userId, String nickname, double similarityScore) {
        this.userId = userId;
        this.nickname = nickname;
        this.similarityScore = similarityScore;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public double getSimilarityScore() {
        return similarityScore;
    }

    public void setSimilarityScore(double similarityScore) {
        this.similarityScore = similarityScore;
    }

    public int getCommonReviews() {
        return commonReviews;
    }

    public void setCommonReviews(int commonReviews) {
        this.commonReviews = commonReviews;
    }

    public double getAverageRatingDifference() {
        return averageRatingDifference;
    }

    public void setAverageRatingDifference(double averageRatingDifference) {
        this.averageRatingDifference = averageRatingDifference;
    }
}
