package service;

import dao.ReviewStatisticsDAO;
import model.ReviewStatistics;
import java.util.List;
import java.util.Map;

public class ReviewStatisticsService {
    private ReviewStatisticsDAO reviewStatisticsDAO = new ReviewStatisticsDAO();
    
    /**
     * 사업자별 리뷰 통계 조회
     */
    public ReviewStatistics getReviewStatisticsByOwnerId(int ownerId) {
        return reviewStatisticsDAO.getReviewStatisticsByOwnerId(ownerId);
    }
    
    /**
     * 평점별 리뷰 개수 조회
     */
    public Map<Integer, Integer> getRatingDistributionByOwnerId(int ownerId) {
        return reviewStatisticsDAO.getRatingDistributionByOwnerId(ownerId);
    }
    
    /**
     * 월별 리뷰 개수 조회
     */
    public List<Map<String, Object>> getMonthlyReviewCountByOwnerId(int ownerId) {
        return reviewStatisticsDAO.getMonthlyReviewCountByOwnerId(ownerId);
    }
    
    /**
     * 최근 리뷰 트렌드 조회
     */
    public List<Map<String, Object>> getRecentReviewTrendByOwnerId(int ownerId, int days) {
        return reviewStatisticsDAO.getRecentReviewTrendByOwnerId(ownerId, days);
    }
}
