package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import dao.ReservationDAO;
import model.Reservation;
import util.MyBatisSqlSessionFactory;
import util.QueryOptimizer;
import util.AsyncTaskProcessor;

public class ReservationService {
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final QueryOptimizer queryOptimizer = QueryOptimizer.getInstance();
    private final AsyncTaskProcessor asyncProcessor = AsyncTaskProcessor.getInstance();

    // --- Read Operations with Caching ---
    public List<Reservation> getReservationsByRestaurantId(int restaurantId) {
        String cacheKey = QueryOptimizer.CacheKeys.reservationKey(restaurantId) + "_list";

        List<Reservation> cachedResult = queryOptimizer.getCachedResult(cacheKey);
        if (cachedResult != null) {
            return cachedResult;
        }

        long startTime = System.currentTimeMillis();
        List<Reservation> reservations = reservationDAO.findByRestaurantId(restaurantId);
        long executionTime = System.currentTimeMillis() - startTime;

        queryOptimizer.recordQuery("getReservationsByRestaurantId", executionTime);
        queryOptimizer.cacheResult(cacheKey, reservations, 180000); // 3분 캐시

        return reservations;
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
                int result = reservationDAO.insert(reservation, sqlSession);
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
                long startTime = System.currentTimeMillis();
                int result = reservationDAO.updateStatus(reservationId, status, sqlSession);
                long executionTime = System.currentTimeMillis() - startTime;

                queryOptimizer.recordQuery("updateReservationStatus", executionTime);

                if (result > 0) {
                    sqlSession.commit();

                    // 캐시 무효화
                    queryOptimizer.invalidateCache("reservation_" + reservationId);

                    // 비동기로 알림 발송
                    asyncProcessor.executeAsync(
                        AsyncTaskProcessor.CommonTasks.notificationTask(
                            reservationId, "예약 상태가 " + status + "로 변경되었습니다."
                        )
                    );

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
                int result = reservationDAO.delete(reservationId, sqlSession);
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

    // ========== AJAX 서블릿용 메서드들 ==========

    /**
     * 예약 상태 업데이트 (사용자 ID로 권한 확인 포함)
     */
    public boolean updateReservationStatus(int reservationId, String status, int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 권한 확인 (해당 사용자의 예약인지 확인)
                Reservation reservation = reservationDAO.findById(reservationId);
                if (reservation == null) {
                    return false;
                }

                // TODO: 실제로는 사용자가 해당 예약에 대한 권한이 있는지 확인
                // 예: 예약의 비즈니스 소유자인지 확인

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

    /**
     * 최근 N분 이내의 비즈니스 사용자용 새 예약 조회
     */
    public List<Reservation> getRecentReservationsForBusiness(int businessUserId, int minutesAgo) {
        try {
            // 실제 데이터베이스에서 최근 N분 이내 예약 조회
            // 사업자가 소유한 레스토랑의 예약들을 조회 후 필터링
            List<Reservation> allReservations = reservationDAO.findByRestaurantId(businessUserId); // restaurantId로 가정
            List<Reservation> recentReservations = new java.util.ArrayList<>();

            java.time.LocalDateTime cutoffTime = java.time.LocalDateTime.now().minusMinutes(minutesAgo);

            for (Reservation reservation : allReservations) {
                if (reservation.getCreatedAt() != null && reservation.getCreatedAt().isAfter(cutoffTime)) {
                    recentReservations.add(reservation);
                }
            }

            return recentReservations;
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * 처리 대기 중인 예약 수 조회
     */
    public int getPendingReservationCount(int businessUserId) {
        try {
            // 실제 데이터베이스에서 대기 중인 예약 수 조회
            List<Reservation> allReservations = reservationDAO.findByRestaurantId(businessUserId);
            int pendingCount = 0;

            for (Reservation reservation : allReservations) {
                if ("PENDING".equals(reservation.getStatus())) {
                    pendingCount++;
                }
            }

            return pendingCount;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
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