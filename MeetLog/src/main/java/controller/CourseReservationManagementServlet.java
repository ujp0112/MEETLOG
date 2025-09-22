package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.AdminCourseReservation;
import model.User;
import service.CourseReservationManagementService; // Service 계층 사용

public class CourseReservationManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CourseReservationManagementService reservationService = new CourseReservationManagementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }
        
        List<AdminCourseReservation> reservations = reservationService.getAllReservationsForAdmin();
        request.setAttribute("reservations", reservations);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/course-reservation-management.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
            return;
        }
        
        String action = request.getParameter("action");
        int reservationId = Integer.parseInt(request.getParameter("id"));
        
        try {
            switch (action) {
                case "confirm":
                    reservationService.updateReservationStatus(reservationId, "CONFIRMED");
                    request.setAttribute("successMessage", "예약이 확정 처리되었습니다.");
                    break;
                case "cancel":
                    reservationService.updateReservationStatus(reservationId, "CANCELLED");
                    request.setAttribute("successMessage", "예약이 취소 처리되었습니다.");
                    break;
                case "complete":
                    reservationService.updateReservationStatus(reservationId, "COMPLETED");
                    request.setAttribute("successMessage", "예약이 완료 처리되었습니다.");
                    break;
                default:
                    request.setAttribute("errorMessage", "알 수 없는 요청입니다.");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "작업 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}