package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.RestaurantDAO;
import model.User;

public class BusinessStatisticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // 실제 DB에서 통계 데이터 조회
            Map<String, Object> statistics = restaurantDAO.getOwnerStatistics(user.getId());
            List<Map<String, Object>> restaurants = restaurantDAO.getOwnerRestaurantsWithStats(user.getId());

            // JSP로 데이터 전달
            if (statistics != null) {
                request.setAttribute("totalRestaurants", statistics.get("totalRestaurants"));
                request.setAttribute("totalReviews", statistics.get("totalReviews"));
                request.setAttribute("totalReservations", statistics.get("totalReservations"));
                request.setAttribute("averageRating", statistics.get("averageRating"));
            } else {
                request.setAttribute("totalRestaurants", 0);
                request.setAttribute("totalReviews", 0);
                request.setAttribute("totalReservations", 0);
                request.setAttribute("averageRating", 0.0);
            }

            request.setAttribute("restaurants", restaurants != null ? restaurants : new ArrayList<>());

            request.getRequestDispatcher("/WEB-INF/views/business-statistics.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "통계 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
