package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger log = LoggerFactory.getLogger(RegisterServlet.class);
	private final UserService userService = new UserService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String email = request.getParameter("email");
		String nickname = request.getParameter("nickname");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");

		log.debug("개인 회원가입 시도: email={}, nickname={}", email, nickname);

		if (password == null || !password.equals(confirmPassword)) {
			log.warn("회원가입 유효성 검사 실패: 비밀번호 불일치 (email={})", email);
			request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
			request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
			return;
		}

		if (userService.isEmailExists(email)) {
			log.warn("회원가입 유효성 검사 실패: 이메일 중복 (email={})", email);
			request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
			request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
			return;
		}

		if (userService.isNicknameExists(nickname)) {
			log.warn("회원가입 유효성 검사 실패: 닉네임 중복 (nickname={})", nickname);
			request.setAttribute("errorMessage", "이미 사용 중인 닉네임입니다.");
			request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
			return;
		}

		User user = new User();
		user.setEmail(email);
		user.setNickname(nickname);
		user.setPassword(password);
		user.setUserType("PERSONAL");
		user.setActive(true);

		if (userService.registerUser(user)) {
			log.info("개인 회원가입 성공: userId={}, email={}", user.getId(), email);
			response.sendRedirect(request.getContextPath() + "/login?register=success");
		} else {
			log.error("개인 회원가입 실패: userService.registerUser가 false 반환 (email={})", email);
			request.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다.");
			request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
		}
	}
}