package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.PurchaseOrder;
import service.OrderService;

public class HqSalesOrdersServlet extends HttpServlet {
	private final OrderService orderService = new OrderService();

	// GET /hq/sales-orders?page=&size=&status=
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String path = req.getPathInfo();
		if ("/sales-orders".equals(path)) {
			long companyId = (Long) req.getAttribute("companyId");
			int page = parseInt(req.getParameter("page"), 1);
			int size = parseInt(req.getParameter("size"), 20);
			String status = req.getParameter("status");
			int offset = (page - 1) * size;

			java.util.List<PurchaseOrder> list = orderService.listOrdersForCompany(companyId, status, size, offset);

			resp.setContentType("application/json; charset=UTF-8");
			StringBuilder sb = new StringBuilder("[");
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			for (int i = 0; i < list.size(); i++) {
				PurchaseOrder po = list.get(i);
				if (i > 0)
					sb.append(',');
				String orderedAt = (po.getOrderedAt() == null) ? "" : fmt.format(po.getOrderedAt());
				sb.append("{\"id\":").append(po.getId()).append(",\"branchName\":\"").append(esc(po.getBranchName()))
						.append("\"").append(",\"totalPrice\":")
						.append(po.getTotalPrice() == null ? 0 : po.getTotalPrice()).append(",\"status\":\"")
						.append(esc(po.getStatus())).append("\"").append(",\"orderedAt\":\"").append(orderedAt)
						.append("\"}");
			}
			sb.append("]");
			resp.getWriter().write(sb.toString());
			return;
		}
		resp.sendError(404);
	}

	// POST /hq/sales-orders/{orderId}/inspect (status=APPROVED|REJECTED|RECEIVED)
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String path = req.getPathInfo();
		if (path != null && path.startsWith("/sales-orders/") && path.endsWith("/inspect")) {
			long companyId = (Long) req.getAttribute("companyId");
			String sid = path.substring("/sales-orders/".length(), path.length() - "/inspect".length());
			long orderId = Long.parseLong(sid);
			String status = req.getParameter("status");
			if (status == null || status.isEmpty())
				status = "APPROVED";

			if ("RECEIVED".equalsIgnoreCase(status)) {
				orderService.markReceivedAndIncreaseInventory(companyId, orderId);
			} else {
				orderService.updateStatus(companyId, orderId, status.toUpperCase());
			}
			resp.setContentType("text/plain; charset=UTF-8");
			resp.getWriter().write("OK");
			return;
		}
		resp.sendError(404);
	}

	private static int parseInt(String s, int d) {
		try {
			return Integer.parseInt(s);
		} catch (Exception e) {
			return d;
		}
	}

	private static String esc(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"");
	}
}
