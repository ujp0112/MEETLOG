package dao;

import model.Restaurant;
import model.RestaurantSummaryDTO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class RestaurantDAO {
	private static final String NAMESPACE = "dao.RestaurantDAO";

    public List<Restaurant> findAll() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findAll");
        }
    }

    public Restaurant findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", id);
        }
    }

    public List<Restaurant> findByCategory(String category) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByCategory", category);
        }
    }

    public List<Restaurant> findByLocation(String location) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByLocation", location);
        }
    }

    public List<Restaurant> findByOwnerId(int ownerId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByOwnerId", ownerId);
        }
    }

	public List<RestaurantSummaryDTO> findSummariesByOwnerId(int ownerId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findSummariesByOwnerId", ownerId);
		}
	}

	public List<Restaurant> findTopRestaurants(int limit) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findTopRestaurants", limit);
		}
	}

	public List<Restaurant> searchRestaurants(Map<String, Object> params) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".searchRestaurants", params);
		}
	}

	public int insert(SqlSession session, Restaurant restaurant) {
		return session.insert(NAMESPACE + ".insert", restaurant);
	}

	public int update(SqlSession session, Restaurant restaurant) {
		return session.update(NAMESPACE + ".update", restaurant);
	}

	public int delete(SqlSession session, int id) {
		return session.delete(NAMESPACE + ".delete", id);
	}
}