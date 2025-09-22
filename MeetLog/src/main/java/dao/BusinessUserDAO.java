package dao;

import org.apache.ibatis.session.SqlSession;
import model.BusinessUser;
import util.MyBatisSqlSessionFactory;
import java.util.List; // List import 추가

public class BusinessUserDAO {
    private static final String NAMESPACE = "dao.BusinessUserDAO";

    public int insert(BusinessUser businessUser, SqlSession sqlSession) {
        return sqlSession.insert(NAMESPACE + ".insert", businessUser);
    }
    
    public int update(BusinessUser businessUser, SqlSession sqlSession) {
        return sqlSession.update(NAMESPACE + ".update", businessUser);
    }

    public int deleteByUserId(int userId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".deleteByUserId", userId);
    }

    public BusinessUser findByBusinessNumber(String businessNumber) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findByBusinessNumber", businessNumber);
        }
    }

    public List<BusinessUser> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
        }
    }

    public BusinessUser findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findByUserId", userId);
        }
    }
    
    public List<BusinessUser> findPendingByCompanyId(int companyId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findPendingByCompanyId", companyId);
        }
    }

    public int updateStatus(int userId, String status) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) {
            java.util.Map<String, Object> params = new java.util.HashMap<>();
            params.put("userId", userId);
            params.put("status", status);
            return sqlSession.update(NAMESPACE + ".updateStatus", params);
        }
    }
    
    public BusinessUser findHqByIdentifier(String identifier) {
        try (SqlSession sqlSession = util.MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findHqByIdentifier", identifier);
        }
    }
}