package dao;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import model.RestaurantTable;
import util.MyBatisSqlSessionFactory;

/**
 * 음식점 테이블 데이터 접근 객체
 */
public class RestaurantTableDAO {

    /**
     * 특정 음식점의 테이블 목록 조회
     */
    public List<RestaurantTable> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("RestaurantTableMapper.findByRestaurantId", restaurantId);
        }
    }

    /**
     * 특정 음식점의 활성화된 테이블 목록 조회
     */
    public List<RestaurantTable> findActiveByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("RestaurantTableMapper.findActiveByRestaurantId", restaurantId);
        }
    }

    /**
     * 특정 인원수를 수용할 수 있는 테이블 목록 조회
     */
    public List<RestaurantTable> findByCapacity(int restaurantId, int partySize) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("partySize", partySize);

            return sqlSession.selectList("RestaurantTableMapper.findByCapacity", params);
        }
    }

    /**
     * 특정 시간대에 예약 가능한 테이블 목록 조회
     */
    public List<RestaurantTable> findAvailableByDateTime(int restaurantId, LocalDateTime reservationTime, int partySize) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("reservationTime", reservationTime);
            params.put("partySize", partySize);

            return sqlSession.selectList("RestaurantTableMapper.findAvailableByDateTime", params);
        }
    }

    /**
     * 테이블 유형별 목록 조회
     */
    public List<RestaurantTable> findByTableType(int restaurantId, RestaurantTable.TableType tableType) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("tableType", tableType.name());

            return sqlSession.selectList("RestaurantTableMapper.findByTableType", params);
        }
    }

    /**
     * ID로 테이블 조회
     */
    public RestaurantTable findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("RestaurantTableMapper.findById", id);
        }
    }

    /**
     * 테이블 번호로 조회 (특정 음식점 내에서)
     */
    public RestaurantTable findByRestaurantAndTableNumber(int restaurantId, int tableNumber) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("tableNumber", tableNumber);

            return sqlSession.selectOne("RestaurantTableMapper.findByRestaurantAndTableNumber", params);
        }
    }

    /**
     * 테이블 추가
     */
    public int insert(RestaurantTable table) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("RestaurantTableMapper.insert", table);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 테이블 수정
     */
    public int update(RestaurantTable table) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("RestaurantTableMapper.update", table);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 테이블 활성화/비활성화
     */
    public int updateActiveStatus(int id, boolean isActive) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            params.put("isActive", isActive);

            int result = sqlSession.update("RestaurantTableMapper.updateActiveStatus", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 테이블 삭제
     */
    public int delete(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete("RestaurantTableMapper.delete", id);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 테이블 번호 중복 확인
     */
    public boolean isTableNumberExists(int restaurantId, int tableNumber, int excludeId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("tableNumber", tableNumber);
            params.put("excludeId", excludeId);

            Integer count = sqlSession.selectOne("RestaurantTableMapper.countByTableNumber", params);
            return count != null && count > 0;
        }
    }

    /**
     * 음식점의 테이블 통계 조회
     */
    public Map<String, Object> getTableStats(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("RestaurantTableMapper.getTableStats", restaurantId);
        }
    }

    /**
     * 테이블 목록 일괄 추가
     */
    public int insertBatch(List<RestaurantTable> tables) {
        if (tables == null || tables.isEmpty()) {
            return 0;
        }

        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int totalInserted = 0;
            for (RestaurantTable table : tables) {
                totalInserted += sqlSession.insert("RestaurantTableMapper.insert", table);
            }
            sqlSession.commit();
            return totalInserted;
        }
    }

    /**
     * 특정 시간대의 테이블 예약 현황 조회
     */
    public List<Map<String, Object>> getTableReservationStatus(int restaurantId, LocalDateTime dateTime) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("dateTime", dateTime);

            return sqlSession.selectList("RestaurantTableMapper.getTableReservationStatus", params);
        }
    }

    /**
     * 최적의 테이블 추천 (인원수와 테이블 타입을 고려)
     */
    public List<RestaurantTable> recommendOptimalTables(int restaurantId, int partySize, LocalDateTime reservationTime) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("partySize", partySize);
            params.put("reservationTime", reservationTime);

            return sqlSession.selectList("RestaurantTableMapper.recommendOptimalTables", params);
        }
    }
}