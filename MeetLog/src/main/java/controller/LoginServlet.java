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
            // 1. UserService를 통해 이메일과 비밀번호로 사용자 인증을 시도합니다.
            //    이때 반환되는 user 객체는 DB의 모든 컬럼 정보(profileImage 포함)를 가지고 있습니다.
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

                // 2. 새로운 세션을 생성하고, profileImage가 포함된 완전한 user 객체를 세션에 저장합니다.
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // 비즈니스 회원이면 businessUser 정보도 세션에 저장
                if ("BUSINESS".equals(user.getUserType())) {
                    BusinessUser businessUser = userService.getBusinessUserByUserId(user.getId());
                    if (businessUser != null) {
                        session.setAttribute("businessUser", businessUser);
                        System.out.println("BusinessUser 세션 저장 완료: " + businessUser.getRole());
                    } else {
                        System.out.println("BusinessUser 정보를 찾을 수 없음: userId=" + user.getId());
                    }
                }
                
                session.setMaxInactiveInterval(30 * 60);

                // 3. 사용자의 유형 또는 요청된 URL에 따라 올바른 페이지로 리다이렉트합니다.
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