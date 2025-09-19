package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
        }
    }
}
