package dao;

import model.RecommendationMetric;
import model.RestaurantRecommendation;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RecommendationMetricDAO {
    private static final String NAMESPACE = "dao.RecommendationMetricDAO";

    /**
     * 추천 메트릭 저장
     */
    public int insertMetric(RecommendationMetric metric) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(NAMESPACE + ".insertMetric", metric);
            session.commit();
            return result;
        }
    }

    /**
     * 추천 항목 저장
     */
    public int insertRecommendationItems(int metricId, List<RestaurantRecommendation> recommendations) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("metricId", metricId);
            params.put("recommendations", recommendations);

            int result = session.insert(NAMESPACE + ".insertRecommendationItems", params);
            session.commit();
            return result;
        }
    }

    /**
     * 사용자별 메트릭 조회
     */
    public List<RecommendationMetric> findMetricsByUserId(int userId, int limit) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("limit", limit);

            return session.selectList(NAMESPACE + ".findMetricsByUserId", params);
        }
    }

    /**
     * 최근 메트릭 통계 조회
     */
    public Map<String, Object> getRecentMetricsStats(int userId, int days) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("days", days);

            return session.selectOne(NAMESPACE + ".getRecentMetricsStats", params);
        }
    }
}