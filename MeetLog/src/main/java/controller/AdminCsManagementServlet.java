package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import model.Inquiry;
import service.InquiryService;
import util.AdminSessionUtils;

public class AdminCsManagementServlet extends HttpServlet {
    private final InquiryService inquiryService = new InquiryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            String statusFilter = request.getParameter("status");
            List<Inquiry> inquiries;

            if (statusFilter != null && !statusFilter.isEmpty()) {
                // 상태별 필터링
                inquiries = inquiryService.getInquiriesByStatus(statusFilter);
            } else {
                // 전체 조회
                inquiries = inquiryService.getAllInquiries();
            }

            // 통계 데이터
            int totalCount = inquiryService.getTotalInquiryCount();
            int pendingCount = inquiryService.getInquiryCountByStatus("PENDING");
            int inProgressCount = inquiryService.getInquiryCountByStatus("IN_PROGRESS");
            int resolvedCount = inquiryService.getInquiryCountByStatus("RESOLVED");
            int closedCount = inquiryService.getInquiryCountByStatus("CLOSED");

            request.setAttribute("inquiries", inquiries);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("inProgressCount", inProgressCount);
            request.setAttribute("resolvedCount", resolvedCount);
            request.setAttribute("closedCount", closedCount);
            request.setAttribute("currentStatus", statusFilter);

            request.getRequestDispatcher("/WEB-INF/views/admin-cs-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 문의 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            String action = request.getParameter("action");
            int inquiryId = Integer.parseInt(request.getParameter("inquiryId"));

            boolean success = false;
            String successMessage = null;

            if ("reply".equals(action)) {
                String reply = request.getParameter("reply");
                success = inquiryService.replyToInquiry(inquiryId, reply, "RESOLVED");
                successMessage = "답변이 등록되었습니다.";
            } else if ("updateStatus".equals(action)) {
                String status = request.getParameter("status");
                success = inquiryService.updateInquiryStatus(inquiryId, status);
                successMessage = "상태가 변경되었습니다.";
            } else if ("close".equals(action)) {
                success = inquiryService.updateInquiryStatus(inquiryId, "CLOSED");
                successMessage = "문의가 종료되었습니다.";
            }

            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", successMessage);
            }

            response.sendRedirect(request.getContextPath() + "/admin/cs-management");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 문의 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
}
