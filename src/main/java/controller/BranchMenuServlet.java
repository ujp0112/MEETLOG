package controller;

import dto.AppUser;
import dto.MenuToggle;
import service.BranchService;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.regex.*;


public class BranchMenuServlet extends HttpServlet {

  private BranchService branchService;

  @Override
  public void init() throws ServletException {
    branchService = new BranchService();
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // ✅ 로그인 세션 키는 authUser
    AppUser user = (AppUser) req.getSession().getAttribute("authUser");
    if (user == null) { resp.sendError(401); return; }
    long companyId = user.getCompanyId();
    long branchId  = user.getBranchId();

    String pi = req.getPathInfo(); // null, "/", "/list", "/{id}/ingredients"
    if (pi == null || "/".equals(pi)) {
      req.getRequestDispatcher("/branch/menu.jsp").forward(req, resp);
      return;
    }

    if ("/list".equals(pi)) {
      String q = req.getParameter("q");
      List<Map<String,Object>> rows = branchService.listMenusForBranch(companyId, branchId, q);
      resp.setContentType("application/json; charset=UTF-8");
      PrintWriter out = resp.getWriter();
      out.write('[');
      for (int i = 0; i < rows.size(); i++) {
        Map<String,Object> m = rows.get(i);
        if (i>0) out.write(',');
        out.write('{');
        out.write("\"id\":"+ m.get("id"));
        out.write(",\"name\":\""+ esc((String)m.get("name")) +"\"");
        out.write(",\"price\":"+ m.get("price"));
        out.write(",\"imgPath\":\""+ esc(nvl((String)m.get("imgPath"))) +"\"");
        out.write(",\"enabled\":\""+ ("Y".equals(m.get("enabled"))?"Y":"N") +"\"");
        out.write('}');
      }
      out.write(']');
      return;
    }

    // ✅ 재료 목록: /branch/menus/{id}/ingredients
    Matcher m = Pattern.compile("^/(\\d+)/ingredients$").matcher(pi);
    if (m.find()) {
      long menuId = Long.parseLong(m.group(1));
      List<Map<String,Object>> rows = branchService.listMenuIngredientsByMenu(companyId, menuId);
      resp.setContentType("application/json; charset=UTF-8");
      PrintWriter out = resp.getWriter();
      out.write('[');
      for (int i = 0; i < rows.size(); i++) {
        Map<String,Object> r = rows.get(i);
        if (i>0) out.write(',');
        out.write('{');
        out.write("\"materialId\":"+ r.get("materialId"));
        out.write(",\"materialName\":\""+ esc((String)r.get("materialName")) +"\"");
        out.write(",\"unit\":\""+ esc(nvl((String)r.get("unit"))) +"\"");
        out.write(",\"unitPrice\":"+ r.get("unitPrice"));
        out.write(",\"qty\":"+ r.get("qty"));
        out.write('}');
      }
      out.write(']');
      return;
    }

    resp.sendError(404);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    AppUser user = (AppUser) req.getSession().getAttribute("authUser");
    if (user == null) { resp.sendError(401); return; }
    long companyId = user.getCompanyId();
    long branchId  = user.getBranchId();

    String pi = req.getPathInfo(); // e.g. "/123/toggle"
    Matcher m = Pattern.compile("^/(\\d+)/toggle$").matcher(pi==null?"":pi);
    if (m.find()) {
      long menuId = Long.parseLong(m.group(1));
      String enabled = req.getParameter("enabled"); // "Y" | "N"
      if (!"Y".equals(enabled) && !"N".equals(enabled)) enabled = "N";

      MenuToggle t = new MenuToggle();
      t.setCompanyId(companyId);
      t.setBranchId(branchId);
      t.setMenuId(menuId);
      t.setEnabled(enabled);

      branchService.upsertBranchMenuToggle(t);

      resp.setStatus(204); // No Content
      return;
    }

    resp.sendError(404);
  }

  private static String esc(String s){
    if (s==null) return "";
    return s.replace("\\","\\\\").replace("\"","\\\"");
  }
  private static String nvl(String s){ return s==null?"":s; }
}
