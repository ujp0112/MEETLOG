package filter;

import model.User;
import util.AdminSessionUtils;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = "/admin/*")
public class AdminAuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String requestUri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String relativePath = requestUri.substring(contextPath.length());

        // Allow access to login resources
        if (relativePath.startsWith("/admin/login") || relativePath.startsWith("/admin/css") || relativePath.startsWith("/admin/js")) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }

        User adminUser = AdminSessionUtils.getAdminUser(request);
        if (adminUser == null) {
            response.sendRedirect(contextPath + "/admin/login");
            return;
        }

        chain.doFilter(servletRequest, servletResponse);
    }
}
