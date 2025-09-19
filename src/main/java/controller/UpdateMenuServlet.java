package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import model.Menu;
import service.MenuService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/menu/update")
public class UpdateMenuServlet extends HttpServlet {
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
            String menuIdStr = request.getParameter("menuId");
            String name = request.getParameter("menuName");
            String priceStr = request.getParameter("menuPrice");
            String description = request.getParameter("menuDescription");
            String popularStr = request.getParameter("popular");
            
            // 유효성 검사
            if (menuIdStr == null || menuIdStr.trim().isEmpty() ||
                name == null || name.trim().isEmpty() || 
                priceStr == null || priceStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "필수 정보를 모두 입력해주세요.");
                request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
                return;
            }
            
            try {
                int menuId = Integer.parseInt(menuIdStr);
                int price = Integer.parseInt(priceStr);
                boolean popular = "on".equals(popularStr);
                
                // 메뉴 객체 생성
                Menu menu = new Menu();
                menu.setId(menuId);
                menu.setName(name.trim());
                menu.setPrice((double) price);
                menu.setDescription(description != null ? description.trim() : "");
                menu.setPopular(popular);
                
                sqlSession = MyBatisSqlSessionFactory.getSqlSession();
                MenuService menuService = new MenuService();
                
                // 메뉴 업데이트
                boolean success = menuService.updateMenu(menu, sqlSession);
                
                if (success) {
                    sqlSession.commit();
                    response.sendRedirect(request.getContextPath() + "/business/menu-management?success=updated");
                } else {
                    sqlSession.rollback();
                    request.setAttribute("errorMessage", "메뉴 수정에 실패했습니다.");
                    request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "가격과 메뉴 ID는 숫자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/views/business/menu-management.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            request.setAttribute("errorMessage", "메뉴 수정 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
}
