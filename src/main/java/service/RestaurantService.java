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
}