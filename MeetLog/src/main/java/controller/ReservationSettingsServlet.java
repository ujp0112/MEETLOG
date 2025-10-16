package controller;

import model.ReservationSettings;
import model.ReservationSettingsNew;
import model.User;
import model.Restaurant;
import service.ReservationSettingsService;
import service.RestaurantService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.math.RoundingMode;

@WebServlet("/reservation-settings/*")
public class ReservationSettingsServlet extends HttpServlet {
	private ReservationSettingsService reservationService = new ReservationSettingsService();
	private RestaurantService restaurantService = new RestaurantService();
	private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String pathInfo = request.getPathInfo();
		HttpSession session = request.getSession(false);

		// 로그인 확인
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User user = (User) session.getAttribute("user");

		// 사업자 권한 확인
		if (!"BUSINESS".equals(user.getUserType())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "사업자만 접근 가능합니다.");
			return;
		}

		// URL에서 음식점 ID 추출
		if (pathInfo == null || pathInfo.equals("/")) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
			return;
		}

		String[] pathParts = pathInfo.split("/");
		if (pathParts.length < 2) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 URL 형식입니다.");
			return;
		}

		int restaurantId;
		try {
			restaurantId = Integer.parseInt(pathParts[1]);
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 음식점 ID입니다.");
			return;
		}

		// 해당 음식점이 현재 사용자 소유인지 확인
		List<Restaurant> myRestaurants = restaurantService.findByOwnerId(user.getId());
		boolean isOwner = myRestaurants.stream().anyMatch(r -> r.getId() == restaurantId);

		if (!isOwner) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "해당 음식점에 대한 권한이 없습니다.");
			return;
		}

		// pathInfo를 다시 확인해서 API 요청인지 판단
		String action = pathParts.length > 2 ? pathParts[2] : "";

		if ("api".equals(action)) {
			// API로 설정 조회
			handleGetSettingsApi(request, response, restaurantId);
		} else if (action.isEmpty()) {
			// 예약 설정 페이지 표시
			handleGetSettings(request, response, restaurantId);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String pathInfo = request.getPathInfo();
		HttpSession session = request.getSession(false);

		// 로그인 확인
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User user = (User) session.getAttribute("user");

		// 사업자 권한 확인
		if (!"BUSINESS".equals(user.getUserType())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "사업자만 접근 가능합니다.");
			return;
		}

		// URL에서 음식점 ID 추출
		if (pathInfo == null || pathInfo.equals("/")) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
			return;
		}

		String[] pathParts = pathInfo.split("/");
		if (pathParts.length < 2) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 URL 형식입니다.");
			return;
		}

		int restaurantId;
		try {
			restaurantId = Integer.parseInt(pathParts[1]);
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 음식점 ID입니다.");
			return;
		}

		// 해당 음식점이 현재 사용자 소유인지 확인
		List<Restaurant> myRestaurants = restaurantService.findByOwnerId(user.getId());
		boolean isOwner = myRestaurants.stream().anyMatch(r -> r.getId() == restaurantId);

		if (!isOwner) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "해당 음식점에 대한 권한이 없습니다.");
			return;
		}

		// pathInfo를 다시 확인해서 액션 판단
		String action = pathParts.length > 2 ? pathParts[2] : "";

		if ("save".equals(action)) {
			handleSaveSettings(request, response, restaurantId);
		} else if ("toggle".equals(action)) {
			handleToggleEnabled(request, response, restaurantId);
		} else if ("auto-accept".equals(action)) {
			handleUpdateAutoAccept(request, response, restaurantId);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void handleGetSettings(HttpServletRequest request, HttpServletResponse response, int restaurantId)
			throws ServletException, IOException {

		// 음식점 정보 조회
		Restaurant restaurant = restaurantService.findById(restaurantId);
		if (restaurant == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
			return;
		}

		java.util.Map<String, Object> settings = reservationService.getReservationSettings(restaurantId);

		if (settings != null && settings.get("blackout_dates") != null) {
			String blackoutDatesJson = (String) settings.get("blackout_dates");

			// JSON 배열 형식의 문자열인지 확인하고, 쉼표로 구분된 문자열로 변환합니다.
			// 예: ["2025-10-20","2025-10-21"] -> 2025-10-20,2025-10-21
			if (blackoutDatesJson != null && blackoutDatesJson.startsWith("[\"") && blackoutDatesJson.endsWith("\"]")) {
				String formattedDates = blackoutDatesJson.substring(2, blackoutDatesJson.length() - 2); // 앞뒤의 [" 와 "]
																										// 제거
				formattedDates = formattedDates.replace("\",\"", ","); // 중간의 "," 를 , 로 변경
				settings.put("blackout_dates", formattedDates);
			} else if ("[]".equals(blackoutDatesJson)) {
				// 빈 배열일 경우 빈 문자열로 설정
				settings.put("blackout_dates", "");
			}
		}

		request.setAttribute("restaurant", restaurant);
		request.setAttribute("reservationSettings", settings);
		request.getRequestDispatcher("/WEB-INF/views/reservation-settings.jsp").forward(request, response);
	}

	private void handleGetSettingsApi(HttpServletRequest request, HttpServletResponse response, int restaurantId)
			throws IOException {

		response.setContentType("application/json; charset=UTF-8");

		try {
			java.util.Map<String, Object> settings = reservationService.getReservationSettings(restaurantId);

			 // ▼▼▼ [디버깅 코드 1] 이 라인을 추가해주세요 ▼▼▼
		    System.out.println("### [1단계] DB에서 가져온 원본 데이터: " + settings.get("blackout_dates"));
			
			if (settings != null && settings.get("blackout_dates") != null) {
				String blackoutDatesJson = (String) settings.get("blackout_dates");

				if (blackoutDatesJson != null && blackoutDatesJson.startsWith("[\"")
						&& blackoutDatesJson.endsWith("\"]")) {
					String formattedDates = blackoutDatesJson.substring(2, blackoutDatesJson.length() - 2);
					formattedDates = formattedDates.replace("\",\"", ",");
					settings.put("blackout_dates", formattedDates);
				} else if ("[]".equals(blackoutDatesJson)) {
					settings.put("blackout_dates", "");
				}
			}
			
			// ▼▼▼ [디버깅 코드 2] 이 라인을 추가해주세요 ▼▼▼
		    System.out.println("### [2단계] JSP로 보내기 직전 데이터: " + settings.get("blackout_dates"));
		    
			response.getWriter().write(gson.toJson(settings));
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
		}
	}

	private void handleSaveSettings(HttpServletRequest request, HttpServletResponse response, int restaurantId)
			throws IOException {

		response.setContentType("application/json; charset=UTF-8");

		try {
			// 파라미터 파싱
			ReservationSettings settings = parseSettingsFromRequest(request, restaurantId);

			// 유효성 검증
			if (!reservationService.validateReservationSettings(settings)) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"error\":\"입력값이 올바르지 않습니다.\"}");
				return;
			}

			// 저장
			boolean success = reservationService.saveReservationSettings(settings);

			if (success) {
				response.getWriter().write("{\"success\":true,\"message\":\"설정이 저장되었습니다.\"}");
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"error\":\"설정 저장에 실패했습니다.\"}");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
		}
	}

	private void handleToggleEnabled(HttpServletRequest request, HttpServletResponse response, int restaurantId)
			throws IOException {

		response.setContentType("application/json; charset=UTF-8");

		try {
			String enabledStr = request.getParameter("enabled");
			boolean enabled = Boolean.parseBoolean(enabledStr);

			boolean success = reservationService.toggleReservationEnabled(restaurantId, enabled);

			if (success) {
				response.getWriter().write("{\"success\":true,\"enabled\":" + enabled + "}");
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"error\":\"설정 변경에 실패했습니다.\"}");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
		}
	}

	private void handleUpdateAutoAccept(HttpServletRequest request, HttpServletResponse response, int restaurantId)
			throws IOException {

		response.setContentType("application/json; charset=UTF-8");

		try {
			String autoAcceptStr = request.getParameter("autoAccept");
			boolean autoAccept = Boolean.parseBoolean(autoAcceptStr);

			boolean success = reservationService.updateAutoAccept(restaurantId, autoAccept);

			if (success) {
				response.getWriter().write("{\"success\":true,\"autoAccept\":" + autoAccept + "}");
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"error\":\"설정 변경에 실패했습니다.\"}");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
		}
	}

	private ReservationSettings parseSettingsFromRequest(HttpServletRequest request, int restaurantId) {
		// ▼▼▼ [수정] 먼저 기존 설정을 불러와 ID를 확보합니다. ▼▼▼
		java.util.Map<String, Object> existingSettingsMap = reservationService.getReservationSettings(restaurantId);
		ReservationSettings settings;
		if (existingSettingsMap != null && existingSettingsMap.get("id") != null) {
			settings = new ReservationSettings(restaurantId);
			settings.setId((Integer) existingSettingsMap.get("id"));
		} else {
			settings = new ReservationSettings(restaurantId);
		}

		// 기본 설정
		settings.setReservationEnabled(Boolean.parseBoolean(request.getParameter("reservationEnabled")));
		settings.setAutoAccept(Boolean.parseBoolean(request.getParameter("autoAccept")));

		// 인원 설정
		try {
			settings.setMinPartySize(Integer.parseInt(request.getParameter("minPartySize")));
			settings.setMaxPartySize(Integer.parseInt(request.getParameter("maxPartySize")));
		} catch (NumberFormatException e) {
			settings.setMinPartySize(1);
			settings.setMaxPartySize(10);
		}

		// 예약 기간 설정
		try {
			settings.setAdvanceBookingDays(Integer.parseInt(request.getParameter("advanceBookingDays")));
			settings.setMinAdvanceHours(Integer.parseInt(request.getParameter("minAdvanceHours")));
		} catch (NumberFormatException e) {
			settings.setAdvanceBookingDays(30);
			settings.setMinAdvanceHours(2);
		}

		// 예약 시간 간격 설정
		try {
			settings.setTimeSlotInterval(Integer.parseInt(request.getParameter("timeSlotInterval")));
		} catch (NumberFormatException e) {
			settings.setTimeSlotInterval(30); // 기본값 30분
		}

		// 시간 설정
		try {
            String startTimeStr = request.getParameter("reservationStartTime");
            String endTimeStr = request.getParameter("reservationEndTime");

            if (startTimeStr != null && !startTimeStr.isEmpty()) {
                settings.setReservationStartTime(LocalTime.parse(startTimeStr));
				System.out.println("DEBUG: " + startTimeStr);
            } else {
                // 파라미터가 없으면 오늘 요일에 맞는 DB 값으로 설정
                settings.setReservationStartTime(getDayOfWeekTime(existingSettingsMap, "start"));
				System.out.println("DEBUG: " + getDayOfWeekTime(existingSettingsMap, "start"));
            }

            if (endTimeStr != null && !endTimeStr.isEmpty()) {
                settings.setReservationEndTime(LocalTime.parse(endTimeStr));
            } else {
                // 파라미터가 없으면 오늘 요일에 맞는 DB 값으로 설정
                settings.setReservationEndTime(getDayOfWeekTime(existingSettingsMap, "end"));
            }
		} catch (Exception e) {
            e.printStackTrace();
			settings.setReservationStartTime(LocalTime.of(9, 0));
			settings.setReservationEndTime(LocalTime.of(22, 0));
		}

		// reservationStartTime과 reservationEndTime을 기반으로 time_slots JSON 생성
		List<String> timeSlotsList = new ArrayList<>();
		LocalTime current = settings.getReservationStartTime();
		if (current != null) {
			LocalTime end = settings.getReservationEndTime();
			// ▼▼▼ [수정] 설정된 시간 간격을 가져와서 사용합니다. ▼▼▼
			int interval = settings.getTimeSlotInterval();

			while (current.isBefore(end)) {
				timeSlotsList.add("\"" + current.toString() + "\"");
				current = current.plusMinutes(interval);
			}
		}
		String timeSlotsJson = "[" + String.join(",", timeSlotsList) + "]";
		settings.setTimeSlots(timeSlotsJson);

		// 요일별 설정
		parseWeeklySettings(request, settings);

		// reservationStartTime과 reservationEndTime을 기반으로 time_slots JSON 생성
		
		// 특별 안내사항
		settings.setSpecialNotes(request.getParameter("specialNotes"));

		// 예약금 설정
		String depositRequiredParam = request.getParameter("depositRequired");
		String depositAmountParam = request.getParameter("depositAmount");
		String depositDescriptionParam = request.getParameter("depositDescription");

		System.out.println("[ReservationSettings] depositRequired=" + depositRequiredParam + ", depositAmount="
				+ depositAmountParam + ", depositDescription=" + depositDescriptionParam);

		boolean depositRequired = Boolean.parseBoolean(depositRequiredParam);
		settings.setDepositRequired(depositRequired);

		if (depositAmountParam != null && !depositAmountParam.trim().isEmpty()) {
			String normalized = depositAmountParam.replaceAll("[^0-9.]", "");
			try {
				java.math.BigDecimal amount = new java.math.BigDecimal(normalized);
				amount = amount.setScale(0, RoundingMode.DOWN);
				settings.setDepositAmount(amount);
			} catch (NumberFormatException ex) {
				settings.setDepositAmount(java.math.BigDecimal.ZERO);
			}
		} else {
			settings.setDepositAmount(java.math.BigDecimal.ZERO);
		}

		settings.setDepositDescription(depositDescriptionParam);

		System.out.println("[ReservationSettings] normalized deposit => required=" + settings.isDepositRequired()
				+ ", amount=" + settings.getDepositAmount() + ", description=" + settings.getDepositDescription());

		// 예약 불가 날짜
		String blackoutDates = request.getParameter("blackoutDates");
		System.out.println("blackoutDates 파라미터: " + blackoutDates);
		if (blackoutDates != null && !blackoutDates.trim().isEmpty()) {
			String[] dates = blackoutDates.split(",");
			List<String> dateList = new ArrayList<>();
			for (String date : dates) {
				String trimmedDate = date.trim();
				if (!trimmedDate.isEmpty()) {
					// JSON 배열에 맞게 큰따옴표 추가
					dateList.add("\"" + trimmedDate + "\"");
				}
			}
			// JSON 문자열로 변환하여 설정
			String blackoutDatesJson = "[" + String.join(",", dateList) + "]";
			settings.setBlackoutDatesJson(blackoutDatesJson);
		} else {
			// 값이 없는 경우 빈 JSON 배열 '[]' 또는 null을 설정
			settings.setBlackoutDatesJson("[]");
		}
		return settings;
	}

    private LocalTime getDayOfWeekTime(java.util.Map<String, Object> settingsMap, String type) {
        if (settingsMap == null) {
            return "start".equals(type) ? LocalTime.of(9, 0) : LocalTime.of(22, 0);
        }

        int dayOfWeek = java.time.LocalDate.now().getDayOfWeek().getValue(); // 1:월, 7:일
        String dayKey;
        switch (dayOfWeek) {
            case 1: dayKey = "monday"; break;
            case 2: dayKey = "tuesday"; break;
            case 3: dayKey = "wednesday"; break;
            case 4: dayKey = "thursday"; break;
            case 5: dayKey = "friday"; break;
            case 6: dayKey = "saturday"; break;
            case 7: dayKey = "sunday"; break;
            default: dayKey = "monday"; // 기본값
        }

        String timeKey = dayKey + "_" + type; // 예: "monday_start"
        Object timeValue = settingsMap.get(timeKey);

        if (timeValue instanceof java.sql.Time) {
            return ((java.sql.Time) timeValue).toLocalTime();
        } else if (timeValue instanceof String) {
            try {
                return LocalTime.parse((String) timeValue);
            } catch (java.time.format.DateTimeParseException e) {
                // 파싱 실패 시 기본값 반환
            }
        }

        // 값이 없거나 타입이 맞지 않으면 기본값 반환
        return "start".equals(type) ? LocalTime.of(9, 0) : LocalTime.of(22, 0);
    }

	private void parseWeeklySettings(HttpServletRequest request, ReservationSettings settings) {
		System.out.println("=== parseWeeklySettings 시작 ===");

		// 모든 파라미터 출력
		System.out.println("=== 모든 파라미터 ===");
		request.getParameterMap().forEach((key, values) -> {
			System.out.println(key + ": " + String.join(", ", values));
		});

		// 월요일
		boolean mondayEnabled = Boolean.parseBoolean(request.getParameter("mondayEnabled"));
		settings.setMondayEnabled(mondayEnabled);
		System.out.println("=== 월요일 파라미터 디버깅 ===");
		System.out.println("mondayEnabled: " + mondayEnabled);

		try {
			String mondayStart = request.getParameter("mondayStart");
			String mondayEnd = request.getParameter("mondayEnd");

			System.out.println("mondayStart: " + mondayStart);
			System.out.println("mondayEnd: " + mondayEnd);

			// NULL 방지: 항상 기본값 설정
			settings.setMondayStart(
					mondayStart != null && !mondayStart.isEmpty() ? LocalTime.parse(mondayStart) : LocalTime.of(9, 0));
			settings.setMondayEnd(
					mondayEnd != null && !mondayEnd.isEmpty() ? LocalTime.parse(mondayEnd) : LocalTime.of(22, 0));
		} catch (Exception e) {
			System.out.println("월요일 파싱 오류: " + e.getMessage());
			settings.setMondayStart(LocalTime.of(9, 0));
			settings.setMondayEnd(LocalTime.of(22, 0));
		}

		// 화요일
		boolean tuesdayEnabled = Boolean.parseBoolean(request.getParameter("tuesdayEnabled"));
		settings.setTuesdayEnabled(tuesdayEnabled);
		System.out.println("=== 화요일 파라미터 디버깅 ===");
		System.out.println("tuesdayEnabled: " + tuesdayEnabled);

		try {
			String tuesdayStart = request.getParameter("tuesdayStart");
			String tuesdayEnd = request.getParameter("tuesdayEnd");

			System.out.println("tuesdayStart: " + tuesdayStart);
			System.out.println("tuesdayEnd: " + tuesdayEnd);

			settings.setTuesdayStart(tuesdayStart != null && !tuesdayStart.isEmpty() ? LocalTime.parse(tuesdayStart)
					: LocalTime.of(9, 0));
			settings.setTuesdayEnd(
					tuesdayEnd != null && !tuesdayEnd.isEmpty() ? LocalTime.parse(tuesdayEnd) : LocalTime.of(22, 0));
		} catch (Exception e) {
			System.out.println("화요일 파싱 오류: " + e.getMessage());
			settings.setTuesdayStart(LocalTime.of(9, 0));
			settings.setTuesdayEnd(LocalTime.of(22, 0));
		}

		// 수요일
		settings.setWednesdayEnabled(Boolean.parseBoolean(request.getParameter("wednesdayEnabled")));
		try {
			String wednesdayStart = request.getParameter("wednesdayStart");
			String wednesdayEnd = request.getParameter("wednesdayEnd");

			settings.setWednesdayStart(
					wednesdayStart != null && !wednesdayStart.isEmpty() ? LocalTime.parse(wednesdayStart)
							: LocalTime.of(9, 0));
			settings.setWednesdayEnd(wednesdayEnd != null && !wednesdayEnd.isEmpty() ? LocalTime.parse(wednesdayEnd)
					: LocalTime.of(22, 0));
		} catch (Exception e) {
			settings.setWednesdayStart(LocalTime.of(9, 0));
			settings.setWednesdayEnd(LocalTime.of(22, 0));
		}

		// 목요일
		settings.setThursdayEnabled(Boolean.parseBoolean(request.getParameter("thursdayEnabled")));
		try {
			String thursdayStart = request.getParameter("thursdayStart");
			String thursdayEnd = request.getParameter("thursdayEnd");

			settings.setThursdayStart(thursdayStart != null && !thursdayStart.isEmpty() ? LocalTime.parse(thursdayStart)
					: LocalTime.of(9, 0));
			settings.setThursdayEnd(
					thursdayEnd != null && !thursdayEnd.isEmpty() ? LocalTime.parse(thursdayEnd) : LocalTime.of(22, 0));
		} catch (Exception e) {
			settings.setThursdayStart(LocalTime.of(9, 0));
			settings.setThursdayEnd(LocalTime.of(22, 0));
		}

		// 금요일
		settings.setFridayEnabled(Boolean.parseBoolean(request.getParameter("fridayEnabled")));
		try {
			String fridayStart = request.getParameter("fridayStart");
			String fridayEnd = request.getParameter("fridayEnd");

			settings.setFridayStart(
					fridayStart != null && !fridayStart.isEmpty() ? LocalTime.parse(fridayStart) : LocalTime.of(9, 0));
			settings.setFridayEnd(
					fridayEnd != null && !fridayEnd.isEmpty() ? LocalTime.parse(fridayEnd) : LocalTime.of(22, 0));
		} catch (Exception e) {
			settings.setFridayStart(LocalTime.of(9, 0));
			settings.setFridayEnd(LocalTime.of(22, 0));
		}

		// 토요일
		settings.setSaturdayEnabled(Boolean.parseBoolean(request.getParameter("saturdayEnabled")));
		try {
			String saturdayStart = request.getParameter("saturdayStart");
			String saturdayEnd = request.getParameter("saturdayEnd");

			settings.setSaturdayStart(saturdayStart != null && !saturdayStart.isEmpty() ? LocalTime.parse(saturdayStart)
					: LocalTime.of(9, 0));
			settings.setSaturdayEnd(
					saturdayEnd != null && !saturdayEnd.isEmpty() ? LocalTime.parse(saturdayEnd) : LocalTime.of(22, 0));
		} catch (Exception e) {
			settings.setSaturdayStart(LocalTime.of(9, 0));
			settings.setSaturdayEnd(LocalTime.of(22, 0));
		}

		// 일요일
		settings.setSundayEnabled(Boolean.parseBoolean(request.getParameter("sundayEnabled")));
		try {
			String sundayStart = request.getParameter("sundayStart");
			String sundayEnd = request.getParameter("sundayEnd");

			settings.setSundayStart(
					sundayStart != null && !sundayStart.isEmpty() ? LocalTime.parse(sundayStart) : LocalTime.of(9, 0));
			settings.setSundayEnd(
					sundayEnd != null && !sundayEnd.isEmpty() ? LocalTime.parse(sundayEnd) : LocalTime.of(22, 0));
		} catch (Exception e) {
			settings.setSundayStart(LocalTime.of(9, 0));
			settings.setSundayEnd(LocalTime.of(22, 0));
		}

		// 활성화된 요일 목록을 JSON 배열 형태로 생성
		List<String> availableDays = new ArrayList<>();
		if (settings.isMondayEnabled())
			availableDays.add("\"monday\"");
		if (settings.isTuesdayEnabled())
			availableDays.add("\"tuesday\"");
		if (settings.isWednesdayEnabled())
			availableDays.add("\"wednesday\"");
		if (settings.isThursdayEnabled())
			availableDays.add("\"thursday\"");
		if (settings.isFridayEnabled())
			availableDays.add("\"friday\"");
		if (settings.isSaturdayEnabled())
			availableDays.add("\"saturday\"");
		if (settings.isSundayEnabled())
			availableDays.add("\"sunday\"");

		String availableDaysJson = "[" + String.join(",", availableDays) + "]";
		settings.setAvailableDays(availableDaysJson); // ReservationSettings 모델에 setAvailableDays 메소드가 있어야 합니다.
	}
}
