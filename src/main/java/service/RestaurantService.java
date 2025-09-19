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
	// IDE Cache Refresh - v2.0
	private RestaurantDAO restaurantDAO = new RestaurantDAO();

	public List<Restaurant> getTopRestaurants(int limit) {
		return restaurantDAO.findTopRestaurants(limit);
	}

	public Restaurant getRestaurantById(int restaurantId) {
		return restaurantDAO.findById(restaurantId);
	}

	public Restaurant findById(int restaurantId) {
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
<<<<<<< HEAD

	// 사업자별 레스토랑 요약 정보 조회 (경량 DTO 사용)
	public List<RestaurantSummaryDTO> getRestaurantSummariesByOwnerId(int ownerId) {
		List<Restaurant> restaurants = restaurantDAO.findByOwnerId(ownerId);
		return restaurants.stream()
			.map(restaurant -> {
				RestaurantSummaryDTO dto = new RestaurantSummaryDTO();
				dto.setId(restaurant.getId());
				dto.setName(restaurant.getName());
				dto.setCategory(restaurant.getCategory());
				dto.setLocation(restaurant.getLocation());
				dto.setAddress(restaurant.getAddress());
				dto.setImage(restaurant.getImage());
				dto.setRating(restaurant.getRating());
				dto.setReviewCount(restaurant.getReviewCount());
				return dto;
			})
			.collect(java.util.stream.Collectors.toList());
	}

	// SqlSession을 받는 addRestaurant 메서드 추가
	public int addRestaurant(SqlSession sqlSession, Restaurant restaurant) {
		return restaurantDAO.insert(restaurant, sqlSession);
=======
	
	/**
	 * 고급 검색을 위한 음식점 검색
	 */
	public List<Restaurant> searchRestaurants(java.util.Map<String, Object> searchParams) {
		return restaurantDAO.searchRestaurants(searchParams);
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
	}
}