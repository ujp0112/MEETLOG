package service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import dao.CouponUsageLogDAO;
import dao.ReservationDAO;
import dao.UserCouponDAO;
import model.Reservation;
import model.User;
import util.MyBatisSqlSessionFactory;
import util.EmailUtil;

import java.math.BigDecimal;

public class ReservationService {
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final UserCouponDAO userCouponDAO = new UserCouponDAO();
    private final CouponUsageLogDAO couponUsageLogDAO = new CouponUsageLogDAO();
    private final PointService pointService = new PointService();
    private final TelegramService telegramService = new TelegramService();
    private final UserService userService = new UserService(); // UserService 추가
    private static final Logger log = LoggerFactory.getLogger(ReservationService.class);
    
    // --- Read Operations ---
    public List<Reservation> getReservationsByRestaurantId(int restaurantId) {
        return reservationDAO.findByRestaurantId(restaurantId);
    }

    public Reservation getReservationById(int reservationId) {
        return reservationDAO.findById(reservationId);
    }

    public Reservation getReservationByPaymentOrderId(String paymentOrderId) {
        return reservationDAO.findByPaymentOrderId(paymentOrderId);
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

    public boolean updatePaymentInfo(int reservationId,
                                     String paymentStatus,
                                     String paymentOrderId,
                                     String paymentProvider,
                                     java.time.LocalDateTime paidAt,
                                     java.math.BigDecimal depositAmount,
                                     boolean depositRequired) {
        try {
            return reservationDAO.updatePaymentInfo(reservationId, paymentStatus, paymentOrderId,
                    paymentProvider, paidAt, depositAmount, depositRequired) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReservationStatus(int reservationId, String status) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                int result = reservationDAO.updateStatus(reservationId, status, sqlSession);
                if (result > 0) {
                    // 예약 확정 시 이메일 발송
                    if ("CONFIRMED".equals(status)) {
                        sendConfirmationEmail(reservationId);
                    }

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
     * 예약 확정 이메일을 발송합니다.
     * @param reservationId 예약 ID
     */
    private void sendConfirmationEmail(int reservationId) {
        try {
            Reservation reservation = getReservationById(reservationId);
            if (reservation == null) {
                log.warn("확정 이메일 발송 실패: 예약을 찾을 수 없음 (reservationId={})", reservationId);
                return;
            }

            User user = userService.getUserById(reservation.getUserId());
            if (user == null || user.getEmail() == null || user.getEmail().isEmpty()) {
                log.warn("확정 이메일 발송 실패: 사용자 또는 이메일 정보 없음 (userId={})", reservation.getUserId());
                return;
            }

            String subject = String.format("[%s] 예약이 확정되었습니다.", reservation.getRestaurantName());
            String body = String.format(
                "안녕하세요, %s님.\n\n요청하신 예약이 확정되었습니다.\n\n- 식당: %s\n- 예약 시간: %s\n- 인원: %d명\n\nMEETLOG를 이용해주셔서 감사합니다.",
                user.getNickname(),
                reservation.getRestaurantName(),
                reservation.getFormattedReservationTime(),
                reservation.getPartySize());

            EmailUtil.sendEmail(user.getEmail(), subject, body);
        } catch (Exception e) {
            log.error("예약 확정 이메일 발송 중 오류 발생: reservationId={}", reservationId, e);
        }
    }

    public boolean cancelReservation(int reservationId, String cancelReason) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            try {
                // 1. 예약 정보 조회 (쿠폰 및 포인트 정보 확인)
                Reservation reservation = reservationDAO.findById(reservationId);
                if (reservation == null) {
                    log.warn("취소할 예약을 찾을 수 없음: reservationId={}", reservationId);
                    return false;
                }

                // 2. 예약 취소 처리
                int result = reservationDAO.updateCancellation(
                        reservationId,
                        cancelReason,
                        LocalDateTime.now(),
                        sqlSession);

                if (result > 0) {
                    // 3. 쿠폰 롤백 (결제 성공 후 취소하는 경우)
                    if (reservation.getUserCouponId() != null && reservation.getUserCouponId() > 0) {
                        log.info("쿠폰 롤백 처리: userCouponId={}, reservationId={}",
                                reservation.getUserCouponId(), reservationId);

                        try {
                            // 쿠폰을 미사용 상태로 되돌림 (is_used = false, used_at = NULL)
                            userCouponDAO.rollbackCoupon(reservation.getUserCouponId());
                            log.info("쿠폰 롤백 완료: userCouponId={}", reservation.getUserCouponId());

                            // coupon_usage_logs에 ROLLBACK 로그 추가
                            BigDecimal discountAmount = reservation.getCouponDiscountAmount() != null
                                ? reservation.getCouponDiscountAmount()
                                : BigDecimal.ZERO;
                            couponUsageLogDAO.insertLog(reservation.getUserCouponId(), reservationId, "ROLLBACK", discountAmount);
                            log.info("쿠폰 롤백 로그 기록 완료: userCouponId={}, reservationId={}",
                                reservation.getUserCouponId(), reservationId);

                        } catch (Exception couponEx) {
                            log.error("쿠폰 롤백 실패: userCouponId={}",
                                    reservation.getUserCouponId(), couponEx);
                            // 쿠폰 롤백 실패해도 예약 취소는 진행
                        }
                    }

                    // 4. 포인트 환불 (적립된 포인트가 있는 경우)
                    if (reservation.getPointsEarned() != null && reservation.getPointsEarned() > 0) {
                        log.info("포인트 차감 처리: userId={}, points={}, reservationId={}",
                                reservation.getUserId(), reservation.getPointsEarned(), reservationId);

                        try {
                            // 적립된 포인트를 다시 차감
                            boolean refunded = pointService.redeemPoints(
                                    reservation.getUserId(),
                                    reservation.getPointsEarned(),
                                    "CANCEL",
                                    Long.valueOf(reservationId),
                                    "예약 취소로 인한 적립 포인트 차감 (예약번호: " + reservationId + ")");

                            if (refunded) {
                                log.info("포인트 차감 완료: userId={}, points={}",
                                        reservation.getUserId(), reservation.getPointsEarned());
                            } else {
                                log.warn("포인트 차감 실패 (잔액 부족 가능): userId={}, points={}",
                                        reservation.getUserId(), reservation.getPointsEarned());
                            }
                        } catch (Exception pointEx) {
                            log.error("포인트 차감 실패: userId={}, points={}",
                                    reservation.getUserId(), reservation.getPointsEarned(), pointEx);
                            // 포인트 차감 실패해도 예약 취소는 진행
                        }
                    }

                    // 5. 사용한 포인트 환불 (포인트로 결제한 경우)
                    if (reservation.getPointsUsed() != null && reservation.getPointsUsed() > 0) {
                        log.info("사용한 포인트 환불 처리: userId={}, points={}, reservationId={}",
                                reservation.getUserId(), reservation.getPointsUsed(), reservationId);

                        try {
                            boolean refunded = pointService.refundPoints(
                                    reservation.getUserId(),
                                    reservation.getPointsUsed(),
                                    "CANCEL",
                                    Long.valueOf(reservationId));

                            if (refunded) {
                                log.info("사용 포인트 환불 완료: userId={}, points={}",
                                        reservation.getUserId(), reservation.getPointsUsed());
                            } else {
                                log.warn("사용 포인트 환불 실패: userId={}, points={}",
                                        reservation.getUserId(), reservation.getPointsUsed());
                            }
                        } catch (Exception pointEx) {
                            log.error("사용 포인트 환불 실패: userId={}, points={}",
                                    reservation.getUserId(), reservation.getPointsUsed(), pointEx);
                            // 포인트 환불 실패해도 예약 취소는 진행
                        }
                    }

                    sqlSession.commit();
                    log.info("예약 취소 완료: reservationId={}", reservationId);

                    // 텔레그램 알림 발송 (별도 try-catch로 실패해도 취소는 완료)
                    try {
                        String notificationMessage = String.format(
                                "❌ *예약 취소 알림*\n\n" +
                                "예약이 취소되었습니다.\n\n" +
                                "📌 예약번호: %d\n" +
                                "🏪 식당: %s\n" +
                                "📅 예약 시간: %s\n" +
                                "💬 취소 사유: %s\n\n" +
                                "포인트 및 쿠폰이 복구되었습니다.",
                                reservationId,
                                reservation.getRestaurantName() != null ? reservation.getRestaurantName() : "식당",
                                reservation.getFormattedReservationTime(),
                                cancelReason != null ? cancelReason : "미기재"
                        );

                        boolean sent = telegramService.sendMessageToUser(
                                reservation.getUserId(),
                                notificationMessage,
                                "RESERVATION_CANCEL",
                                "reservation",
                                Long.valueOf(reservationId)
                        );

                        if (sent) {
                            log.info("텔레그램 취소 알림 발송 완료: userId={}, reservationId={}",
                                    reservation.getUserId(), reservationId);
                        }

                    } catch (Exception telegramEx) {
                        log.warn("텔레그램 취소 알림 발송 중 오류: reservationId={}", reservationId, telegramEx);
                    }

                    return true;
                }
            } catch (Exception e) {
                log.error("예약 취소 처리 중 오류: reservationId={}", reservationId, e);
                e.printStackTrace();
                sqlSession.rollback();
            }
        }
        return false;
    }

    public boolean cancelReservation(int reservationId) {
        return cancelReservation(reservationId, null);
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

    /**
     * 특정 사업자의 입금 완료된 예약금 총액 조회 (출금 가능 금액)
     */
    public BigDecimal getTotalDepositByOwnerId(int ownerId) {
        return reservationDAO.getTotalDepositByOwnerId(ownerId);
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
