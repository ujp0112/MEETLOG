package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import model.Reservation;
import model.User;
import service.ReservationService;

@WebServlet("/business/reservation/notifications")
public class BusinessReservationNotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ObjectMapper objectMapper = new ObjectMapper();
    private ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            // 최근 5분 이내의 새로운 예약 조회
            List<Reservation> newReservations = reservationService.getRecentReservationsForBusiness(user.getId(), 5);

            // 처리 대기 중인 총 예약 수
            int totalPendingReservations = reservationService.getPendingReservationCount(user.getId());

            result.put("success", true);
            result.put("newReservations", newReservations);
            result.put("newCount", newReservations.size());
            result.put("totalPending", totalPendingReservations);
            result.put("timestamp", System.currentTimeMillis());

            if (newReservations.size() > 0) {
                result.put("hasNewReservations", true);
                String message = newReservations.size() == 1 ?
                    "새로운 예약 1건이 접수되었습니다." :
                    String.format("새로운 예약 %d건이 접수되었습니다.", newReservations.size());
                result.put("message", message);
            } else {
                result.put("hasNewReservations", false);
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "알림 조회에 실패했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}