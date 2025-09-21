package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.BusinessUser;
import service.UserService;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirectUrl = request.getParameter("redirectUrl");
        
        try {
            User user = userService.authenticateUser(email, password);

            if (user != null) {
                // ============== 인증 성공 ==============
                // 비즈니스 회원의 경우, 승인 상태 추가 확인
                if ("BUSINESS".equals(user.getUserType())) {
                    BusinessUser bizUser = userService.getBusinessUserByUserId(user.getId());
                    if (bizUser != null && "PENDING".equals(bizUser.getStatus())) {
                        request.setAttribute("errorMessage", "가입 승인 대기 중인 계정입니다. 본사의 승인 후 로그인해주세요.");
                        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                        return;
                    }
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // 비즈니스 회원이면 businessUser 정보도 세션에 저장
                if ("BUSINESS".equals(user.getUserType())) {
                     session.setAttribute("businessUser", userService.getBusinessUserByUserId(user.getId()));
                }
                
                session.setMaxInactiveInterval(30 * 60);

                // 리다이렉트 처리
                String targetUrl = redirectUrl;
                if (targetUrl == null || targetUrl.trim().isEmpty()) {
                    switch (user.getUserType()) {
                        case "ADMIN":
                            targetUrl = request.getContextPath() + "/admin";
                            break;
                        case "BUSINESS":
                            targetUrl = request.getContextPath() + "/business/restaurants";
                            break;
                        default:
                            targetUrl = request.getContextPath() + "/main";
                            break;
                    }
                }
                response.sendRedirect(targetUrl);
                
            } else {
                // ============== 인증 실패 ==============
                request.setAttribute("errorMessage", "이메일 또는 비밀번호가 올바르지 않습니다.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "로그인 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}