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
<<<<<<< HEAD

=======
    
    /**
     * 메뉴 추가 (트랜잭션 포함)
     */
    public int insert(Menu menu, SqlSession sqlSession) {
        return sqlSession.insert(NAMESPACE + ".insert", menu);
    }
    
    /**
     * 메뉴 수정 (트랜잭션 포함)
     */
    public int update(Menu menu, SqlSession sqlSession) {
        return sqlSession.update(NAMESPACE + ".update", menu);
    }
    
    /**
     * 메뉴 삭제 (트랜잭션 포함)
     */
    public int delete(int menuId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".delete", menuId);
    }
    
    /**
     * 메뉴 상세 조회
     */
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
    public Menu findById(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", menuId);
        }
    }
<<<<<<< HEAD

    public int update(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.update(NAMESPACE + ".update", menu);
        }
    }

    public int delete(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.delete(NAMESPACE + ".delete", menuId);
=======
    
    /**
     * 인기 메뉴 목록 조회
     */
    public List<Menu> findPopularMenus() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findPopularMenus");
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
        }
    }
}