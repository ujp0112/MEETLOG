package dao;

import java.util.List;
import model.QnA;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

public class QnADAO {
    
    private static final String NAMESPACE = "QnAMapper";
    
    public List<QnA> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        } catch (Exception e) {
            System.err.println("Q&A 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public List<QnA> findAllActive() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAllActive");
        } catch (Exception e) {
            System.err.println("Q&A 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public int insertQnA(QnA qna) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insertQnA", qna);
            // sqlSession.commit(); // 서비스 계층에서 트랜잭션 관리
            return result;
        } catch (Exception e) {
            System.err.println("Q&A 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    public int updateQnA(QnA qna) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".updateQnA", qna);
            // sqlSession.commit(); // 서비스 계층에서 트랜잭션 관리
            return result;
        } catch (Exception e) {
            System.err.println("Q&A 수정 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    public int deleteQnA(int qnaId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".deleteQnA", qnaId);
            // sqlSession.commit(); // 서비스 계층에서 트랜잭션 관리
            return result;
        } catch (Exception e) {
            System.err.println("Q&A 삭제 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    public List<QnA> findByBusinessUserId(int businessUserId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByBusinessUserId", businessUserId);
        }
    }
}