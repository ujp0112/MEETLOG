package erpController;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.google.gson.Gson;

import erpDto.Notice;
import erpDto.NoticeFile;
import erpDto.NoticeImage;
import erpService.NoticeService;
import model.BusinessUser;
import util.AppConfig;

/**
 * Servlet implementation class HqNoticeServlet
 */
@WebServlet({ "/hq/notice", "/hq/notice/*", "/hq/notice/form" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class HqNoticeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	NoticeService noticeService = new NoticeService();
	private final Gson gson = new Gson();

	// HqNoticeServlet.java의 doGet 메소드 수정

	private static final int PAGE_SIZE = 10; // 페이지당 보여줄 공지 개수

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/login.jsp");
			return;
		}
		long companyId = user.getCompanyId();

		String servletPath = req.getServletPath();
		String pathInfo = req.getPathInfo();

		// [새 로직] 공지 열람 페이지 (GET /hq/notice/view?id=123)
		if ("/view".equals(pathInfo)) {
			long noticeId = Long.parseLong(req.getParameter("id"));
			Notice notice = noticeService.getNoticeById(companyId, noticeId);
			req.setAttribute("notice", notice);
			req.getRequestDispatcher("/WEB-INF/hq/notice-view.jsp").forward(req, resp);
			return;
		}

		// [새 로직] 작성/수정 폼 페이지 요청 처리
		if ("/hq/notice/form".equals(servletPath)) {
			String noticeIdStr = req.getParameter("id");
			if (noticeIdStr != null) { // 수정 모드
				long noticeId = Long.parseLong(noticeIdStr);
				Notice notice = noticeService.getNoticeById(companyId, noticeId);
				req.setAttribute("notice", notice);
			}
			// 작성 모드일 경우 notice 객체 없이 그냥 포워딩
			req.getRequestDispatcher("/WEB-INF/hq/notice-form.jsp").forward(req, resp);
			return;
		}

		// 상세 정보 API (GET /hq/notice/{id}) - 기존 로직 유지
		if (pathInfo != null && pathInfo.matches("/\\d+")) {
			long noticeId = Long.parseLong(pathInfo.substring(1));
			Notice notice = noticeService.getNoticeById(companyId, noticeId);
			resp.setContentType("application/json; charset=UTF-8");
			resp.getWriter().write(gson.toJson(notice));
			return;
		}

		// --- 페이지네이션 로직 시작 ---
		int currentPage = 1;
		try {
			String pageParam = req.getParameter("page");
			if (pageParam != null) {
				currentPage = Integer.parseInt(pageParam);
			}
		} catch (NumberFormatException e) {
			currentPage = 1; // 숫자가 아닌 파라미터일 경우 1페이지로
		}
		int offset = (currentPage - 1) * PAGE_SIZE;

		// 서비스 호출 시 페이징 정보 전달
		List<Notice> notices = noticeService.listNotices(companyId, PAGE_SIZE, offset);
		int totalCount = noticeService.getNoticeCount(companyId);

		// JSP로 페이징 정보 전달
		req.setAttribute("notices", notices);
		req.setAttribute("totalCount", totalCount);
		req.setAttribute("currentPage", currentPage);
		req.setAttribute("pageSize", PAGE_SIZE);
		// --- 페이지네이션 로직 끝 ---

		req.getRequestDispatcher("/WEB-INF/hq/notice-management.jsp").forward(req, resp);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/login.jsp");
			return;
		}
		long companyId = user.getCompanyId();

		// [수정] 삭제 요청은 action 파라미터로 분기 처리
		String action = req.getParameter("action");
		if ("delete".equals(action)) {
			doDelete(req, resp);
			return;
		}

		// --- 생성 및 수정 로직 시작 ---
		String noticeIdStr = req.getParameter("noticeId");
		String title = req.getParameter("title");
		String content = req.getParameter("content");

		Notice notice = new Notice();
		notice.setCompanyId(companyId);
		notice.setTitle(title);
		notice.setContent(content);

		// 파일 저장 경로 설정
		String uploadPath = AppConfig.getUploadPath(); 
        if(uploadPath == null || uploadPath.isEmpty()){
            throw new ServletException("업로드 경로가 config.properties에 설정되지 않았습니다.");
        }
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();


		List<NoticeFile> attachedFiles = new ArrayList<>();

		boolean imagesUpdated = false;
		boolean filesUpdated = false;
		
		// [추가] 삭제할 파일/이미지 ID 목록 수집
	    List<Long> deleteImageIds = new ArrayList<>();
	    String[] deleteImageIdsParam = req.getParameterValues("deleteImageIds");
	    if (deleteImageIdsParam != null) {
	        for (String id : deleteImageIdsParam) {
	            deleteImageIds.add(Long.parseLong(id));
	        }
	    }

	    List<Long> deleteFileIds = new ArrayList<>();
	    String[] deleteFileIdsParam = req.getParameterValues("deleteFileIds");
	    if (deleteFileIdsParam != null) {
	        for (String id : deleteFileIdsParam) {
	            deleteFileIds.add(Long.parseLong(id));
	        }
	    }

		// 여러 이미지 처리
		List<NoticeImage> imageList = new ArrayList<>();
		int displayOrder = 1;
		for (Part part : req.getParts()) {
			if ("images".equals(part.getName()) && part.getSize() > 0) {
				imagesUpdated = true; // 새 이미지 파일이 있으면 플래그 설정
				String savedFilename = saveFile(part);

				NoticeImage noticeImage = new NoticeImage();
				noticeImage.setCompanyId(companyId);
				noticeImage.setFilePath(savedFilename);
				noticeImage.setDisplayOrder(displayOrder++);
				imageList.add(noticeImage);
			}
		}
		notice.setImages(imageList);

		// 여러 첨부파일 처리
		List<NoticeFile> fileList = new ArrayList<>();
		for (Part part : req.getParts()) {
			if ("files".equals(part.getName()) && part.getSize() > 0) {
				filesUpdated = true; // 새 첨부 파일이 있으면 플래그 설정
				String originalFilename = part.getSubmittedFileName();
				String savedFilename = saveFile(part);

				NoticeFile nf = new NoticeFile();
				nf.setCompanyId(companyId);
				nf.setOriginalFilename(originalFilename);
				nf.setSavedFilename(savedFilename);
				nf.setFilePath(savedFilename);
				nf.setFileSize(part.getSize());
				attachedFiles.add(nf);
				fileList.add(nf);
			}
		}
		notice.setFiles(fileList);

		if (noticeIdStr != null && !noticeIdStr.isEmpty()) {
	        notice.setId(Long.parseLong(noticeIdStr));
	        // [수정] 서비스 호출 시 삭제할 ID 목록 전달
	        noticeService.updateNotice(notice, imagesUpdated, filesUpdated, deleteImageIds, deleteFileIds);
	    } else {
	        noticeService.createNotice(notice);
	    }

		resp.sendRedirect(req.getContextPath() + "/hq/notice");
	}

	// [추가] 삭제 로직은 별도의 메소드로 분리
	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		HttpSession session = req.getSession(false);
		BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
		if (user == null) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}
		long companyId = user.getCompanyId();
		long noticeId = Long.parseLong(req.getParameter("noticeId"));
		noticeService.deleteNotice(companyId, noticeId);

		resp.sendRedirect(req.getContextPath() + "/hq/notice");
	}

	// [수정] saveFile 메소드가 AppConfig를 직접 사용하도록 변경
    private String saveFile(Part part) throws IOException {
        String uploadPath = AppConfig.getUploadPath(); // AppConfig에서 경로 가져오기
        String originalFilename = part.getSubmittedFileName();
        String extension = "";
        if (originalFilename.lastIndexOf(".") > 0) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String savedFilename = UUID.randomUUID().toString() + extension;
        part.write(uploadPath + File.separator + savedFilename);
        return savedFilename;
    }
}
