package dao;

import model.Restaurant;
import model.RestaurantSummaryDTO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class RestaurantDAO {
	private static final String NAMESPACE = "dao.RestaurantDAO";

	/**
	 * [수정] 트랜잭션 관리를 위해 SqlSession을 외부에서 받아 처리하는 insert 메소드
	 */
	public void insert(SqlSession sqlSession, Restaurant restaurant) {
		sqlSession.insert(NAMESPACE + ".insert", restaurant);
	}

	/**
	 * [수정] 단독으로 가게 정보를 삽입할 때 사용하는 insert 메소드 (자동 커밋)
	 */
	public int insert(Restaurant restaurant) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			int result = sqlSession.insert(NAMESPACE + ".insert", restaurant);
			sqlSession.commit();
			return result;
		}
	}

	// (다른 find, search, update, delete 메소드들은 그대로 유지)
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
	public int update(Restaurant restaurant) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			int result = sqlSession.update(NAMESPACE + ".update", restaurant);
			sqlSession.commit();
			return result;
		}
	}
	public int delete(int id) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			int result = sqlSession.update(NAMESPACE + ".delete", id);
			sqlSession.commit();
			return result;
		}
	}
}