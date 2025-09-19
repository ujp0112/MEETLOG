package controller;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.Menu;
import model.Restaurant;
import model.User;
import service.MenuService;
import service.RestaurantService;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class EditMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID와 메뉴 ID 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID와 메뉴 ID가 필요합니다.");
            return;
        }
        
        try {
            String[] pathParts = pathInfo.substring(1).split("/");
            int restaurantId = Integer.parseInt(pathParts[0]);
            int menuId = Integer.parseInt(pathParts[2]);
            
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
            request.getRequestDispatcher("/WEB-INF/views/edit-menu.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 ID입니다.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // URL에서 음식점 ID와 메뉴 ID 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID와 메뉴 ID가 필요합니다.");
            return;
        }
        
        try {
            String[] pathParts = pathInfo.substring(1).split("/");
            int restaurantId = Integer.parseInt(pathParts[0]);
            int menuId = Integer.parseInt(pathParts[2]);
            
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
            
            // 이미지 업로드 처리
            Part filePart = request.getPart("menuImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/uploads/menu_images");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                filePart.write(uploadPath + java.io.File.separator + uniqueFileName);
                menu.setImage("uploads/menu_images/" + uniqueFileName);
            }
            
            // 메뉴 정보 업데이트
            menu.setName(request.getParameter("name"));
            menu.setDescription(request.getParameter("description"));
            menu.setPrice(request.getParameter("price"));
            menu.setPopular(Boolean.parseBoolean(request.getParameter("popular")));
            
            // 메뉴 업데이트
            menuService.updateMenu(menu);
            
            response.sendRedirect(request.getContextPath() + "/business/restaurants/" + restaurantId + "/menus");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메뉴 수정 중 오류가 발생했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/edit-menu.jsp").forward(request, response);
        }
    }
}
