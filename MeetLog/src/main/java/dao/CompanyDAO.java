package dao;

import org.apache.ibatis.session.SqlSession;
import model.Company;
import util.MyBatisSqlSessionFactory;

public class CompanyDAO {
    private static final String NAMESPACE = "dao.CompanyDAO";

    public void insert(SqlSession sqlSession, Company company) {
        // 이 메소드가 실행되면 company 객체의 id 필드에 DB에 생성된 ID가 채워집니다.
        sqlSession.insert(NAMESPACE + ".insert", company);
    }

    public boolean existsById(int companyId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int count = sqlSession.selectOne(NAMESPACE + ".existsById", companyId);
            return count > 0;
        }
    }
}