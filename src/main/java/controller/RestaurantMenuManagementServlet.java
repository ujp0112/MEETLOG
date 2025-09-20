package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.Restaurant;
import model.Menu;
import service.RestaurantService;
import service.MenuService;

public class RestaurantMenuManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private MenuService menuService = new MenuService();

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

            // URL에서 음식점 ID 추출
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
                return;
            }
            
            int restaurantId = Integer.parseInt(pathInfo.substring(1)); // "/1" -> "1"
            
            // 음식점 정보 조회
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
                return;
            }
            
            // 사업자의 음식점인지 확인
            if (restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
                return;
            }
            
            // 메뉴 목록 조회
            List<Menu> menus = menuService.getMenusByRestaurantId(restaurantId);
            
            // JSP로 데이터 전달
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("menus", menus);

            request.getRequestDispatcher("/WEB-INF/views/restaurant-menu-management.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 음식점 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "메뉴 관리 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
