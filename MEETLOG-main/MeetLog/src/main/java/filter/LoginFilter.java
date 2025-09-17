package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 로그인이 필요한 경로만 감시
@WebFilter(urlPatterns = { "/mypage/*", "/admin/*", "/review/write", "/reservation/*" })
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);

        // 세션이 없거나 user 속성이 없으면 로그인 페이지로 이동
        if (session == null || session.getAttribute("user") == null) {
            // 원래 가려던 경로 저장 (로그인 후 redirect 용도)
            session = httpRequest.getSession(true);
            session.setAttribute("redirectURL", httpRequest.getRequestURI());
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return; // 리다이렉트 후 중단
        }
        
        // 로그인 상태면 계속 진행
        chain.doFilter(request, response); // ✅ 올바른 호출
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
