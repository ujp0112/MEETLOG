package dao;

import model.Restaurant;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class RestaurantDAO {
    private static final String NAMESPACE = "dao.RestaurantDAO";

    public List<Restaurant> findByOwnerId(int ownerId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByOwnerId", ownerId);
        }
    }

    public List<Restaurant> findTopRestaurants(int limit) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findTopRestaurants", limit);
        }
    }

    public Restaurant findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", id);
        }
    }

    public List<Restaurant> searchRestaurants(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".searchRestaurants", params);
        }
    }

    public int insert(Restaurant restaurant) {
        // ▼▼▼ 수정된 부분 ▼▼▼
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", restaurant);
            sqlSession.commit(); // 수동으로 commit 해줍니다.
            return result;
        }
        // ▲▲▲ 수정 완료 ▲▲▲
    }

    public int update(Restaurant restaurant) {
        // ▼▼▼ 수정된 부분 ▼▼▼
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".update", restaurant);
            sqlSession.commit(); // 수동으로 commit 해줍니다.
            return result;
        }
        // ▲▲▲ 수정 완료 ▲▲▲
    }

    public int delete(int id) {
        // ▼▼▼ 수정된 부분 ▼▼▼
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".delete", id);
            sqlSession.commit(); // 수동으로 commit 해줍니다.
            return result;
        }
        // ▲▲▲ 수정 완료 ▲▲▲
    }
}