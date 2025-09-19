package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import service.AuthService;
import dto.*;

public class AuthServlet extends HttpServlet {
  private final AuthService service = new AuthService();

  @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String path = req.getPathInfo(); // /login, /hq/login, /branch/login, /hq/register, /branch/register
    if (path == null) { resp.sendError(404); return; }
    try {
      switch (path) {
        case "/hq/login": roleLogin(req, resp, "HQ"); return;
        case "/branch/login": roleLogin(req, resp, "BRANCH"); return;
        case "/hq/register": registerHq(req, resp); return;
        case "/branch/register": registerBranch(req, resp); return;
        default: resp.sendError(404);
      }
    } catch (Exception e) {
      e.printStackTrace(); resp.sendError(500);
    }
  }

  private void roleLogin(HttpServletRequest req, HttpServletResponse resp, String role) throws IOException {
    String email = req.getParameter("email");
    String password = req.getParameter("password");
    AppUser u = service.findByEmail(email);
    if (u == null || !"Y".equals(u.getActiveYn()) || !PasswordUtil.matches(password, u.getPwHash()) || !role.equals(u.getRole())) {
      req.getSession(true).setAttribute("error", "이메일/비밀번호 또는 역할이 올바르지 않습니다.");
      resp.sendRedirect(req.getContextPath() + "/login.jsp"); return;
    }
    HttpSession session = req.getSession(true);
    session.setAttribute("authUser", u);
    if ("HQ".equals(u.getRole())) resp.sendRedirect(req.getContextPath() + "/hq/branch-management.jsp");
    else resp.sendRedirect(req.getContextPath() + "/branch/menus");
  }

  private void registerHq(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String companyName = req.getParameter("companyName");
    String email = req.getParameter("email");
    String password = req.getParameter("password");
    Company c = new Company(); c.setName(companyName);
    long companyId = service.createCompany(c);
    AppUser u = new AppUser();
    u.setCompanyId(companyId); u.setRole("HQ"); u.setEmail(email);
    u.setPwHash(PasswordUtil.hash(password)); u.setActiveYn("Y");
    service.createUser(u);
    resp.sendRedirect(req.getContextPath() + "/login.jsp");
  }

  private void registerBranch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String hqIdentifier = req.getParameter("hqIdentifier");
    String branchName = req.getParameter("branchName");
    String branchCode = req.getParameter("branchCode");
    String email = req.getParameter("email");
    String password = req.getParameter("password");

    AppUser hq = service.findHqByIdentifier(hqIdentifier);
    if (hq == null) {
      req.getSession(true).setAttribute("error", "본사(HQ) 식별자를 찾을 수 없습니다.");
      resp.sendRedirect(req.getContextPath() + "/register-branch.jsp"); return;
    }
    Branch b = new Branch();
    b.setCompanyId(hq.getCompanyId()); b.setName(branchName); b.setCode(branchCode); b.setActiveYn("Y");
    long branchId = service.createBranch(b);

    AppUser u = new AppUser();
    u.setCompanyId(hq.getCompanyId()); u.setBranchId(branchId); u.setRole("BRANCH");
    u.setEmail(email); u.setPwHash(PasswordUtil.hash(password)); u.setActiveYn("Y");
    service.createUser(u);
    resp.sendRedirect(req.getContextPath() + "/login.jsp");
  }

  @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    if ("/logout".equals(req.getPathInfo())) {
      HttpSession s = req.getSession(false); if (s != null) s.invalidate();
      resp.sendRedirect(req.getContextPath() + "/login.jsp");
    } else {
      resp.sendError(404);
    }
  }

  // 데모용 간단 해시 (운영은 BCrypt 권장)
  static class PasswordUtil {
    static String hash(String plain){
      try {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
        byte[] bytes = md.digest(plain.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for(byte b: bytes){ sb.append(String.format("%02x", b)); }
        return sb.toString();
      } catch(Exception e){ throw new RuntimeException(e); }
    }
    static boolean matches(String plain, String hash){
      return hash(plain).equals(hash);
    }
  }
}
