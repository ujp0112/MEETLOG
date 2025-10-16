package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.WithdrawalRequest;
import service.WithdrawalService;

/**
 * 어드민 출금 신청 관리 서블릿
 * - GET /admin/withdrawals : 출금 신청 목록 페이지
 * - POST /admin/withdrawals/approve : 출금 승인
 * - POST /admin/withdrawals/reject : 출금 거절
 * - POST /admin/withdrawals/complete : 출금 완료 처리
 */
@WebServlet({"/admin/withdrawals", "/admin/withdrawals/approve", "/admin/withdrawals/reject", "/admin/withdrawals/complete"})
public class AdminWithdrawalManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WithdrawalService withdrawalService = new WithdrawalService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();

        // 관리자 권한 확인
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        if ("/admin/withdrawals".equals(pathInfo)) {
            handleWithdrawalList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();

        // 관리자 권한 확인
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print("{\"success\": false, \"message\": \"관리자 권한이 필요합니다.\"}");
            return;
        }

        User admin = (User) session.getAttribute("user");

        switch (pathInfo) {
            case "/admin/withdrawals/approve":
                handleApprove(request, response, admin.getId());
                break;
            case "/admin/withdrawals/reject":
                handleReject(request, response, admin.getId());
                break;
            case "/admin/withdrawals/complete":
                handleComplete(request, response, admin.getId());
                break;
        }
    }

    /**
     * 출금 신청 목록 페이지
     */
    private void handleWithdrawalList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");

        // 전체 출금 신청 목록 조회
        List<WithdrawalRequest> withdrawals;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            withdrawals = withdrawalService.getWithdrawalsWithPaging(
                    java.util.Map.of("status", statusFilter));
        } else {
            withdrawals = withdrawalService.getAllWithdrawals();
        }

        // 상태별 개수 계산
        long totalCount = withdrawals.size();
        long pendingCount = withdrawals.stream().filter(w -> "PENDING".equals(w.getStatus())).count();
        long approvedCount = withdrawals.stream().filter(w -> "APPROVED".equals(w.getStatus())).count();
        long rejectedCount = withdrawals.stream().filter(w -> "REJECTED".equals(w.getStatus())).count();
        long completedCount = withdrawals.stream().filter(w -> "COMPLETED".equals(w.getStatus())).count();

        request.setAttribute("withdrawals", withdrawals);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("adminMenu", "withdrawal");

        request.getRequestDispatcher("/WEB-INF/views/admin-withdrawal-management.jsp").forward(request, response);
    }

    /**
     * 출금 승인
     */
    private void handleApprove(HttpServletRequest request, HttpServletResponse response, int adminId)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int withdrawalId = Integer.parseInt(request.getParameter("withdrawalId"));
            String adminMemo = request.getParameter("adminMemo");

            boolean success = withdrawalService.approveWithdrawal(withdrawalId, adminId, adminMemo);

            if (success) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"승인 처리에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    /**
     * 출금 거절
     */
    private void handleReject(HttpServletRequest request, HttpServletResponse response, int adminId)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int withdrawalId = Integer.parseInt(request.getParameter("withdrawalId"));
            String adminMemo = request.getParameter("adminMemo");

            if (adminMemo == null || adminMemo.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"거절 사유를 입력해주세요.\"}");
                return;
            }

            boolean success = withdrawalService.rejectWithdrawal(withdrawalId, adminId, adminMemo);

            if (success) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"거절 처리에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    /**
     * 출금 완료 처리
     */
    private void handleComplete(HttpServletRequest request, HttpServletResponse response, int adminId)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int withdrawalId = Integer.parseInt(request.getParameter("withdrawalId"));
            String adminMemo = request.getParameter("adminMemo");

            boolean success = withdrawalService.completeWithdrawal(withdrawalId, adminId, adminMemo);

            if (success) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"완료 처리에 실패했습니다.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    /**
     * 관리자 권한 확인
     */
    private boolean isAdmin(HttpSession session) {
        if (session == null) {
            return false;
        }
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getUserType());
    }
}
