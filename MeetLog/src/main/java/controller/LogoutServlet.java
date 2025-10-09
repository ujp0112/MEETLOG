// controller/LogoutServlet.java 파일 전체를 아래 코드로 교체하세요.

package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.AppConfigListener;

public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String provider = null;
        
        if (session != null) {
            provider = (String) session.getAttribute("socialProvider");
            session.invalidate(); 
        }

        // [수정] 부분 경로가 아닌 전체 URL을 생성하도록 변경
        String scheme = request.getScheme();             // http
        String serverName = request.getServerName();     // localhost
        int serverPort = request.getServerPort();        // 8080
        String contextPath = request.getContextPath();   // /MeetLog

        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(scheme).append("://").append(serverName);

        if (serverPort != 80 && serverPort != 443) {
            urlBuilder.append(":").append(serverPort);
        }
        
        urlBuilder.append(contextPath).append("/main");
        String logoutRedirectUrl = urlBuilder.toString(); // 최종 결과: http://localhost:8080/MeetLog/main
        
        // 카카오로 로그인한 경우, 카카오 로그아웃을 추가로 호출
        if ("kakao".equals(provider)) {
            String kakaoClientId = AppConfigListener.getApiKey("kakao.clientId");
            String kakaoLogoutUrl = "https://kauth.kakao.com/oauth/logout?client_id=" + kakaoClientId + "&logout_redirect_uri=" + logoutRedirectUrl;
            response.sendRedirect(kakaoLogoutUrl);
            return;
        }
        
        response.sendRedirect(logoutRedirectUrl);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}