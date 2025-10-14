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

    public int insert(SqlSession sqlSession, Menu menu) {
        return sqlSession.insert(NAMESPACE + ".insert", menu);
    }

    public int update(SqlSession sqlSession, Menu menu) {
        return sqlSession.update(NAMESPACE + ".update", menu);
    }

    public int delete(SqlSession sqlSession, int menuId) {
        return sqlSession.delete(NAMESPACE + ".delete", menuId);
    }

    public List<Menu> findPopularMenus() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findPopularMenus");
        }
    }
    public int getMenuCount(long companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("erpMapper.BranchMenuMapper.getMenuCount", companyId);
        }
    }

}