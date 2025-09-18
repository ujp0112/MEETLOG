package controller;

import dto.AppUser;
import dto.Material;
import service.MaterialService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.util.*;


@MultipartConfig
public class HqMaterialsServlet extends HttpServlet {

  private final MaterialService materialService = new MaterialService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
    req.setCharacterEncoding("UTF-8");

    HttpSession session = req.getSession(false);
    AppUser user = (session == null) ? null : (AppUser) session.getAttribute("authUser");
    if (user == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }

    long companyId = user.getCompanyId();
    List<Material> materials = materialService.listByCompany(companyId);
    req.setAttribute("materials", materials);

    req.getRequestDispatcher("/hq/material-management.jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
    req.setCharacterEncoding("UTF-8");

    HttpSession session = req.getSession(false);
    AppUser user = (session == null) ? null : (AppUser) session.getAttribute("authUser");
    if (user == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }
    long companyId = user.getCompanyId();

    String pathInfo = req.getPathInfo(); // null or "/{id}/edit|/delete"

    // === 생성 ===
    if (pathInfo == null || "/".equals(pathInfo)) {
      Material m = new Material();
      m.setCompanyId(companyId);
      m.setName(trim(req.getParameter("name")));
      m.setUnit(trim(req.getParameter("unit")));
      m.setUnitPrice(toDouble(req.getParameter("unit_price")));
      m.setStep(toDouble(req.getParameter("step")));

      String fromText = trim(req.getParameter("img_path"));
      String resolved = resolveImgPath(req, null, fromText);
      m.setImgPath(resolved);

      materialService.create(m);
      resp.sendRedirect(req.getContextPath()+"/hq/materials");
      return;
    }

    // === 수정/삭제 ===
    String[] parts = pathInfo.split("/");
    if (parts.length == 3) {
      long id = Long.parseLong(parts[1]);
      String action = parts[2];

      if ("edit".equals(action)) {
        Material existing = materialService.findById(companyId, id);
        if (existing == null) { resp.sendError(404); return; }

        Material m = new Material();
        m.setId(id);
        m.setCompanyId(companyId);
        m.setName(trim(req.getParameter("name")));
        m.setUnit(trim(req.getParameter("unit")));
        m.setUnitPrice(toDouble(req.getParameter("unit_price")));
        m.setStep(toDouble(req.getParameter("step")));

        String prev = trim(req.getParameter("prev_img_path"));
        if (prev == null || prev.isEmpty()) prev = existing.getImgPath();
        String fromText = trim(req.getParameter("img_path"));
        String resolved = resolveImgPath(req, prev, fromText);
        m.setImgPath(resolved);

        materialService.update(m);
        resp.sendRedirect(req.getContextPath()+"/hq/materials");
        return;
      }

      if ("delete".equals(action)) {
        materialService.softDelete(companyId, id);
        resp.sendRedirect(req.getContextPath()+"/hq/materials");
        return;
      }
    }

    resp.sendError(400);
  }

  // ----- utils -----

  private static String trim(String s){ return s==null? null : s.trim(); }

  private static Double toDouble(String s) {
    try {
      if (s == null || s.isEmpty()) return null;
      return new BigDecimal(s.replaceAll(",", "")).doubleValue();
    } catch (Exception e) { return null; }
  }

  /** 이미지 경로 결정: 텍스트(URL) > 파일업로드 > 이전값(prev) */
  private String resolveImgPath(HttpServletRequest req, String prev, String textUrl)
      throws IOException, ServletException {

    if (textUrl != null && !textUrl.isEmpty()) {
      return textUrl;
    }

    Part part = null;
    try { part = req.getPart("image"); } catch (Exception ignore) {}
    if (part != null && part.getSize() > 0) {
      String saved = saveImagePart(part, req.getServletContext().getRealPath("/uploads/materials"));
      return saved; // e.g. "/uploads/materials/uuid.jpg"
    }

    return prev;
  }

  private String saveImagePart(Part part, String uploadDir) throws IOException {
    Files.createDirectories(new File(uploadDir).toPath());
    String submitted = part.getSubmittedFileName();
    String ext = (submitted != null && submitted.lastIndexOf('.') >= 0)
        ? submitted.substring(submitted.lastIndexOf('.')).toLowerCase(Locale.ROOT)
        : ".jpg";
    String filename = UUID.randomUUID().toString().replace("-", "") + ext;
    File target = new File(uploadDir, filename);
    try (InputStream in = part.getInputStream(); OutputStream out = new FileOutputStream(target)) {
      in.transferTo(out);
    }
    return "/uploads/materials/" + filename;
  }

  
}
