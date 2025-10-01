package dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;

import model.Restaurant;
import model.RestaurantSummaryDTO;
import util.MyBatisSqlSessionFactory;

public class RestaurantDAO {
	private static final String NAMESPACE = "dao.RestaurantDAO";

	public List<Restaurant> findAll() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findAll");
		}
	}

	public Restaurant findById(int id) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".findById", id);
		}
	}

	public List<Restaurant> findByCategory(String category) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByCategory", category);
		}
	}

	public List<Restaurant> findByLocation(String location) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByLocation", location);
		}
	}

	public List<Restaurant> findByOwnerId(int ownerId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findByOwnerId", ownerId);
		}
	}

	/**
	 * ✨ [추가] 지역명으로 맛집을 검색하여 평점순으로 상위 10개를 조회합니다.
	 * 
	 * @param region 검색할 지역명
	 * @return 평점순으로 정렬된 Restaurant 리스트
	 */
	public List<Restaurant> getRankedByRegion(String region) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			// "getRankedByRegion"은 RestaurantMapper.xml에 추가한 select 태그의 id와 일치해야 합니다.
			return sqlSession.selectList(NAMESPACE + ".getRankedByRegion", region);
		}
	}

	public List<RestaurantSummaryDTO> findSummariesByOwnerId(int ownerId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findSummariesByOwnerId", ownerId);
		}
	}

	public List<Restaurant> findTopRestaurants(int limit) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".findTopRestaurants", limit);
		}
	}

	public List<Restaurant> searchRestaurants(Map<String, Object> params) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".searchRestaurants", params);
		}
	}

	public int insert(SqlSession session, Restaurant restaurant) {
		return session.insert(NAMESPACE + ".insert", restaurant);
	}
	
	public int insert(Restaurant restaurant) {
        // [수정] openSession() 사용 및 commit() 호출
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", restaurant);
            sqlSession.commit(); // <-- 이 부분이 매우 중요합니다.
            return result;
        }
    }

	public int update(SqlSession session, Restaurant restaurant) {
		return session.update(NAMESPACE + ".update", restaurant);
	}

	public int delete(SqlSession session, int id) {
		return session.delete(NAMESPACE + ".delete", id);
	}

	public Restaurant findDetailById(int id) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".findDetailById", id);
		}
	}

	public int deleteRestaurantImages(SqlSession session, int restaurantId) {
		return session.delete(NAMESPACE + ".deleteRestaurantImages", restaurantId);
	}

	public int deleteOperatingHours(SqlSession session, int restaurantId) {
		return session.delete(NAMESPACE + ".deleteOperatingHours", restaurantId);
	}

	// --- ▼▼▼ [추가] 아래 메소드를 추가합니다. ▼▼▼ ---
	public int deleteRestaurantImagesByNames(SqlSession session, int restaurantId, List<String> imageList) {
		Map<String, Object> params = new HashMap<>();
		params.put("restaurantId", restaurantId);
		params.put("imageList", imageList);
		return session.delete(NAMESPACE + ".deleteRestaurantImagesByNames", params);
	}

	/**
	 * 특정 위도/경도 주변의 레스토랑을 카테고리 필터와 함께 조회합니다.
	 * 
	 * @param latitude   중심 위도
	 * @param longitude  중심 경도
	 * @param radiusKm   검색 반경 (km)
	 * @param categories 필터링할 카테고리 목록
	 * @return 조건에 맞는 레스토랑 목록
	 */
	public List<Restaurant> findNearbyRestaurants(double latitude, double longitude, double radiusKm,
			List<String> categories) {
		List<Restaurant> nearbyRestaurants = new ArrayList<>();
		// 1. MyBatis를 통해 모든 레스토랑 정보를 가져옵니다. (위치 정보가 있는 레스토랑만)
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {

			List<Restaurant> allRestaurants = sqlSession.selectList(NAMESPACE + ".findAllWithLocation");

			// 2. Java 스트림을 사용하여 필터링합니다.
			nearbyRestaurants = allRestaurants.stream().filter(r -> {
				// 2-1. 거리 계산 (Haversine formula)
				double distance = calculateDistance(latitude, longitude, r.getLatitude(), r.getLongitude());
				return distance <= radiusKm;
			}).filter(r -> {
				// 2-2. 카테고리 필터링 (categories 목록이 비어있으면 모든 카테고리 허용)
				return categories == null || categories.isEmpty() || categories.contains(r.getCategory());
			}).collect(Collectors.toList());

		}
		return nearbyRestaurants;
	}

	/**
	 * 두 지점 간의 거리를 킬로미터(km) 단위로 계산합니다. (Haversine formula)
	 */
	private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
		if (Double.isNaN(lat1) || Double.isNaN(lon1) || Double.isNaN(lat2) || Double.isNaN(lon2)) {
			return Double.MAX_VALUE;
		}

		final int R = 6371; // 지구의 반지름 (km)
		double latDistance = Math.toRadians(lat2 - lat1);
		double lonDistance = Math.toRadians(lon2 - lon1);
		double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) + Math.cos(Math.toRadians(lat1))
				* Math.cos(Math.toRadians(lat2)) * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
		double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
		return R * c;
	}

	/**
	 * [최종 수정] 특정 위치 주변의 레스토랑을 페이징 처리하여 조회합니다. 모든 계산과 필터링을 데이터베이스 쿼리에서 처리하여 성능을
	 * 최적화합니다.
	 *
	 * @param latitude   중심 위도
	 * @param longitude  중심 경도
	 * @param radiusKm   검색 반경 (km)
	 * @param categories 필터링할 카테고리 목록
	 * @param offset     건너뛸 레코드 수
	 * @param limit      가져올 레코드 수
	 * @return 조건에 맞는 레스토랑 목록
	 */
	public List<Restaurant> findNearbyRestaurantsByPage(double latitude, double longitude, double radiusKm,
			List<String> categories, int offset, int limit, List<Integer> excludeIds) {
		// [수정] try-with-resources 구문으로 변경하여 SqlSession을 안전하게 자동 관리합니다.
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("latitude", latitude);
			params.put("longitude", longitude);
			params.put("radiusKm", radiusKm);
			params.put("categories", categories);
			params.put("offset", offset);
			params.put("limit", limit);
			params.put("excludeIds", excludeIds);

			return sqlSession.selectList(NAMESPACE + ".findNearbyRestaurantsByPage", params);
		} // finally 블록은 try-with-resources가 자동으로 처리하므로 제거합니다.
	}

	public void updateRatingAndReviewCount(SqlSession session, int restaurantId) {
		session.update(NAMESPACE + ".updateRatingAndReviewCount", restaurantId);
	}

	/**
	 * 비즈니스 사용자의 전체 통계 조회
	 */
	public Map<String, Object> getOwnerStatistics(int ownerId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectOne(NAMESPACE + ".getOwnerStatistics", ownerId);
		}
	}

	/**
	 * 비즈니스 사용자의 음식점 목록과 통계 조회
	 */
	public List<Map<String, Object>> getOwnerRestaurantsWithStats(int ownerId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
			return sqlSession.selectList(NAMESPACE + ".getOwnerRestaurantsWithStats", ownerId);
		}
	}
	 // ▼▼▼ [추가] findByKakaoPlaceId 메서드 ▼▼▼
    public Restaurant findByKakaoPlaceId(String kakaoPlaceId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findByKakaoPlaceId", kakaoPlaceId);
        }
    }

}