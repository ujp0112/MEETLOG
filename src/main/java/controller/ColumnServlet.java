package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Column;
import model.User;
import service.ColumnService;

public class ColumnServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ColumnService columnService = new ColumnService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                List<Column> columns = columnService.getAllColumns();
                request.setAttribute("columns", columns);
                request.getRequestDispatcher("/WEB-INF/views/column-list.jsp").forward(request, response);

            } else if (pathInfo.equals("/detail")) { // [수정] URL 처리 방식을 명확하게 변경
                int columnId = Integer.parseInt(request.getParameter("id"));
                
                // [수정] 상세 보기 시 조회수 1 증가 로직 추가
                columnService.incrementViews(columnId);
                
                Column column = columnService.getColumnById(columnId);
                request.setAttribute("column", column);
                request.getRequestDispatcher("/WEB-INF/views/column-detail.jsp").forward(request, response);

            } else if (pathInfo.equals("/write")) {
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
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        if ("/write".equals(pathInfo)) {
            try {
                HttpSession session = request.getSession(false);
                // [수정] 로그인하지 않은 사용자는 글을 쓸 수 없도록 처리
                if (session == null || session.getAttribute("user") == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                User user = (User) session.getAttribute("user");

                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String image = request.getParameter("image"); // 실제 파일 업로드 로직으로 교체 필요
                
                Column newColumn = new Column();
                newColumn.setUserId(user.getId());
                newColumn.setAuthor(user.getNickname());
                newColumn.setAuthorImage(user.getProfileImage()); // User 모델에 profileImage 필드가 있다면 자동으로 설정
                newColumn.setTitle(title);
                newColumn.setContent(content);
                newColumn.setImage(image);

                columnService.createColumn(newColumn);
                response.sendRedirect(request.getContextPath() + "/column"); 

            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}