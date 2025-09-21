package service;

import java.util.List;
import dao.QnADAO;
import model.QnA;

public class QnAService {
    private QnADAO qnaDAO = new QnADAO();
    
    /**
     * 맛집별 Q&A 조회 (메서드 이름 수정: getQnAByRestaurantId -> getQnAsByRestaurantId)
     */
    public List<QnA> getQnAsByRestaurantId(int restaurantId) {
        try {
            return qnaDAO.findByRestaurantId(restaurantId);
        } catch (Exception e) {
            System.err.println("맛집별 Q&A 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public List<QnA> getAllActiveQnA() {
        try {
            return qnaDAO.findAllActive();
        } catch (Exception e) {
            System.err.println("활성 Q&A 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean addQnA(QnA qna) {
        try {
            int result = qnaDAO.insertQnA(qna);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Q&A 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateQnA(QnA qna) {
        try {
            int result = qnaDAO.updateQnA(qna);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Q&A 수정 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteQnA(int qnaId) {
        try {
            int result = qnaDAO.deleteQnA(qnaId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Q&A 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}