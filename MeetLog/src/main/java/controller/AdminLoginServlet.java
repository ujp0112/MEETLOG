package controller;

import model.User;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String adminEmail = request.getParameter("email");
        String password = request.getParameter("password");

        if (adminEmail == null || adminEmail.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "관리자 이메일과 비밀번호를 모두 입력해주세요.");
            request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
            return;
        }

        try {
            User adminUser = userService.authenticateUser(adminEmail.trim(), password, "ADMIN");
            if (adminUser == null) {
                request.setAttribute("errorMessage", "관리자 계정 정보가 올바르지 않습니다.");
                request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", adminUser);
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "로그인 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
        }
    }
}
