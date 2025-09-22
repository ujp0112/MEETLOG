package dao;

import model.ReviewStatistics;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class ReviewStatisticsDAO {
    private static final String NAMESPACE = "dao.ReviewStatisticsDAO";
    
    /**
     * 사업자별 리뷰 통계 조회
     */
    public ReviewStatistics getReviewStatisticsByOwnerId(int ownerId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getReviewStatisticsByOwnerId", ownerId);
        }
    }
    
    /**
     * 평점별 리뷰 개수 조회
     */
    public Map<Integer, Integer> getRatingDistributionByOwnerId(int ownerId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectMap(NAMESPACE + ".getRatingDistributionByOwnerId", ownerId, "rating");
        }
    }
    
    /**
     * 월별 리뷰 개수 조회
     */
    public List<Map<String, Object>> getMonthlyReviewCountByOwnerId(int ownerId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".getMonthlyReviewCountByOwnerId", ownerId);
        }
    }
    
    /**
     * 최근 리뷰 트렌드 조회
     */
    public List<Map<String, Object>> getRecentReviewTrendByOwnerId(int ownerId, int days) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of("ownerId", ownerId, "days", days);
            return sqlSession.selectList(NAMESPACE + ".getRecentReviewTrendByOwnerId", params);
        }
    }
}
