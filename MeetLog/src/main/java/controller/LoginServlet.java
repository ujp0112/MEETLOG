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
        String userType = request.getParameter("userType"); // PERSONAL 또는 BUSINESS
        
        // [수정] 폼에서 넘어온 돌아갈 URL을 가져옵니다.
        String redirectUrl = request.getParameter("redirectUrl");

        try {
            User user = this.userService.authenticateUser(email, password, userType);

            // [추가] userType으로 인증 실패 시, 혹시 모를 관리자(ADMIN) 계정인지 한 번 더 확인
            if (user == null && "PERSONAL".equals(userType)) {
                 user = this.userService.authenticateUser(email, password, "ADMIN");
            }

            if (user != null) {
                // ============== 인증 성공 ==============
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userType", user.getUserType());

                // [수정] 세션에 저장된 redirectUrl은 이제 사용했으므로 제거합니다.
                session.removeAttribute("redirectUrl");
                
                // [수정] 리다이렉트 우선순위 로직
                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    // 1순위: 돌아갈 URL이 있으면 그곳으로 보냅니다.
                    response.sendRedirect(redirectUrl);
                } else {
                    // 2순위: 돌아갈 URL이 없으면 역할(Role)에 따라 기본 페이지로 보냅니다.
                    if ("ADMIN".equals(user.getUserType())) {
                        response.sendRedirect(request.getContextPath() + "/admin");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/main");
                    }
                }
            } else {
                // ============== 인증 실패 ==============
                request.setAttribute("errorMessage", "이메일 또는 비밀번호가 올바르지 않습니다.");
                
                // [수정] 로그인 실패 시에도 redirectUrl 정보를 뷰(JSP)로 다시 전달해야 합니다.
                // 이렇게 해야 로그인 재시도 시에도 원래 목적지 정보를 잃지 않습니다.
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