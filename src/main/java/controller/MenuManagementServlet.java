package controller;

import java.io.IOException;
import java.util.List;

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

public class MenuManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 간단한 테스트를 위한 로그
        System.out.println("=== MenuManagementServlet 호출됨 ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Path Info: " + request.getPathInfo());
        
        // URL에서 음식점 ID 추출
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // 디버깅을 위한 로그
        System.out.println("DEBUG - requestURI: " + requestURI);
        System.out.println("DEBUG - contextPath: " + contextPath);
        System.out.println("DEBUG - path: " + path);
        
        // 테스트 URL 처리
        if ("/menu-test".equals(path) || "/menu-management-test".equals(path)) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h1>MenuManagementServlet 테스트 성공!</h1>");
            response.getWriter().println("<p>서블릿이 정상적으로 호출되었습니다.</p>");
            response.getWriter().println("<p>Path: " + path + "</p>");
            return;
        }
        
        // 메뉴 추가 페이지 처리
        if (path.matches("/business/restaurants/\\d+/menus/add")) {
            handleMenuAdd(request, response);
            return;
        }
        
        // 메뉴 수정 페이지 처리
        if (path.matches("/business/restaurants/\\d+/menus/edit/\\d+")) {
            handleMenuEdit(request, response);
            return;
        }
        
        // /business/restaurants/11/menus -> 11 추출
        String[] pathParts = path.split("/");
        System.out.println("DEBUG - pathParts length: " + pathParts.length);
        for (int i = 0; i < pathParts.length; i++) {
            System.out.println("DEBUG - pathParts[" + i + "]: '" + pathParts[i] + "'");
        }
        
        if (pathParts.length < 5 || (pathParts.length > 3 && pathParts[3].isEmpty())) {
            System.out.println("DEBUG - Path validation failed. Length: " + pathParts.length + ", pathParts[3]: '" + (pathParts.length > 3 ? pathParts[3] : "N/A") + "'");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
            return;
        }
        
        try {
            // 안전하게 restaurant ID 추출
            int restaurantId = 0;
            if (pathParts.length >= 4) {
                restaurantId = Integer.parseInt(pathParts[3]);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
                return;
            }
            
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
            
            // 음식점 정보 조회 및 소유자 확인
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
                return;
            }
            
            if (restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "이 음식점의 소유자가 아닙니다.");
                return;
            }
            
            // 메뉴 목록 조회
            List<Menu> menus = menuService.findByRestaurantId(restaurantId);
            
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("menus", menus);
            
            request.getRequestDispatcher("/WEB-INF/views/menu-management.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 음식점 ID입니다.");
        }
    }
    
    private void handleMenuAdd(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID 추출
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        String[] pathParts = path.split("/");
        
        try {
            int restaurantId = Integer.parseInt(pathParts[3]);
            
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
            
            // 음식점 정보 조회 및 소유자 확인
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
                return;
            }
            
            if (restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "이 음식점의 소유자가 아닙니다.");
                return;
            }
            
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/WEB-INF/views/menu-add.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 음식점 ID입니다.");
        }
    }
    
    private void handleMenuEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID와 메뉴 ID 추출
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        String[] pathParts = path.split("/");
        
        try {
            int restaurantId = Integer.parseInt(pathParts[3]);
            int menuId = Integer.parseInt(pathParts[6]);
            
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
            
            // 음식점 정보 조회 및 소유자 확인
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
                return;
            }
            
            if (restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "이 음식점의 소유자가 아닙니다.");
                return;
            }
            
            // 메뉴 정보 조회
            Menu menu = menuService.findById(menuId);
            if (menu == null || menu.getRestaurantId() != restaurantId) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "메뉴를 찾을 수 없습니다.");
                return;
            }
            
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("menu", menu);
            request.getRequestDispatcher("/WEB-INF/views/menu-edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 ID입니다.");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID 추출
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        String[] pathParts = path.split("/");
        
        try {
            int restaurantId = Integer.parseInt(pathParts[3]);
            
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
            
            // 음식점 정보 조회 및 소유자 확인
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "음식점을 찾을 수 없습니다.");
                return;
            }
            
            if (restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "이 음식점의 소유자가 아닙니다.");
                return;
            }
            
            // 메뉴 추가 처리
            if (path.matches("/business/restaurants/\\d+/menus")) {
                handleMenuCreate(request, response, restaurantId);
            }
            // 메뉴 수정 처리
            else if (path.matches("/business/restaurants/\\d+/menus/edit/\\d+")) {
                int menuId = Integer.parseInt(pathParts[6]);
                handleMenuUpdate(request, response, restaurantId, menuId);
            }
            else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 요청입니다.");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 ID입니다.");
        }
    }
    
    private void handleMenuCreate(HttpServletRequest request, HttpServletResponse response, int restaurantId) 
            throws ServletException, IOException {
        
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            String category = request.getParameter("category");
            String stockParam = request.getParameter("stock");
            int stock = stockParam != null && !stockParam.isEmpty() ? Integer.parseInt(stockParam) : 0;
            boolean isActive = request.getParameter("isActive") != null;
            
            Menu menu = new Menu();
            menu.setRestaurantId(restaurantId);
            menu.setName(name);
            menu.setDescription(description);
            menu.setPrice(price);
            menu.setCategory(category);
            menu.setStock(stock);
            menu.setActive(isActive);
            
            // TODO: 이미지 업로드 처리 (필요시)
            
            boolean success = menuService.addMenu(menu);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/business/restaurants/" + restaurantId + "/menus?success=created");
            } else {
                request.setAttribute("errorMessage", "메뉴 생성에 실패했습니다.");
                request.getRequestDispatcher("/WEB-INF/views/menu-add.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메뉴 생성 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/menu-add.jsp").forward(request, response);
        }
    }
    
    private void handleMenuUpdate(HttpServletRequest request, HttpServletResponse response, int restaurantId, int menuId) 
            throws ServletException, IOException {
        
        try {
            // 기존 메뉴 조회
            Menu existingMenu = menuService.findById(menuId);
            if (existingMenu == null || existingMenu.getRestaurantId() != restaurantId) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "메뉴를 찾을 수 없습니다.");
                return;
            }
            
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            String category = request.getParameter("category");
            String stockParam = request.getParameter("stock");
            int stock = stockParam != null && !stockParam.isEmpty() ? Integer.parseInt(stockParam) : 0;
            boolean isActive = request.getParameter("isActive") != null;
            
            existingMenu.setName(name);
            existingMenu.setDescription(description);
            existingMenu.setPrice(price);
            existingMenu.setCategory(category);
            existingMenu.setStock(stock);
            existingMenu.setActive(isActive);
            
            // TODO: 이미지 업로드 처리 (필요시)
            
            boolean success = menuService.updateMenu(existingMenu);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/business/restaurants/" + restaurantId + "/menus?success=updated");
            } else {
                request.setAttribute("errorMessage", "메뉴 수정에 실패했습니다.");
                request.setAttribute("menu", existingMenu);
                request.getRequestDispatcher("/WEB-INF/views/menu-edit.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메뉴 수정 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/menu-edit.jsp").forward(request, response);
        }
    }
}