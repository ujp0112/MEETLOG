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

import model.Reservation;
import model.Restaurant;
import model.User;
import service.ReservationService;
import service.RestaurantService;
import dao.ReservationSettingsDAO;
import service.payment.NaverPayService;
import service.payment.NaverPayService.NaverPayJsConfig;

// [아키텍처 오류 수정] 기존 JDBC 서블릿을 삭제하고 Service 계층을 사용하는 컨트롤러로 변경합니다.
//
@WebServlet("/reservation/*")
public class ReservationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ReservationService reservationService = new ReservationService();
	private RestaurantService restaurantService = new RestaurantService();
	private ReservationSettingsDAO reservationSettingsDAO = new ReservationSettingsDAO();
	private final NaverPayService naverPayService = new NaverPayService();

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

		try {
			if ("/create".equals(pathInfo)) {
				// 예약 폼 페이지 요청 (restaurantId 쿼리 파라미터 필요)
				handleReservationCreateForm(request, response);
			} else if (pathInfo != null && pathInfo.startsWith("/detail/")) {
				// 예약 상세 페이지 요청 (예: /reservation/detail/1)
				handleReservationDetail(request, response, pathInfo);
			} else {
				// 그 외 경로는 내 예약 목록으로 보냄
				response.sendRedirect(request.getContextPath() + "/mypage/reservations");
			}
		} catch (Exception e) {
			e.printStackTrace();
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

		if ("/create".equals(pathInfo)) {
			// 예약 폼 제출
			handleReservationCreateSubmit(request, response);
		} else if ("/cancel".equals(pathInfo)) {
			// 예약 취소 요청 (my-reservations.jsp에서 호출)
			handleReservationCancel(request, response);
		} else if ("getTimeSlots".equals(action)) {
			// 시간 슬롯 조회 (AJAX 요청)
			handleGetTimeSlots(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	private void handleReservationCreateForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 예약 폼을 보여주기 전, 대상 식당 정보가 필요합니다.
		try {
			int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
			if (restaurant != null) {
// --- ▼▼▼ [ReservationSettings 연동] 시간 슬롯 계산 로직 ▼▼▼ ---

				// 1. 파라미터로 받은 날짜 확인 (없으면 오늘 날짜)
				String dateStr = request.getParameter("reservationDate");
				LocalDate selectedDate = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr)
						: LocalDate.now();
				int dayOfWeek = selectedDate.getDayOfWeek().getValue(); // 1=월요일, 7=일요일

				// 2. 해당 가게의 예약 설정 정보 조회
				List<String> timeSlots = new ArrayList<>();

				// 3. DAO를 통한 예약 설정 조회
				java.util.Map<String, Object> settings = reservationSettingsDAO.findByRestaurantId(restaurantId);

				System.out.println("=== 예약 설정 디버깅 ===");
				System.out.println("Restaurant ID: " + restaurantId);
				System.out.println("Selected Date: " + selectedDate + " (요일: " + dayOfWeek + ")");
				System.out.println("Settings found: " + (settings != null));
				if (settings != null) {
					System.out.println("Settings data: " + settings);
					System.out.println("Reservation enabled: " + settings.get("reservation_enabled"));
				}

				// 설정이 있고 예약이 활성화된 경우 실제 설정 사용, 없으면 기본 설정
				boolean useActualSettings = (settings != null && toBoolean(settings.get("reservation_enabled")));

				if (settings == null) {
					System.out.println("⚠️ 예약 설정이 없어서 기본 시간 슬롯을 생성합니다.");
				} else if (!useActualSettings) {
					System.out.println("⚠️ 예약이 비활성화되어 있어서 기본 시간 슬롯을 생성합니다.");
				} else {
					System.out.println("✅ 예약 설정이 활성화되어 있습니다. 실제 설정을 사용합니다.");
				}

				// 4. 시간 슬롯 생성 (실제 설정 또는 기본 설정)
				LocalTime startTime = LocalTime.of(11, 0); // 기본 시작 시간
				LocalTime endTime = LocalTime.of(21, 0);   // 기본 종료 시간

				if (useActualSettings) {
					// 실제 설정이 있는 경우 요일별 시간 사용
					String dayColumn = "";
					String startColumn = "";
					String endColumn = "";

					switch (dayOfWeek) {
						case 1: dayColumn = "monday_enabled"; startColumn = "monday_start"; endColumn = "monday_end"; break;
						case 2: dayColumn = "tuesday_enabled"; startColumn = "tuesday_start"; endColumn = "tuesday_end"; break;
						case 3: dayColumn = "wednesday_enabled"; startColumn = "wednesday_start"; endColumn = "wednesday_end"; break;
						case 4: dayColumn = "thursday_enabled"; startColumn = "thursday_start"; endColumn = "thursday_end"; break;
						case 5: dayColumn = "friday_enabled"; startColumn = "friday_start"; endColumn = "friday_end"; break;
						case 6: dayColumn = "saturday_enabled"; startColumn = "saturday_start"; endColumn = "saturday_end"; break;
						case 7: dayColumn = "sunday_enabled"; startColumn = "sunday_start"; endColumn = "sunday_end"; break;
					}

					boolean dayEnabled = toBoolean(settings.get(dayColumn));
					if (dayEnabled) {
						LocalTime configuredStart = toLocalTime(settings.get(startColumn));
						LocalTime configuredEnd = toLocalTime(settings.get(endColumn));
						if (configuredStart != null && configuredEnd != null) {
							startTime = configuredStart;
							endTime = configuredEnd;
							System.out.println("실제 설정 사용 - " + startColumn + ": " + startTime + " ~ " + endTime);
						}
					} else {
						System.out.println("해당 요일(" + dayOfWeek + ")은 예약 불가능합니다.");
						// 예약 불가능한 요일이면 빈 슬롯 반환
						timeSlots = new ArrayList<>();
					}
				}

				if (!timeSlots.isEmpty() || !useActualSettings) {
					System.out.println("최종 예약 시간: " + startTime + " ~ " + endTime);

					// 5. 30분 간격으로 시간 슬롯 생성
					LocalTime currentTime = startTime;
					while (currentTime.isBefore(endTime)) {
						timeSlots.add(currentTime.format(DateTimeFormatter.ofPattern("HH:mm")));
						currentTime = currentTime.plusMinutes(30);
					}
					System.out.println("생성된 시간 슬롯 수: " + timeSlots.size());
				}

				Collections.sort(timeSlots);

				// 6. 계산된 시간 목록을 request에 저장
				request.setAttribute("timeSlots", timeSlots);
				request.setAttribute("selectedDate", selectedDate);
				request.setAttribute("lunchStart", LocalTime.of(12, 0));
				request.setAttribute("dinnerStart", LocalTime.of(17, 0));
				boolean depositRequired = settings != null && toBoolean(settings.get("deposit_required"));
				request.setAttribute("depositRequired", depositRequired);
				request.setAttribute("depositAmount", settings != null ? toBigDecimal(settings.get("deposit_amount")) : BigDecimal.ZERO);
				request.setAttribute("depositDescription", settings != null ? settings.get("deposit_description") : "");

				// --- ▲▲▲ [ReservationSettings 연동] 로직 끝 ▲▲▲ ---
				request.setAttribute("restaurant", restaurant);
				request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "식당 정보 없음");
			}
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 식당 ID");
		}
	}

	private void handleReservationDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
			throws ServletException, IOException {
		// (reservation-detail.jsp 페이지를 위한 로직)
		try {
			int reservationId = Integer.parseInt(pathInfo.substring("/detail/".length()));
			Reservation reservation = reservationService.getReservationById(reservationId);
			if (reservation != null) {
				// --- ▼▼▼ [추가] LocalDateTime을 Date로 변환하는 로직 ▼▼▼ ---
				if (reservation.getReservationTime() != null) {
					reservation.setReservationTimeAsDate(Timestamp.valueOf(reservation.getReservationTime()));
				}
				if (reservation.getCreatedAt() != null) {
					// System.out.println("((((((((((((((((((((createdAt is : " +
					// reservation.getCreatedAt());
					reservation.setCreatedAtAsDate(Timestamp.valueOf(reservation.getCreatedAt()));
					// System.out.println("((((((((((((((((((" +reservation.getCreatedAtAsDate());
				}
				if (reservation.getUpdatedAt() != null) {
					reservation.setUpdatedAtAsDate(Timestamp.valueOf(reservation.getUpdatedAt()));
				}
				// --- ▲▲▲ [추가] 로직 끝 ▲▲▲ ---

				// 이 예약과 관련된 레스토랑 정보도 함께 조회해서 전달
				Restaurant restaurant = restaurantService.getRestaurantById(reservation.getRestaurantId());
				request.setAttribute("restaurant", restaurant);
				request.setAttribute("reservation", reservation);
				request.getRequestDispatcher("/WEB-INF/views/reservation-detail.jsp").forward(request, response);
			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "예약 정보를 찾을 수 없습니다.");
			}
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 예약 ID");
		}
	}

	private void handleReservationCreateSubmit(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;

		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		int restaurantId = 0;
		try {
			restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
			String restaurantName = request.getParameter("restaurantName");
			String reservationDate = request.getParameter("reservationDate"); // "YYYY-MM-DD"
			String reservationTimeStr = request.getParameter("reservationTime"); // "HH:MM"
			int partySize = Integer.parseInt(request.getParameter("partySize"));
			String contactPhone = request.getParameter("contactPhone");

			// --- ▼▼▼ [예약 검증] ReservationSettings 확인 ▼▼▼ ---
			java.util.Map<String, Object> settings = reservationSettingsDAO.findByRestaurantId(restaurantId);

			// 1. 예약 활성화 확인
			if (settings == null || !toBoolean(settings.get("reservation_enabled"))) {
				throw new Exception("현재 예약을 받지 않는 음식점입니다.");
			}

			// 2. 인원수 제한 확인
			Object minObj = settings.get("min_party_size");
			Object maxObj = settings.get("max_party_size");
			int minPartySize = minObj instanceof Integer ? (Integer) minObj : 1;
			int maxPartySize = maxObj instanceof Integer ? (Integer) maxObj : 10;
			if (partySize < minPartySize || partySize > maxPartySize) {
				throw new Exception(String.format("예약 가능 인원은 %d명부터 %d명까지입니다.",
					minPartySize, maxPartySize));
			}

			// 3. 예약 날짜/시간 검증
			LocalDate selectedDate = LocalDate.parse(reservationDate);
			LocalTime selectedTime = LocalTime.parse(reservationTimeStr);
			int dayOfWeek = selectedDate.getDayOfWeek().getValue();

			// 요일별 운영 확인
			boolean isDayEnabled = false;
			LocalTime dayStart = null;
			LocalTime dayEnd = null;
			String dayKey = null;

			switch (dayOfWeek) {
				case 1: dayKey = "monday"; break;
				case 2: dayKey = "tuesday"; break;
				case 3: dayKey = "wednesday"; break;
				case 4: dayKey = "thursday"; break;
				case 5: dayKey = "friday"; break;
				case 6: dayKey = "saturday"; break;
				case 7: dayKey = "sunday"; break;
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
				throw new Exception(String.format("예약 가능 시간은 %s부터 %s까지입니다.",
					dayStart.format(DateTimeFormatter.ofPattern("HH:mm")),
					dayEnd.minusMinutes(30).format(DateTimeFormatter.ofPattern("HH:mm"))));
			}
			// --- ▲▲▲ [예약 검증] 끝 ▲▲▲ ---

			// 날짜와 시간을 LocalDateTime으로 결합
			LocalDateTime reservationDateTime = LocalDateTime.parse(reservationDate + "T" + reservationTimeStr);

			Reservation reservation = new Reservation(restaurantId, user.getId(), restaurantName, user.getNickname(),
					reservationDateTime, partySize, contactPhone);

			boolean depositRequired = toBoolean(settings.get("deposit_required"));
			BigDecimal depositAmount = depositRequired ? toBigDecimal(settings.get("deposit_amount")) : BigDecimal.ZERO;
			String depositDescription = (String) settings.get("deposit_description");
			reservation.setDepositRequired(depositRequired);
			reservation.setDepositAmount(depositAmount);
			reservation.setSpecialRequests(request.getParameter("specialRequests"));
			if (depositRequired && depositAmount != null && depositAmount.compareTo(BigDecimal.ZERO) > 0) {
				reservation.setPaymentStatus("PENDING");
				reservation.setPaymentProvider("NAVERPAY");
			} else {
				reservation.setPaymentStatus("NOT_REQUIRED");
			}

			// --- ▼▼▼ [자동 승인] 설정에 따라 예약 상태 결정 ▼▼▼ ---
			boolean autoAccept = toBoolean(settings.get("auto_accept"));
			if (autoAccept) {
				reservation.setStatus("CONFIRMED"); // 자동 승인
				System.out.println("✅ 자동 승인이 활성화되어 있어 예약 상태를 CONFIRMED로 설정합니다.");
			} else {
				reservation.setStatus("PENDING"); // 승인 대기
				System.out.println("⏳ 자동 승인이 비활성화되어 있어 예약 상태를 PENDING으로 설정합니다.");
			}
			// --- ▲▲▲ [자동 승인] 끝 ▲▲▲ ---

			if (reservationService.createReservation(reservation)) {
				if (reservation.isDepositRequired()
						&& reservation.getDepositAmount() != null
						&& reservation.getDepositAmount().compareTo(BigDecimal.ZERO) > 0) {
					if (!naverPayService.isConfigured()) {
						throw new Exception("네이버페이 설정이 완료되지 않았습니다. 관리자에게 문의해주세요.");
					}

					String merchantPayKey = naverPayService.generateMerchantPayKey(reservation.getId());
					reservation.setPaymentOrderId(merchantPayKey);
					reservationService.updatePaymentInfo(
							reservation.getId(),
							reservation.getPaymentStatus(),
							merchantPayKey,
							reservation.getPaymentProvider(),
							reservation.getPaymentApprovedAt(),
							reservation.getDepositAmount(),
							reservation.isDepositRequired());

					NaverPayJsConfig jsConfig = naverPayService.buildJsConfig(request, user, reservation,
							reservation.getDepositAmount());
					request.setAttribute("naverPayConfig", jsConfig);
					request.setAttribute("reservation", reservation);
					request.setAttribute("depositDescription", depositDescription);
					request.getRequestDispatcher("/WEB-INF/views/reservation-payment.jsp").forward(request, response);
					return;
				}

				// 예약 성공 시, 내 예약 목록 페이지로 이동
				response.sendRedirect(request.getContextPath() + "/mypage/reservations");
			} else {
				throw new Exception("예약 등록 실패 (DB insert 실패)");
			}

		} catch (DateTimeParseException e) {
			e.printStackTrace();
			request.setAttribute("errorMessage", "잘못된 날짜 또는 시간 형식입니다.");
			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId); // 폼 재전송을 위해 식당정보 로드
			request.setAttribute("restaurant", restaurant);
			request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMessage", "예약 처리 중 오류가 발생했습니다.");
			Restaurant restaurant = restaurantService.getRestaurantById(restaurantId); // 폼 재전송을 위해 식당정보 로드
			request.setAttribute("restaurant", restaurant);
			request.getRequestDispatcher("/WEB-INF/views/create-reservation.jsp").forward(request, response);
		}
	}

	private void handleReservationCancel(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		// my-reservations.jsp에서 호출하는 취소 로직
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "로그인이 필요합니다.");
			return;
		}

		try {
			int reservationId = Integer.parseInt(request.getParameter("reservationId"));
			User currentUser = (User) session.getAttribute("user");

			// 예약자 검증: 해당 예약을 요청한 사용자가 실제 예약자인지 확인
			Reservation reservation = reservationService.getReservationById(reservationId);
			if (reservation == null) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				response.getWriter().write("{\"success\": false, \"message\": \"예약을 찾을 수 없습니다.\"}");
				return;
			}

			if (reservation.getUserId() != currentUser.getId()) {
				response.setStatus(HttpServletResponse.SC_FORBIDDEN);
				response.getWriter().write("{\"success\": false, \"message\": \"본인의 예약만 취소할 수 있습니다.\"}");
				return;
			}

			if (reservationService.cancelReservation(reservationId)) {
				response.getWriter().write("{\"success\": true}");
				//response.sendRedirect(request.getContextPath() + "/mypage/reservations");
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"success\": false, \"message\": \"예약 취소에 실패했습니다.\"}");
//                 request.setAttribute("errorMessage", "예약 취소 실패.");
//                 request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
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

			// 날짜 파싱
			LocalDate selectedDate = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr)
					: LocalDate.now();
			int dayOfWeek = selectedDate.getDayOfWeek().getValue(); // 1=월요일, 7=일요일

			// 예약 설정 조회
			java.util.Map<String, Object> settings = reservationSettingsDAO.findByRestaurantId(restaurantId);
			List<String> timeSlots = new ArrayList<>();

			if (settings != null) {
				// 예약 기능이 활성화되어 있는지 확인
				boolean reservationEnabled = toBoolean(settings.get("reservation_enabled"));
				if (!reservationEnabled) {
					response.getWriter().write("{\"timeSlots\": [], \"message\": \"예약 기능이 비활성화되었습니다.\"}");
					return;
				}

				// 블랙아웃 날짜 확인
				String blackoutDatesJson = (String) settings.get("blackout_dates");
				System.out.println("=== 블랙아웃 날짜 체크 ===");
				System.out.println("blackoutDatesJson: " + blackoutDatesJson);
				System.out.println("selectedDate: " + selectedDate.toString());
				if (blackoutDatesJson != null && !blackoutDatesJson.isEmpty()) {
					String dateString = selectedDate.toString();
					if (blackoutDatesJson.contains("\"" + dateString + "\"")) {
						System.out.println("블랙아웃 날짜 발견 - 예약 불가");
						response.getWriter().write("{\"timeSlots\": [], \"message\": \"해당 날짜는 예약이 불가능합니다.\"}");
						return;
					}
				}

				// 요일별 설정 확인
				String dayKey = null;
				switch (dayOfWeek) {
					case 1: dayKey = "monday"; break;
					case 2: dayKey = "tuesday"; break;
					case 3: dayKey = "wednesday"; break;
					case 4: dayKey = "thursday"; break;
					case 5: dayKey = "friday"; break;
					case 6: dayKey = "saturday"; break;
					case 7: dayKey = "sunday"; break;
				}

				if (dayKey != null && toBoolean(settings.get(dayKey + "_enabled"))) {
					LocalTime startTime = toLocalTime(settings.get(dayKey + "_start"));
					LocalTime endTime = toLocalTime(settings.get(dayKey + "_end"));

					if (startTime != null && endTime != null) {
						// 30분 간격으로 시간 슬롯 생성
						LocalTime currentTime = startTime;
						while (currentTime.isBefore(endTime)) {
							timeSlots.add(currentTime.format(DateTimeFormatter.ofPattern("HH:mm")));
							currentTime = currentTime.plusMinutes(30);
						}
					}
				}
			}

			Collections.sort(timeSlots);

			// JSON 응답 생성
			StringBuilder json = new StringBuilder();
			json.append("{\"timeSlots\": [");
			for (int i = 0; i < timeSlots.size(); i++) {
				if (i > 0) json.append(",");
				json.append("\"").append(timeSlots.get(i)).append("\"");
			}
			json.append("]}");

			response.getWriter().write(json.toString());

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"시간 슬롯 조회 중 오류가 발생했습니다.\"}");
		}
	}
}
