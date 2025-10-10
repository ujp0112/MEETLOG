package controller.payment;

import java.io.IOException;
import java.math.BigDecimal;
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
import service.payment.NaverPayService;
import service.payment.NaverPayService.PaymentConfirmResult;

@WebServlet("/payment/naver/return")
public class NaverPayCallbackServlet extends HttpServlet {
	private static final Logger log = LoggerFactory.getLogger(NaverPayCallbackServlet.class);
    private static final long serialVersionUID = 1L;
    private static final String SUCCESS_CODE = "Success";

    private final ReservationService reservationService = new ReservationService();
    private final NaverPayService naverPayService = new NaverPayService();

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
            reservationService.updateReservationStatus(reservation.getId(), reservation.getStatus());
            redirectSuccess(request, response);
        } else if (naverPayService.isAutoApproveOnReturn() && SUCCESS_CODE.equalsIgnoreCase(resultCode)) {
            log.info("Auto-approving payment on return (dev mode fallback): reservationId={}, merchantPayKey={}",
                    reservation.getId(), merchantPayKey);
            naverPayService.markPaymentSuccess(reservation, merchantPayKey);
            persistPayment(reservation);
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
