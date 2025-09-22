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
import model.Restaurant; // Restaurant 모델 import

public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();
    private final RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 관리자 권한 체크 (userType이 "ADMIN"인지 확인)
        if (user == null || !"ADMIN".equals(user.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
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
            // 에러 페이지 경로를 프로젝트에 맞게 확인하세요.
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    private void handleAdminDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 대시보드에 필요한 데이터 로딩 (총 사용자 수, 총 맛집 수 등)
        int totalUsers = userService.getAllUsers().size();
        request.setAttribute("totalUsers", totalUsers);
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void handleUserManagement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/user-management.jsp").forward(request, response);
    }

    private void handleRestaurantManagement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // RestaurantService에 모든 가게를 가져오는 메소드가 필요합니다.
        // List<Restaurant> restaurants = restaurantService.getAllRestaurants();
        // request.setAttribute("restaurants", restaurants);
        // request.getRequestDispatcher("/WEB-INF/views/admin/restaurant-management.jsp").forward(request, response);
        response.getWriter().println("Restaurant Management Page (Not Implemented)");
    }
}