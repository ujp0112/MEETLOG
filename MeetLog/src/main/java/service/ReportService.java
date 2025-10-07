package service;

import dao.ReportDAO;
import dao.ReviewDAO;
import model.Report;
import model.Review;

/**
 * 신고 관련 비즈니스 로직을 담당합니다.
 */
public class ReportService {
    private static final String REVIEW_TYPE = "REVIEW";

    private final ReportDAO reportDAO = new ReportDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    /**
     * 리뷰 신고를 접수합니다.
     *
     * @param reporterId 신고자 사용자 ID
     * @param reviewId   신고 대상 리뷰 ID
     * @param reason     신고 사유 (500자 이내)
     */
    public void submitReviewReport(int reporterId, int reviewId, String reason) {
        if (reportDAO.existsReport(reporterId, REVIEW_TYPE, reviewId)) {
            throw new IllegalStateException("이미 신고한 리뷰입니다.");
        }

        Review targetReview = reviewDAO.findById(reviewId);
        if (targetReview == null) {
            throw new IllegalArgumentException("리뷰를 찾을 수 없습니다.");
        }

        if (targetReview.getUserId() == reporterId) {
            throw new IllegalArgumentException("자신의 리뷰는 신고할 수 없습니다.");
        }

        Report report = new Report();
        report.setReporterId(reporterId);
        report.setReportedType(REVIEW_TYPE);
        report.setReportedId(reviewId);
        report.setReportedUserId(targetReview.getUserId());
        report.setReason(reason);
        report.setStatus("PENDING");

        reportDAO.insertReport(report);
    }
}

