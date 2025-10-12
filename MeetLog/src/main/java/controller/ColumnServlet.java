package controller;

import com.google.gson.Gson; // Gson 임포트
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import model.Column;
import model.ColumnComment;
import model.Restaurant;
import model.User;
import model.FeedItem;
import service.ColumnService;
import service.ColumnCommentService;
import service.FeedService;
import util.AppConfig; // AppConfig 임포트

// web.xml에 매핑했으므로 주석 처리
//@WebServlet("/column/*")
public class ColumnServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ColumnService columnService = new ColumnService();
	private ColumnCommentService columnCommentService = new ColumnCommentService();
	private FeedService feedService = new FeedService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String pathInfo = request.getPathInfo();

		try {
			if (pathInfo == null || pathInfo.equals("/") || "/list".equals(pathInfo)) {
				// [수정] 검색어(keyword) 파라미터 처리 로직 추가
				String keyword = request.getParameter("keyword");
				List<Column> columns;

				if (keyword != null && !keyword.trim().isEmpty()) {
					// 검색어가 있으면 검색 실행
					Map<String, Object> searchParams = new HashMap<>();
					searchParams.put("keyword", keyword.trim());
					columns = columnService.searchColumns(searchParams);
				} else {
					// 검색어가 없으면 전체 목록 조회
					columns = columnService.getAllColumns();
				}

				request.setAttribute("columns", columns);
				request.getRequestDispatcher("/WEB-INF/views/column-list.jsp").forward(request, response);

			// [수정] /api/columns/* 매핑에 따라 pathInfo는 /by-restaurants가 됩니다.
			} else if ("/by-restaurants".equals(pathInfo)) {
				handleGetColumnsByRestaurants(request, response);
				// API 요청은 JSON 응답 후 종료되어야 하므로, 아래 코드를 실행하지 않도록 return 합니다.
				return;
			} else if ("/detail".equals(pathInfo)) {
				int columnId = Integer.parseInt(request.getParameter("id"));
				columnService.incrementViews(columnId);
				Column column = columnService.getColumnById(columnId);

				// 댓글 목록 조회
				List<ColumnComment> comments = columnCommentService.getCommentsByColumnId(columnId);
				int commentCount = columnCommentService.getCommentCount(columnId);

				// [추가] 칼럼에 연결된 맛집 목록 조회 로직
				List<Restaurant> attachedRestaurants = columnService.getAttachedRestaurantsByColumnId(columnId);

				request.setAttribute("column", column);
				request.setAttribute("comments", comments);
				request.setAttribute("commentCount", commentCount);
				request.setAttribute("attachedRestaurants", attachedRestaurants); // [추가]
				request.getRequestDispatcher("/WEB-INF/views/column-detail.jsp").forward(request, response);

			} else if ("/attached-restaurants".equals(pathInfo)) {
				// [추가] 칼럼에 첨부된 맛집 목록을 JSON으로 반환하는 API
				handleGetAttachedRestaurants(request, response);
				return;

			} else if ("/write".equals(pathInfo)) {
				request.getRequestDispatcher("/WEB-INF/views/write-column.jsp").forward(request, response);

			} else if ("/edit".equals(pathInfo)) {
				showEditColumnForm(request, response);

			} else if ("/delete".equals(pathInfo)) {
				handleDeleteColumn(request, response);

			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String pathInfo = request.getPathInfo();

		// [수정] 요청 경로에 따라 핸들러 분기
		if ("/write".equals(pathInfo)) {
			handleCreateColumn(request, response);
		} else if ("/edit".equals(pathInfo)) {
			handleUpdateColumn(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
		}
	}

	// [수정] 칼럼 생성 로직을 별도 메소드로 분리
	private void handleCreateColumn(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		try {
			Map<String, String> formFields = new HashMap<>();
			FileItem imageFileItem = null;
			List<FileItem> formItems = parseMultipartRequest(request);

			for (FileItem item : formItems) {
				if (item.isFormField()) {
					formFields.put(item.getFieldName(), item.getString("UTF-8"));
				} else {
					if ("thumbnail".equals(item.getFieldName()) && item.getSize() > 0) {
						imageFileItem = item;
					}
				}
			}

			String imageFileName = processImageUpload(imageFileItem);

			Column column = new Column();
			column.setTitle(formFields.get("title"));
			column.setContent(formFields.get("content"));
			column.setImage(imageFileName);

			User user = (User) session.getAttribute("user");
			column.setUserId(user.getId());

			// [추가] 첨부된 맛집 ID 목록 처리
			String restaurantIdsStr = formFields.get("attachedRestaurants");
			List<Integer> restaurantIds = null;
			if (restaurantIdsStr != null && !restaurantIdsStr.isEmpty()) {
				restaurantIds = Arrays.stream(restaurantIdsStr.split(",")).map(Integer::parseInt)
						.collect(Collectors.toList());
			}

			// [수정] 서비스 호출 시 맛집 ID 목록 전달
			boolean success = columnService.createColumnWithRestaurants(column, restaurantIds);

			if (success) {
				try {
					feedService.createSimpleColumnFeedItem(user.getId(), column.getId());
				} catch (Exception e) {
					System.err.println("피드 아이템 생성 실패: " + e.getMessage());
				}
				response.sendRedirect(request.getContextPath() + "/column");
			} else {
				request.setAttribute("errorMessage", "칼럼 등록에 실패했습니다.");
				request.getRequestDispatcher("/WEB-INF/views/write-column.jsp").forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMessage", "오류가 발생했습니다: " + e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/write-column.jsp").forward(request, response);
		}
	}

	private void showEditColumnForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String columnIdStr = request.getParameter("id");
		if (columnIdStr == null || columnIdStr.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "칼럼 ID가 필요합니다.");
			return;
		}

		try {
			int columnId = Integer.parseInt(columnIdStr);
			Column column = columnService.getColumnById(columnId);

			if (column == null) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "칼럼을 찾을 수 없습니다.");
				return;
			}

			User user = (User) session.getAttribute("user");
			if (column.getUserId() != user.getId()) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "자신의 칼럼만 수정할 수 있습니다.");
				return;
			}

			List<Restaurant> attachedRestaurants = columnService.getAttachedRestaurantsByColumnId(columnId);
			request.setAttribute("column", column);
			request.setAttribute("isEditMode", true);
			request.setAttribute("attachedRestaurants", attachedRestaurants); // [추가]
			request.getRequestDispatcher("/WEB-INF/views/write-column.jsp").forward(request, response);

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 칼럼 ID입니다.");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}

	private void handleUpdateColumn(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		try {
			Map<String, String> formFields = new HashMap<>();
			FileItem imageFileItem = null;
			List<FileItem> formItems = parseMultipartRequest(request);

			for (FileItem item : formItems) {
				if (item.isFormField()) {
					formFields.put(item.getFieldName(), item.getString("UTF-8"));
				} else {
					if ("thumbnail".equals(item.getFieldName()) && item.getSize() > 0) {
						imageFileItem = item;
					}
				}
			}

			int columnId = Integer.parseInt(formFields.get("columnId"));
			Column existingColumn = columnService.getColumnById(columnId);

			if (existingColumn == null) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "칼럼을 찾을 수 없습니다.");
				return;
			}

			User user = (User) session.getAttribute("user");
			if (existingColumn.getUserId() != user.getId()) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "자신의 칼럼만 수정할 수 있습니다.");
				return;
			}

			// 이미지 처리
			String imageFileName = existingColumn.getImage();
			if (imageFileItem != null) {
				imageFileName = processImageUpload(imageFileItem);
			}

			existingColumn.setTitle(formFields.get("title"));
			existingColumn.setContent(formFields.get("content"));
			existingColumn.setImage(imageFileName);

			// [추가] 첨부된 맛집 ID 목록 처리
			String restaurantIdsStr = formFields.get("attachedRestaurants");
			List<Integer> restaurantIds = null;
			if (restaurantIdsStr != null && !restaurantIdsStr.isEmpty()) {
				restaurantIds = Arrays.stream(restaurantIdsStr.split(",")).map(String::trim).map(Integer::parseInt)
						.collect(Collectors.toList());
			}

			// [수정] 서비스 호출 시 맛집 ID 목록 전달
			boolean success = columnService.updateColumnWithRestaurants(existingColumn, restaurantIds);

			if (success) {
				response.sendRedirect(request.getContextPath() + "/column/detail?id=" + columnId);
			} else {
				request.setAttribute("errorMessage", "칼럼 수정에 실패했습니다.");
				request.setAttribute("column", existingColumn);
				request.setAttribute("isEditMode", true);
				request.getRequestDispatcher("/WEB-INF/views/write-column.jsp").forward(request, response);
			}

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 칼럼 ID입니다.");
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMessage", "오류가 발생했습니다: " + e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/write-column.jsp").forward(request, response);
		}
	}

	// [추가] 중복 로직을 위한 헬퍼 메소드
	private List<FileItem> parseMultipartRequest(HttpServletRequest request) throws Exception {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setHeaderEncoding("UTF-8");
		return upload.parseRequest(request);
	}

	// [추가] 중복 로직을 위한 헬퍼 메소드
	private String processImageUpload(FileItem imageFileItem) throws Exception {
		if (imageFileItem == null || imageFileItem.getSize() == 0) {
			return null;
		}

		String uploadPath = AppConfig.getUploadPath();
		if (uploadPath == null || uploadPath.isEmpty()) {
			throw new Exception("업로드 경로가 설정되지 않았습니다.");
		}

		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		String originalFileName = new File(imageFileItem.getName()).getName();
		String imageFileName = UUID.randomUUID().toString() + "_" + originalFileName;

		File storeFile = new File(uploadPath, imageFileName);
		imageFileItem.write(storeFile);
		return imageFileName;
	}

	private void handleDeleteColumn(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
			return;
		}

		User user = (User) session.getAttribute("user");
		String columnIdStr = request.getParameter("id");

		if (columnIdStr == null || columnIdStr.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "칼럼 ID가 필요합니다.");
			return;
		}

		try {
			int columnId = Integer.parseInt(columnIdStr);

			// 칼럼 소유권 확인
			Column column = columnService.getColumnById(columnId);
			if (column == null) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "칼럼을 찾을 수 없습니다.");
				return;
			}

			if (column.getUserId() != user.getId()) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "자신의 칼럼만 삭제할 수 있습니다.");
				return;
			}

			// 칼럼 삭제
			boolean success = columnService.deleteColumn(columnId);

			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			if (success) {
				response.getWriter().write("{\"success\": true, \"message\": \"칼럼이 삭제되었습니다.\"}");
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"success\": false, \"message\": \"칼럼 삭제에 실패했습니다.\"}");
			}

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 칼럼 ID입니다.");
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
		}
	}
	
	/**
	 * [추가] 레스토랑 ID 목록을 받아 관련 칼럼을 JSON으로 반환하는 API 핸들러
	 */
	private void handleGetColumnsByRestaurants(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String idsParam = request.getParameter("ids");
		if (idsParam == null || idsParam.isEmpty()) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("[]"); // 빈 배열 반환
			return;
		}

		try {
			List<Integer> restaurantIds = Arrays.stream(idsParam.split(","))
					.map(Integer::parseInt)
					.collect(Collectors.toList());
			
			List<Column> columns = columnService.getColumnsByRestaurantIds(restaurantIds);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(new Gson().toJson(columns));
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid restaurant IDs format.");
		}
	}
	
	/**
	 * [추가] 특정 칼럼에 첨부된 맛집 목록을 JSON으로 반환합니다.
	 */
	private void handleGetAttachedRestaurants(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String columnIdStr = request.getParameter("columnId");
		if (columnIdStr == null || columnIdStr.isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "columnId is required.");
			return;
		}
		
		try {
			int columnId = Integer.parseInt(columnIdStr);
			List<Restaurant> restaurants = columnService.getAttachedRestaurantsByColumnId(columnId);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(new Gson().toJson(restaurants));
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid columnId format.");
		}
	}
}