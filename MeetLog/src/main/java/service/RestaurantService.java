package service;

import dao.RestaurantDAO;
import model.Restaurant;
import model.RestaurantSummaryDTO;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
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
    
    /**
     * [추가] 필터와 페이징이 적용된 맛집 목록을 가져오는 메소드
     */
    public List<Restaurant> getPaginatedRestaurants(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("dao.RestaurantDAO.findWithFilters", params);
        }
    }

    /**
     * [추가] 필터가 적용된 맛집의 전체 개수를 가져오는 메소드
     */
    public int getRestaurantCount(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("dao.RestaurantDAO.countWithFilters", params);
        }
    }
    
    public List<Restaurant> searchRestaurants(String keyword) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("keyword", keyword);
            // 'searchRestaurants' 쿼리를 다시 사용합니다.
            return sqlSession.selectList("dao.RestaurantDAO.searchRestaurants", params);
        }
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