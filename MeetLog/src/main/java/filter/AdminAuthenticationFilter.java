package filter;

import model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = "/admin/*")
public class AdminAuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        
        String contextPath = request.getContextPath();
        String requestURI = request.getRequestURI();

        // 1. 요청된 주소가 로그인 페이지 자체인 경우, 검사하지 않고 무조건 통과시킵니다.
        if (requestURI.equals(contextPath + "/admin/login")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. 그 외 모든 /admin/* 경로에 대해서는 세션을 검사합니다.
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 3. 로그인이 안 되어 있거나, 관리자(ADMIN)가 아닌 경우
        if (user == null || !"ADMIN".equals(user.getUserType())) {
            // [핵심 수정] 관리자 로그인 페이지(/admin/login)로 정확하게 리디렉션합니다.
            response.sendRedirect(contextPath + "/admin/login");
            return;
        }

        // 4. 모든 검사를 통과한 진짜 관리자는 요청한 페이지로 보냅니다.
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}