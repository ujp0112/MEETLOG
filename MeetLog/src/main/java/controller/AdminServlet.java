package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;
import service.UserService;
import service.RestaurantService;


public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 관리자 권한 체크 (userType이 "ADMIN"인지 확인)
        if (user == null || !"ADMIN".equals(user.getUserType())) {
            // [수정] 접근 권한이 없을 때 403 Forbidden 에러를 보내거나 메인으로 리다이렉트
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            // response.sendRedirect(request.getContextPath() + "/main?error=auth");
            return;
        }
        // 권한이 있으면 doGet/doPost 등 실행
        super.service(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/"; // 기본 경로를 대시보드로
        }

        try {
            switch (pathInfo) {
                case "/users":
                    handleUserManagement(request, response);
                    break;
                case "/restaurants":
                    handleRestaurantManagement(request, response);
                    break;
                case "/":
                default:
                    handleAdminDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "관리자 페이지 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    private void handleAdminDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: 대시보드에 필요한 데이터 로딩 (총 사용자 수, 총 맛집 수 등)
        // 예: int totalUsers = userService.getAllUsers().size();
        // request.setAttribute("totalUsers", totalUsers);
        request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
    }

    private void handleUserManagement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin-user-management.jsp").forward(request, response);
    }

    private void handleRestaurantManagement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: 맛집 관리 로직 구현 (맛집 목록 표시 등)
        // List<Restaurant> restaurants = restaurantService.searchRestaurants(null, null, null, null, null);
        // request.setAttribute("restaurants", restaurants);
        // request.getRequestDispatcher("/WEB-INF/views/admin-restaurant-management.jsp").forward(request, response);
        response.getWriter().println("Restaurant Management Page (Not Implemented)");
    }
}