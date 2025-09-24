package service;

import java.util.List;
import model.BusinessQnA;
import dao.BusinessQnADAO;
import util.MyBatisSqlSessionFactory;
// import org.apache.ibatis.session.SqlSession;

public class BusinessQnAService {
    private BusinessQnADAO qnaDAO = new BusinessQnADAO();
    
    /**
     * 사업자별 Q&A 조회
     */
    public List<BusinessQnA> getQnAByOwnerId(int ownerId) {
        return qnaDAO.findByOwnerId(ownerId);
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
     * Q&A 답변 업데이트 (트랜잭션 포함)
     */
    public boolean updateQnAAnswer(int qnaId, String answer, Object sqlSession) {
        try {
            return qnaDAO.updateAnswer(qnaId, answer, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Q&A 답변 업데이트 (자동 트랜잭션)
     */
    public boolean updateQnAAnswer(int qnaId, String answer) {
        try (org.apache.ibatis.session.SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(false)) {
            int result = qnaDAO.updateAnswer(qnaId, answer, sqlSession);
            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Q&A 상태 업데이트
     */
    public boolean updateQnAStatus(int qnaId, String status) {
        try (org.apache.ibatis.session.SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(false)) {
            int result = qnaDAO.updateStatus(qnaId, status, sqlSession);
            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Q&A 삭제
     */
    public boolean deleteQnA(int qnaId) {
        try (org.apache.ibatis.session.SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(false)) {
            int result = qnaDAO.delete(qnaId, sqlSession);
            if (result > 0) {
                sqlSession.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 최근 N분 이내의 답변되지 않은 Q&A 조회 (실시간 알림용)
     */
    public List<BusinessQnA> getRecentUnansweredQnAs(int ownerId, int minutesAgo) {
        try {
            // 실제 데이터베이스에서 조회 - 기본 조회 후 필터링으로 구현
            List<BusinessQnA> allQnAs = qnaDAO.findByOwnerId(ownerId);
            List<BusinessQnA> recentQnAs = new java.util.ArrayList<>();

            java.time.LocalDateTime cutoffTime = java.time.LocalDateTime.now().minusMinutes(minutesAgo);

            for (BusinessQnA qna : allQnAs) {
                if (qna.getCreatedAt() != null &&
                    qna.getCreatedAt().isAfter(cutoffTime) &&
                    ("답변대기".equals(qna.getStatus()) || qna.getAnswer() == null || qna.getAnswer().trim().isEmpty())) {
                    recentQnAs.add(qna);
                }
            }

            return recentQnAs;
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * 답변되지 않은 Q&A 총 개수 조회
     */
    public int getUnansweredQnACount(int ownerId) {
        try {
            // 실제 데이터베이스에서 미답변 Q&A 개수 조회
            List<BusinessQnA> allQnAs = qnaDAO.findByOwnerId(ownerId);
            int unansweredCount = 0;

            for (BusinessQnA qna : allQnAs) {
                if ("답변대기".equals(qna.getStatus()) || qna.getAnswer() == null || qna.getAnswer().trim().isEmpty()) {
                    unansweredCount++;
                }
            }

            return unansweredCount;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
