package dao;

import org.apache.ibatis.session.SqlSession;
import model.BusinessUser;

public class BusinessUserDAO {
    private static final String NAMESPACE = "dao.BusinessUserDAO";

    public int insert(BusinessUser businessUser, SqlSession sqlSession) {
        // 트랜잭션 관리를 위해 SqlSession을 외부(서비스)에서 받아옵니다.
        return sqlSession.insert(NAMESPACE + ".insert", businessUser);
    }
}