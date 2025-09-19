package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Menu;
import model.Restaurant;
import model.User;
import service.MenuService;
import service.RestaurantService;

public class DeleteMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private MenuService menuService = new MenuService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID와 메뉴 ID 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID와 메뉴 ID가 필요합니다.");
            return;
        }

        try {
            String[] pathParts = pathInfo.split("/");
            int restaurantId = Integer.parseInt(pathParts[1]);
            int menuId = Integer.parseInt(pathParts[3]);
            
            // 세션 확인
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"BUSINESS".equals(user.getUserType())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
                return;
            }

            // 음식점 소유권 확인
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null || restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "해당 음식점에 대한 메뉴 삭제 권한이 없습니다.");
                return;
            }

            // 메뉴 존재 확인
            Menu menu = menuService.findById(menuId);
            if (menu == null || menu.getRestaurantId() != restaurantId) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "메뉴를 찾을 수 없습니다.");
                return;
            }

            // 메뉴 삭제
            boolean success = menuService.deleteMenu(menuId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/business/restaurants/" + restaurantId + "/menus");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "메뉴 삭제에 실패했습니다.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "메뉴 삭제 중 오류가 발생했습니다.");
        }
    }
}