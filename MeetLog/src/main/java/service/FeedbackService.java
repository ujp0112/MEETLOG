package service;

import dao.FeedbackDAO;
import model.Feedback;

import java.util.List;

public class FeedbackService {
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    public List<Feedback> getAllFeedbacks() {
        return feedbackDAO.findAll();
    }

    public Feedback getFeedbackById(int id) {
        return feedbackDAO.findById(id);
    }

    public List<Feedback> getFeedbacksByRating(int rating) {
        return feedbackDAO.findByRating(rating);
    }

    public boolean createFeedback(Feedback feedback) {
        try {
            return feedbackDAO.insert(feedback) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Feedback 생성 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFeedback(int id) {
        try {
            return feedbackDAO.delete(id) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Feedback 삭제 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalFeedbackCount() {
        try {
            return feedbackDAO.countTotal();
        } catch (Exception e) {
            System.out.println("ERROR: Feedback 총 개수 조회 실패 - " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public double getAverageRating() {
        try {
            return feedbackDAO.getAverageRating();
        } catch (Exception e) {
            System.out.println("ERROR: Feedback 평균 평점 조회 실패 - " + e.getMessage());
            e.printStackTrace();
            return 0.0;
        }
    }
}