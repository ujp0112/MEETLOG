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

@WebServlet("/admin/reservation-statistics")
public class ReservationStatisticsServlet extends HttpServlet {
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
            // 통계 데이터 조회
            Map<String, Integer> statistics = reservationDAO.getReservationStatistics();

            // 최근 예약 목록 (상위 10개)
            List<CourseReservation> recentReservations = reservationDAO.selectAllReservations();
            if (recentReservations.size() > 10) {
                recentReservations = recentReservations.subList(0, 10);
            }

            request.setAttribute("statistics", statistics);
            request.setAttribute("recentReservations", recentReservations);

            request.getRequestDispatcher("/WEB-INF/views/admin-reservation-statistics.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "통계 데이터를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
