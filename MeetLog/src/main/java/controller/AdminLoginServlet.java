package controller;

import model.User;
import service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

	private static final Logger log = LoggerFactory.getLogger(AdminLoginServlet.class);
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

		log.debug("관리자 로그인 시도: email={}", adminEmail);

		if (adminEmail == null || adminEmail.trim().isEmpty() || password == null || password.trim().isEmpty()) {
			request.setAttribute("errorMessage", "관리자 이메일과 비밀번호를 모두 입력해주세요.");
			request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
			return;
		}

		try {
			User adminUser = userService.authenticateUser(adminEmail.trim(), password, "ADMIN");
			if (adminUser == null) {
				log.warn("관리자 로그인 실패: 계정 정보 불일치 (email={})", adminEmail.trim());
				request.setAttribute("errorMessage", "관리자 계정 정보가 올바르지 않습니다.");

				// [디버깅] 비밀번호 불일치 시, 암호화된 값 비교 출력
				User userInDb = userService.findByEmail(adminEmail.trim());
				log.debug("DB 저장된 암호: {}", userInDb != null ? userInDb.getPassword() : "사용자 없음");
				log.debug("입력된 암호의 해시: {}", PasswordUtil.hashPassword(password));

				request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
				return;
			}

			HttpSession session = request.getSession(true);
			session.setAttribute("user", adminUser);
			session.setMaxInactiveInterval(30 * 60);

			log.info("관리자 로그인 성공: userId={}, email={}", adminUser.getId(), adminUser.getEmail());
			response.sendRedirect(request.getContextPath() + "/admin/dashboard");
		} catch (Exception e) {
			log.error("관리자 로그인 처리 중 심각한 오류 발생", e);
			request.setAttribute("errorMessage", "로그인 처리 중 오류가 발생했습니다.");
			request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
		}
	}
}