package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Logger import 추가
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import model.Coupon;
import model.Reservation;
import model.Restaurant;
import model.User;
import service.ReservationService;
import service.RestaurantService;
import service.UserCouponService;
import service.UserCouponService.CouponValidationResult;
import dao.ReservationSettingsDAO;
import service.payment.NaverPayService;
import service.payment.NaverPayService.NaverPayJsConfig;

@WebServlet("/reservation/*")
public class ReservationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	// Logger 변수 선언
	private static final Logger log = LoggerFactory.getLogger(ReservationServlet.class);

	private ReservationService reservationService = new ReservationService();
	private RestaurantService restaurantService = new RestaurantService();
	private ReservationSettingsDAO reservationSettingsDAO = new ReservationSettingsDAO();
	private final NaverPayService naverPayService = new NaverPayService();
	private final UserCouponService userCouponService = new UserCouponService();

	private boolean toBoolean(Object value) {
		if (value == null) {
			return false;
		}
		if (value instanceof Boolean) {
			return (Boolean) value;
		}
		if (value instanceof Number) {
			return ((Number) value).intValue() != 0;
		}
		if (value instanceof String) {
			String str = ((String) value).trim();
			return "true".equalsIgnoreCase(str) || "1".equals(str);
		}
		return false;
	}

	private BigDecimal toBigDecimal(Object value) {
		if (value == null) {
			return BigDecimal.ZERO;
		}
		if (value instanceof BigDecimal) {
			return (BigDecimal) value;
		}
		if (value instanceof Number) {
			return BigDecimal.valueOf(((Number) value).doubleValue());
		}
		if (value instanceof String) {
			String str = ((String) value).trim();
			if (!str.isEmpty()) {
				try {
					return new BigDecimal(str);
				} catch (NumberFormatException ignore) {
				}
			}
		}
		return BigDecimal.ZERO;
	}

	private LocalTime toLocalTime(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof java.sql.Time) {
			return ((java.sql.Time) value).toLocalTime();
		}
		if (value instanceof LocalTime) {
			return (LocalTime) value;
		}
		if (value instanceof String) {
			String str = ((String) value).trim();
			if (!str.isEmpty()) {
				return LocalTime.parse(str);
			}
		}
		return null;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String pathInfo = request.getPathInfo();
		log.debug("GET 요청 수신: pathInfo={}", pathInfo);

		try {
			if ("/create".equals(pathInfo)) {
				handleReservationCreateForm(request, response);
			} else if (pathInfo != null && pathInfo.startsWith("/detail/")) {
				handleReservationDetail(request, response, pathInfo);
			} else {
				response.sendRedirect(request.getContextPath() + "/mypage/reservations");
			}
		} catch (Exception e) {
			log.error("GET 요청 처리 중 예외 발생: pathInfo={}", pathInfo, e);
			request.setAttribute("errorMessage", "예약 페이지 처리 중 오류.");
			request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String pathInfo = request.getPathInfo();
		String action = request.getParameter("action");
		log.debug("POST 요청 수신: pathInfo={}, action={}", pathInfo, action);

		if ("/create".equals(pathInfo)) {
			handleReservationCreateSubmit(request, response);
		} else if ("/cancel".equals(pathInfo)) {
			handleReservationCancel(request, response);
		} else if ("getTimeSlots".equals(action)) {
			handleGetTimeSlots(request, response);
		} else {
			log.warn("잘못된 POST 요청 수신: pathInfo={}", pathInfo);
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	private void handleReservationCreateForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			// [ ✨ 1. 이전 페이지에서 사용자가 선택한 모든 정보를 파라미터로 받습니다 ✨ ]
			int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
			String reservationDate = request.getParameter("reservationDate");
			String reservationTime = request.getParameter("reservationTime"); // 가장 중요한 선택된 시간 값
			String partySize = request.getParameter("partySize");

			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

			if (restaurant != null) {
				// [ ✨ 2. 받은 모든 정보를 request attribute에 담아 JSP로 그대로 전달합니다 ✨ ]
				// 이렇게 해야 JSP에서 ${reservationTime} 등으로 값을 사용할 수 있습니다.
				request.setAttribute("restaurant", restaurant);
				request.setAttribute("reservationDate", reservationDate);
				request.setAttribute("reservationTime", reservationTime);
				request.setAttribute("partySize", partySize);

				// --- JSP의 시간 선택 <select> dropdown을 채우기 위한 로직 ---
				// 사용자가 예약 페이지에서 날짜를 변경할 경우를 대비해, 선택된 날짜의 전체 시간 목록을 다시 계산하여 전달합니다.
				LocalDate selectedDate = (reservationDate != null && !reservationDate.isEmpty())
						? LocalDate.parse(reservationDate)
						: LocalDate.now();
				int dayOfWeek = selectedDate.getDayOfWeek().getValue();

				java.util.Map<String, Object> settings = reservationSettingsDAO.findByRestaurantId(restaurantId);
				List<String> timeSlots = new ArrayList<>();

				if (settings != null && toBoolean(settings.get("reservation_enabled"))) {
					String dayKey = "";
					switch (dayOfWeek) {
					case 1:
						dayKey = "monday";
						break;
					case 2:
						dayKey = "tuesday";
						break;
					case 3:
						dayKey = "wednesday";
						break;
					case 4:
						dayKey = "thursday";
						break;
					case 5:
						dayKey = "friday";
						break;
					case 6:
						dayKey = "saturday";
						break;
					case 7:
						dayKey = "sunday";
						break;
					}

					if (!dayKey.isEmpty() && toBoolean(settings.get(dayKey + "_enabled"))) {
						LocalTime startTime = toLocalTime(settings.get(dayKey + "_start"));
						LocalTime endTime = toLocalTime(settings.get(dayKey + "_end"));
						if (startTime != null && endTime != null) {
							LocalTime currentTime = startTime;
							while (currentTime.isBefore(endTime)) {
								timeSlots.add(currentTime.format(DateTimeFormatter.ofPattern("HH:mm")));
								currentTime = currentTime.plusMinutes(30);
							}
						}
					}
				}
				request.setAttribute("timeSlots", timeSlots);
				// --- Time Slot 전달 로직 끝 ---

				request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);

			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "식당 정보를 찾을 수 없습니다.");
			}
		} catch (Exception e) {
			// 오류 발생 시 스택 트레이스를 출력하여 원인 파악을 돕습니다.
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 요청입니다.");
		}
	}

	private void handleReservationDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
			throws ServletException, IOException {
		try {
			int reservationId = Integer.parseInt(pathInfo.substring("/detail/".length()));
			log.debug("예약 상세 정보 요청: reservationId={}", reservationId);
			Reservation reservation = reservationService.getReservationById(reservationId);
			if (reservation != null) {
				if (reservation.getReservationTime() != null) {
					reservation.setReservationTimeAsDate(Timestamp.valueOf(reservation.getReservationTime()));
				}
				if (reservation.getCreatedAt() != null) {
					reservation.setCreatedAtAsDate(Timestamp.valueOf(reservation.getCreatedAt()));
				}
				if (reservation.getUpdatedAt() != null) {
					reservation.setUpdatedAtAsDate(Timestamp.valueOf(reservation.getUpdatedAt()));
				}
				if (reservation.getPaymentApprovedAt() != null) {
					reservation.setPaymentApprovedAtAsDate(Timestamp.valueOf(reservation.getPaymentApprovedAt()));
				}
				Restaurant restaurant = restaurantService.getRestaurantById(reservation.getRestaurantId());
				request.setAttribute("restaurant", restaurant);
				request.setAttribute("reservation", reservation);
				request.getRequestDispatcher("/WEB-INF/views/reservation-detail.jsp").forward(request, response);
			} else {
				log.warn("예약 정보를 찾을 수 없음: reservationId={}", reservationId);
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "예약 정보를 찾을 수 없습니다.");
			}
		} catch (NumberFormatException e) {
			log.error("잘못된 예약 ID 형식: pathInfo={}", pathInfo, e);
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 예약 ID");
		}
	}

	private void handleReservationCreateSubmit(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;

		if (user == null) {
			log.warn("로그인되지 않은 사용자의 예약 생성 시도");
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		int restaurantId = 0;
		try {
			restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
			String restaurantName = request.getParameter("restaurantName");
			String reservationDate = request.getParameter("reservationDate"); // "YYYY-MM-DD"
			if (reservationDate == null || reservationDate.trim().isEmpty()) {
				throw new Exception("예약 날짜를 선택해주세요.");
			}
			reservationDate = reservationDate.trim();

			String reservationTimeStr = request.getParameter("reservationTime"); // "HH:MM"
			if (reservationTimeStr == null || reservationTimeStr.trim().isEmpty()) {
				throw new Exception("예약 시간을 선택해주세요.");
			}
			reservationTimeStr = reservationTimeStr.trim();
			int partySize = Integer.parseInt(request.getParameter("partySize"));
			String contactPhone = request.getParameter("contactPhone");
			log.info("예약 생성 제출: userId={}, restaurantId={}, dateTime={}, partySize={}", user.getId(), restaurantId,
					reservationDate + "T" + reservationTimeStr, partySize);

			java.util.Map<String, Object> settings = reservationSettingsDAO.findByRestaurantId(restaurantId);

			if (settings == null || !toBoolean(settings.get("reservation_enabled"))) {
				throw new Exception("현재 예약을 받지 않는 음식점입니다.");
			}

			Object minObj = settings.get("min_party_size");
			Object maxObj = settings.get("max_party_size");
			int minPartySize = minObj instanceof Integer ? (Integer) minObj : 1;
			int maxPartySize = maxObj instanceof Integer ? (Integer) maxObj : 10;
			if (partySize < minPartySize || partySize > maxPartySize) {
				throw new Exception(String.format("예약 가능 인원은 %d명부터 %d명까지입니다.", minPartySize, maxPartySize));
			}

			LocalDate selectedDate = LocalDate.parse(reservationDate);
			LocalTime selectedTime = LocalTime.parse(reservationTimeStr);
			int dayOfWeek = selectedDate.getDayOfWeek().getValue();
			boolean isDayEnabled = false;
			LocalTime dayStart = null;
			LocalTime dayEnd = null;
			String dayKey = null;
			switch (dayOfWeek) {
			case 1:
				dayKey = "monday";
				break;
			case 2:
				dayKey = "tuesday";
				break;
			case 3:
				dayKey = "wednesday";
				break;
			case 4:
				dayKey = "thursday";
				break;
			case 5:
				dayKey = "friday";
				break;
			case 6:
				dayKey = "saturday";
				break;
			case 7:
				dayKey = "sunday";
				break;
			}
			if (dayKey != null) {
				isDayEnabled = toBoolean(settings.get(dayKey + "_enabled"));
				dayStart = toLocalTime(settings.get(dayKey + "_start"));
				dayEnd = toLocalTime(settings.get(dayKey + "_end"));
			}
			if (!isDayEnabled) {
				throw new Exception("선택하신 요일에는 예약을 받지 않습니다.");
			}
			if (dayStart == null || dayEnd == null) {
				throw new Exception("해당 요일의 예약 시간이 설정되어 있지 않습니다.");
			}
			if (selectedTime.isBefore(dayStart) || selectedTime.isAfter(dayEnd.minusMinutes(30))) {
				throw new Exception(
						String.format("예약 가능 시간은 %s부터 %s까지입니다.", dayStart.format(DateTimeFormatter.ofPattern("HH:mm")),
								dayEnd.minusMinutes(30).format(DateTimeFormatter.ofPattern("HH:mm"))));
			}

			LocalDateTime reservationDateTime = LocalDateTime.parse(reservationDate + "T" + reservationTimeStr);
			Reservation reservation = new Reservation(restaurantId, user.getId(), restaurantName, user.getNickname(),
					reservationDateTime, partySize, contactPhone);

			boolean depositRequired = toBoolean(settings.get("deposit_required"));
			BigDecimal depositAmount = depositRequired ? toBigDecimal(settings.get("deposit_amount")) : BigDecimal.ZERO;
			String depositDescription = (String) settings.get("deposit_description");

			// 쿠폰 선택만 저장 (할인은 가게에서 처리)
			String userCouponIdParam = request.getParameter("userCouponId");
			if (userCouponIdParam != null && !userCouponIdParam.trim().isEmpty()) {
				try {
					int userCouponId = Integer.parseInt(userCouponIdParam);
					log.info("쿠폰 선택: userCouponId={}, userId={}", userCouponId, user.getId());

					// 쿠폰 소유권 및 사용 가능 여부만 검증
					CouponValidationResult validationResult = userCouponService.validateCouponUsable(
							userCouponId, user.getId(), BigDecimal.ZERO);

					if (validationResult.isValid()) {
						// 예약에 쿠폰 ID만 저장 (할인은 적용하지 않음)
						reservation.setUserCouponId(userCouponId);
						log.info("쿠폰 선택 저장 완료: userCouponId={}", userCouponId);
					} else {
						log.warn("쿠폰 검증 실패: {}", validationResult.getMessage());
						throw new Exception("쿠폰 사용 불가: " + validationResult.getMessage());
					}
				} catch (NumberFormatException e) {
					log.error("잘못된 쿠폰 ID 형식: {}", userCouponIdParam);
					throw new Exception("잘못된 쿠폰 정보입니다.");
				}
			}

			reservation.setDepositRequired(depositRequired);
			reservation.setDepositAmount(depositAmount);
			reservation.setSpecialRequests(request.getParameter("specialRequests"));
			if (depositRequired && depositAmount != null && depositAmount.compareTo(BigDecimal.ZERO) > 0) {
				reservation.setPaymentStatus("PENDING");
				reservation.setPaymentProvider("NAVERPAY");
			} else {
				reservation.setPaymentStatus("NOT_REQUIRED");
			}

			boolean autoAccept = toBoolean(settings.get("auto_accept"));
			if (autoAccept) {
				reservation.setStatus("CONFIRMED");
			} else {
				reservation.setStatus("PENDING");
			}

			if (reservationService.createReservation(reservation)) {
				if (reservation.isDepositRequired() && reservation.getDepositAmount() != null
						&& reservation.getDepositAmount().compareTo(BigDecimal.ZERO) > 0) {
					if (!naverPayService.isConfigured()) {
						throw new Exception("네이버페이 설정이 완료되지 않았습니다. 관리자에게 문의해주세요.");
					}
					String merchantPayKey = naverPayService.generateMerchantPayKey(reservation.getId());
					reservation.setPaymentOrderId(merchantPayKey);
					reservationService.updatePaymentInfo(reservation.getId(), reservation.getPaymentStatus(),
							merchantPayKey, reservation.getPaymentProvider(), reservation.getPaymentApprovedAt(),
							reservation.getDepositAmount(), reservation.isDepositRequired());

					NaverPayJsConfig jsConfig = naverPayService.buildJsConfig(request, user, reservation,
							reservation.getDepositAmount());
					request.setAttribute("naverPayConfig", jsConfig);
					request.setAttribute("reservation", reservation);
					request.setAttribute("depositDescription", depositDescription);
					request.getRequestDispatcher("/WEB-INF/views/reservation-payment.jsp").forward(request, response);
					return;
				}
				response.sendRedirect(request.getContextPath() + "/mypage/reservations");
			} else {
				throw new Exception("예약 등록 실패 (DB insert 실패)");
			}

		} catch (DateTimeParseException e) {
			log.error("잘못된 날짜/시간 형식으로 예약 시도: restaurantId={}", restaurantId, e);
			request.setAttribute("errorMessage", "잘못된 날짜 또는 시간 형식입니다.");
			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
			request.setAttribute("restaurant", restaurant);
			request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
		} catch (Exception e) {
			log.error("예약 처리 중 오류 발생: restaurantId={}, userId={}", restaurantId, user.getId(), e);
			String message = e.getMessage();
			if (message == null || message.trim().isEmpty()) {
				message = "예약 처리 중 오류가 발생했습니다.";
			}
			request.setAttribute("errorMessage", message);
			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
			request.setAttribute("restaurant", restaurant);
			request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
		}
	}

	private void handleReservationCancel(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			log.warn("로그인되지 않은 사용자의 예약 취소 시도");
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "로그인이 필요합니다.");
			return;
		}

		try {
			int reservationId = Integer.parseInt(request.getParameter("reservationId"));
			User currentUser = (User) session.getAttribute("user");
			log.info("예약 취소 요청: reservationId={}, userId={}", reservationId, currentUser.getId());

			String cancelReason = request.getParameter("cancelReason");
			if (cancelReason == null || cancelReason.trim().isEmpty()) {
				log.warn("취소 사유 미입력으로 예약 취소 실패: reservationId={}", reservationId);
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"success\": false, \"message\": \"취소 사유를 입력해주세요.\"}");
				return;
			}
			cancelReason = cancelReason.trim();
			if (cancelReason.length() > 500) {
				log.warn("취소 사유 길이 초과로 예약 취소 실패: reservationId={}, length={}", reservationId, cancelReason.length());
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"success\": false, \"message\": \"취소 사유는 500자 이내로 입력해주세요.\"}");
				return;
			}

			Reservation reservation = reservationService.getReservationById(reservationId);
			if (reservation == null) {
				log.warn("존재하지 않는 예약에 대한 취소 시도: reservationId={}", reservationId);
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				response.getWriter().write("{\"success\": false, \"message\": \"예약을 찾을 수 없습니다.\"}");
				return;
			}

			if (reservation.getUserId() != currentUser.getId()) {
				log.error("타인의 예약 취소 시도 (보안 위협): 시도자 userId={}, 예약 소유자 userId={}, reservationId={}",
						currentUser.getId(), reservation.getUserId(), reservationId);
				response.setStatus(HttpServletResponse.SC_FORBIDDEN);
				response.getWriter().write("{\"success\": false, \"message\": \"본인의 예약만 취소할 수 있습니다.\"}");
				return;
			}

			if (reservationService.cancelReservation(reservationId, cancelReason)) {
				log.info("예약 취소 성공: reservationId={}", reservationId);
				response.getWriter().write("{\"success\": true}");
				// response.sendRedirect(request.getContextPath() + "/mypage/reservations");
			} else {
				log.error("예약 취소 실패 (서비스 로직 실패): reservationId={}", reservationId);
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"success\": false, \"message\": \"예약 취소에 실패했습니다.\"}");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
//			request.setAttribute("errorMessage", "예약 취소 처리 중 오류.");
//			request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
		}
	}

	private void handleGetTimeSlots(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
			String dateStr = request.getParameter("date");
			log.debug("AJAX 시간 슬롯 조회: restaurantId={}, date={}", restaurantId, dateStr);

			LocalDate selectedDate = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr)
					: LocalDate.now();
			int dayOfWeek = selectedDate.getDayOfWeek().getValue();

			java.util.Map<String, Object> settings = reservationSettingsDAO.findByRestaurantId(restaurantId);
			List<String> timeSlots = new ArrayList<>();

			if (settings != null) {
				boolean reservationEnabled = toBoolean(settings.get("reservation_enabled"));
				if (!reservationEnabled) {
					log.debug("예약 기능 비활성화됨: restaurantId={}", restaurantId);
					response.getWriter().write("{\"timeSlots\": [], \"message\": \"예약 기능이 비활성화되었습니다.\"}");
					return;
				}

				String blackoutDatesJson = (String) settings.get("blackout_dates");
				log.trace("블랙아웃 날짜 체크: blackoutDatesJson={}, selectedDate={}", blackoutDatesJson, selectedDate);
				if (blackoutDatesJson != null && !blackoutDatesJson.isEmpty()) {
					String dateString = selectedDate.toString();
					if (blackoutDatesJson.contains("\"" + dateString + "\"")) {
						log.debug("블랙아웃 날짜({}) 발견, 예약 불가 처리: restaurantId={}", selectedDate, restaurantId);
						response.getWriter().write("{\"timeSlots\": [], \"message\": \"해당 날짜는 예약이 불가능합니다.\"}");
						return;
					}
				}

				String dayKey = null;
				switch (dayOfWeek) {
				case 1:
					dayKey = "monday";
					break;
				case 2:
					dayKey = "tuesday";
					break;
				case 3:
					dayKey = "wednesday";
					break;
				case 4:
					dayKey = "thursday";
					break;
				case 5:
					dayKey = "friday";
					break;
				case 6:
					dayKey = "saturday";
					break;
				case 7:
					dayKey = "sunday";
					break;
				}

				if (dayKey != null && toBoolean(settings.get(dayKey + "_enabled"))) {
					LocalTime startTime = toLocalTime(settings.get(dayKey + "_start"));
					LocalTime endTime = toLocalTime(settings.get(dayKey + "_end"));

					if (startTime != null && endTime != null) {
						LocalTime currentTime = startTime;
						while (currentTime.isBefore(endTime)) {
							timeSlots.add(currentTime.format(DateTimeFormatter.ofPattern("HH:mm")));
							currentTime = currentTime.plusMinutes(30);
						}
					}
				}
			}

			Collections.sort(timeSlots);

			StringBuilder json = new StringBuilder();
			json.append("{\"timeSlots\": [");
			for (int i = 0; i < timeSlots.size(); i++) {
				if (i > 0)
					json.append(",");
				json.append("\"").append(timeSlots.get(i)).append("\"");
			}
			json.append("]}");

			response.getWriter().write(json.toString());

		} catch (Exception e) {
			log.error("시간 슬롯 조회 AJAX 처리 중 예외 발생", e);
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"시간 슬롯 조회 중 오류가 발생했습니다.\"}");
		}
	}
}