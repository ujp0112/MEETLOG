package dao;

import org.apache.ibatis.session.SqlSession;
import model.Company;
import util.MyBatisSqlSessionFactory;

public class CompanyDAO {
    private static final String NAMESPACE = "dao.CompanyDAO";

    public int insert(SqlSession sqlSession, Company company) {
        // [수정] 반환 타입을 int로 변경하여 Service 계층에서 성공 여부 확인
        return sqlSession.insert(NAMESPACE + ".insert", company);
    }

    public boolean existsById(int companyId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int count = sqlSession.selectOne(NAMESPACE + ".existsById", companyId);
            return count > 0;
        }
    }
}