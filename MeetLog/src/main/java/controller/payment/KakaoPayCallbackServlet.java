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
import service.PointService;
import service.ReservationService;
import service.TelegramService;
import service.payment.KakaoPayService;
import service.payment.PaymentConfirmResult;

@WebServlet("/payment/kakao/callback")
public class KakaoPayCallbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger log = LoggerFactory.getLogger(KakaoPayCallbackServlet.class);

	private final KakaoPayService kakaoPayService = new KakaoPayService();
	private final ReservationService reservationService = new ReservationService();
	private final PointService pointService = new PointService();
	private final TelegramService telegramService = new TelegramService();
	private static final BigDecimal POINT_EARNING_RATE = new BigDecimal("0.01");

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String result = request.getParameter("result");

		if ("cancel".equals(result)) {
			log.info("KakaoPay payment cancelled by user.");
			redirectFailure(request, response, "사용자가 결제를 취소했습니다.");
			return;
		}

		if ("fail".equals(result)) {
			log.error("KakaoPay payment failed.");
			redirectFailure(request, response, "결제에 실패했습니다.");
			return;
		}

		// --- 결제 성공 시 (approval) ---
		String pgToken = request.getParameter("pg_token");
		HttpSession session = request.getSession(false);
		User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

		if (pgToken == null || session == null || currentUser == null) {
			log.error("Invalid access to KakaoPay approval callback. pg_token or session is null.");
			redirectFailure(request, response, "잘못된 접근입니다.");
			return;
		}

		String tid = (String) session.getAttribute("kakaoPayTid");
		String partnerOrderId = (String) session.getAttribute("kakaoPayPartnerOrderId");

		if (tid == null || partnerOrderId == null) {
			log.error("KakaoPay session attributes (tid, orderId) are missing.");
			redirectFailure(request, response, "결제 정보가 만료되었습니다.");
			return;
		}

		// 세션 정보 정리
		session.removeAttribute("kakaoPayTid");
		session.removeAttribute("kakaoPayPartnerOrderId");

		Reservation reservation = reservationService.getReservationByPaymentOrderId(partnerOrderId);
		if (reservation == null) {
			// partnerOrderId에서 reservationId를 추출하여 다시 시도
			int reservationId = extractReservationId(partnerOrderId);
			if (reservationId > 0) {
				reservation = reservationService.getReservationById(reservationId);
			}
		}

		if (reservation == null) {
			log.error("Cannot find reservation for kakaoPay callback. partnerOrderId={}", partnerOrderId);
			redirectFailure(request, response, "예약 정보를 찾을 수 없습니다.");
			return;
		}

		String partnerUserId = "USER-" + reservation.getUserId();

		// 최종 결제 승인 요청
		PaymentConfirmResult confirmResult = kakaoPayService.approvePayment(pgToken, tid, partnerOrderId,
				partnerUserId);

		if (confirmResult.isSuccess()) {
			log.info("KakaoPay approval success. reservationId={}, aid={}", reservation.getId(),
					confirmResult.getPaymentId());
			// DB에 결제 성공 정보 업데이트
			reservation.setPaymentStatus("PAID");
			reservation.setPaymentOrderId(partnerOrderId); // 최종 주문 ID로 업데이트
			reservation.setPaymentApprovedAt(java.time.LocalDateTime.now());
			reservation.setStatus("CONFIRMED");
			reservation.setPaymentProvider("KAKAOPAY");

			persistPayment(reservation);
			handlePaymentSuccessBenefits(reservation);
			reservationService.updateReservationStatus(reservation.getId(), reservation.getStatus());
			redirectSuccess(request, response);

		} else {
			log.error("KakaoPay approval failed. reservationId={}, reason={}", reservation.getId(),
					confirmResult.getMessage());
			reservation.setPaymentStatus("FAILED");
			reservation.setPaymentProvider("KAKAOPAY");
			persistPayment(reservation);
			redirectFailure(request, response, "결제 최종 승인에 실패했습니다: " + confirmResult.getMessage());
		}
	}

	// NaverPayCallbackServlet에 있던 메소드들을 재사용
	private void persistPayment(Reservation reservation) {
		reservationService.updatePaymentInfo(reservation.getId(), reservation.getPaymentStatus(),
				reservation.getPaymentOrderId(), reservation.getPaymentProvider(), reservation.getPaymentApprovedAt(),
				reservation.getDepositAmount(), reservation.isDepositRequired());
	}

	private void handlePaymentSuccessBenefits(Reservation reservation) {
		try {
			BigDecimal paymentAmount = reservation.getDepositAmount();
			if (paymentAmount != null && paymentAmount.compareTo(BigDecimal.ZERO) > 0) {
				int pointsToEarn = paymentAmount.multiply(POINT_EARNING_RATE).setScale(0, RoundingMode.DOWN).intValue();
				if (pointsToEarn > 0) {
					pointService.awardPoints(reservation.getUserId(), pointsToEarn, "PAYMENT",
							(long) reservation.getId(), "예약 결제 적립");
					reservation.setPointsEarned(pointsToEarn);
				}
			}
			// 텔레그램 알림 등
			telegramService.sendMessageToUser(reservation.getUserId(),
					"카카오페이로 예약금 " + reservation.getDepositAmount() + "원 결제가 완료되었습니다.", "PAYMENT_SUCCESS", "reservation",
					(long) reservation.getId());

		} catch (Exception e) {
			log.error("Error processing benefits for reservationId={}", reservation.getId(), e);
		}
	}

	private void redirectSuccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.sendRedirect(request.getContextPath() + "/mypage/reservations?payment=success");
	}

	private void redirectFailure(HttpServletRequest request, HttpServletResponse response, String message)
			throws IOException {
		String redirectUrl = request.getContextPath() + "/mypage/reservations?payment=failure&message="
				+ URLEncoder.encode(message, StandardCharsets.UTF_8);
		response.sendRedirect(redirectUrl);
	}

	private int extractReservationId(String partnerOrderId) {
		if (partnerOrderId == null || !partnerOrderId.startsWith("RES-"))
			return -1;
		try {
			return Integer.parseInt(partnerOrderId.split("-")[1]);
		} catch (Exception e) {
			return -1;
		}
	}
}