package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import service.OrderService;
import dto.PurchaseOrderLine;

public class OrderServlet extends HttpServlet {
	private final OrderService orderService = new OrderService();

//import java.util.stream.Collectors; 필요

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		long companyId = (Long) req.getAttribute("companyId");
		Long branchIdObj = (Long) req.getAttribute("branchId");
		if (branchIdObj == null) {
			resp.sendError(403);
			return;
		}
		long branchId = branchIdObj;

		// ✅ 폼 파라미터를 최우선
		String body = req.getParameter("orderJson");

		// 폼이 아니고 JSON 바디일 때만 Reader 사용
		if ((body == null || body.isEmpty())) {
			String ct = req.getContentType();
			if (ct != null && ct.startsWith("application/json")) {
				body = req.getReader().lines().collect(java.util.stream.Collectors.joining());
			}
		}

		if (body == null || body.isEmpty()) {
			resp.sendError(400);
			return;
		}

		List<PurchaseOrderLine> lines = new ArrayList<>();
		try {
			// body는 배열 또는 {"items":[...]} 모두 허용
			int lb = body.indexOf('['), rb = body.lastIndexOf(']');
			if (lb < 0 || rb < lb)
				throw new RuntimeException("no array");
			String itemsPart = body.substring(lb + 1, rb).trim();
			if (!itemsPart.isEmpty()) {
				String[] chunks = itemsPart.split("\\},\\{");
				int idx = 1;
				for (String c : chunks) {
					String t = c.replace("{", "").replace("}", "");

					Long matId = getLongFlexible(t, "\"id\":"); // 👈 문자열 숫자도 허용
					Double qty = getDouble(t, "\"quantity\":");
					Double unitPrice = getDouble(t, "\"unitPrice\":");
					if (matId == null || qty == null || unitPrice == null)
						continue;

					PurchaseOrderLine l = new PurchaseOrderLine();
					l.setMaterialId(matId);
					l.setQty(qty);
					l.setUnitPrice(unitPrice);
					l.setLineNo(idx++);
					lines.add(l);
				}
			}
		} catch (Exception e) {
			resp.sendError(400);
			return;
		}

		long orderId = orderService.createOrder(companyId, branchId, lines);
		resp.setContentType("application/json; charset=UTF-8");
		resp.getWriter().write("{\"orderId\":" + orderId + "}");
	}

	private static Long getLongFlexible(String s, String key) {
		int i = s.indexOf(key);
		if (i < 0)
			return null;
		i += key.length();
		// " , : 등 모두 건너뛰고 숫자 시작 위치 찾기
		while (i < s.length() && !Character.isDigit(s.charAt(i)))
			i++;
		if (i >= s.length())
			return null;
		int j = i;
		while (j < s.length() && Character.isDigit(s.charAt(j)))
			j++;
		return Long.parseLong(s.substring(i, j));
	}

	private static Double getDouble(String s, String key) {
		int i = s.indexOf(key);
		if (i < 0)
			return null;
		i += key.length();
		while (i < s.length() && " \":".indexOf(s.charAt(i)) >= 0)
			i++; // 공백/콜론/따옴표 스킵
		int j = i;
		while (j < s.length() && "-+.0123456789".indexOf(s.charAt(j)) >= 0)
			j++;
		return Double.parseDouble(s.substring(i, j));
	}

}
