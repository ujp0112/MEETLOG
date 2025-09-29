package dao;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import model.ReservationBlackoutDate;
import util.MyBatisSqlSessionFactory;

/**
 * 예약 블랙아웃 날짜 데이터 접근 객체
 */
public class ReservationBlackoutDateDAO {

    /**
     * 특정 음식점의 블랙아웃 날짜 목록 조회
     */
    public List<ReservationBlackoutDate> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationBlackoutDateMapper.findByRestaurantId", restaurantId);
        }
    }

    /**
     * 특정 음식점의 활성화된 블랙아웃 날짜 목록 조회
     */
    public List<ReservationBlackoutDate> findActiveByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList("ReservationBlackoutDateMapper.findActiveByRestaurantId", restaurantId);
        }
    }

    /**
     * 특정 날짜가 블랙아웃 날짜인지 확인
     */
    public boolean isBlackoutDate(int restaurantId, LocalDate date) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("blackoutDate", date);

            Integer count = sqlSession.selectOne("ReservationBlackoutDateMapper.countByRestaurantAndDate", params);
            return count != null && count > 0;
        }
    }

    /**
     * 특정 기간의 블랙아웃 날짜 목록 조회
     */
    public List<ReservationBlackoutDate> findByDateRange(int restaurantId, LocalDate startDate, LocalDate endDate) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("startDate", startDate);
            params.put("endDate", endDate);

            return sqlSession.selectList("ReservationBlackoutDateMapper.findByDateRange", params);
        }
    }

    /**
     * 미래의 블랙아웃 날짜 목록 조회
     */
    public List<ReservationBlackoutDate> findFutureBlackoutDates(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("currentDate", LocalDate.now());

            return sqlSession.selectList("ReservationBlackoutDateMapper.findFutureBlackoutDates", params);
        }
    }

    /**
     * ID로 블랙아웃 날짜 조회
     */
    public ReservationBlackoutDate findById(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("ReservationBlackoutDateMapper.findById", id);
        }
    }

    /**
     * 블랙아웃 날짜 추가
     */
    public int insert(ReservationBlackoutDate blackoutDate) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert("ReservationBlackoutDateMapper.insert", blackoutDate);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 블랙아웃 날짜 수정
     */
    public int update(ReservationBlackoutDate blackoutDate) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("ReservationBlackoutDateMapper.update", blackoutDate);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 블랙아웃 날짜 비활성화
     */
    public int deactivate(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update("ReservationBlackoutDateMapper.deactivate", id);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 블랙아웃 날짜 삭제
     */
    public int delete(int id) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete("ReservationBlackoutDateMapper.delete", id);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 특정 음식점의 과거 블랙아웃 날짜 정리 (자동 비활성화)
     */
    public int deactivatePastDates(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", restaurantId);
            params.put("currentDate", LocalDate.now());

            int result = sqlSession.update("ReservationBlackoutDateMapper.deactivatePastDates", params);
            sqlSession.commit();
            return result;
        }
    }

    /**
     * 블랙아웃 날짜 목록 일괄 추가
     */
    public int insertBatch(List<ReservationBlackoutDate> blackoutDates) {
        if (blackoutDates == null || blackoutDates.isEmpty()) {
            return 0;
        }

        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int totalInserted = 0;
            for (ReservationBlackoutDate blackoutDate : blackoutDates) {
                totalInserted += sqlSession.insert("ReservationBlackoutDateMapper.insert", blackoutDate);
            }
            sqlSession.commit();
            return totalInserted;
        }
    }

    /**
     * 음식점의 블랙아웃 날짜 통계 조회
     */
    public Map<String, Object> getBlackoutDateStats(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne("ReservationBlackoutDateMapper.getBlackoutDateStats", restaurantId);
        }
    }
}