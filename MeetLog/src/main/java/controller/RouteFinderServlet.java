// 예시: RouteFinderServlet.java
package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.AppConfigListener;

@WebServlet("/route/find") // 이 경로로 서블릿에 접근합니다.
public class RouteFinderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	// 중요: 본인의 REST API 키로 교체해야 합니다.
	private static final String KAKAO_REST_API_KEY = AppConfigListener.getApiKey("kakao.mobility.rest.key");

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("### 서블릿 doPost 실행됨 ###"); // doPost가 실행되는지 확인용 로그
		System.out.println("### 서블릿이 받은 QueryString: [" + request.getQueryString() + "]");
		System.out.println("### 서블릿이 받은 origin: [" + request.getParameter("origin") + "]");
		System.out.println("### 서블릿이 받은 destination: [" + request.getParameter("destination") + "]");

		try {
			String origin = request.getParameter("origin");
			String destination = request.getParameter("destination");

			String apiUrl = "https://apis-navi.kakaomobility.com/v1/directions?origin=" + origin + "&destination="
					+ destination;

			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			// 헤더에 REST API 키를 추가합니다.
			conn.setRequestProperty("Authorization", "KakaoAK " + KAKAO_REST_API_KEY);
			conn.setRequestProperty("Content-Type", "application/json");

			int responseCode = conn.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}

			String inputLine;
			StringBuilder responseBuilder = new StringBuilder();
			while ((inputLine = br.readLine()) != null) {
				responseBuilder.append(inputLine);
			}
			br.close();

			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(responseBuilder.toString());

		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
		}
	}
}