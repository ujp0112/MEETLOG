// src/main/java/controller/SocialLoginServlet.java (새 파일)
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.KakaoLoginBO;
import util.NaverLoginBO;
import util.GoogleLoginBO;
// import util.GoogleLoginBO; // 추후 구글 로그인 BO 클래스를 만들면 추가

@WebServlet("/auth/login/*")
public class SocialLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String provider = request.getPathInfo().substring(1); // URL에서 /naver, /kakao 등을 추출
		String authUrl = null;

		System.out.println("Social Login 요청 수신: " + provider); // 디버깅용 로그

		if ("naver".equals(provider)) {
			authUrl = NaverLoginBO.getAuthorizationUrl(request.getSession());
		} else if ("kakao".equals(provider)) {
			authUrl = KakaoLoginBO.getAuthorizationUrl();
		} else if ("google".equals(provider)) {
			authUrl = GoogleLoginBO.getAuthorizationUrl(); // 구글 로그인 로직 추가 시 주석 해제
			System.out.println("Google login is not yet implemented."); // 임시 로그
		}

		if (authUrl != null) {
			System.out.println("인증 URL로 리디렉션: " + authUrl); // 디버깅용 로그
			response.sendRedirect(authUrl);
		} else {
			System.err.println("유효하지 않은 provider 또는 미구현: " + provider); // 디버깅용 로그
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unknown provider: " + provider);
		}
	}
}