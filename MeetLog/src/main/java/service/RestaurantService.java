package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import dao.RestaurantDAO;
import model.Restaurant;
import model.RestaurantSummaryDTO;
import util.MyBatisSqlSessionFactory;

public class RestaurantService {
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    // --- Read Operations ---
    public List<Restaurant> findAll() {
        return restaurantDAO.findAll();
    }

    public Restaurant findById(int id) {
        return restaurantDAO.findById(id);
    }
    
    public Restaurant getRestaurantById(int id) {
        return findById(id);
    }

    public List<Restaurant> findByCategory(String category) {
        return restaurantDAO.findByCategory(category);
    }

    public List<Restaurant> findByLocation(String location) {
        return restaurantDAO.findByLocation(location);
    }

    public List<Restaurant> findByOwnerId(int ownerId) {
        return restaurantDAO.findByOwnerId(ownerId);
    }
    
    public List<Restaurant> getRestaurantsByOwnerId(int ownerId) {
        return restaurantDAO.findByOwnerId(ownerId);
    }

    public List<RestaurantSummaryDTO> getRestaurantSummariesByOwnerId(int ownerId) {
        return restaurantDAO.findSummariesByOwnerId(ownerId);
    }

    public List<Restaurant> getTopRestaurants(int limit) {
        return restaurantDAO.findTopRestaurants(limit);
    }

    public List<Restaurant> searchRestaurants(Map<String, Object> searchParams) {
        return restaurantDAO.searchRestaurants(searchParams);
    }
    
    public List<Restaurant> getPaginatedRestaurants(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("dao.RestaurantDAO.findWithFilters", params);
        }
    }

    public int getRestaurantCount(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("dao.RestaurantDAO.countWithFilters", params);
        }
    }

    // --- Write Operations with Service-Layer Transaction Management ---
    public boolean createRestaurant(Restaurant restaurant) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = restaurantDAO.insert(sqlSession, restaurant);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean updateRestaurant(Restaurant restaurant) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = restaurantDAO.update(sqlSession, restaurant);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean deleteRestaurant(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = restaurantDAO.delete(sqlSession, id);
                if (result > 0) {
                    sqlSession.commit();
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }
}