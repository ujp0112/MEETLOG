package controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || "/list".equals(pathInfo)) {
                List<Column> columns = columnService.getAllColumns();
                request.setAttribute("columns", columns);
                request.getRequestDispatcher("/WEB-INF/views/column-list.jsp").forward(request, response);

            } else if ("/detail".equals(pathInfo)) {
                int columnId = Integer.parseInt(request.getParameter("id"));
                columnService.incrementViews(columnId);
                Column column = columnService.getColumnById(columnId);

                // 댓글 목록 조회
                List<ColumnComment> comments = columnCommentService.getCommentsByColumnId(columnId);
                int commentCount = columnCommentService.getCommentCount(columnId);

                request.setAttribute("column", column);
                request.setAttribute("comments", comments);
                request.setAttribute("commentCount", commentCount);
                request.getRequestDispatcher("/WEB-INF/views/column-detail.jsp").forward(request, response);

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if ("/edit".equals(pathInfo)) {
            handleUpdateColumn(request, response);
            return;
        }

        if (!"/write".equals(pathInfo)) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            Map<String, String> formFields = new HashMap<>();
            FileItem imageFileItem = null;

            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    formFields.put(item.getFieldName(), item.getString("UTF-8"));
                } else {
                    if ("thumbnail".equals(item.getFieldName()) && item.getSize() > 0) {
                        imageFileItem = item;
                    }
                }
            }

            String imageFileName = null;
            if (imageFileItem != null) {
                String uploadPath = AppConfig.getUploadPath();
                if (uploadPath == null || uploadPath.isEmpty()) {
                    throw new Exception("업로드 경로가 설정되지 않았습니다.");
                }
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String originalFileName = new File(imageFileItem.getName()).getName();
                imageFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                
                File storeFile = new File(uploadPath, imageFileName);
                imageFileItem.write(storeFile);
            }

            Column column = new Column();
            column.setTitle(formFields.get("title"));
            column.setContent(formFields.get("content"));
            column.setImage(imageFileName);

            User user = (User) session.getAttribute("user");
            column.setUserId(user.getId());

            boolean success = columnService.createColumn(column);

            if (success) {
                // 피드 아이템 생성
                try {
                    feedService.createSimpleColumnFeedItem(user.getId(), column.getId());
                    System.out.println("DEBUG: 칼럼 피드 아이템 생성 완료 - 칼럼 ID: " + column.getId());
                } catch (Exception e) {
                    System.err.println("피드 아이템 생성 실패: " + e.getMessage());
                    e.printStackTrace();
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

            request.setAttribute("column", column);
            request.setAttribute("isEditMode", true);
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
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");

            Map<String, String> formFields = new HashMap<>();
            FileItem imageFileItem = null;

            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    formFields.put(item.getFieldName(), item.getString("UTF-8"));
                } else {
                    if ("thumbnail".equals(item.getFieldName()) && item.getSize() > 0) {
                        imageFileItem = item;
                    }
                }
            }

            String columnIdStr = formFields.get("columnId");
            if (columnIdStr == null || columnIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "칼럼 ID가 필요합니다.");
                return;
            }

            int columnId = Integer.parseInt(columnIdStr);
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
            String imageFileName = existingColumn.getImage(); // 기존 이미지 유지
            if (imageFileItem != null) {
                String uploadPath = AppConfig.getUploadPath();
                if (uploadPath == null || uploadPath.isEmpty()) {
                    throw new Exception("업로드 경로가 설정되지 않았습니다.");
                }

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String originalFileName = new File(imageFileItem.getName()).getName();
                imageFileName = UUID.randomUUID().toString() + "_" + originalFileName;

                File storeFile = new File(uploadPath, imageFileName);
                imageFileItem.write(storeFile);
            }

            // 칼럼 정보 업데이트
            existingColumn.setTitle(formFields.get("title"));
            existingColumn.setContent(formFields.get("content"));
            existingColumn.setImage(imageFileName);

            boolean success = columnService.updateColumn(existingColumn);

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
}