package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; // @WebServlet을 사용하기 위해 import
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.github.scribejava.core.model.OAuth2AccessToken;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.services.oauth2.model.Userinfo;

import model.User;
import service.SocialLoginService;
import service.UserService;
import util.NaverLoginBO;
import util.GoogleLoginBO;
import util.KakaoLoginBO;

@WebServlet("/auth/callback/*") // 이 어노테이션이 가장 중요합니다!
public class SocialLoginCallbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final UserService userService = new UserService();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String provider = request.getPathInfo().substring(1);
		String code = request.getParameter("code");
		String state = request.getParameter("state");

		System.out.println("콜백 요청 수신: " + provider + ", code: " + (code != null ? "있음" : "없음")); // 디버깅 로그 추가

		SocialLoginService socialLoginService = new SocialLoginService();
		User profile = null;

		try {
			if ("naver".equals(provider)) {
				OAuth2AccessToken accessToken = NaverLoginBO.getAccessToken(request, code, state);
				String apiResult = NaverLoginBO.getUserProfile(accessToken);
				profile = socialLoginService.getNaverProfile(apiResult);
			} else if ("kakao".equals(provider)) {
				OAuth2AccessToken accessToken = KakaoLoginBO.getAccessToken(code);
				String apiResult = KakaoLoginBO.getUserProfile(accessToken);
				profile = socialLoginService.getKakaoProfile(apiResult);
			} else if ("google".equals(provider)) {
				Credential credential = GoogleLoginBO.getAccessToken(code);
				Userinfo userInfo = GoogleLoginBO.getUserProfile(credential);
				profile = socialLoginService.getGoogleProfile(userInfo);
			}

			if (profile != null) {
				User user = userService.getOrCreateSocialUser(profile);
				if (user != null) {
					HttpSession session = request.getSession();
					session.setAttribute("user", user);
					session.setMaxInactiveInterval(30 * 60);
					
					session.setAttribute("socialProvider", provider); 

					System.out.println("로그인 성공, 메인 페이지로 리디렉션: " + user.getEmail()); // 성공 로그 추가
					response.sendRedirect(request.getContextPath() + "/main");
				} else {
					System.err.println("UserService에서 user 객체를 생성하지 못함.");
					request.setAttribute("errorMessage", "사용자 정보를 처리하는 데 실패했습니다.");
					request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
				}
			} else {
				System.err.println("소셜 프로필 정보를 가져오는 데 실패함.");
				request.setAttribute("errorMessage", "소셜 로그인에 실패했습니다. API 응답을 확인해주세요.");
				request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
			}
		} catch (Exception e) {
			System.err.println("콜백 처리 중 예외 발생!");
			e.printStackTrace();
			request.setAttribute("errorMessage", "소셜 로그인 처리 중 서버 오류가 발생했습니다.");
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
		}
	}
}