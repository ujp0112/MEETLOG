package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 관리자 로그인 페이지로 이동
        request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String adminId = request.getParameter("adminId");
        String password = request.getParameter("password");
        
        try {
            // 간단한 관리자 인증 (실제로는 데이터베이스에서 확인)
            if ("admin".equals(adminId) && "admin123".equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("adminId", adminId);
                session.setAttribute("adminRole", "SUPER_ADMIN");
                
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                request.setAttribute("errorMessage", "관리자 ID 또는 비밀번호가 올바르지 않습니다.");
                request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "로그인 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
        }
    }
}
