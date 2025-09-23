package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import dao.RestaurantDAO;
import model.Restaurant;
import model.RestaurantSummaryDTO;
import util.MyBatisSqlSessionFactory;

import dao.OperatingHourDAO;
import model.OperatingHour;

public class RestaurantService {
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();
    private final OperatingHourDAO operatingHourDAO = new OperatingHourDAO();

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
    
    public Restaurant getRestaurantDetailById(int id) {
        return restaurantDAO.findDetailById(id);
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

    public boolean createRestaurant(Restaurant restaurant, List<String> additionalImagePaths, List<OperatingHour> hoursList) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 1. 레스토랑 기본 정보 삽입 (대표 이미지 포함)
            restaurantDAO.insert(sqlSession, restaurant);
            int restaurantId = restaurant.getId(); // 생성된 ID 가져오기

            // 2. 추가 이미지들 저장
            if (additionalImagePaths != null && !additionalImagePaths.isEmpty()) {
                Map<String, Object> params = new HashMap<>();
                params.put("restaurantId", restaurantId);
                params.put("imageList", additionalImagePaths);
                sqlSession.insert("dao.RestaurantDAO.insertRestaurantImages", params);
            }
            
            // 3. 영업시간 정보 저장
            if (hoursList != null && !hoursList.isEmpty()) {
                for (OperatingHour hour : hoursList) {
                    hour.setRestaurantId(restaurantId);
                }
                operatingHourDAO.insertList(sqlSession, hoursList);
            }
            
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            sqlSession.close();
        }
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