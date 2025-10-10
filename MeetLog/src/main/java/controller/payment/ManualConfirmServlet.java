package controller.payment;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Reservation;
import service.ReservationService;
import service.payment.NaverPayService;

@WebServlet("/payment/naver/manual-confirm")
public class ManualConfirmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ReservationService reservationService = new ReservationService();
    private final NaverPayService naverPayService = new NaverPayService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resultCode = request.getParameter("resultCode");
        String merchantPayKey = request.getParameter("merchantPayKey");
        String paymentId = request.getParameter("paymentId");

        if (resultCode == null || merchantPayKey == null || paymentId == null) {
            response.sendRedirect(request.getContextPath() + "/mypage/reservations?payment=failure&message=invalid_params");
            return;
        }

        int reservationId = extractReservationId(merchantPayKey);
        Reservation reservation = reservationService.getReservationById(reservationId);
        if (reservation == null) {
            response.sendRedirect(request.getContextPath() + "/mypage/reservations?payment=failure&message=reservation_not_found");
            return;
        }

        if (!naverPayService.isSkipConfirm()) {
            response.sendRedirect(request.getContextPath() + "/mypage/reservations?payment=failure&message=not_allowed");
            return;
        }

        // 개발 환경에서는 바로 결제 완료 처리
        if ("Success".equalsIgnoreCase(resultCode)) {
            naverPayService.markPaymentSuccess(reservation, merchantPayKey);
            reservation.setPaymentProvider("NAVERPAY");
            reservationService.updatePaymentInfo(
                    reservation.getId(),
                    reservation.getPaymentStatus(),
                    reservation.getPaymentOrderId(),
                    reservation.getPaymentProvider(),
                    reservation.getPaymentApprovedAt(),
                    reservation.getDepositAmount() != null ? reservation.getDepositAmount() : BigDecimal.ZERO,
                    reservation.isDepositRequired());
            reservationService.updateReservationStatus(reservation.getId(), reservation.getStatus());
            response.sendRedirect(request.getContextPath() + "/mypage/reservations?payment=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/mypage/reservations?payment=failure&message=" + resultCode);
        }
    }

    private int extractReservationId(String merchantPayKey) {
        try {
            if (merchantPayKey != null && merchantPayKey.startsWith("RES-")) {
                String[] parts = merchantPayKey.split("-");
                if (parts.length >= 2) {
                    return Integer.parseInt(parts[1]);
                }
            }
        } catch (NumberFormatException ignored) {
        }
        return -1;
    }
}
