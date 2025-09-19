package controller;

<<<<<<< HEAD
import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
=======
import javax.servlet.ServletException;
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
<<<<<<< HEAD
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
public class AddMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantService restaurantService = new RestaurantService();
    private MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 음식점 ID 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
            return;
        }
        
        try {
            int restaurantId = Integer.parseInt(pathInfo.substring(1).replace("/menus/add", ""));
            
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
            request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 음식점 ID입니다.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // URL에서 음식점 ID 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "음식점 ID가 필요합니다.");
            return;
        }
        
        try {
            int restaurantId = Integer.parseInt(pathInfo.substring(1).replace("/menus/add", ""));
            
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
            
            // 이미지 업로드 처리
            Part filePart = request.getPart("menuImage");
            String savedFilePath = null;
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/uploads/menu_images");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                filePart.write(uploadPath + java.io.File.separator + uniqueFileName);
                savedFilePath = "uploads/menu_images/" + uniqueFileName;
            }
            
            // 메뉴 정보 설정
            Menu menu = new Menu();
            menu.setRestaurantId(restaurantId);
            menu.setName(request.getParameter("name"));
            menu.setDescription(request.getParameter("description"));
            menu.setPrice(request.getParameter("price"));
            menu.setPopular(Boolean.parseBoolean(request.getParameter("popular")));
            if (savedFilePath != null) {
                menu.setImage(savedFilePath);
            }
            
            // 메뉴 저장
            menuService.addMenu(menu);
            
            response.sendRedirect(request.getContextPath() + "/business/restaurants/" + restaurantId + "/menus");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 음식점 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "메뉴 추가 중 오류가 발생했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/add-menu.jsp").forward(request, response);
=======
import java.io.IOException;
import model.User;
import model.Menu;
import service.MenuService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/menu/add")
public class AddMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        SqlSession sqlSession = null;
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // 폼 데이터 받기
            String name = request.getParameter("menuName");
            String priceStr = request.getParameter("menuPrice");
            String description = request.getParameter("menuDescription");
            String restaurantIdStr = request.getParameter("restaurantId");
            
            // 유효성 검사
            if (name == null || name.trim().isEmpty() || 
                priceStr == null || priceStr.trim().isEmpty() ||
                restaurantIdStr == null || restaurantIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "필수 정보를 모두 입력해주세요.");
                request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
                return;
            }
            
            try {
                int restaurantId = Integer.parseInt(restaurantIdStr);
                int price = Integer.parseInt(priceStr);
                
                // 메뉴 객체 생성
                Menu menu = new Menu();
                menu.setName(name.trim());
                menu.setPrice((double) price);
                menu.setDescription(description != null ? description.trim() : "");
                menu.setRestaurantId(restaurantId);
                menu.setPopular(false); // 기본값
                
                sqlSession = MyBatisSqlSessionFactory.getSqlSession();
                MenuService menuService = new MenuService();
                
                // 메뉴 저장
                boolean success = menuService.addMenu(menu, sqlSession);
                
                if (success) {
                    sqlSession.commit();
                    response.sendRedirect(request.getContextPath() + "/business/menu-management?success=added");
                } else {
                    sqlSession.rollback();
                    request.setAttribute("errorMessage", "메뉴 추가에 실패했습니다.");
                    request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "가격과 음식점 ID는 숫자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            request.setAttribute("errorMessage", "메뉴 추가 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
        }
    }
}
