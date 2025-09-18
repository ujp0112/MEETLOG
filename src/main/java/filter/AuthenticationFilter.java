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

/**
 * [수정] 로그인 없이 접근 가능한 페이지(코스 상세 등)를 제외하고,
 * 로그인이 꼭 필요한 특정 페이지만 urlPatterns에 명시합니다.
 */
@WebFilter(urlPatterns = {
    "/mypage/*", 
    "/review/write/*", 
    "/reservation/*",
    "/course/create",      // [수정] '코스 만들기' 페이지만 정확히 지정
    "/course/edit/*",      // [수정] '코스 수정' 관련 페이지만 보호
    "/course/delete/*"     // [수정] '코스 삭제' 관련 페이지만 보호
}) 
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            String requestURI = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            String redirectUrl = requestURI;
            
            if (queryString != null) {
                redirectUrl += "?" + queryString;
            }
            
            HttpSession newSession = httpRequest.getSession(true);
            newSession.setAttribute("redirectUrl", redirectUrl);
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    @Override
    public void init(FilterConfig fConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
