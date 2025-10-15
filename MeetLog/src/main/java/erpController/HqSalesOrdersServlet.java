package erpController;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import erpDto.PurchaseOrder;
import erpDto.PurchaseOrderLine;
import erpService.OrderService;
import model.BusinessUser;

@WebServlet(urlPatterns = {"/hq/sales-orders", "/hq/sales-orders/*"})
public class HqSalesOrdersServlet extends HttpServlet {
	private final OrderService orderService = new OrderService();
	private final Gson gson = new Gson();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");

		String path = req.getPathInfo();
	    HttpSession session = req.getSession(false);
	    BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
	    if (user == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }
	    long companyId = user.getCompanyId();

		// 1. JSP 페이지 로딩 처리 (e.g., /hq/sales-orders)
		if (path == null || path.equals("/") || path.equals("/sales-orders")) {
			int page = parseInt(req.getParameter("page"), 1);
			int size = parseInt(req.getParameter("size"), 10);
			String status = req.getParameter("status");
			int offset = (page - 1) * size;

			List<PurchaseOrder> list = orderService.listOrdersForCompany(companyId, status, size, offset);
			int totalCount = orderService.getTotalOrderCountForCompany(companyId, status); // 전체 개수 조회

			req.setAttribute("orders", list);
			req.setAttribute("totalCount", totalCount);
			req.setAttribute("currentPage", page);
			req.setAttribute("pageSize", size);

			req.getRequestDispatcher("/WEB-INF/hq/sales-orders.jsp").forward(req, resp);
			return;
		}

		// 2. 모달 상세 품목 데이터 조회 API (e.g., /hq/sales-orders/{orderId}/details)
		String[] pathParts = path.split("/");
		System.out.println(path.toString());
		if (pathParts.length == 3 && "details".equals(pathParts[2])) {
			try {
				long orderId = Long.parseLong(pathParts[1]);
				List<PurchaseOrderLine> lines = orderService.listOrderLines(companyId, orderId);
				System.out.println(lines);
				resp.setContentType("application/json; charset=UTF-8");
				resp.getWriter().write(gson.toJson(lines));
			} catch (NumberFormatException e) {
				resp.sendError(400, "Invalid order ID");
			}
			return;
		}

		resp.sendError(404);
	}

	// POST /hq/sales-orders/{orderId}/inspect
	// HqSalesOrdersServlet.java의 doPost 메소드
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    String path = req.getPathInfo();
	    String[] pathParts = (path != null) ? path.split("/") : new String[0];

	    // 경로가 /_ORDER_ID_/inspect 형태인지 확인 (e.g., /101/inspect)
	    if (pathParts.length == 3 && "inspect".equals(pathParts[2])) {
	        HttpSession session = req.getSession(false);
	        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
	        if (user == null) {
	            resp.sendError(403, "Authentication required");
	            return;
	        }
	        long companyId = user.getCompanyId(); // <- 세션에서 companyId를 가져옵니다.

	        try {
	            long orderId = Long.parseLong(pathParts[1]); // orderId를 경로에서 추출합니다.

	            String body = req.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
	            java.lang.reflect.Type listType = new TypeToken<List<PurchaseOrderLine>>(){}.getType();
	            List<PurchaseOrderLine> linesToUpdate = gson.fromJson(body, listType);

	            if (linesToUpdate != null && !linesToUpdate.isEmpty()) {
	                // companyId를 서비스 메소드로 전달해야 할 수 있습니다. (OrderService 구현에 따라 다름)
	                orderService.updateOrderLineStatuses(companyId, orderId, linesToUpdate);
	            }

	            resp.setContentType("application/json; charset=UTF-8");
	            resp.getWriter().write("{\"status\":\"OK\"}");
	            return; // <- 처리 후 반드시 return

	        } catch (NumberFormatException e) {
	            resp.sendError(400, "Invalid order ID format");
	            return;
	        }
	    }
	    resp.sendError(404);
	}

	private static int parseInt(String s, int d) {
		try {
			return Integer.parseInt(s);
		} catch (NumberFormatException e) {
			// s가 null이거나 숫자가 아닐 때 기본값 d를 반환합니다.
			return d;
		} catch (Exception e) {
			return d;
		}
	}
}