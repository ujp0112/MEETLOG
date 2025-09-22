package dao;

import java.util.List;
import model.QnA;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

public class QnADAO {
    
    private static final String NAMESPACE = "QnAMapper";
    
    /**
     * 맛집별 Q&A 조회
     */
    public List<QnA> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("QnAMapper.findByRestaurantId", restaurantId);
        } catch (Exception e) {
            System.err.println("Q&A 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 모든 활성 Q&A 조회
     */
    public List<QnA> findAllActive() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("QnAMapper.findAllActive");
        } catch (Exception e) {
            System.err.println("Q&A 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Q&A 추가
     */
    public int insertQnA(QnA qna) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("QnAMapper.insertQnA", qna);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("Q&A 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * Q&A 수정
     */
    public int updateQnA(QnA qna) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("QnAMapper.updateQnA", qna);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("Q&A 수정 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * Q&A 삭제 (비활성화)
     */
    public int deleteQnA(int qnaId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("QnAMapper.deleteQnA", qnaId);
            sqlSession.commit();
            return result;
        } catch (Exception e) {
            System.err.println("Q&A 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 사업자별 Q&A 조회
     */
    public List<QnA> findByBusinessUserId(int businessUserId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByBusinessUserId", businessUserId);
        }
    }
}
