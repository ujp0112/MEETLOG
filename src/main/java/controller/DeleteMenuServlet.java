package controller;

<<<<<<< HEAD
import java.io.IOException;

=======
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
<<<<<<< HEAD

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
            
            // 메뉴 삭제
            menuService.deleteMenu(menuId);
            
            response.sendRedirect(request.getContextPath() + "/business/restaurants/" + restaurantId + "/menus");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "올바르지 않은 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "메뉴 삭제 중 오류가 발생했습니다.");
=======
import java.io.IOException;
import model.User;
import service.MenuService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/menu/delete")
public class DeleteMenuServlet extends HttpServlet {
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
            
            // 메뉴 ID 받기
            String menuIdStr = request.getParameter("menuId");
            
            if (menuIdStr == null || menuIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "메뉴 ID가 필요합니다.");
                request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
                return;
            }
            
            try {
                int menuId = Integer.parseInt(menuIdStr);
                
                sqlSession = MyBatisSqlSessionFactory.getSqlSession();
                MenuService menuService = new MenuService();
                
                // 메뉴 삭제
                boolean success = menuService.deleteMenu(menuId, sqlSession);
                
                if (success) {
                    sqlSession.commit();
                    response.sendRedirect(request.getContextPath() + "/business/menu-management?success=deleted");
                } else {
                    sqlSession.rollback();
                    request.setAttribute("errorMessage", "메뉴 삭제에 실패했습니다.");
                    request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "메뉴 ID는 숫자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            request.setAttribute("errorMessage", "메뉴 삭제 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
>>>>>>> 0964c5034709fc22f4307bc36d412f3659e9c08d
        }
    }
}
