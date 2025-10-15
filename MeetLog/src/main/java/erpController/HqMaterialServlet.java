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
import model.User;
import service.UserService;
import util.AppConfig;

@WebServlet(urlPatterns = { "/hq/material", "/hq/material/*" })
@MultipartConfig
public class HqMaterialServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final MaterialService materialService = new MaterialService();
	private static final int PAGE_SIZE = 10; // 페이지당 보여줄 재료 개수
	private final UserService userService = new UserService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		for (int i = 0; i < 10; i++)
			System.out.println("디버깅 시작");
		req.setCharacterEncoding("UTF-8");

		HttpSession session = req.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;

		BusinessUser bizUser = (session != null) ? (BusinessUser) session.getAttribute("businessUser") : null;
		if (bizUser == null || !"HQ".equals(bizUser.getRole())) {
			resp.sendRedirect(req.getContextPath() + "/login"); // 로그인 안됐거나 HQ가 아니면 리디렉션
			return;
		}

		long companyId = bizUser.getCompanyId();

		// --- 페이지네이션 로직 시작 ---
		int currentPage = 1;
		try {
			String pageParam = req.getParameter("page");
			if (pageParam != null && !pageParam.isEmpty()) {
				currentPage = Integer.parseInt(pageParam);
			}
		} catch (NumberFormatException e) {
			currentPage = 1;
		}
		int offset = (currentPage - 1) * PAGE_SIZE;
		
		List<Material> materials = materialService.listByCompany(companyId, PAGE_SIZE, offset);
		int totalCount = materialService.getMaterialCount(companyId);

		req.setAttribute("materials", materials);
		req.setAttribute("totalCount", totalCount);
		req.setAttribute("currentPage", currentPage);
		req.setAttribute("pageSize", PAGE_SIZE);
		// --- 페이지네이션 로직 끝 ---

		req.getRequestDispatcher("/WEB-INF/hq/material-management.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		for (int i = 0; i < 10; i++)
			System.out.println("디버깅 시작");
		req.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null || !"HQ".equals(user.getRole())) {
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
			resp.sendRedirect(req.getContextPath() + "/hq/material");
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
				resp.sendRedirect(req.getContextPath() + "/hq/material");
				return;
			}

			if ("delete".equals(action)) {
				materialService.softDelete(companyId, id);
				resp.sendRedirect(req.getContextPath() + "/hq/material");
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
