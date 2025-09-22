package dao;

import java.util.List;
import model.UserCollection;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

public class UserCollectionDAO {

    public List<UserCollection> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("dao.UserCollectionDAO.findByUserId", userId);
        }
    }

    public int insert(UserCollection collection) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(true)) {
            return sqlSession.insert("dao.UserCollectionDAO.insert", collection);
        }
    }
}
