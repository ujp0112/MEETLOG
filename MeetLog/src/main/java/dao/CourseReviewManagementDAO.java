package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import model.AdminCourseReview;
import util.MyBatisSqlSessionFactory;

public class CourseReviewManagementDAO {
    private static final String NAMESPACE = "mapper.CourseReviewManagementMapper.";

    /**
     * 관리자용 모든 코스 리뷰 목록을 DB에서 조회합니다.
     * @return AdminCourseReview 목록
     */
    public List<AdminCourseReview> selectAllReviewsForAdmin() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + "selectAllReviewsForAdmin");
        }
    }
    
    /**
     * 특정 리뷰에 대한 답변을 DB에 추가/수정합니다.
     * @param reviewId 수정할 리뷰 ID
     * @param responseContent 추가/수정할 답변 내용
     */
    public void updateReviewResponse(int reviewId, String responseContent) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", reviewId);
            params.put("responseContent", responseContent);
            session.update(NAMESPACE + "updateReviewResponse", params);
        }
    }
    
    /**
     * 리뷰를 DB에서 삭제합니다.
     * @param reviewId 삭제할 리뷰 ID
     */
    public void deleteReview(int reviewId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.delete(NAMESPACE + "deleteReview", reviewId);
        }
    }
}