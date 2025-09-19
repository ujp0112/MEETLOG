package service;

import dao.RestaurantDAO;
import model.Restaurant;
import model.RestaurantSummaryDTO;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

public class RestaurantService {
	private RestaurantDAO restaurantDAO = new RestaurantDAO();

	public List<Restaurant> getTopRestaurants(int limit) {
		return restaurantDAO.findTopRestaurants(limit);
	}

	public Restaurant getRestaurantById(int restaurantId) {
		return restaurantDAO.findById(restaurantId);
	}

	public List<Restaurant> searchRestaurants(String keyword, String category, String location, String priceRange,
			String parking) {
		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		params.put("category", category);
		params.put("location", location);
		params.put("priceRange", priceRange);
		params.put("parking", parking);
		return restaurantDAO.searchRestaurants(params);
	}

	public boolean addRestaurant(Restaurant restaurant) {
		return restaurantDAO.insert(restaurant) > 0;
	}

	public int createRestaurant(Restaurant restaurant) {
		restaurantDAO.insert(restaurant);
		return restaurant.getId(); // 생성된 ID 반환
	}

	public boolean updateRestaurant(Restaurant restaurant) {
		return restaurantDAO.update(restaurant) > 0;
	}

	public boolean deleteRestaurant(int restaurantId) {
		return restaurantDAO.delete(restaurantId) > 0;
	}

	// 사업자별 레스토랑 조회 메서드 추가
	public List<Restaurant> getRestaurantsByOwnerId(int ownerId) {
		return restaurantDAO.findByOwnerId(ownerId);
	}

	// 사업자별 레스토랑 요약 정보 조회 (경량 DTO 사용)
	public List<RestaurantSummaryDTO> getRestaurantSummariesByOwnerId(int ownerId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList("restaurant.findSummariesByOwnerId", ownerId);
		}
	}

	// SqlSession을 받는 addRestaurant 메서드 추가
	public int addRestaurant(SqlSession sqlSession, Restaurant restaurant) {
		return restaurantDAO.insert(restaurant, sqlSession);
	}
}