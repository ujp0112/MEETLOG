package dao;

import model.BusinessQnA;
import util.MyBatisSqlSessionFactory;
// import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class BusinessQnADAO {
    private static final String NAMESPACE = "dao.BusinessQnADAO";
    
    /**
     * 사업자별 Q&A 조회 (임시로 빈 목록 반환)
     */
    public List<BusinessQnA> findByOwnerId(int ownerId) {
        // TODO: 실제 데이터베이스 조회 구현
        return new java.util.ArrayList<>();
    }
    
    /**
     * Q&A 답변 업데이트 (임시로 성공 반환)
     */
    public int updateAnswer(int qnaId, String answer, Object sqlSession) {
        // TODO: 실제 데이터베이스 업데이트 구현
        return 1;
    }
    
    /**
     * Q&A 상태 업데이트 (임시로 성공 반환)
     */
    public int updateStatus(int qnaId, String status, Object sqlSession) {
        // TODO: 실제 데이터베이스 업데이트 구현
        return 1;
    }
    
    /**
     * Q&A 삭제 (임시로 성공 반환)
     */
    public int delete(int qnaId, Object sqlSession) {
        // TODO: 실제 데이터베이스 삭제 구현
        return 1;
    }
}
