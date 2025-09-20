package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Menu;
import model.OperatingHour;
import model.Restaurant;
import model.User;
import service.MenuService;
import service.OperatingHourService;
import service.RestaurantService;
import service.BusinessQnAService;

public class RestaurantDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private MenuService menuService = new MenuService();
    private OperatingHourService operatingHourService = new OperatingHourService();
    private BusinessQnAService qnaService = new BusinessQnAService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID 추출
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // /restaurant/detail/11 -> 11 추출
        String[] pathParts = path.split("/");
        if (pathParts.length < 4 || pathParts[3].isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
            return;
        }
        
        try {
            int restaurantId = Integer.parseInt(pathParts[3]);
            
            // 음식점 정보 조회
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
                return;
            }
            
            // 메뉴 목록 조회
            List<Menu> menus = menuService.findByRestaurantId(restaurantId);
            
            // 운영시간 조회
            List<OperatingHour> operatingHours = operatingHourService.findByRestaurantId(restaurantId);
            
            // Q&A 조회
            List<model.BusinessQnA> qnas = qnaService.getQnAByRestaurantId(restaurantId);
            
            // 세션에서 사용자 정보 확인 (소유자 여부 판단용)
            HttpSession session = request.getSession(false);
            boolean isOwner = false;
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                isOwner = user.getId() == restaurant.getOwnerId() && "BUSINESS".equals(user.getUserType());
            }
            
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("menus", menus);
            request.setAttribute("operatingHours", operatingHours);
            request.setAttribute("qnas", qnas);
            request.setAttribute("isOwner", isOwner);
            
            request.getRequestDispatcher("/WEB-INF/views/restaurant-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 음식점 ID입니다.");
        }
    }
}
