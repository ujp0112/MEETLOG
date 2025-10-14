package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dao.ReservationBlackoutDateDAO;
import dao.RestaurantTableDAO;
import dao.ReservationNotificationDAO;
import model.ReservationBlackoutDate;
import model.RestaurantTable;
import model.ReservationNotification;
import model.User;
import service.ReservationService;
import service.RestaurantService;

/**
 * 고급 예약 관리 서블릿 - 사업자용 예약 시스템 관리
 */
@WebServlet("/business/advanced-reservation-management/*")
public class AdvancedReservationManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ReservationBlackoutDateDAO blackoutDateDAO = new ReservationBlackoutDateDAO();
    private final RestaurantTableDAO tableDAO = new RestaurantTableDAO();
    private final ReservationNotificationDAO notificationDAO = new ReservationNotificationDAO();
    private final ReservationService reservationService = new ReservationService();
    private final RestaurantService restaurantService = new RestaurantService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 사업자 권한 확인
        if (!isBusinessUser(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "사업자 권한이 필요합니다.");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if ("/dashboard".equals(pathInfo)) {
                showReservationDashboard(request, response);
            } else if ("/blackout-dates".equals(pathInfo)) {
                showBlackoutDates(request, response);
            } else if ("/table-management".equals(pathInfo)) {
                showTableManagement(request, response);
            } else if ("/notifications".equals(pathInfo)) {
                showNotifications(request, response);
            } else if ("/analytics".equals(pathInfo)) {
                showAnalytics(request, response);
            } else if ("/table-status".equals(pathInfo)) {
                showTableStatus(request, response);
            } else {
                // 기본값: 대시보드로 이동
                response.sendRedirect(request.getContextPath() + "/business/advanced-reservation-management/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "페이지 로딩 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 사업자 권한 확인
        if (!isBusinessUser(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "사업자 권한이 필요합니다.");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if ("/blackout-date/add".equals(pathInfo)) {
                addBlackoutDate(request, response);
            } else if ("/blackout-date/remove".equals(pathInfo)) {
                removeBlackoutDate(request, response);
            } else if ("/table/add".equals(pathInfo)) {
                addTable(request, response);
            } else if ("/table/update".equals(pathInfo)) {
                updateTable(request, response);
            } else if ("/table/delete".equals(pathInfo)) {
                deleteTable(request, response);
            } else if ("/reservation/approve".equals(pathInfo)) {
                approveReservation(request, response);
            } else if ("/reservation/reject".equals(pathInfo)) {
                rejectReservation(request, response);
            } else if ("/notification/send".equals(pathInfo)) {
                sendNotification(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 요청입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "요청 처리 중 오류가 발생했습니다.");
        }
    }

    /**
     * 예약 대시보드 표시
     */
    private void showReservationDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request);
        int restaurantId = getRestaurantId(user);

        // 오늘의 예약 현황
        var todayReservations = reservationService.getTodayReservations(restaurantId);

        // 예약 통계
        var reservationStats = reservationService.getReservationStats(restaurantId);

        // 테이블 통계
        var tableStats = tableDAO.getTableStats(restaurantId);

        // 블랙아웃 날짜 통계
        var blackoutStats = blackoutDateDAO.getBlackoutDateStats(restaurantId);

        // 알림 통계
        var notificationStats = notificationDAO.getNotificationStats();

        request.setAttribute("todayReservations", todayReservations);
        request.setAttribute("reservationStats", reservationStats);
        request.setAttribute("tableStats", tableStats);
        request.setAttribute("blackoutStats", blackoutStats);
        request.setAttribute("notificationStats", notificationStats);

        request.getRequestDispatcher("/WEB-INF/views/business/advanced-reservation-dashboard.jsp")
                .forward(request, response);
    }

    /**
     * 블랙아웃 날짜 관리 페이지
     */
    private void showBlackoutDates(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request);
        int restaurantId = getRestaurantId(user);

        // 미래의 블랙아웃 날짜 목록
        List<ReservationBlackoutDate> blackoutDates = blackoutDateDAO.findFutureBlackoutDates(restaurantId);

        request.setAttribute("blackoutDates", blackoutDates);
        request.setAttribute("restaurantId", restaurantId);

        request.getRequestDispatcher("/WEB-INF/views/business/reservation-blackout-dates.jsp")
                .forward(request, response);
    }

    /**
     * 테이블 관리 페이지
     */
    private void showTableManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request);
        int restaurantId = getRestaurantId(user);

        // 테이블 목록
        List<RestaurantTable> tables = tableDAO.findByRestaurantId(restaurantId);

        // 테이블 통계
        Map<String, Object> tableStats = tableDAO.getTableStats(restaurantId);

        request.setAttribute("tables", tables);
        request.setAttribute("tableStats", tableStats);
        request.setAttribute("restaurantId", restaurantId);
        request.setAttribute("tableTypes", RestaurantTable.TableType.values());

        request.getRequestDispatcher("/WEB-INF/views/business/restaurant-table-management.jsp")
                .forward(request, response);
    }

    /**
     * 알림 관리 페이지
     */
    private void showNotifications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 발송 대기 중인 알림
        List<ReservationNotification> pendingNotifications = notificationDAO.findPendingNotifications();

        // 최근 알림 내역
        LocalDateTime startDate = LocalDateTime.now().minusDays(7);
        LocalDateTime endDate = LocalDateTime.now();
        List<ReservationNotification> recentNotifications = notificationDAO.findByDateRange(startDate, endDate);

        // 알림 유형별 통계
        List<Map<String, Object>> notificationTypeStats = notificationDAO.getStatsByNotificationType();

        request.setAttribute("pendingNotifications", pendingNotifications);
        request.setAttribute("recentNotifications", recentNotifications);
        request.setAttribute("notificationTypeStats", notificationTypeStats);

        request.getRequestDispatcher("/WEB-INF/views/business/reservation-notifications.jsp")
                .forward(request, response);
    }

    /**
     * 예약 분석 페이지
     */
    private void showAnalytics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request);
        int restaurantId = getRestaurantId(user);

        // 분석 기간 파라미터 (기본값: 최근 30일)
        String periodParam = request.getParameter("period");
        int days = 30;
        try {
            if (periodParam != null) {
                days = Integer.parseInt(periodParam);
            }
        } catch (NumberFormatException e) {
            days = 30;
        }

        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        LocalDateTime endDate = LocalDateTime.now();

        // 예약 검색 파라미터
        Map<String, Object> searchParams = new HashMap<>();
        searchParams.put("restaurantId", restaurantId);
        searchParams.put("startDate", startDate);
        searchParams.put("endDate", endDate);

        // 기간별 예약 목록
        var reservations = reservationService.searchReservations(searchParams);

        // 알림 발송 성공률
        var notificationSuccessRate = notificationDAO.getSuccessRateByDateRange(startDate, endDate);

        request.setAttribute("reservations", reservations);
        request.setAttribute("notificationSuccessRate", notificationSuccessRate);
        request.setAttribute("period", days);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("/WEB-INF/views/business/reservation-analytics.jsp")
                .forward(request, response);
    }

    /**
     * 실시간 테이블 현황 페이지
     */
    private void showTableStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request);
        int restaurantId = getRestaurantId(user);

        // 현재 시간 또는 지정된 시간
        String dateTimeParam = request.getParameter("datetime");
        LocalDateTime targetDateTime = LocalDateTime.now();

        if (dateTimeParam != null && !dateTimeParam.isEmpty()) {
            try {
                targetDateTime = LocalDateTime.parse(dateTimeParam, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            } catch (DateTimeParseException e) {
                // 파싱 실패 시 현재 시간 사용
                targetDateTime = LocalDateTime.now();
            }
        }

        // 테이블 예약 현황
        List<Map<String, Object>> tableStatus = tableDAO.getTableReservationStatus(restaurantId, targetDateTime);

        request.setAttribute("tableStatus", tableStatus);
        request.setAttribute("targetDateTime", targetDateTime);
        request.setAttribute("restaurantId", restaurantId);

        request.getRequestDispatcher("/WEB-INF/views/business/table-status.jsp")
                .forward(request, response);
    }

    /**
     * 블랙아웃 날짜 추가
     */
    private void addBlackoutDate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request);
        int restaurantId = getRestaurantId(user);

        String dateStr = request.getParameter("blackoutDate");
        String reason = request.getParameter("reason");

        try {
            LocalDate blackoutDate = LocalDate.parse(dateStr);

            // 과거 날짜 체크
            if (blackoutDate.isBefore(LocalDate.now())) {
                sendJsonError(response, "과거 날짜는 블랙아웃 날짜로 설정할 수 없습니다.");
                return;
            }

            // 중복 체크
            if (blackoutDateDAO.isBlackoutDate(restaurantId, blackoutDate)) {
                sendJsonError(response, "이미 블랙아웃 날짜로 설정된 날짜입니다.");
                return;
            }

            ReservationBlackoutDate newBlackoutDate = new ReservationBlackoutDate(restaurantId, blackoutDate, reason);
            int result = blackoutDateDAO.insert(newBlackoutDate);

            if (result > 0) {
                sendJsonSuccess(response, "블랙아웃 날짜가 추가되었습니다.");
            } else {
                sendJsonError(response, "블랙아웃 날짜 추가에 실패했습니다.");
            }

        } catch (DateTimeParseException e) {
            sendJsonError(response, "잘못된 날짜 형식입니다.");
        }
    }

    /**
     * 블랙아웃 날짜 제거
     */
    private void removeBlackoutDate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int blackoutDateId = Integer.parseInt(request.getParameter("blackoutDateId"));

            int result = blackoutDateDAO.deactivate(blackoutDateId);

            if (result > 0) {
                sendJsonSuccess(response, "블랙아웃 날짜가 제거되었습니다.");
            } else {
                sendJsonError(response, "블랙아웃 날짜 제거에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "잘못된 블랙아웃 날짜 ID입니다.");
        }
    }

    /**
     * 테이블 추가
     */
    private void addTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request);
        int restaurantId = getRestaurantId(user);

        try {
            String tableName = request.getParameter("tableName");
            int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String tableTypeStr = request.getParameter("tableType");
            String notes = request.getParameter("notes");

            // 테이블 번호 중복 체크
            if (tableDAO.isTableNumberExists(restaurantId, tableNumber, 0)) {
                sendJsonError(response, "이미 존재하는 테이블 번호입니다.");
                return;
            }

            RestaurantTable newTable = new RestaurantTable(restaurantId, tableName, tableNumber, capacity);
            if (tableTypeStr != null && !tableTypeStr.isEmpty()) {
                newTable.setTableTypeString(tableTypeStr);
            }
            if (notes != null && !notes.trim().isEmpty()) {
                newTable.setNotes(notes);
            }

            int result = tableDAO.insert(newTable);

            if (result > 0) {
                sendJsonSuccess(response, "테이블이 추가되었습니다.");
            } else {
                sendJsonError(response, "테이블 추가에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "잘못된 숫자 입력입니다.");
        }
    }

    /**
     * 테이블 수정
     */
    private void updateTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int tableId = Integer.parseInt(request.getParameter("tableId"));
            String tableName = request.getParameter("tableName");
            int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String tableTypeStr = request.getParameter("tableType");
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            String notes = request.getParameter("notes");

            RestaurantTable table = tableDAO.findById(tableId);
            if (table == null) {
                sendJsonError(response, "존재하지 않는 테이블입니다.");
                return;
            }

            // 테이블 번호 중복 체크 (자신 제외)
            if (tableDAO.isTableNumberExists(table.getRestaurantId(), tableNumber, tableId)) {
                sendJsonError(response, "이미 존재하는 테이블 번호입니다.");
                return;
            }

            table.setTableName(tableName);
            table.setTableNumber(tableNumber);
            table.setCapacity(capacity);
            table.setTableTypeString(tableTypeStr);
            table.setActive(isActive);
            table.setNotes(notes);

            int result = tableDAO.update(table);

            if (result > 0) {
                sendJsonSuccess(response, "테이블 정보가 수정되었습니다.");
            } else {
                sendJsonError(response, "테이블 수정에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "잘못된 입력값입니다.");
        }
    }

    /**
     * 테이블 삭제
     */
    private void deleteTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int tableId = Integer.parseInt(request.getParameter("tableId"));

            int result = tableDAO.delete(tableId);

            if (result > 0) {
                sendJsonSuccess(response, "테이블이 삭제되었습니다.");
            } else {
                sendJsonError(response, "테이블 삭제에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "잘못된 테이블 ID입니다.");
        }
    }

    /**
     * 예약 승인
     */
    private void approveReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));

            boolean result = reservationService.updateReservationStatus(reservationId, "CONFIRMED");

            if (result) {
                // ReservationService에서 이메일 및 기타 알림을 처리합니다.
                sendJsonSuccess(response, "예약이 승인되었습니다.");
            } else {
                sendJsonError(response, "예약 승인에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "잘못된 예약 ID입니다.");
        }
    }

    /**
     * 예약 거부
     */
    private void rejectReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            String reason = request.getParameter("reason");

            boolean result = reservationService.updateReservationStatus(reservationId, "CANCELLED");

            if (result) {
                // 거부 알림 발송
                String message = "예약이 거부되었습니다.";
                if (reason != null && !reason.trim().isEmpty()) {
                    message += " 사유: " + reason;
                }
                sendReservationNotification(reservationId, message);
                sendJsonSuccess(response, "예약이 거부되었습니다.");
            } else {
                sendJsonError(response, "예약 거부에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "잘못된 예약 ID입니다.");
        }
    }

    /**
     * 알림 발송
     */
    private void sendNotification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            String notificationTypeStr = request.getParameter("notificationType");
            String message = request.getParameter("message");

            ReservationNotification.NotificationType notificationType =
                ReservationNotification.NotificationType.valueOf(notificationTypeStr);

            // 예약 정보 조회하여 수신자 정보 얻기
            var reservation = reservationService.getReservationById(reservationId);
            if (reservation == null) {
                sendJsonError(response, "존재하지 않는 예약입니다.");
                return;
            }

            String recipient = getRecipientByType(reservation, notificationType);
            if (recipient == null) {
                sendJsonError(response, "수신자 정보를 찾을 수 없습니다.");
                return;
            }

            ReservationNotification notification = new ReservationNotification(
                reservationId, notificationType, recipient, message);

            int result = notificationDAO.insert(notification);

            if (result > 0) {
                sendJsonSuccess(response, "알림이 발송되었습니다.");
            } else {
                sendJsonError(response, "알림 발송에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "잘못된 예약 ID입니다.");
        } catch (IllegalArgumentException e) {
            sendJsonError(response, "잘못된 알림 타입입니다.");
        }
    }

    // === 유틸리티 메서드들 ===

    private boolean isBusinessUser(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null && "BUSINESS".equals(user.getUserType());
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    private int getRestaurantId(User user) {
        // 사업자 사용자의 경우 본인 소유 음식점 ID 반환
        // 실제 구현에서는 사용자와 음식점 매핑 테이블에서 조회
        // 여기서는 간단히 사용자 ID를 음식점 ID로 사용
        return user.getId();
    }

    private void sendReservationNotification(int reservationId, String message) {
        try {
            var reservation = reservationService.getReservationById(reservationId);
            if (reservation != null && reservation.getContactPhone() != null) {
                ReservationNotification notification = new ReservationNotification(
                    reservationId,
                    ReservationNotification.NotificationType.SMS,
                    reservation.getContactPhone(),
                    message
                );
                notificationDAO.insert(notification);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getRecipientByType(model.Reservation reservation, ReservationNotification.NotificationType type) {
        switch (type) {
            case SMS:
                return reservation.getContactPhone();
            case EMAIL:
                // 예약 시 이메일 정보가 있다면 반환
                return null; // 현재 예약 모델에 이메일 필드가 없음
            case PUSH:
                return String.valueOf(reservation.getUserId()); // 사용자 ID를 푸시 수신자로 사용
            default:
                return null;
        }
    }

    private void sendJsonSuccess(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);

        response.getWriter().write(gson.toJson(result));
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);

        response.getWriter().write(gson.toJson(result));
    }
}