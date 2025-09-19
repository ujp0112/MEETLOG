package dao;

import model.Reservation;
import service.ReservationService.ReservationStats;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;

public class ReservationDAO {
    private static final String NAMESPACE = "dao.ReservationDAO";
    
    /**
     * 음식점별 예약 목록 조회
     */
    public List<Reservation> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }
    
    /**
     * 예약 상세 조회
     */
    public Reservation findById(int reservationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", reservationId);
        }
    }
    
    /**
     * 예약 상태 변경 (트랜잭션 포함)
     */
    public int updateStatus(int reservationId, String status, SqlSession sqlSession) {
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("id", reservationId);
        params.put("status", status);
        return sqlSession.update(NAMESPACE + ".updateStatus", params);
    }
    
    /**
     * 예약 삭제 (트랜잭션 포함)
     */
    public int delete(int reservationId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".delete", reservationId);
    }
    
    /**
     * 오늘 예약 목록 조회
     */
    public List<Reservation> findTodayReservations(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findTodayReservations", restaurantId);
        }
    }
    
    /**
     * 예약 통계 조회
     */
    public ReservationStats getReservationStats(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getReservationStats", restaurantId);
        }
    }
    
    /**
     * 고급 검색을 위한 예약 검색
     */
    public List<Reservation> searchReservations(java.util.Map<String, Object> searchParams) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".searchReservations", searchParams);
        }
    }
}