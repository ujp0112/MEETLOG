package dao;

import model.BusinessQnA;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class BusinessQnADAO {
    private static final String NAMESPACE = "dao.BusinessQnADAO";

    /**
     * 사업자별 Q&A 조회 - 실제 MyBatis 구현
     */
    public List<BusinessQnA> findByOwnerId(int ownerId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByOwnerId", ownerId);
        } catch (Exception e) {
            e.printStackTrace();
            // DB 조회 실패 시 빈 목록 반환
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Q&A 답변 업데이트 - 실제 MyBatis 구현
     */
    public int updateAnswer(int qnaId, String answer, Object sqlSession) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("qnaId", qnaId);
            params.put("answer", answer);
            params.put("answeredAt", new java.util.Date());
            params.put("status", "답변완료");

            if (sqlSession instanceof SqlSession) {
                return ((SqlSession) sqlSession).update(NAMESPACE + ".updateAnswer", params);
            } else {
                try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
                    int result = session.update(NAMESPACE + ".updateAnswer", params);
                    session.commit();
                    return result;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Q&A 상태 업데이트 - 실제 MyBatis 구현
     */
    public int updateStatus(int qnaId, String status, Object sqlSession) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("qnaId", qnaId);
            params.put("status", status);
            params.put("updatedAt", new java.util.Date());

            if (sqlSession instanceof SqlSession) {
                return ((SqlSession) sqlSession).update(NAMESPACE + ".updateStatus", params);
            } else {
                try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
                    int result = session.update(NAMESPACE + ".updateStatus", params);
                    session.commit();
                    return result;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Q&A 삭제 - 실제 MyBatis 구현
     */
    public int delete(int qnaId, Object sqlSession) {
        try {
            if (sqlSession instanceof SqlSession) {
                return ((SqlSession) sqlSession).delete(NAMESPACE + ".delete", qnaId);
            } else {
                try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
                    int result = session.delete(NAMESPACE + ".delete", qnaId);
                    session.commit();
                    return result;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Q&A 등록 - 실제 MyBatis 구현
     */
    public int insert(BusinessQnA qna) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", qna);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Q&A ID로 조회 - 실제 MyBatis 구현
     */
    public BusinessQnA findById(int qnaId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", qnaId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 레스토랑별 Q&A 조회 - 실제 MyBatis 구현
     */
    public List<BusinessQnA> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
}
