package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import dto.AppUser;
import dto.BranchMenu;
import dto.MenuIngredient;
import model.BusinessUser;
import service.BranchMenuService;
import service.MaterialService;

@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
@WebServlet(urlPatterns = {"/hq/menus", "/hq/menus/*"})
public class HqMenusServlet extends HttpServlet {

  private final BranchMenuService menuService = new BranchMenuService();
  private final MaterialService materialService = new MaterialService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
    req.setCharacterEncoding("UTF-8");

    HttpSession session = req.getSession(false);
    BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
    if (user == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }
    long companyId = user.getCompanyId();
    String pi = req.getPathInfo(); // 예: null, "/", "/123/ingredients"
    if (pi != null) {
        Matcher mm = Pattern.compile("^/(\\d+)/ingredients$").matcher(pi);
        if (mm.find()) {
            long menuId = Long.parseLong(mm.group(1));


            // 서비스로부터 해당 메뉴의 재료 목록 조회
            java.util.List<dto.MenuIngredient> list = menuService.listIngredients(companyId, menuId);

            resp.setContentType("application/json; charset=UTF-8");

            StringBuilder sb = new StringBuilder();
            sb.append('[');
            for (int i = 0; i < list.size(); i++) {
                dto.MenuIngredient mi = list.get(i);
                if (i > 0) sb.append(',');
                sb.append('{')
                  .append("\"materialId\":").append(mi.getMaterialId()).append(',')
                  .append("\"materialName\":\"").append(escape(mi.getMaterialName())).append("\",")
                  .append("\"unit\":\"").append(escape(mi.getUnit())).append("\",")
                  .append("\"unitPrice\":").append(mi.getUnitPrice()).append(',')
                  .append("\"qty\":").append(mi.getQty())
                  .append('}');
            }
            sb.append(']');
            resp.getWriter().write(sb.toString());
            return;
        }
    }
    req.setAttribute("menus", menuService.listMenus(companyId, 500, 0));
    req.setAttribute("materials", materialService.listByCompany(companyId));

    // 이 JSP는 반드시 서블릿을 통해 접근
    req.getRequestDispatcher("/WEB-INF/hq/menu-register.jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
    req.setCharacterEncoding("UTF-8");

    HttpSession session = req.getSession(false);
    BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
    if (user == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }
    long companyId = user.getCompanyId();

    String pathInfo = req.getPathInfo(); // null, "/edit", "/{id}/delete"

    // ===== 생성 =====
    if (pathInfo == null || "/".equals(pathInfo)) {
      BranchMenu m = new BranchMenu();
      m.setCompanyId(companyId);
      m.setName(trim(req.getParameter("name")));
      m.setPrice(parseLong(req.getParameter("salePrice")));
      m.setActiveYn("Y");
      m.setDeletedYn("N");

      // 파일 업로드 (append 모달: input name="ifile")
      String imgPath = saveMenuImageIfAny(req, "ifile", "/uploads/menu");
      if (imgPath != null) m.setImgPath(imgPath);

      List<MenuIngredient> ings = parseIngredientsJson(req.getParameter("ingredientsJson"), companyId);
      System.out.println(req.getParameter("ingredientsJson"));
      
      long newMenuId = menuService.createMenu(m, ings);
      for (MenuIngredient mi : ings) {
        mi.setMenuId(newMenuId);
      }
      menuService.replaceMenuIngredients(companyId, newMenuId, ings);
      resp.sendRedirect(req.getContextPath() + "/hq/menus");
      return;
    }

    // ===== 수정 ===== (edit 모달: action="/hq/menus/edit", hidden name="num")
    if ("/edit".equals(pathInfo)) {
      BranchMenu m = new BranchMenu();
      m.setCompanyId(companyId);
      m.setId(parseLong(req.getParameter("num")));
      m.setName(trim(req.getParameter("name")));
      m.setPrice(parseLong(req.getParameter("salePrice")));
      m.setActiveYn("Y"); // 필요 시 폼에서 받아 반영해도 됨

      String newImg = saveMenuImageIfAny(req, "ifile", "/uploads/menu"); // 없으면 null → 서비스에서 기존 보존
      if (newImg != null) m.setImgPath(newImg);

      List<MenuIngredient> ings = parseIngredientsJson(req.getParameter("ingredientsJson"), companyId);

      menuService.updateMenu(m, ings);
      resp.sendRedirect(req.getContextPath() + "/hq/menus");
      return;
    }

    // ===== 삭제 ===== (목록 버튼: POST /hq/menus/{id}/delete)
    if (pathInfo != null && pathInfo.startsWith("/") && pathInfo.endsWith("/delete")) {
      String sid = pathInfo.substring(1, pathInfo.length() - "/delete".length());
      long menuId = parseLong(sid);
      menuService.softDeleteMenu(companyId, menuId);
      resp.setContentType("text/plain; charset=UTF-8");
      resp.getWriter().write("OK");
      return;
    }

    resp.sendError(404);
  }

  // ---------- utils ----------
  
  private static String trim(String s){ return s==null? null : s.trim(); }
  private static long parseLong(String s) {
    if (s == null || s.isEmpty()) return 0L;
    try { return Long.parseLong(s.replaceAll("[^0-9-]", "")); } catch (Exception e) { return 0L; }
  }
  
  private String toJson(List<MenuIngredient> list) {
	    StringBuilder sb = new StringBuilder();
	    sb.append('[');
	    for (int i = 0; i < list.size(); i++) {
	        MenuIngredient mi = list.get(i);
	        if (i > 0) sb.append(',');
	        sb.append('{')
	          .append("\"materialId\":").append(mi.getMaterialId()).append(',')
	          .append("\"materialName\":\"").append(escape(mi.getMaterialName())).append("\",")
	          .append("\"unit\":\"").append(escape(mi.getUnit())).append("\",")
	          .append("\"unitPrice\":").append(mi.getUnitPrice()).append(',')
	          .append("\"qty\":").append(mi.getQty())
	          .append('}');
	    }
	    sb.append(']');
	    return sb.toString();
	}

	private String escape(String s){
	    if (s == null) return "";
	    // 아주 최소한의 escape
	    return s.replace("\\", "\\\\").replace("\"", "\\\"");
	}


  /** ifile 파트 저장 (없으면 null) */
  private String saveMenuImageIfAny(HttpServletRequest req, String partName, String relDir)
      throws IOException, ServletException {
    Part part = null;
    try { part = req.getPart(partName); } catch (Exception ignore) {}
    if (part == null || part.getSize() <= 0) return null;

    String fileName = System.currentTimeMillis() + "_" + Optional.ofNullable(part.getSubmittedFileName()).orElse("image");
    File dir = new File(req.getServletContext().getRealPath(relDir));
    if (!dir.exists()) dir.mkdirs();
    File dest = new File(dir, fileName);
    try (InputStream in = part.getInputStream()) {
      Files.copy(in, dest.toPath());
    }
    return relDir + "/" + fileName; // 컨텍스트 상대 경로 저장
  }

  /** ingredientsJson(배열) 파싱 → quantity 키를 qty(Double)로 세팅 */
  private List<MenuIngredient> parseIngredientsJson(String json, long companyId) {
    List<MenuIngredient> list = new ArrayList<>();
    if (json == null || json.trim().isEmpty()) return list;

    // 아주 단순한 파서: {...},{...} 덩어리로 자르고 필요한 key만 뽑음
    // 기대 형식: [{"materialId":123,"name":"...","unit":"kg","unitPrice":4500,"quantity":2.5}, ...]
    String body = json.trim();
    if (body.startsWith("[")) body = body.substring(1);
    if (body.endsWith("]")) body = body.substring(0, body.length()-1);
    if (body.trim().isEmpty()) return list;

    String[] objs = body.split("\\},\\s*\\{");
    Pattern pMat = Pattern.compile("\"materialId\"\\s*:\\s*(\\d+)");
    Pattern pQty = Pattern.compile("\"quantity\"\\s*:\\s*([-+]?\\d*\\.?\\d+)");
    for (String raw : objs) {
      String o = raw;
      if (!o.startsWith("{")) o = "{"+o;
      if (!o.endsWith("}")) o = o+"}";
      Matcher m1 = pMat.matcher(o);
      Matcher m2 = pQty.matcher(o);
      if (m1.find() && m2.find()) {
        long materialId = Long.parseLong(m1.group(1));
        double quantity  = Double.parseDouble(m2.group(1));
        if (materialId > 0 && quantity > 0) {
          MenuIngredient mi = new MenuIngredient();
          mi.setCompanyId(companyId);
          mi.setMaterialId(materialId);
          mi.setQty(quantity);   // DTO는 qty 사용
          list.add(mi);
        }
      }
    }
    return list;
  }
}
