package service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dao.RestaurantDAO;
import model.Restaurant;
import util.MyBatisSqlSessionFactory;

public class RestaurantService {
    private RestaurantDAO restaurantDAO = new RestaurantDAO();

    /**
     * 모든 음식점 조회
     */
    public List<Restaurant> findAll() {
        return restaurantDAO.findAll();
    }

    /**
     * ID로 음식점 조회
     */
    public Restaurant findById(int id) {
        return restaurantDAO.findById(id);
    }

    /**
     * 카테고리로 음식점 조회
     */
    public List<Restaurant> findByCategory(String category) {
        return restaurantDAO.findByCategory(category);
    }

    /**
     * 위치로 음식점 조회
     */
    public List<Restaurant> findByLocation(String location) {
        return restaurantDAO.findByLocation(location);
    }

    /**
     * 사업자 ID로 음식점 목록 조회
     */
    public List<Restaurant> findByOwnerId(int ownerId) {
        return restaurantDAO.findByOwnerId(ownerId);
    }

    /**
     * 음식점 추가
     */
    public int addRestaurant(Restaurant restaurant) {
        return restaurantDAO.insert(restaurant);
    }

    /**
     * 음식점 추가 (트랜잭션 포함)
     */
    public int addRestaurant(SqlSession sqlSession, Restaurant restaurant) {
        return restaurantDAO.insert(restaurant, sqlSession);
    }

    /**
     * 음식점 수정
     */
    public boolean updateRestaurant(Restaurant restaurant) {
        return restaurantDAO.update(restaurant) > 0;
    }

    /**
     * 음식점 삭제
     */
    public boolean deleteRestaurant(int id) {
        return restaurantDAO.delete(id) > 0;
    }

    /**
     * 고급 검색을 위한 음식점 검색
     */
    public List<Restaurant> searchRestaurants(java.util.Map<String, Object> searchParams) {
        return restaurantDAO.searchRestaurants(searchParams);
    }
    
    /**
     * ID로 음식점 조회 (getRestaurantById)
     */
    public Restaurant getRestaurantById(int id) {
        return findById(id);
    }
    
    /**
     * 음식점 생성 (createRestaurant)
     */
    public boolean createRestaurant(Restaurant restaurant) {
        return addRestaurant(restaurant) > 0;
    }
    
    /**
     * 인기 음식점 조회 (getTopRestaurants)
     */
    public List<Restaurant> getTopRestaurants(int limit) {
        return restaurantDAO.findTopRestaurants(limit);
    }
}