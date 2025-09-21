package service;

import dao.RestaurantDAO;
import model.Restaurant;
import model.RestaurantSummaryDTO;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class RestaurantService {
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    /**
     * [수정] 가게 등록 시 restaurantDAO.insert 호출
     */
    public void addRestaurant(SqlSession sqlSession, Restaurant restaurant) {
        restaurantDAO.insert(sqlSession, restaurant);
    }

    public boolean addRestaurant(Restaurant restaurant) {
        return restaurantDAO.insert(restaurant) > 0;
    }
    
    // (다른 서비스 메소드들은 그대로 유지)
    public List<Restaurant> searchRestaurants(String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        return restaurantDAO.searchRestaurants(params);
    }
    public List<Restaurant> searchRestaurants(String keyword, String category, String location, String priceRange, String parking) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("category", category);
        params.put("location", location);
        params.put("priceRange", priceRange);
        params.put("parking", "true".equals(parking));
        return restaurantDAO.searchRestaurants(params);
    }
    public List<Restaurant> getTopRestaurants(int limit) {
        return restaurantDAO.findTopRestaurants(limit);
    }
    public Restaurant getRestaurantById(int restaurantId) {
        return restaurantDAO.findById(restaurantId);
    }
    public List<RestaurantSummaryDTO> getRestaurantSummariesByOwnerId(int ownerId) {
        return restaurantDAO.findSummariesByOwnerId(ownerId);
    }
    public List<Restaurant> getRestaurantsByOwnerId(int ownerId) {
        return restaurantDAO.findByOwnerId(ownerId);
    }
    public boolean updateRestaurant(Restaurant restaurant) {
        return restaurantDAO.update(restaurant) > 0;
    }
    public boolean deleteRestaurant(int restaurantId) {
        return restaurantDAO.delete(restaurantId) > 0;
    }
}