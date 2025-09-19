package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;
import service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    public LoginServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType"); // "PERSONAL" 또는 "BUSINESS"
        String redirectUrl = request.getParameter("redirectUrl");

        try {
            User user = this.userService.authenticateUser(email, password, userType);

            if (user == null && "PERSONAL".equals(userType)) {
                 user = this.userService.authenticateUser(email, password, "ADMIN");
            }

            if (user != null) {
                // ============== 인증 성공 ==============
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userType", user.getUserType());
                session.removeAttribute("redirectUrl");

                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    response.sendRedirect(redirectUrl);
                } else {
                    String userRole = user.getUserType();
                    if ("ADMIN".equals(userRole)) {
                        response.sendRedirect(request.getContextPath() + "/admin");
                    } else if ("BUSINESS".equals(userRole)) {
                        // 기업회원(BUSINESS)은 '내 가게 목록' 페이지로 이동
                        response.sendRedirect(request.getContextPath() + "/business/restaurants");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/main");
                    }
                }
            } else {
                // ============== 인증 실패 ==============
                request.setAttribute("errorMessage", "이메일 또는 비밀번호가 올바르지 않습니다.");
                request.setAttribute("redirectUrl", redirectUrl);
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "로그인 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}