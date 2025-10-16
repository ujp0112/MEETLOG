package controller;

import java.io.IOException;
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
 * 사업자 출금 신청 내역 조회 서블릿
 * GET /business/withdrawal-history : 사업자의 출금 신청 내역 페이지
 */
@WebServlet("/business/withdrawal-history")
public class BusinessWithdrawalHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WithdrawalService withdrawalService = new WithdrawalService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 세션에서 사용자 정보 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"BUSINESS".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // 사업자의 출금 신청 목록 조회
        List<WithdrawalRequest> withdrawals = withdrawalService.getWithdrawalsByOwnerId(user.getId());

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

        request.getRequestDispatcher("/WEB-INF/views/business/withdrawal-history.jsp").forward(request, response);
    }
}
