package erpController;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import erpDto.Material;
import erpService.MaterialService;
import model.BusinessUser;
import util.AppConfig;

@WebServlet(name = "HqMaterialsServlet", urlPatterns = { "/hq/materials", "/hq/materials/*" })
@MultipartConfig
public class HqMaterialsServlet extends HttpServlet {

	private final MaterialService materialService = new MaterialService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		req.setCharacterEncoding("UTF-8");

		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/login.jsp");
			return;
		}

		long companyId = user.getCompanyId();
		List<Material> materials = materialService.listByCompany(companyId);
		req.setAttribute("materials", materials);

		req.getRequestDispatcher("/WEB-INF/hq/material-management.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		req.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/login.jsp");
			return;
		}
		long companyId = user.getCompanyId();

		String pathInfo = req.getPathInfo();

		// === 생성 ===
		if (pathInfo == null || "/".equals(pathInfo)) {
			Material m = new Material();
			m.setCompanyId(companyId);
			m.setName(trim(req.getParameter("name")));
			m.setUnit(trim(req.getParameter("unit")));
			m.setUnitPrice(toDouble(req.getParameter("unit_price")));
			m.setStep(toDouble(req.getParameter("step")));

			// [수정] 파일 업로드 로직 변경
			m.setImgPath(saveImagePart(req.getPart("image")));

			materialService.create(m);
			resp.sendRedirect(req.getContextPath() + "/hq/materials");
			return;
		}

		// === 수정/삭제 ===
		String[] parts = pathInfo.split("/");
		if (parts.length == 3) {
			long id = Long.parseLong(parts[1]);
			String action = parts[2];

			if ("edit".equals(action)) {
				Material m = new Material();
				m.setId(id);
				m.setCompanyId(companyId);
				m.setName(trim(req.getParameter("name")));
				m.setUnit(trim(req.getParameter("unit")));
				m.setUnitPrice(toDouble(req.getParameter("unit_price")));
				m.setStep(toDouble(req.getParameter("step")));

				// [수정] 파일 업로드 로직 변경
				String newImgPath = saveImagePart(req.getPart("image"));
				if (newImgPath != null) {
					m.setImgPath(newImgPath);
				} else {
					// 새 파일이 없으면 기존 경로 유지
					m.setImgPath(req.getParameter("prev_img_path"));
				}

				materialService.update(m);
				resp.sendRedirect(req.getContextPath() + "/hq/materials");
				return;
			}

			if ("delete".equals(action)) {
				materialService.softDelete(companyId, id);
				resp.sendRedirect(req.getContextPath() + "/hq/materials");
				return;
			}
		}
		resp.sendError(400);
	}

	// [새로운 파일 저장 메소드]
	private String saveImagePart(Part part) throws IOException {
		if (part == null || part.getSize() <= 0)
			return null;

		String uploadPath = AppConfig.getUploadPath();
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		String submitted = part.getSubmittedFileName();
		String ext = (submitted != null && submitted.lastIndexOf('.') >= 0)
				? submitted.substring(submitted.lastIndexOf('.'))
				: ".jpg";
		String filename = UUID.randomUUID().toString() + ext;

		part.write(uploadPath + File.separator + filename);
		return filename; // [핵심] 파일명만 반환
	}

	// ----- utils -----

	private static String trim(String s) {
		return s == null ? null : s.trim();
	}

	private static Double toDouble(String s) {
		try {
			if (s == null || s.isEmpty())
				return null;
			return new BigDecimal(s.replaceAll(",", "")).doubleValue();
		} catch (Exception e) {
			return null;
		}
	}

	/** 이미지 경로 결정: 텍스트(URL) > 파일업로드 > 이전값(prev) */
	private String resolveImgPath(HttpServletRequest req, String prev, String textUrl)
			throws IOException, ServletException {

		if (textUrl != null && !textUrl.isEmpty()) {
			return textUrl;
		}

		Part part = null;
		try {
			part = req.getPart("image");
		} catch (Exception ignore) {
		}
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
