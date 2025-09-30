package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import model.Inquiry;
import service.InquiryService;

public class InquiryManagementServlet extends HttpServlet {

    private final InquiryService inquiryService = new InquiryService();

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

            // DB에서 모든 문의 조회
            List<Inquiry> inquiries = inquiryService.getAllInquiries();
            int totalInquiries = inquiryService.getTotalInquiryCount();
            int pendingCount = inquiryService.getInquiryCountByStatus("PENDING");
            int resolvedCount = inquiryService.getInquiryCountByStatus("RESOLVED");

            System.out.println("DEBUG: 관리자 문의 관리 - 조회된 문의 수: " + inquiries.size());

            request.setAttribute("inquiries", inquiries);
            request.setAttribute("totalInquiries", totalInquiries);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("resolvedCount", resolvedCount);

            request.getRequestDispatcher("/WEB-INF/views/admin-inquiry-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "문의 목록을 불러오는 중 오류가 발생했습니다.");
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
                case "reply":
                    handleReplyInquiry(request, out);
                    break;
                case "updateStatus":
                    handleUpdateStatus(request, out);
                    break;
                case "delete":
                    handleDeleteInquiry(request, out);
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

    private void handleReplyInquiry(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String idStr = request.getParameter("id");
            String reply = request.getParameter("reply");

            if (idStr == null || reply == null || reply.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"답변 내용을 입력해주세요.\"}");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 문의 ID입니다.\"}");
                return;
            }

            boolean success = inquiryService.replyToInquiry(id, reply.trim(), "RESOLVED");
            if (success) {
                out.print("{\"success\": true, \"message\": \"답변이 성공적으로 등록되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"답변 등록에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"답변 등록 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");

            if (idStr == null || status == null || status.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"필수 파라미터가 누락되었습니다.\"}");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 문의 ID입니다.\"}");
                return;
            }

            boolean success = inquiryService.updateInquiryStatus(id, status.trim());
            if (success) {
                out.print("{\"success\": true, \"message\": \"상태가 성공적으로 변경되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"상태 변경에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"상태 변경 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleDeleteInquiry(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            String idStr = request.getParameter("id");

            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"문의 ID가 필요합니다.\"}");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"유효하지 않은 문의 ID입니다.\"}");
                return;
            }

            boolean success = inquiryService.deleteInquiry(id);

            if (success) {
                out.print("{\"success\": true, \"message\": \"문의가 성공적으로 삭제되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"문의 삭제에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"문의 삭제 중 오류가 발생했습니다.\"}");
        }
    }
}
