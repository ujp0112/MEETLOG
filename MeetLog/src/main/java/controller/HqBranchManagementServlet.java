package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.AppUser;
import dto.Branch;
import service.AuthService;

// [수정] web.xml에 정의된 URL 패턴에 맞게 어노테이션 추가
@WebServlet("/hq/branch-management")
public class HqBranchManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AuthService authService = new AuthService();

    public HqBranchManagementServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // 로그인 및 HQ 권한 확인 (실제 프로젝트에서는 필터로 구현하는 것이 더 좋습니다)
        if (session == null || session.getAttribute("authUser") == null || !"HQ".equals(((AppUser)session.getAttribute("authUser")).getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppUser hqUser = (AppUser) session.getAttribute("authUser");
        
        // 서비스로부터 미승인 지점 목록 조회
        List<Branch> pendingBranches = authService.findPendingBranches(hqUser.getCompanyId());
        
        // JSP로 데이터 전달
        request.setAttribute("pendingBranches", pendingBranches);
        request.getRequestDispatcher("/hq/branch-management.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("authUser") == null || !"HQ".equals(((AppUser)session.getAttribute("authUser")).getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        AppUser hqUser = (AppUser) session.getAttribute("authUser");

        // 폼에서 전송된 파라미터 받기
        String action = request.getParameter("action");
        long branchId = Long.parseLong(request.getParameter("branchId"));
        long userId = Long.parseLong(request.getParameter("userId"));

        try {
            if ("approve".equals(action)) {
                // 승인 서비스 호출
                authService.approveBranch(hqUser.getCompanyId(), branchId, userId);
            } else if ("reject".equals(action)) {
                // 거절 서비스 호출
                authService.rejectBranch(hqUser.getCompanyId(), branchId, userId);
            }
        } catch (Exception e) {
            // 에러 처리 로직 (필요 시)
            e.printStackTrace();
        }

        // 처리 후 다시 지점 관리 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/hq/branch-management");
    }
}