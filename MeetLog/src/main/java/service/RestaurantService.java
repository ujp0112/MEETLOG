package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.OperatingHourDAO;
import dao.RestaurantDAO;
import model.OperatingHour;
import model.Restaurant;
import model.RestaurantSummaryDTO;
import util.MyBatisSqlSessionFactory;

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

    public Restaurant getRestaurantById(int restaurantId) {
        return restaurantDAO.findById(restaurantId);
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

    // --- Write Operations with Service-Layer Transaction Management ---
    
    public boolean addRestaurant(Restaurant restaurant) {
        return addRestaurant(restaurant, null, null);
    }

    public boolean addRestaurant(Restaurant restaurant, List<OperatingHour> hoursList) {
        return addRestaurant(restaurant, null, hoursList);
    }

    /**
     * 레스토랑 정보, 추가 이미지, 영업시간을 함께 추가하고 트랜잭션을 관리합니다.
     */
    public boolean addRestaurant(Restaurant restaurant, List<String> additionalImagePaths, List<OperatingHour> hoursList) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 1. 레스토랑 기본 정보 삽입 (대표 이미지 포함)
                int result = restaurantDAO.insert(sqlSession, restaurant);
                if (result == 0) {
                    throw new Exception("Restaurant base info insert failed.");
                }
                
                int restaurantId = restaurant.getId(); // MyBatis에 의해 생성된 ID가 객체에 설정됨

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
            }
        }
    }

    /**
     * 가게 정보, 추가 이미지, 영업시간을 트랜잭션 안에서 안전하게 업데이트합니다.
     * @param restaurant             업데이트할 기본 정보 (id, ownerId 포함)
     * @param newAdditionalImagePaths 새로 추가된 이미지 파일명 리스트
     * @param imagesToDelete         삭제할 기존 이미지 파일명 리스트
     * @param hoursList              새로운 전체 온라인 예약 시간 리스트
     * @return 성공 여부
     */
    public boolean updateRestaurant(Restaurant restaurant, List<String> newAdditionalImagePaths, List<String> imagesToDelete, List<OperatingHour> hoursList) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession();
        try {
            int restaurantId = restaurant.getId();

            // 1. [수정] 삭제하기로 선택한 기존 이미지만 삭제
            if (imagesToDelete != null && !imagesToDelete.isEmpty()) {
                restaurantDAO.deleteRestaurantImagesByNames(sqlSession, restaurantId, imagesToDelete);
            }

            // 2. 기존 온라인 예약 시간을 모두 삭제 (새로운 시간으로 덮어쓰기 위함)
            operatingHourDAO.deleteOperatingHoursByRestaurantId(sqlSession, restaurantId);

            // 3. 가게 기본 정보 업데이트 (대표 이미지 포함)
            restaurantDAO.update(sqlSession, restaurant);

            // 4. 새로 추가된 이미지들 저장
            if (newAdditionalImagePaths != null && !newAdditionalImagePaths.isEmpty()) {
                Map<String, Object> params = new HashMap<>();
                params.put("restaurantId", restaurantId);
                params.put("imageList", newAdditionalImagePaths);
                sqlSession.insert("dao.RestaurantDAO.insertRestaurantImages", params);
            }

            // 5. 새로운 온라인 예약 시간 정보 저장
            if (hoursList != null && !hoursList.isEmpty()) {
                for (OperatingHour hour : hoursList) {
                    hour.setRestaurantId(restaurantId);
                }
                operatingHourDAO.insertList(sqlSession, hoursList);
            }

            sqlSession.commit(); // 모든 작업이 성공하면 커밋
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback(); // 중간에 오류 발생 시 모든 작업 롤백
            return false;
        } finally {
            sqlSession.close(); // 세션 닫기
        }
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
    
// ▼▼▼ [추가] RestaurantApiServlet에서 사용할 서비스 메서드들 ▼▼▼
    
    /**
     * 카카오 장소 ID로 DB에 저장된 맛집 정보를 조회합니다.
     */
    public Restaurant findRestaurantByKakaoPlaceId(String kakaoPlaceId) {
        return restaurantDAO.findByKakaoPlaceId(kakaoPlaceId);
    }
    
    /**
     * 새로운 맛집 정보를 DB에 저장하고, 생성된 ID가 포함된 객체를 반환합니다.
     */
    public Restaurant createRestaurantAndReturn(Restaurant restaurant) {
        // DAO의 insert 메서드는 MyBatis의 useGeneratedKeys 속성 덕분에
        // 파라미터로 전달된 restaurant 객체의 id 필드를 채워줍니다.
        int result = restaurantDAO.insert(restaurant);
        
        if (result > 0) {
            // 삽입 성공 시, ID가 채워진 객체를 반환합니다.
            return restaurant;
        } else {
            // 실패 시 null 반환
            return null; 
        }
    }
}