package filter;

import javax.servlet.*;
import javax.servlet.http.*;

import erpDto.AppUser;

import java.io.IOException;

public class AuthFilter implements Filter {
  @Override
  public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
      throws IOException, ServletException {
    HttpServletRequest request = (HttpServletRequest) req;
    HttpServletResponse response = (HttpServletResponse) res;

    String ctx = request.getContextPath();
    String uri = request.getRequestURI();

    // 로그인/회원가입 JSP, 인증 API, 이미지/정적리소스는 통과
    if (uri.equals(ctx + "/login.jsp")
    		 || uri.equals(ctx + "/register-branch.jsp")
    		 || uri.equals(ctx + "/register-hq.jsp")
    		 || uri.startsWith(ctx + "/auth")    // POST 엔드포인트
    		 || uri.startsWith(ctx + "/imageView")
    		 || uri.startsWith(ctx + "/uploads/")
    		 || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif")) {
      chain.doFilter(req, res); return;
    }

    HttpSession session = request.getSession(false);
    AppUser user = (session != null) ? (AppUser) session.getAttribute("authUser") : null;
    if (user == null) { response.sendRedirect(ctx + "/login.jsp"); return; }

    // Role guard
    //if (uri.startsWith(ctx + "/hq/") && !"HQ".equals(user.getRole())) { response.sendError(403); return; }
    //if (uri.startsWith(ctx + "/branch/") && !"BRANCH".equals(user.getRole())) { response.sendError(403); return; }

    // downstream 편의
    request.setAttribute("companyId", user.getCompanyId());
    request.setAttribute("branchId", user.getBranchId());
    request.setAttribute("role", user.getRole());

    chain.doFilter(req, res);
  }
}
