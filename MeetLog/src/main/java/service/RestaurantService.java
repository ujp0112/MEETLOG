package service;

import dao.RestaurantDAO;
import model.Restaurant;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class RestaurantService {
	private RestaurantDAO restaurantDAO = new RestaurantDAO();

	public List<Restaurant> getTopRestaurants(int limit) {
		return restaurantDAO.findTopRestaurants(limit);
	}

	public Restaurant getRestaurantById(int restaurantId) {
		return restaurantDAO.findById(restaurantId);
	}

	/**
	 * [추가] CourseServlet의 장소 검색(대화형)을 위한 간소화된 메서드
	 * 파라미터가 1개인 경우를 처리합니다.
	 */
	public List<Restaurant> searchRestaurants(String keyword) {
		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		// 다른 파라미터는 null로 전달하여 MyBatis가 동적 쿼리로 처리하도록 함
		return restaurantDAO.searchRestaurants(params);
	}
	
	public List<Restaurant> getRestaurantsByOwnerId(int ownerId) {
		return restaurantDAO.findByOwnerId(ownerId);
	}

	/**
	 * 상세 검색 (모든 파라미터 사용)
	 * 파라미터가 5개인 경우를 처리합니다.
	 */
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

	public boolean updateRestaurant(Restaurant restaurant) {
		return restaurantDAO.update(restaurant) > 0;
	}

	public boolean deleteRestaurant(int restaurantId) {
		return restaurantDAO.delete(restaurantId) > 0;
	}
}