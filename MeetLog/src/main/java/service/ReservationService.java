package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import dao.ReservationDAO;
import model.Reservation;
import util.MyBatisSqlSessionFactory;

public class ReservationService {
    private final ReservationDAO reservationDAO = new ReservationDAO();

    // --- Read Operations ---
    public List<Reservation> getReservationsByRestaurantId(int restaurantId) {
        return reservationDAO.findByRestaurantId(restaurantId);
    }

    public Reservation getReservationById(int reservationId) {
        return reservationDAO.findById(reservationId);
    }

    public List<Reservation> getTodayReservations(int restaurantId) {
        return reservationDAO.findTodayReservations(restaurantId);
    }

    public ReservationStats getReservationStats(int restaurantId) {
        return (ReservationStats) reservationDAO.getReservationStats(restaurantId);
    }

    public List<Reservation> searchReservations(Map<String, Object> searchParams) {
        return reservationDAO.searchReservations(searchParams);
    }

    public List<Reservation> getReservationsByUserId(int userId) {
        return reservationDAO.findByUserId(userId);
    }

    public List<Reservation> getRecentReservations(int userId, int limit) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("limit", limit);
        return reservationDAO.findRecentByUserId(params);
    }

    // --- Write Operations with Service-Layer Transaction Management ---
    public boolean createReservation(Reservation reservation) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reservationDAO.insert(sqlSession, reservation);
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

    public boolean updateReservationStatus(int reservationId, String status) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reservationDAO.updateStatus(reservationId, status, sqlSession);
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

    public boolean cancelReservation(int reservationId) {
        return updateReservationStatus(reservationId, "CANCELLED");
    }

    public boolean deleteReservation(int reservationId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reservationDAO.delete(sqlSession, reservationId);
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

    // --- Inner Class for Stats ---
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
}