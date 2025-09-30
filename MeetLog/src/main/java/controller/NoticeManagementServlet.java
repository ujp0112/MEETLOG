package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

import model.Notice;
import service.NoticeService;

public class NoticeManagementServlet extends HttpServlet {

    private final NoticeService noticeService = new NoticeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");

            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            // DB에서 모든 공지사항 조회 (관리자용)
            List<Notice> notices = noticeService.getAllNotices();
            int totalNotices = noticeService.getTotalNoticeCount();

            System.out.println("DEBUG: 관리자 공지사항 관리 - 조회된 공지사항 수: " + notices.size());
            System.out.println("DEBUG: 전체 공지사항: " + totalNotices);

            request.setAttribute("notices", notices);
            request.setAttribute("totalNotices", totalNotices);

            request.getRequestDispatcher("/WEB-INF/views/admin-notice-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "공지사항 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");

            if (adminId == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "관리자 권한이 필요합니다.");
                return;
            }

            String action = request.getParameter("action");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (action == null || action.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"요청 작업이 지정되지 않았습니다.\"}");
                return;
            }

            switch (action) {
                case "create":
                    handleCreateNotice(request, out);
                    break;
                case "update":
                    handleUpdateNotice(request, out);
                    break;
                case "delete":
                    handleDeleteNotice(request, out);
                    break;
                default:
                    out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    private void handleCreateNotice(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"제목과 내용을 모두 입력해주세요.\"}");
                return;
            }

            Notice notice = new Notice();
            notice.setTitle(title.trim());
            notice.setContent(content.trim());
            notice.setCreatedAt(new Date(System.currentTimeMillis()));

            boolean success = noticeService.createNotice(notice);
            if (success) {
                out.print("{\"success\": true, \"message\": \"공지사항이 성공적으로 등록되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"공지사항 등록에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"공지사항 등록 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleUpdateNotice(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String idStr = request.getParameter("id");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            if (idStr == null || title == null || content == null) {
                out.print("{\"success\": false, \"message\": \"필수 항목을 모두 입력해주세요.\"}");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 공지사항 ID입니다.\"}");
                return;
            }

            Notice notice = new Notice();
            notice.setId(id);
            notice.setTitle(title.trim());
            notice.setContent(content.trim());

            boolean success = noticeService.updateNotice(notice);
            if (success) {
                out.print("{\"success\": true, \"message\": \"공지사항이 성공적으로 수정되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"공지사항 수정에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"공지사항 수정 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleDeleteNotice(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String idStr = request.getParameter("id");

            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"공지사항 ID가 필요합니다.\"}");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 공지사항 ID입니다.\"}");
                return;
            }

            boolean success = noticeService.deleteNotice(id);

            if (success) {
                out.print("{\"success\": true, \"message\": \"공지사항이 성공적으로 삭제되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"공지사항 삭제에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"공지사항 삭제 중 오류가 발생했습니다.\"}");
        }
    }
}
