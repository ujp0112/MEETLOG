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

@WebServlet("/auth/login/*")
public class SocialLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String pathInfo = request.getPathInfo();
		if (pathInfo == null || pathInfo.length() <= 1) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Provider is required");
			return;
		}

		String provider = pathInfo.substring(1).toLowerCase();
		String authUrl = null;

		System.out.println("Social Login 요청 수신: " + provider); // 디버깅용 로그

		try {
			switch (provider) {
			case "naver":
				authUrl = NaverLoginBO.getAuthorizationUrl(request.getSession());
				break;
			case "kakao":
				authUrl = KakaoLoginBO.getAuthorizationUrl();
				break;
			case "google":
				authUrl = GoogleLoginBO.getAuthorizationUrl();
				break;
			default:
				System.err.println("지원하지 않는 provider: " + provider);
			}
		} catch (Exception e) {
			System.err.println("소셜 로그인 URL 생성 실패: " + e.getMessage());
			e.printStackTrace();
		}

		if (authUrl != null && !authUrl.isEmpty()) {
			System.out.println("인증 URL로 리디렉션: " + authUrl); // 디버깅용 로그
			response.sendRedirect(authUrl);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unknown provider: " + provider);
		}
	}
}
