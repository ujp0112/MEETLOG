package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import service.BranchService;
import dto.AppUser;
import dto.InventoryItem;

/**
 * Servlet implementation class BranchInventoryServlet
 */

@WebServlet("/branch/inventory")
public class BranchInventoryServlet extends HttpServlet {
    private final BranchService branchService = new BranchService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	HttpSession session = req.getSession(false);
        AppUser user = (session != null) ? (AppUser) session.getAttribute("authUser") : null;

        if (user == null || user.getBranchId() == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        int page = 1;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignore) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        long companyId = user.getCompanyId();
        long branchId = user.getBranchId();
        List<InventoryItem> inventories = branchService.listInventoryForBranch(companyId, branchId, PAGE_SIZE, offset);
        int totalCount = branchService.getTotalMaterialCount(companyId);
        
        System.out.println("### BranchInventoryServlet: 조회된 재고 아이템 개수 = " + (inventories != null ? inventories.size() : "null"));

        
        req.setAttribute("inventories", inventories);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("page", page);

        req.getRequestDispatcher("/branch/inventory.jsp").forward(req, resp);
    }
}
