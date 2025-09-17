package dao;

import model.Column;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class ColumnDAO {
    private static final String NAMESPACE = "dao.ColumnDAO";

    public List<Column> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
        }
    }
    
    public List<Column> findTopColumns(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findTopColumns", limit);
        }
    }
    
    public List<Column> findRecentColumns(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentColumns", limit);
        }
    }
    
    public Column findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", id);
        }
    }

    public List<Column> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
        }
    }

    // [추가] MypageServlet을 위한 메서드
    public List<Column> findRecentByUserId(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentByUserId", params);
        }
    }

    public int insert(Column column) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", column);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int update(Column column) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".update", column);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int delete(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".delete", id);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int incrementViews(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".incrementViews", id);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int likeColumn(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".likeColumn", id);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }
}