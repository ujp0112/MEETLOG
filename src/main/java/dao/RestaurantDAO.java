package dao;

import model.Restaurant;
import model.RestaurantSummaryDTO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class RestaurantDAO {
    private static final String NAMESPACE = "dao.RestaurantDAO";

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
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.insert(NAMESPACE + ".insert", restaurant);
        }
    }

    public int update(Restaurant restaurant) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.update(NAMESPACE + ".update", restaurant);
        }
    }

	public int delete(int id) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.update(NAMESPACE + ".delete", id);
		}
	}

	// 사업자별 레스토랑 조회 메서드 추가
	public List<Restaurant> findByOwnerId(int ownerId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByOwnerId", ownerId);
		}
	}

	// SqlSession을 받는 insert 메서드 추가
	public int insert(Restaurant restaurant, SqlSession sqlSession) {
		return sqlSession.insert(NAMESPACE + ".insert", restaurant);
	}
}