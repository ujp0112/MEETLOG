package service;

import java.util.List;
import model.Reservation;
import dao.ReservationDAO;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

public class ReservationService {
    // IDE Cache Refresh - v2.0
    private ReservationDAO reservationDAO = new ReservationDAO();
    
    /**
     * 음식점별 예약 목록 조회
     */
    public List<Reservation> getReservationsByRestaurantId(int restaurantId) {
        return reservationDAO.findByRestaurantId(restaurantId);
    }
    
    /**
     * 예약 상세 조회
     */
    public Reservation getReservationById(int reservationId) {
        return reservationDAO.findById(reservationId);
    }
    
    /**
     * 예약 상태 변경 (트랜잭션 포함)
     */
    public boolean updateReservationStatus(int reservationId, String status, SqlSession sqlSession) {
        try {
            return reservationDAO.updateStatus(reservationId, status, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 예약 상태 변경 (자동 트랜잭션)
     */
    public boolean updateReservationStatus(int reservationId, String status) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = reservationDAO.updateStatus(reservationId, status, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 예약 삭제 (트랜잭션 포함)
     */
    public boolean deleteReservation(int reservationId, SqlSession sqlSession) {
        try {
            return reservationDAO.delete(reservationId, sqlSession) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 예약 삭제 (자동 트랜잭션)
     */
    public boolean deleteReservation(int reservationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            boolean result = reservationDAO.delete(reservationId, sqlSession) > 0;
            if (result) {
                sqlSession.commit();
            } else {
                sqlSession.rollback();
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 오늘 예약 목록 조회
     */
    public List<Reservation> getTodayReservations(int restaurantId) {
        return reservationDAO.findTodayReservations(restaurantId);
    }
    
    /**
     * 예약 통계 조회
     */
    public ReservationStats getReservationStats(int restaurantId) {
        return (ReservationStats) reservationDAO.getReservationStats(restaurantId);
    }
    
    /**
     * 예약 통계 클래스
     */
    public static class ReservationStats {
        private int totalReservations;
        private int pendingReservations;
        private int confirmedReservations;
        private int cancelledReservations;
        private int completedReservations;
        
        // Getters and Setters
        public int getTotalReservations() { return totalReservations; }
        public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }
        public int getPendingReservations() { return pendingReservations; }
        public void setPendingReservations(int pendingReservations) { this.pendingReservations = pendingReservations; }
        public int getConfirmedReservations() { return confirmedReservations; }
        public void setConfirmedReservations(int confirmedReservations) { this.confirmedReservations = confirmedReservations; }
        public int getCancelledReservations() { return cancelledReservations; }
        public void setCancelledReservations(int cancelledReservations) { this.cancelledReservations = cancelledReservations; }
        public int getCompletedReservations() { return completedReservations; }
        public void setCompletedReservations(int completedReservations) { this.completedReservations = completedReservations; }
    }
    
    /**
     * 고급 검색을 위한 예약 검색
     */
    public List<Reservation> searchReservations(java.util.Map<String, Object> searchParams) {
        return reservationDAO.searchReservations(searchParams);
    }
    
    /**
     * 예약 생성
     */
    public boolean createReservation(Reservation reservation) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = reservationDAO.insert(reservation, sqlSession);
            if (result > 0) {
                sqlSession.commit();
                return true;
            } else {
                sqlSession.rollback();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 예약 취소
     */
    public boolean cancelReservation(int reservationId) {
        return updateReservationStatus(reservationId, "CANCELLED");
    }
}