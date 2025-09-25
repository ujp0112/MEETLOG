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
import service.ColumnService;
import service.ColumnCommentService;
import util.AppConfig; // AppConfig 임포트

// web.xml에 매핑했으므로 주석 처리
//@WebServlet("/column/*")
public class ColumnServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ColumnService columnService = new ColumnService();
    private ColumnCommentService columnCommentService = new ColumnCommentService();

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
}