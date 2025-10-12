package controller.payment;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Reservation;
import model.User;
import service.ReservationService;
import service.payment.NaverPayService;
import service.payment.KakaoPayService; // ✨ 1. KakaoPayService를 import 합니다.

@WebServlet("/payment/methods")
public class PaymentMethodServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final ReservationService reservationService = new ReservationService();
	private final NaverPayService naverPayService = new NaverPayService();
	private final KakaoPayService kakaoPayService = new KakaoPayService(); // ✨ 2. KakaoPayService 객체를 생성합니다.

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		String reservationIdStr = request.getParameter("reservationId");

		if (user == null || reservationIdStr == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 접근입니다.");
			return;
		}

		try {
			int reservationId = Integer.parseInt(reservationIdStr);
			Reservation reservation = reservationService.getReservationById(reservationId);

			if (reservation == null || reservation.getUserId() != user.getId()) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
				return;
			}

			// 각 결제 수단에 필요한 설정 정보들을 생성
			Object naverPayConfig = naverPayService.buildPaymentRequest(request, user, reservation);
			Object kakaoPayConfig = kakaoPayService.buildPaymentRequest(request, user, reservation); // ✨ 3. 카카오페이 결제 준비
																										// 요청을 보냅니다.

			// JSP에 전달할 데이터 맵
			Map<String, Object> paymentConfigs = new HashMap<>();
			paymentConfigs.put("NAVERPAY", naverPayConfig);
			paymentConfigs.put("KAKAOPAY", kakaoPayConfig); // ✨ 4. 생성된 카카오페이 정보를 맵에 추가합니다.

			request.setAttribute("reservation", reservation);
			request.setAttribute("paymentConfigs", paymentConfigs);

			request.getRequestDispatcher("/WEB-INF/views/payment-methods.jsp").forward(request, response);

		} catch (Exception e) {
			// 예외 처리
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "결제 페이지를 준비하는 중 오류가 발생했습니다.");
		}
	}
}