package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.CourseReservationDAO;
import model.CourseReservation;
import model.User;

@WebServlet("/admin/course-reservation")
public class CourseReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CourseReservationDAO reservationDAO = new CourseReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        try {
            String statusFilter = request.getParameter("status");
            String courseIdParam = request.getParameter("courseId");

            List<CourseReservation> reservations;

            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                int courseId = Integer.parseInt(courseIdParam);
                reservations = reservationDAO.selectReservationsByCourse(courseId);
            } else if (statusFilter != null && !statusFilter.isEmpty()) {
                reservations = reservationDAO.selectReservationsByStatus(statusFilter);
            } else {
                reservations = reservationDAO.selectAllReservations();
            }

            Map<String, Integer> statistics = reservationDAO.getReservationStatistics();

            request.setAttribute("reservations", reservations);
            request.setAttribute("statistics", statistics);
            request.setAttribute("currentStatus", statusFilter);

            request.getRequestDispatcher("/WEB-INF/views/admin-course-reservation.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        try {
            String action = request.getParameter("action");
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));

            String newStatus = null;
            String successMessage = null;

            if ("confirm".equals(action)) {
                newStatus = "CONFIRMED";
                successMessage = "예약이 확정되었습니다.";
            } else if ("complete".equals(action)) {
                newStatus = "COMPLETED";
                successMessage = "예약이 완료 처리되었습니다.";
            } else if ("cancel".equals(action)) {
                newStatus = "CANCELLED";
                successMessage = "예약이 취소되었습니다.";
            }

            if (newStatus != null) {
                reservationDAO.updateReservationStatus(reservationId, newStatus);
                session.setAttribute("successMessage", successMessage);
            }

            response.sendRedirect(request.getContextPath() + "/admin/course-reservation");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "예약 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
}
