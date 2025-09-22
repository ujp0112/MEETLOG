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

    public Menu findById(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", menuId);
        }
    }

    public int insert(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", menu);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int update(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".update", menu);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public int delete(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".delete", menuId);
            if (result > 0) {
                sqlSession.commit();
            }
            return result;
        }
    }

    public List<Menu> findPopularMenus() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findPopularMenus");
        }
    }
}