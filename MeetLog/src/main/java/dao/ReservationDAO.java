package dao;

import model.Reservation;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;

public class ReservationDAO {
    private static final String NAMESPACE = "dao.ReservationDAO";
    
    public List<Reservation> findByRestaurantId(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByRestaurantId", restaurantId);
        }
    }
    
    public Reservation findById(int reservationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", reservationId);
        }
    }

    public List<Reservation> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
        }
    }

    public List<Reservation> findRecentByUserId(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findRecentByUserId", params);
        }
    }
    
    public int updateStatus(int reservationId, String status, SqlSession sqlSession) {
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("id", reservationId);
        params.put("status", status);
        return sqlSession.update(NAMESPACE + ".updateStatus", params);
    }
    
    public int delete(int reservationId, SqlSession sqlSession) {
        return sqlSession.delete(NAMESPACE + ".delete", reservationId);
    }
    
    public List<Reservation> findTodayReservations(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findTodayReservations", restaurantId);
        }
    }
    
    public Object getReservationStats(int restaurantId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".getReservationStats", restaurantId);
        }
    }
    
    public List<Reservation> searchReservations(java.util.Map<String, Object> searchParams) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".searchReservations", searchParams);
        }
    }
    
    public int insert(Reservation reservation, SqlSession sqlSession) {
    	System.out.println(")))))))))))))))))))))" + reservation);
        return sqlSession.insert(NAMESPACE + ".insert", reservation);
    }
}