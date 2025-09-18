package dao;

import model.Restaurant;
import model.RestaurantRecommendation;
import model.SimilarUser;
import model.UserPreference;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

/**
 * 추천 시스템을 위한 DAO 클래스
 * 협업 필터링, 콘텐츠 기반 필터링, 하이브리드 추천을 지원합니다.
 */
public class RecommendationDAO {
    private static final String NAMESPACE = "dao.RecommendationDAO";

    /**
     * 사용자 취향 분석 데이터 저장/업데이트
     */
    public int upsertUserPreference(UserPreference preference) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".upsertUserPreference", preference);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 사용자의 취향 분석 데이터 조회
     */
    public List<UserPreference> getUserPreferences(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getUserPreferences", userId);
        }
    }

    /**
     * 비슷한 취향의 사용자들 찾기 (협업 필터링)
     */
    public List<SimilarUser> findSimilarUsers(int userId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit);
            return sqlSession.selectList(NAMESPACE + ".findSimilarUsers", params);
        }
    }

    /**
     * 비슷한 사용자들이 좋아한 맛집들 조회
     */
    public List<Restaurant> getRestaurantsLikedBySimilarUsers(List<Integer> similarUserIds, int currentUserId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                "similarUserIds", similarUserIds,
                "currentUserId", currentUserId,
                "limit", limit
            );
            return sqlSession.selectList(NAMESPACE + ".getRestaurantsLikedBySimilarUsers", params);
        }
    }

    /**
     * 콘텐츠 기반 필터링: 비슷한 특성을 가진 맛집들 찾기
     */
    public List<Restaurant> findSimilarRestaurants(int restaurantId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("restaurantId", restaurantId, "limit", limit);
            return sqlSession.selectList(NAMESPACE + ".findSimilarRestaurants", params);
        }
    }

    /**
     * 사용자가 아직 방문하지 않은 맛집들 조회
     */
    public List<Restaurant> getUnvisitedRestaurants(int userId, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("userId", userId, "limit", limit);
            return sqlSession.selectList(NAMESPACE + ".getUnvisitedRestaurants", params);
        }
    }

    /**
     * 사용자 취향에 맞는 맛집들 조회 (카테고리, 가격대, 분위기 기반)
     */
    public List<Restaurant> getRestaurantsByPreferences(UserPreference preference, int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                "category", preference.getCategory(),
                "priceRange", preference.getPriceRange(),
                "atmosphere", preference.getAtmosphere(),
                "limit", limit
            );
            return sqlSession.selectList(NAMESPACE + ".getRestaurantsByPreferences", params);
        }
    }

    /**
     * 인기 맛집 조회 (전체 사용자 기준)
     */
    public List<Restaurant> getPopularRestaurants(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getPopularRestaurants", limit);
        }
    }

    /**
     * 최신 맛집 조회
     */
    public List<Restaurant> getRecentRestaurants(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getRecentRestaurants", limit);
        }
    }

    /**
     * 사용자의 리뷰 패턴 분석을 위한 데이터 조회
     */
    public List<Map<String, Object>> getUserReviewPatterns(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getUserReviewPatterns", userId);
        }
    }

    /**
     * 맛집 유사도 계산을 위한 데이터 조회
     */
    public List<Map<String, Object>> getRestaurantSimilarityData(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getRestaurantSimilarityData", restaurantId);
        }
    }
}
