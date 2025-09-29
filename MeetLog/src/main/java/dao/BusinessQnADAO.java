package dao;

import model.BusinessQnA;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class BusinessQnADAO {
    private static final String NAMESPACE = "dao.BusinessQnADAO";

    /**
     * 사업자별 Q&A 조회
     */
    public List<BusinessQnA> findByOwnerId(int ownerId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findByOwnerId", ownerId);
        }
    }

    /**
     * 음식점별 Q&A 조회
     */
    public List<BusinessQnA> findByRestaurantId(int restaurantId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }

    /**
     * Q&A 등록
     */
    public int insert(BusinessQnA qna) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(NAMESPACE + ".insert", qna);
            session.commit();
            return result;
        }
    }

    /**
     * Q&A 답변 업데이트
     */
    public int updateAnswer(int qnaId, String answer, SqlSession session) {
        Map<String, Object> params = Map.of(
                "qnaId", qnaId,
                "answer", answer
        );
        return session.update(NAMESPACE + ".updateAnswer", params);
    }

    /**
     * Q&A 답변 업데이트 (자동 트랜잭션)
     */
    public int updateAnswer(int qnaId, String answer) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                    "qnaId", qnaId,
                    "answer", answer
            );
            int result = session.update(NAMESPACE + ".updateAnswer", params);
            session.commit();
            return result;
        }
    }

    /**
     * Q&A 상태 업데이트
     */
    public int updateStatus(int qnaId, String status, SqlSession session) {
        Map<String, Object> params = Map.of(
                "qnaId", qnaId,
                "status", status
        );
        return session.update(NAMESPACE + ".updateStatus", params);
    }

    /**
     * Q&A 상태 업데이트 (자동 트랜잭션)
     */
    public int updateStatus(int qnaId, boolean isActive) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                    "qnaId", qnaId,
                    "status", isActive ? 1 : 0
            );
            int result = session.update(NAMESPACE + ".updateStatus", params);
            session.commit();
            return result;
        }
    }

    /**
     * Q&A 삭제 (소프트 삭제)
     */
    public int delete(int qnaId, SqlSession session) {
        return session.update(NAMESPACE + ".delete", qnaId);
    }

    /**
     * Q&A 삭제 (자동 트랜잭션)
     */
    public int delete(int qnaId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update(NAMESPACE + ".delete", qnaId);
            session.commit();
            return result;
        }
    }

    /**
     * Q&A 답변 등록과 상태 업데이트 (트랜잭션)
     */
    public int updateAnswerWithStatus(int qnaId, String answer, SqlSession session) {
        Map<String, Object> params = Map.of(
                "qnaId", qnaId,
                "answer", answer
        );
        return session.update(NAMESPACE + ".updateAnswerWithStatus", params);
    }

    /**
     * Q&A 해결완료 상태 업데이트
     */
    public int updateResolvedStatus(int qnaId, boolean isResolved) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = Map.of(
                    "qnaId", qnaId,
                    "isResolved", isResolved
            );
            int result = session.update(NAMESPACE + ".updateResolvedStatus", params);
            session.commit();
            return result;
        }
    }
}
