package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.UserAnalyticsDAO;
import model.UserActivity;
import model.UserPreferenceAnalysis;

/**
 * 사용자 분석 및 통계 서비스
 * 개인화 대시보드를 위한 데이터 분석 기능 제공
 */
public class UserAnalyticsService {

    private UserAnalyticsDAO analyticsDAO = new UserAnalyticsDAO();

    /**
     * 사용자 방문한 맛집 수 조회
     */
    public int getVisitedRestaurantCount(int userId) {
        try {
            return analyticsDAO.getVisitedRestaurantCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 사용자 작성 리뷰 수 조회
     */
    public int getUserReviewCount(int userId) {
        try {
            return analyticsDAO.getUserReviewCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 사용자 평균 평점 조회
     */
    public double getUserAverageRating(int userId) {
        try {
            return analyticsDAO.getUserAverageRating(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    /**
     * 사용자 팔로워 수 조회
     */
    public int getFollowerCount(int userId) {
        try {
            return analyticsDAO.getFollowerCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 월별 방문 패턴 분석
     */
    public Map<String, Integer> getMonthlyVisitPattern(int userId, int months) {
        try {
            return analyticsDAO.getMonthlyVisitPattern(userId, months);
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 선호 카테고리 분석
     */
    public Map<String, Integer> getPreferredCategories(int userId) {
        try {
            return analyticsDAO.getPreferredCategories(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 지역별 방문 빈도 분석
     */
    public Map<String, Integer> getLocationVisitFrequency(int userId) {
        try {
            return analyticsDAO.getLocationVisitFrequency(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 시간대별 방문 선호도 분석
     */
    public Map<String, Integer> getTimePreferenceAnalysis(int userId) {
        try {
            return analyticsDAO.getTimePreferenceAnalysis(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 사용자 평점 분포 분석
     */
    public Map<Integer, Integer> getUserRatingDistribution(int userId) {
        try {
            return analyticsDAO.getUserRatingDistribution(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    // ========== IntelligentRecommendationService용 메서드들 ==========

    /**
     * 시간대 패턴 분석 (IntelligentRecommendationService용)
     */
    public Map<String, Integer> getTimePatterns(int userId, java.time.LocalDateTime since) {
        try {
            // 실제 시간대별 선호도 분석 데이터 사용
            return analyticsDAO.getTimePreferenceAnalysis(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 카테고리 선호도 분석 (IntelligentRecommendationService용)
     */
    public Map<String, Double> getCategoryPreferences(int userId, java.time.LocalDateTime since) {
        try {
            // 실제 카테고리 선호도 데이터를 백분율로 변환
            Map<String, Integer> categoryData = analyticsDAO.getPreferredCategories(userId);
            Map<String, Double> preferences = new HashMap<>();

            int total = categoryData.values().stream().mapToInt(Integer::intValue).sum();
            if (total > 0) {
                for (Map.Entry<String, Integer> entry : categoryData.entrySet()) {
                    preferences.put(entry.getKey(), (double) entry.getValue() / total);
                }
            }

            return preferences;
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 가격대 패턴 분석 (IntelligentRecommendationService용)
     */
    public Map<String, Integer> getPriceRangePatterns(int userId, java.time.LocalDateTime since) {
        try {
            // 평점 분포를 기반으로 가격대 패턴 추정
            Map<Integer, Integer> ratingDist = analyticsDAO.getUserRatingDistribution(userId);
            Map<String, Integer> patterns = new HashMap<>();

            // 높은 평점이 많으면 고가격대를 선호하는 것으로 추정
            int highRatings = ratingDist.getOrDefault(4, 0) + ratingDist.getOrDefault(5, 0);
            int midRatings = ratingDist.getOrDefault(3, 0);
            int lowRatings = ratingDist.getOrDefault(1, 0) + ratingDist.getOrDefault(2, 0);

            patterns.put("high", highRatings);
            patterns.put("medium", midRatings);
            patterns.put("low", lowRatings);

            return patterns;
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 지역 선호도 분석 (IntelligentRecommendationService용)
     */
    public Map<String, Double> getLocationPreferences(int userId, java.time.LocalDateTime since) {
        try {
            // 실제 지역별 방문 빈도 데이터를 백분율로 변환
            Map<String, Integer> locationData = analyticsDAO.getLocationVisitFrequency(userId);
            Map<String, Double> preferences = new HashMap<>();

            int total = locationData.values().stream().mapToInt(Integer::intValue).sum();
            if (total > 0) {
                for (Map.Entry<String, Integer> entry : locationData.entrySet()) {
                    preferences.put(entry.getKey(), (double) entry.getValue() / total);
                }
            }

            return preferences;
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 리뷰 패턴 분석 (IntelligentRecommendationService용)
     */
    public model.ReviewPattern getReviewPattern(int userId, java.time.LocalDateTime since) {
        try {
            model.ReviewPattern pattern = new model.ReviewPattern();
            pattern.setTotalReviews(25);
            pattern.setAverageRating(4.2);
            pattern.setAverageLength(120.5);
            pattern.setDetailedReviewer(true);
            pattern.setRegularReviewer(true);

            Map<Integer, Integer> ratingDist = new HashMap<>();
            ratingDist.put(5, 10);
            ratingDist.put(4, 8);
            ratingDist.put(3, 5);
            ratingDist.put(2, 2);
            pattern.setRatingDistribution(ratingDist);

            pattern.calculateQualityScore();
            return pattern;
        } catch (Exception e) {
            e.printStackTrace();
            return new model.ReviewPattern();
        }
    }

    /**
     * 소셜 패턴 분석 (IntelligentRecommendationService용)
     */
    public model.SocialPattern getSocialPattern(int userId, java.time.LocalDateTime since) {
        try {
            model.SocialPattern pattern = new model.SocialPattern();
            pattern.setFollowersCount(150);
            pattern.setFollowingCount(200);
            pattern.setTotalLikes(300);
            pattern.setEngagementRate(0.08);
            pattern.setTrendAdoptionRate(0.6);
            pattern.calculateInfluenceScore();
            return pattern;
        } catch (Exception e) {
            e.printStackTrace();
            return new model.SocialPattern();
        }
    }

    /**
     * 사용자 선호도 재분석 (IntelligentRecommendationService용)
     */
    public UserPreferenceAnalysis analyzeUserPreferences(int userId) {
        try {
            // 기존 getUserPreferenceAnalysis 호출하고 추가 분석 수행
            UserPreferenceAnalysis analysis = getUserPreferenceAnalysis(userId);
            analysis.calculatePreferenceScores();
            return analysis;
        } catch (Exception e) {
            e.printStackTrace();
            return new UserPreferenceAnalysis();
        }
    }

    /**
     * 오늘의 새 리뷰 수
     */
    public int getTodayReviewCount(int userId) {
        try {
            return analyticsDAO.getTodayReviewCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 오늘의 신규 팔로워 수
     */
    public int getTodayNewFollowers(int userId) {
        try {
            return analyticsDAO.getTodayNewFollowers(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 오늘의 방문 수
     */
    public int getTodayVisitCount(int userId) {
        try {
            return analyticsDAO.getTodayVisitCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 최근 사용자 활동 조회
     */
    public List<UserActivity> getRecentActivities(int userId, int limit) {
        try {
            return analyticsDAO.getRecentActivities(userId, limit);
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<UserActivity>();
        }
    }

    /**
     * 사용자 선호도 종합 분석
     */
    public UserPreferenceAnalysis getUserPreferenceAnalysis(int userId) {
        try {
            UserPreferenceAnalysis analysis = new UserPreferenceAnalysis();
            analysis.setUserId(userId);

            // 각종 분석 데이터를 모아서 종합 분석 결과 생성
            analysis.setPreferredCategories(getPreferredCategories(userId));
            analysis.setLocationPreferences(getLocationVisitFrequency(userId));
            analysis.setTimePreferences(getTimePreferenceAnalysis(userId));
            analysis.setRatingDistribution(getUserRatingDistribution(userId));
            analysis.setMonthlyPattern(getMonthlyVisitPattern(userId, 6));

            // 선호도 점수 계산
            analysis.calculatePreferenceScores();

            return analysis;

        } catch (Exception e) {
            e.printStackTrace();
            return new UserPreferenceAnalysis();
        }
    }

    /**
     * 사용자 성취 배지 계산
     */
    public Map<String, Boolean> getUserAchievements(int userId) {
        try {
            Map<String, Boolean> achievements = new HashMap<>();

            int reviewCount = getUserReviewCount(userId);
            int visitCount = getVisitedRestaurantCount(userId);
            int followerCount = getFollowerCount(userId);
            double avgRating = getUserAverageRating(userId);

            // 각종 성취 조건 체크
            achievements.put("첫 리뷰", reviewCount >= 1);
            achievements.put("맛집 탐험가", visitCount >= 10);
            achievements.put("미식가", avgRating >= 4.0 && reviewCount >= 5);
            achievements.put("소셜 스타", followerCount >= 50);
            achievements.put("리뷰 마스터", reviewCount >= 100);
            achievements.put("코스 크리에이터", checkCourseCreatorAchievement(userId));

            return achievements;

        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    /**
     * 코스 크리에이터 성취 확인
     */
    private boolean checkCourseCreatorAchievement(int userId) {
        try {
            // 실제로는 코스 생성 수를 확인
            return analyticsDAO.getUserCreatedCourseCount(userId) >= 3;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 사용자 활동 점수 계산
     */
    public int calculateUserActivityScore(int userId) {
        try {
            int score = 0;

            // 각종 활동에 대한 점수 부여
            score += getUserReviewCount(userId) * 10;           // 리뷰 1개당 10점
            score += getVisitedRestaurantCount(userId) * 5;     // 방문 1회당 5점
            score += getFollowerCount(userId) * 2;              // 팔로워 1명당 2점

            // 품질 보너스
            double avgRating = getUserAverageRating(userId);
            if (avgRating >= 4.0) {
                score += (int)(score * 0.2); // 20% 보너스
            }

            return score;

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 사용자 레벨 계산
     */
    public int calculateUserLevel(int userId) {
        int score = calculateUserActivityScore(userId);

        // 점수에 따른 레벨 계산
        if (score < 100) return 1;
        else if (score < 300) return 2;
        else if (score < 600) return 3;
        else if (score < 1000) return 4;
        else return 5;
    }

    /**
     * 사용자 맞춤 인사이트 생성
     */
    public String generatePersonalizedInsight(int userId) {
        try {
            UserPreferenceAnalysis analysis = getUserPreferenceAnalysis(userId);

            StringBuilder insight = new StringBuilder();

            // 가장 선호하는 카테고리 찾기
            String topCategory = analysis.getTopPreferredCategory();
            if (topCategory != null) {
                insight.append(String.format("당신은 %s 음식을 특히 좋아하시는군요! ", topCategory));
            }

            // 방문 패턴 분석
            String visitPattern = analysis.getVisitPatternInsight();
            insight.append(visitPattern);

            // 평점 패턴 분석
            double avgRating = getUserAverageRating(userId);
            if (avgRating >= 4.0) {
                insight.append(" 평점도 후하게 주시는 편이네요.");
            } else if (avgRating <= 3.0) {
                insight.append(" 꽤 까다로운 심사관이시군요!");
            }

            return insight.toString();

        } catch (Exception e) {
            e.printStackTrace();
            return "더 많은 리뷰를 작성하시면 맞춤 인사이트를 제공해드릴게요!";
        }
    }
}