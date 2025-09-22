package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import model.Menu;
import util.MyBatisSqlSessionFactory;

public class MenuDAO {
    private static final String NAMESPACE = "menu";

    /**
     * 특정 음식점의 메뉴 목록 조회
     */
    public List<Menu> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }

    /**
     * 메뉴 ID로 조회
     */
    public Menu findById(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", menuId);
        }
    }

    /**
     * 메뉴 추가
     */
    public int insert(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", menu);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 메뉴 추가 (트랜잭션 포함)
     */
    public int insert(Menu menu, SqlSession sqlSession) {
        return sqlSession.insert(NAMESPACE + ".insert", menu);
    }

    /**
     * 메뉴 수정
     */
    public int update(Menu menu) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".update", menu);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 메뉴 수정 (트랜잭션 포함)
     */
    public int update(Menu menu, SqlSession sqlSession) {
        return sqlSession.update(NAMESPACE + ".update", menu);
    }

    /**
     * 메뉴 삭제
     */
    public int delete(int menuId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".delete", menuId);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 메뉴 삭제 (트랜잭션 포함)
     */
    public int delete(int menuId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".delete", menuId);
    }

    /**
     * 인기 메뉴 목록 조회
     */
    public List<Menu> findPopularMenus() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findPopularMenus");
        }
    }
}