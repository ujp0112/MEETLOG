package service;

import java.util.List;
import model.BusinessQnA;
import dao.BusinessQnADAO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

public class BusinessQnAService {
    private BusinessQnADAO qnaDAO = new BusinessQnADAO();

    /**
     * 사업자별 Q&A 조회
     */
    public List<BusinessQnA> getQnAByOwnerId(int ownerId) {
        try {
            return qnaDAO.findByOwnerId(ownerId);
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * 음식점별 Q&A 조회
     */
    public List<BusinessQnA> getQnAByRestaurantId(int restaurantId) {
        try {
            return qnaDAO.findByRestaurantId(restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Q&A 등록
     */
    public boolean addQnA(BusinessQnA qna) {
        try {
            return qnaDAO.insert(qna) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Q&A 답변 업데이트 (자동 트랜잭션)
     */
    public boolean updateQnAAnswer(int qnaId, String answer) {
        try {
            return qnaDAO.updateAnswer(qnaId, answer) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Q&A 답변 업데이트 (트랜잭션 포함)
     */
    public boolean updateQnAAnswer(int qnaId, String answer, SqlSession session) {
        try {
            return qnaDAO.updateAnswer(qnaId, answer, session) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Q&A 상태 업데이트
     */
    public boolean updateQnAStatus(int qnaId, boolean isActive) {
        try {
            return qnaDAO.updateStatus(qnaId, isActive) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Q&A 상태 업데이트 (트랜잭션 포함)
     */
    public boolean updateQnAStatus(int qnaId, String status, SqlSession session) {
        try {
            return qnaDAO.updateStatus(qnaId, status, session) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Q&A 삭제 (소프트 삭제)
     */
    public boolean deleteQnA(int qnaId) {
        try {
            return qnaDAO.delete(qnaId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Q&A 삭제 (트랜잭션 포함)
     */
    public boolean deleteQnA(int qnaId, SqlSession session) {
        try {
            return qnaDAO.delete(qnaId, session) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
