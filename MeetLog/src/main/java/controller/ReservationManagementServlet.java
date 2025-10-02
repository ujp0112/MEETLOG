package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import model.Reservation;
import service.ReservationService;
import util.AdminSessionUtils;
import util.AdminSessionUtils;

@WebServlet("/admin/reservation-management")
public class ReservationManagementServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }
            
            // 실제 DB에서 모든 예약 조회 (관리자용)
            Map<String, Object> emptyParams = new HashMap<>();
            List<Reservation> reservations = reservationService.searchReservations(emptyParams);
            System.out.println("DEBUG: 관리자 예약 관리 - 조회된 예약 수: " + reservations.size());
            request.setAttribute("reservations", reservations);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-reservation-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    // 임시데이터 생성 메서드 제거 - 이제 실제 DB에서 조회
}
