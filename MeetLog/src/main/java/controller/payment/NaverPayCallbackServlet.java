package controller.payment;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import model.Reservation;
import model.User;
import service.ReservationService;
import service.UserCouponService;
import service.PointService;
import service.TelegramService;
import service.payment.NaverPayService;
import service.payment.NaverPayService.PaymentConfirmResult;
import dao.CouponDAO;

@WebServlet("/payment/naver/return")
public class NaverPayCallbackServlet extends HttpServlet {
	private static final Logger log = LoggerFactory.getLogger(NaverPayCallbackServlet.class);
    private static final long serialVersionUID = 1L;
    private static final String SUCCESS_CODE = "Success";

    private final ReservationService reservationService = new ReservationService();
    private final NaverPayService naverPayService = new NaverPayService();
    private final UserCouponService userCouponService = new UserCouponService();
    private final PointService pointService = new PointService();
    private final TelegramService telegramService = new TelegramService();
    private final CouponDAO couponDAO = new CouponDAO();

    // 포인트 적립률: 결제 금액의 1% (설정으로 분리 가능)
    private static final BigDecimal POINT_EARNING_RATE = new BigDecimal("0.01");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resultCode = request.getParameter("resultCode");
        String resultMessage = request.getParameter("resultMessage");
        String merchantPayKey = request.getParameter("merchantPayKey");
        String paymentId = request.getParameter("paymentId");
        String errorMessage = request.getParameter("errorMessage");
        String reservationIdParam = request.getParameter("reservationId");

        log.info("NaverPay return received: resultCode={}, merchantPayKey={}, paymentId={}, reservationIdParam={}",
                resultCode, merchantPayKey, paymentId, reservationIdParam);

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("user") : null;

        // merchantPayKey는 네이버페이 콜백에서 전달되지 않을 수 있으므로 체크 제거
        // if (merchantPayKey == null || merchantPayKey.isBlank()) {
        //     redirectFailure(request, response, "INVALID_PAY_KEY");
        //     return;
        // }

        int reservationId = parseInt(reservationIdParam);
        log.info("Parsed reservationId from param: {}", reservationId);

        if (reservationId <= 0) {
            reservationId = extractReservationId(merchantPayKey);
            log.info("Extracted reservationId from merchantPayKey: {}", reservationId);
        }

        Reservation reservation = reservationId > 0
                ? reservationService.getReservationById(reservationId)
                : null;
        log.info("Reservation lookup by ID {}: {}", reservationId, reservation != null ? "found" : "null");

        if (reservation == null && merchantPayKey != null && !merchantPayKey.isBlank()) {
            reservation = reservationService.getReservationByPaymentOrderId(merchantPayKey);
            log.info("Reservation lookup by merchantPayKey {}: {}", merchantPayKey, reservation != null ? "found" : "null");
        }

        if (reservation == null) {
            log.error("Reservation not found! reservationIdParam={}, merchantPayKey={}", reservationIdParam, merchantPayKey);
            redirectFailure(request, response, "RESERVATION_NOT_FOUND");
            return;
        }

        if (reservationId <= 0) {
            reservationId = reservation.getId();
        }

        if (currentUser == null || reservation.getUserId() != currentUser.getId()) {
            redirectFailure(request, response, "UNAUTHORIZED");
            return;
        }

        log.info("Payment info check: reservationId={}, paymentOrderId={}, incoming merchantPayKey={}",
                reservationId, reservation.getPaymentOrderId(), merchantPayKey);

        if (merchantPayKey != null && !merchantPayKey.isBlank()) {
            if (reservation.getPaymentOrderId() == null || reservation.getPaymentOrderId().isBlank()) {
                log.debug("Assigning merchantPayKey {} to reservation {}", merchantPayKey, reservationId);
                reservation.setPaymentOrderId(merchantPayKey);
            } else if (!reservation.getPaymentOrderId().equals(merchantPayKey)) {
                log.warn("merchantPayKey mismatch. existing={}, incoming={}. Updating to incoming.", reservation.getPaymentOrderId(), merchantPayKey);
                reservation.setPaymentOrderId(merchantPayKey);
            }
        } else if (reservation.getPaymentOrderId() != null) {
            merchantPayKey = reservation.getPaymentOrderId();
            log.info("Using existing paymentOrderId {} as merchantPayKey.", merchantPayKey);
        } else {
            log.error("No merchantPayKey available! reservationId={}, paymentOrderId is null", reservationId);
        }

        if (!SUCCESS_CODE.equalsIgnoreCase(resultCode)) {
            handleFailure(reservation, merchantPayKey, request, response,
                    resultMessage != null ? resultMessage : errorMessage);
            return;
        }

        if (!reservation.isDepositRequired()) {
            handleFailure(reservation, merchantPayKey, request, response, "DEPOSIT_NOT_REQUIRED");
            return;
        }

        BigDecimal expectedAmount = reservation.getDepositAmount();
        if (expectedAmount == null || expectedAmount.compareTo(BigDecimal.ZERO) <= 0) {
            handleFailure(reservation, merchantPayKey, request, response, "INVALID_DEPOSIT_AMOUNT");
            return;
        }

        if (merchantPayKey == null || merchantPayKey.isBlank()) {
            merchantPayKey = reservation.getPaymentOrderId();
        }
        if (merchantPayKey == null || merchantPayKey.isBlank()) {
            merchantPayKey = "RES-" + reservation.getId();
            log.warn("merchantPayKey missing. Using fallback key {}.", merchantPayKey);
        }

        PaymentConfirmResult confirmResult = naverPayService.confirmPayment(
                paymentId,
                merchantPayKey,
                expectedAmount,
                "USER-" + reservation.getUserId());

        if (!confirmResult.isSuccess()
                && naverPayService.isFallbackOnFailure()
                && SUCCESS_CODE.equalsIgnoreCase(resultCode)) {
            String fallbackPaymentId = confirmResult.getPaymentId();
            if (fallbackPaymentId == null || fallbackPaymentId.isBlank()) {
                fallbackPaymentId = paymentId != null && !paymentId.isBlank() ? paymentId : merchantPayKey;
            }
            confirmResult = PaymentConfirmResult.success(
                    fallbackPaymentId,
                    SUCCESS_CODE,
                    "Development fallback",
                    confirmResult.getRawResponse()
            );
        }

        if (confirmResult.isSuccess()) {
            naverPayService.markPaymentSuccess(reservation, merchantPayKey);
            persistPayment(reservation);
            handlePaymentSuccessBenefits(reservation);  // 쿠폰 사용 처리 & 포인트 적립
            reservationService.updateReservationStatus(reservation.getId(), reservation.getStatus());
            redirectSuccess(request, response);
        } else if (naverPayService.isAutoApproveOnReturn() && SUCCESS_CODE.equalsIgnoreCase(resultCode)) {
            log.info("Auto-approving payment on return (dev mode fallback): reservationId={}, merchantPayKey={}",
                    reservation.getId(), merchantPayKey);
            naverPayService.markPaymentSuccess(reservation, merchantPayKey);
            persistPayment(reservation);
            handlePaymentSuccessBenefits(reservation);  // 쿠폰 사용 처리 & 포인트 적립
            reservationService.updateReservationStatus(reservation.getId(), reservation.getStatus());
            redirectSuccess(request, response);
        } else {
            String message = confirmResult.getMessage() != null ? confirmResult.getMessage() : errorMessage;
            handleFailure(reservation, merchantPayKey, request, response, message);
        }
    }

    private void persistPayment(Reservation reservation) {
        reservationService.updatePaymentInfo(
                reservation.getId(),
                reservation.getPaymentStatus(),
                reservation.getPaymentOrderId(),
                reservation.getPaymentProvider(),
                reservation.getPaymentApprovedAt(),
                reservation.getDepositAmount(),
                reservation.isDepositRequired());
    }

    /**
     * 결제 성공 시 포인트 적립 및 텔레그램 알림
     * (쿠폰 사용은 가게에서 처리하므로 여기서는 하지 않음)
     *
     * @param reservation 예약 정보
     */
    private void handlePaymentSuccessBenefits(Reservation reservation) {
        try {
            // 1. 포인트 적립
            BigDecimal paymentAmount = reservation.getDepositAmount();
            if (paymentAmount != null && paymentAmount.compareTo(BigDecimal.ZERO) > 0) {
                // 결제 금액의 1% 적립 (소수점 버림)
                int pointsToEarn = paymentAmount.multiply(POINT_EARNING_RATE)
                        .setScale(0, RoundingMode.DOWN)
                        .intValue();

                if (pointsToEarn > 0) {
                    log.info("Awarding points: userId={}, amount={}, reservationId={}",
                            reservation.getUserId(), pointsToEarn, reservation.getId());

                    boolean pointsAwarded = pointService.awardPoints(
                            reservation.getUserId(),
                            pointsToEarn,
                            "PAYMENT",
                            Long.valueOf(reservation.getId()),
                            "예약 결제 적립 (예약번호: " + reservation.getId() + ")");

                    if (pointsAwarded) {
                        log.info("Points awarded successfully: userId={}, points={}",
                                reservation.getUserId(), pointsToEarn);
                        reservation.setPointsEarned(pointsToEarn);
                    } else {
                        log.warn("Failed to award points: userId={}, amount={}",
                                reservation.getUserId(), pointsToEarn);
                    }
                }
            }

            // 2. 텔레그램 알림 발송
            try {
                String notificationMessage = String.format(
                        "💳 *결제 완료 알림*\n\n" +
                        "예약이 성공적으로 결제되었습니다!\n\n" +
                        "📌 예약번호: %d\n" +
                        "🏪 식당: %s\n" +
                        "💰 결제 금액: %,d원\n" +
                        "📅 예약 시간: %s\n\n" +
                        "예약 확인 및 관리는 마이페이지에서 가능합니다.",
                        reservation.getId(),
                        reservation.getRestaurantName() != null ? reservation.getRestaurantName() : "식당",
                        reservation.getDepositAmount().intValue(),
                        reservation.getFormattedReservationTime()
                );

                boolean sent = telegramService.sendMessageToUser(
                        reservation.getUserId(),
                        notificationMessage,
                        "PAYMENT_SUCCESS",
                        "reservation",
                        Long.valueOf(reservation.getId())
                );

                if (sent) {
                    log.info("텔레그램 결제 알림 발송 완료: userId={}, reservationId={}",
                            reservation.getUserId(), reservation.getId());
                } else {
                    log.debug("텔레그램 연결 없음 또는 발송 실패: userId={}", reservation.getUserId());
                }

            } catch (Exception telegramEx) {
                log.warn("텔레그램 알림 발송 중 오류: reservationId={}", reservation.getId(), telegramEx);
                // 알림 실패해도 결제는 성공 처리
            }

        } catch (Exception e) {
            // 쿠폰/포인트 처리 실패해도 결제 자체는 성공 상태 유지
            // 로그만 남기고 계속 진행
            log.error("Error processing payment benefits (coupon/points): reservationId={}",
                    reservation.getId(), e);
        }
    }

    private void handleFailure(Reservation reservation,
                               String merchantPayKey,
                               HttpServletRequest request,
                               HttpServletResponse response,
                               String message) throws IOException {
        naverPayService.markPaymentFailure(reservation, merchantPayKey);
        persistPayment(reservation);
        String msg = message != null ? message : "PAYMENT_FAILED";
        redirectFailure(request, response, msg);
    }

    private void redirectSuccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/mypage/reservations?payment=success");
    }

    private void redirectFailure(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        String redirect = request.getContextPath() + "/mypage/reservations?payment=failure";
        if (message != null && !message.isBlank()) {
            redirect += "&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8);
        }
        response.sendRedirect(redirect);
    }

    private int extractReservationId(String merchantPayKey) {
        if (merchantPayKey == null || merchantPayKey.isBlank()) {
            return -1;
        }
        try {
            if (merchantPayKey.startsWith("RES-")) {
                String[] parts = merchantPayKey.split("-");
                if (parts.length >= 2) {
                    return Integer.parseInt(parts[1]);
                }
            }
        } catch (NumberFormatException ignore) {
        }
        return -1;
    }

    private int parseInt(String value) {
        if (value == null || value.isBlank()) {
            return -1;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}
