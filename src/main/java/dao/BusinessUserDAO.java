package dao;

import org.apache.ibatis.session.SqlSession;
import model.BusinessUser;
import util.MyBatisSqlSessionFactory;
import java.util.List;

public class BusinessUserDAO {
    private static final String NAMESPACE = "dao.BusinessUserDAO";

    public int insert(BusinessUser businessUser, SqlSession sqlSession) {
        // 트랜잭션 관리를 위해 SqlSession을 외부(서비스)에서 받아옵니다.
        return sqlSession.insert(NAMESPACE + ".insert", businessUser);
    }

    public BusinessUser findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findByUserId", userId);
        }
    }

    public BusinessUser findByBusinessNumber(String businessNumber) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findByBusinessNumber", businessNumber);
        }
    }

    public int update(BusinessUser businessUser, SqlSession sqlSession) {
        return sqlSession.update(NAMESPACE + ".update", businessUser);
    }

    public int deleteByUserId(int userId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".deleteByUserId", userId);
    }

    public List<BusinessUser> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
        }
    }

    // 트랜잭션을 지원하는 메서드들
    public BusinessUser findByUserId(int userId, SqlSession sqlSession) {
        return sqlSession.selectOne(NAMESPACE + ".findByUserId", userId);
    }

    public BusinessUser findByBusinessNumber(String businessNumber, SqlSession sqlSession) {
        return sqlSession.selectOne(NAMESPACE + ".findByBusinessNumber", businessNumber);
    }
}