package controller;

import java.io.File;
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
import model.Restaurant; // Restaurant 모델 import 추가
import model.User;
import service.MenuService;
import service.RestaurantService; // RestaurantService import 추가
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuService menuService = new MenuService();
    // RestaurantService 추가
    private RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 요청 URL: /business/menus/add/1
        // request.getPathInfo()는 "/1"을 반환
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.split("/").length < 2) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "레스토랑 ID가 필요합니다.");
            return;
        }
        
        String[] pathParts = pathInfo.split("/");
        // pathParts -> ["", "1"]

        try {
            int restaurantId = Integer.parseInt(pathParts[1]);
            
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

            // 레스토랑 정보도 조회해서 JSP로 넘겨줍니다. (JSP에서 ${restaurant.name} 사용)
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null || restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없거나 존재하지 않는 레스토랑입니다.");
                return;
            }

            request.setAttribute("restaurant", restaurant); // restaurant 객체 전달
            request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 레스토랑 ID입니다.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // 요청 URL: /business/menus/add/1
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.split("/").length < 2) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "레스토랑 ID가 필요합니다.");
            return;
        }
        
        String[] pathParts = pathInfo.split("/");
        int restaurantId = 0;

        try {
            restaurantId = Integer.parseInt(pathParts[1]);
            
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

            // 소유권 확인
            Restaurant restaurant = restaurantService.findById(restaurantId);
            if (restaurant == null || restaurant.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
                return;
            }

            // 파일 업로드 처리
            String savedFilePath = null;
            // JSP 파일에서 name="menuImage"로 설정되어 있으므로 "image"가 아닌 "menuImage"로 받습니다.
            Part filePart = request.getPart("menuImage"); 
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                if (fileName != null && !fileName.isEmpty()) {
                    String fileExtension = "";
                    if (fileName.lastIndexOf(".") > 0) {
                        fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    }
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    
                    String uploadPath = getServletContext().getRealPath("/uploads/menus");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    filePart.write(filePath);
                    savedFilePath = "uploads/menus/" + uniqueFileName;
                }
            }

            // 메뉴 정보 설정
            Menu menu = new Menu();
            menu.setRestaurantId(restaurantId);
            menu.setName(request.getParameter("name"));
            menu.setDescription(request.getParameter("description"));
            menu.setPrice(request.getParameter("price"));
            menu.setCategory(request.getParameter("category")); // category 추가
            String stockParam = request.getParameter("stock");
            menu.setStock(stockParam != null && !stockParam.isEmpty() ? Integer.parseInt(stockParam) : 0); // stock 추가
            menu.setActive(request.getParameter("isActive") != null); // isActive 추가
            menu.setPopular(request.getParameter("popular") != null); 
            
            if (savedFilePath != null) {
                menu.setImage(savedFilePath);
            }
            
            boolean success = menuService.addMenu(menu);
            
            if (success) {
                // 성공 시 새로운 목록 URL로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/business/menus/" + restaurantId);
            } else {
                request.setAttribute("errorMessage", "메뉴 추가에 실패했습니다.");
                request.setAttribute("restaurant", restaurant);
                request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 레스토랑 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메뉴 추가 중 오류가 발생했습니다: " + e.getMessage());
            request.setAttribute("restaurant", restaurantService.findById(restaurantId));
            request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);
        }
    }
}