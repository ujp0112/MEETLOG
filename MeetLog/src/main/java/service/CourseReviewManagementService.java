package service;

import java.util.List;
import dao.CourseReviewManagementDAO;
import model.AdminCourseReview;

public class CourseReviewManagementService {
    private CourseReviewManagementDAO reviewDAO = new CourseReviewManagementDAO();

    /**
     * 관리자 페이지의 모든 코스 리뷰 목록을 가져옵니다.
     * @return AdminCourseReview 목록
     */
    public List<AdminCourseReview> getAllReviewsForAdmin() {
        return reviewDAO.selectAllReviewsForAdmin();
    }
    
    /**
     * 특정 리뷰에 관리자 답변을 추가하거나 수정합니다.
     * @param reviewId 답변을 추가할 리뷰 ID
     * @param responseContent 관리자 답변 내용
     */
    public void addOrUpdateResponse(int reviewId, String responseContent) {
        reviewDAO.updateReviewResponse(reviewId, responseContent);
    }
    
    /**
     * ID에 해당하는 리뷰를 삭제합니다.
     * @param reviewId 삭제할 리뷰 ID
     */
    public void deleteReview(int reviewId) {
        reviewDAO.deleteReview(reviewId);
    }
}