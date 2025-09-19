package dao;

import model.Restaurant;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

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
	
	/**
	 * 고급 검색을 위한 음식점 검색
	 */
	public List<Restaurant> searchRestaurants(java.util.Map<String, Object> searchParams) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".searchRestaurants", searchParams);
		}
	}
}