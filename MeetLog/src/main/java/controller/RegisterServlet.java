package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import service.UserService;
import util.PasswordUtil;

public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();

    /**
     * GET 요청 시, 개인 회원가입 페이지(register.jsp)를 보여줍니다.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    /**
     * POST 요청 시, 개인 회원가입 데이터를 처리합니다.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword"); // 비밀번호 확인 값

        // --- 유효성 검사 ---
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        if (userService.isEmailExists(email)) {
            request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        if (userService.isNicknameExists(nickname)) {
            request.setAttribute("errorMessage", "이미 사용 중인 닉네임입니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // --- User 객체 생성 및 DB 저장 ---
        User user = new User();
        user.setEmail(email);
        user.setNickname(nickname);
        user.setPassword(PasswordUtil.hashPassword(password)); // 비밀번호 해싱
        user.setUserType("PERSONAL");
        
		if (userService.registerUser(user)) {
			// 성공 시 로그인 페이지로 이동
			response.sendRedirect(request.getContextPath() + "/login?register=success");
		} else {
			// 실패 시 오류 메시지와 함께 가입 페이지로 복귀
			request.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다.");
			request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
		}
    }
}