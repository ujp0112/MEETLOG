package erpController;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.BusinessUser;
import service.UserService;

// @WebServlet은 web.xml에서 관리하므로 주석 처리
@WebServlet(urlPatterns = "/hq/branch-management")
public class HqBranchManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        BusinessUser bizUser = (user != null && "BUSINESS".equals(user.getUserType())) ? userService.getBusinessUserByUserId(user.getId()) : null;
        if (bizUser == null || !"HQ".equals(bizUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<BusinessUser> pendingBranches = userService.getPendingBranches(bizUser.getCompanyId());
        
        request.setAttribute("pendingBranches", pendingBranches);
        
        // [수정] 최종적으로 변경된 안전한 경로로 수정
        request.getRequestDispatcher("/WEB-INF/hq/branch-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // doPost 로직은 변경할 필요 없습니다. (이전 코드와 동일)
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        BusinessUser bizUser = (user != null && "BUSINESS".equals(user.getUserType())) ? userService.getBusinessUserByUserId(user.getId()) : null;
        if (bizUser == null || !"HQ".equals(bizUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        int branchUserId = Integer.parseInt(request.getParameter("userId"));

        try {
            if ("approve".equals(action)) {
                userService.approveBranch(branchUserId);
            } else if ("reject".equals(action)) {
                userService.rejectBranch(branchUserId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/hq/branch-management");
    }
}