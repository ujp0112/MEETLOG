package dao;

import model.Menu;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class MenuDAO {
    private static final String NAMESPACE = "dao.MenuDAO";

    public List<Menu> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }

    public int insert(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.insert(NAMESPACE + ".insert", menu);
        }
    }

    public Menu findById(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", menuId);
        }
    }

    public int update(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.update(NAMESPACE + ".update", menu);
        }
    }

    public int delete(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.delete(NAMESPACE + ".delete", menuId);
        }
    }
}