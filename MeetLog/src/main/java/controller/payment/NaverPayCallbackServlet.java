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
// ✨ CHANGED: 외부 클래스로 분리된 PaymentConfirmResult를 import 합니다.
import service.payment.PaymentConfirmResult;
import dao.CouponDAO;

@WebServlet("/payment/naver/return")
public class NaverPayCallbackServlet extends HttpServlet {
	private static final Logger log = LoggerFactory.getLogger(NaverPayCallbackServlet.class);
	private static final long serialVersionUID = 1L;
	private static final String SUCCESS_CODE = "Success";

	private final ReservationService reservationService = new ReservationService();
	private final NaverPayService naverPayService = new NaverPayService();
	// (다른 서비스 필드들은 그대로 유지)
	private final PointService pointService = new PointService();
	private final TelegramService telegramService = new TelegramService();

	private static final BigDecimal POINT_EARNING_RATE = new BigDecimal("0.01");

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String resultCode = request.getParameter("resultCode");
		String merchantPayKeyFromParam = request.getParameter("merchantPayKey");
		String reservationIdParam = request.getParameter("reservationId");

		log.info("NaverPay return received: resultCode={}, merchantPayKey={}, reservationId={}", resultCode,
				merchantPayKeyFromParam, reservationIdParam);

		HttpSession session = request.getSession(false);
		User currentUser = session != null ? (User) session.getAttribute("user") : null;

		Reservation reservation = findReservationFromRequest(request);

		if (reservation == null) {
			log.error("Reservation not found from request: reservationIdParam={}, merchantPayKey={}",
					reservationIdParam, merchantPayKeyFromParam);
			redirectFailure(request, response, "RESERVATION_NOT_FOUND");
			return;
		}

		if (currentUser == null || reservation.getUserId() != currentUser.getId()) {
			log.warn("Unauthorized access attempt on payment callback. currentUser={}, reservationOwner={}",
					currentUser != null ? currentUser.getId() : "null", reservation.getUserId());
			redirectFailure(request, response, "UNAUTHORIZED");
			return;
		}

		// ✨ CHANGED: 새로운 인터페이스 방식에 맞게 confirmPayment 메소드 호출을 변경합니다.
		// 기존의 복잡한 파라미터 전달 방식 대신, request 객체 하나만 넘겨줍니다.
		PaymentConfirmResult confirmResult = naverPayService.confirmPayment(request);

		if (confirmResult.isSuccess()) {
			// 성공 로직
			log.info("Payment confirmation success for reservationId={}", reservation.getId());
			naverPayService.markPaymentSuccess(reservation, confirmResult.getOrderId());
			persistPayment(reservation);

			// 포인트 적립, 쿠폰 처리 등
			handlePaymentSuccessBenefits(reservation);
			reservationService.updateReservationStatus(reservation.getId(), reservation.getStatus());
			redirectSuccess(request, response);
		} else {
			// 실패 로직
			log.warn("Payment confirmation failed for reservationId={}. Reason: {}", reservation.getId(),
					confirmResult.getMessage());
			naverPayService.markPaymentFailure(reservation, confirmResult.getOrderId());
			persistPayment(reservation);
			redirectFailure(request, response, confirmResult.getMessage());
		}
	}

	/**
	 * 요청 파라미터로부터 예약 정보를 조회하는 헬퍼 메소드
	 */
	private Reservation findReservationFromRequest(HttpServletRequest request) {
		String reservationIdParam = request.getParameter("reservationId");
		String merchantPayKey = request.getParameter("merchantPayKey");
		int reservationId = -1;

		if (reservationIdParam != null && !reservationIdParam.isBlank()) {
			try {
				reservationId = Integer.parseInt(reservationIdParam);
			} catch (NumberFormatException e) {
				/* 무시 */ }
		} else if (merchantPayKey != null && !merchantPayKey.isBlank()) {
			reservationId = extractReservationId(merchantPayKey);
		}

		if (reservationId > 0) {
			return reservationService.getReservationById(reservationId);
		}
		if (merchantPayKey != null && !merchantPayKey.isBlank()) {
			return reservationService.getReservationByPaymentOrderId(merchantPayKey);
		}
		return null;
	}

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
							Long.valueOf(reservation.getId()), "예약 결제 적립 (예약번호: " + reservation.getId() + ")");
					reservation.setPointsEarned(pointsToEarn);
				}
			}

			String notificationMessage = String.format(
					"💳 *결제 완료 알림*\n\n" + "예약이 성공적으로 결제되었습니다!\n\n" + "📌 예약번호: %d\n" + "🏪 식당: %s\n"
							+ "💰 결제 금액: %,d원\n" + "📅 예약 시간: %s\n\n" + "예약 확인 및 관리는 마이페이지에서 가능합니다.",
					reservation.getId(), reservation.getRestaurantName(), reservation.getDepositAmount().intValue(),
					reservation.getFormattedReservationTime());

			telegramService.sendMessageToUser(reservation.getUserId(), notificationMessage, "PAYMENT_SUCCESS",
					"reservation", Long.valueOf(reservation.getId()));

		} catch (Exception e) {
			log.error("Error processing payment benefits (points/telegram): reservationId={}", reservation.getId(), e);
		}
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
}