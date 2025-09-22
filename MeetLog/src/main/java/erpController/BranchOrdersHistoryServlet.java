package erpController;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import erpDto.PurchaseOrder;
import erpDto.PurchaseOrderLine;
import erpService.OrderService;
import model.BusinessUser;

@WebServlet(urlPatterns = {"/branch/orders-history", "/branch/orders/*"})
public class BranchOrdersHistoryServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final Gson gson = new Gson();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");

        if (user == null || user.getUserId()+"" == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        long companyId = user.getCompanyId();
        long branchId = user.getUserId();
        String path = req.getPathInfo();

        // 1. 상세 보기 API 요청 처리 (e.g., /123/details)
        if (path != null && path.matches("/\\d+/details")) {
            try {
                long orderId = Long.parseLong(path.split("/")[1]);
                // [수정된 부분] 서비스에서 품목 목록을 가져옵니다.
                List<PurchaseOrderLine> lines = orderService.listOrderLines(companyId, orderId);
                
                // [수정된 부분] JSP가 원하는 JSON 형식으로 응답 데이터를 만듭니다.
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("items", lines); // "items" 라는 키로 품목 리스트를 넣습니다.
                responseData.put("totalCount", lines.size()); // 전체 카운트 (여기서는 페이징 없이 전체를 보내므로 리스트 크기)
                responseData.put("page", 1);
                responseData.put("pageSize", lines.size());

                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write(gson.toJson(responseData)); // Map 객체를 JSON으로 변환하여 응답
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
            }
            return; // API 응답 후 처리를 종료합니다.
        }

        // 2. 발주 기록 목록 페이지 처리 (기존 코드 유지)
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null) page = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) { /* page=1 유지 */ }
        int offset = (page - 1) * PAGE_SIZE;

        List<PurchaseOrder> orders = orderService.listOrdersForBranch(companyId, branchId, PAGE_SIZE, offset);
        int totalCount = orderService.getTotalOrderCountForBranch(companyId, branchId);

        req.setAttribute("orders", orders);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", PAGE_SIZE);

        req.getRequestDispatcher("/WEB-INF/branch/orders-history.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");

        if (user == null || user.getUserId()+"" == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
            return;
        }

        String path = req.getPathInfo();
        // URL이 /123/receive 와 같은 형태인지 확인
        if (path != null && path.matches("/\\d+/receive")) {
            try {
                long companyId = user.getCompanyId();
                long orderId = Long.parseLong(path.split("/")[1]);

                // 이미 준비된 서비스 로직 호출!
                new OrderService().markReceivedAndIncreaseInventory(companyId, orderId);

                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"OK\"}");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to process receipt.");
            }
            return;
        }

        resp.sendError(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
    }
}