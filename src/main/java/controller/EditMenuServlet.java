package controller;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
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
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 100    // 100 MB
)
public class EditMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 요청 URL: /business/menus/edit/1/3
        // request.getPathInfo()는 "/1/3"을 반환
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.split("/").length < 3) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "레스토랑 ID와 메뉴 ID가 필요합니다.");
            return;
        }
        
        String[] pathParts = pathInfo.split("/");
        // pathParts -> ["", "1", "3"]
        
        try {
            int restaurantId = Integer.parseInt(pathParts[1]);
            int menuId = Integer.parseInt(pathParts[2]);
            
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
            
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null || restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
                return;
            }
            
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
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.split("/").length < 3) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "레스토랑 ID와 메뉴 ID가 필요합니다.");
            return;
        }
        
        String[] pathParts = pathInfo.split("/");
        int restaurantId = 0;
        int menuId = 0;
        
        try {
            restaurantId = Integer.parseInt(pathParts[1]);
            menuId = Integer.parseInt(pathParts[2]);
            
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
            
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null || restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
                return;
            }
            
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
            
            // 메뉴 정보 업데이트 (누락된 필드 모두 반영)
            menu.setName(request.getParameter("name"));
            menu.setDescription(request.getParameter("description"));
            menu.setPrice(request.getParameter("price"));
            menu.setCategory(request.getParameter("category"));
            
            String stockParam = request.getParameter("stock");
            menu.setStock(stockParam != null && !stockParam.isEmpty() ? Integer.parseInt(stockParam) : 0);
            
            menu.setActive(request.getParameter("isActive") != null);
            menu.setPopular(request.getParameter("popular") != null);
            
            menuService.updateMenu(menu);
            
            // 성공 시 새로운 목록 URL로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/business/menus/" + restaurantId);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메뉴 수정 중 오류가 발생했습니다. 다시 시도해주세요.");
            request.setAttribute("restaurant", restaurantService.findById(restaurantId));
            request.setAttribute("menu", menuService.findById(menuId)); // menu 객체도 다시 설정
            request.getRequestDispatcher("/WEB-INF/views/edit-menu.jsp").forward(request, response);
        }
    }
}