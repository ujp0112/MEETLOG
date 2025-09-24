package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.User;
import model.Reservation;
import service.ReservationService;

@WebServlet("/business/reservation/update-status")
public class BusinessReservationUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ObjectMapper objectMapper = new ObjectMapper();
    private ReservationService reservationService = new ReservationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if it's an AJAX request
        String contentType = request.getContentType();
        boolean isAjax = contentType != null && contentType.contains("application/json");

        if (isAjax) {
            handleAjaxRequest(request, response);
        } else {
            handleFormRequest(request, response);
        }
    }

    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            result.put("success", false);
            result.put("message", "로그인이 필요하거나 권한이 없습니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }

        try {
            // JSON 요청 파싱
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuffer.append(line);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> requestData = objectMapper.readValue(jsonBuffer.toString(), Map.class);

            Object reservationIdObj = requestData.get("reservationId");
            String status = (String) requestData.get("status");

            if (reservationIdObj == null || status == null || status.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "필수 정보가 누락되었습니다.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(objectMapper.writeValueAsString(result));
                return;
            }

            int reservationId = Integer.parseInt(reservationIdObj.toString());

            // 예약 상태 업데이트
            boolean success = reservationService.updateReservationStatus(reservationId, status, user.getId());

            if (success) {
                // 업데이트된 예약 정보 조회
                Reservation updatedReservation = reservationService.getReservationById(reservationId);

                result.put("success", true);
                result.put("message", "예약 상태가 성공적으로 업데이트되었습니다.");
                result.put("reservationId", reservationId);
                result.put("newStatus", status);
                result.put("reservation", updatedReservation);
                result.put("timestamp", System.currentTimeMillis());
            } else {
                result.put("success", false);
                result.put("message", "예약 상태 업데이트에 실패했습니다.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "예약 ID는 숫자여야 합니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }

    private void handleFormRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 기존 폼 방식 처리 (기존 코드와 호환성 유지)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String reservationIdStr = request.getParameter("reservationId");
            String status = request.getParameter("status");

            if (reservationIdStr != null && status != null) {
                int reservationId = Integer.parseInt(reservationIdStr);
                boolean success = reservationService.updateReservationStatus(reservationId, status, user.getId());

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/business/reservation-management?success=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/business/reservation-management?error=update_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/business/reservation-management?error=invalid_params");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/business/reservation-management?error=server_error");
        }
    }
}