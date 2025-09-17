package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import service.OrderService;
import dto.PurchaseOrderLine;

public class OrderServlet extends HttpServlet {
  private final OrderService orderService = new OrderService();

  @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    long companyId = (Long) req.getAttribute("companyId");
    Long branchIdObj = (Long) req.getAttribute("branchId");
    if (branchIdObj == null) { resp.sendError(403); return; }
    long branchId = branchIdObj;

    String body = req.getReader().lines().reduce("", (a,b)->a+b);
    if (body == null || body.isEmpty()) body = req.getParameter("orderJson");
    if (body == null || body.isEmpty()) { resp.sendError(400); return; }

    List<PurchaseOrderLine> lines = new ArrayList<>();
    try {
      String itemsPart = body.substring(body.indexOf('[')+1, body.lastIndexOf(']')).trim();
      if (!itemsPart.isEmpty()) {
        String[] chunks = itemsPart.split("\\},\\{");
        int idx=1;
        for (String c : chunks) {
          String t = c.replace("{","").replace("}","");
          Long matId = getLong(t, "\"id\":");
          Double qty = getDouble(t, "\"quantity\":");
          Double unitPrice = getDouble(t, "\"unitPrice\":");
          if (matId == null || qty == null || unitPrice == null) continue;
          PurchaseOrderLine l = new PurchaseOrderLine();
          l.setMaterialId(matId);
          l.setQty(qty);
          l.setUnitPrice(unitPrice);
          l.setLineNo(idx++);
          lines.add(l);
        }
      }
    } catch(Exception e){
      resp.sendError(400); return;
    }

    long orderId = orderService.createOrder(companyId, branchId, lines);
    resp.setContentType("application/json; charset=UTF-8");
    resp.getWriter().write("{\"orderId\":"+orderId+"}");
  }

  private static Long getLong(String s, String key){
    int i = s.indexOf(key); if (i<0) return null;
    i += key.length();
    int j = i;
    while (j<s.length() && (Character.isDigit(s.charAt(j)))) j++;
    return Long.parseLong(s.substring(i,j));
  }
  private static Double getDouble(String s, String key){
    int i = s.indexOf(key); if (i<0) return null;
    i += key.length();
    int j = i;
    while (j<s.length() && ("-+.0123456789".indexOf(s.charAt(j))>=0)) j++;
    return Double.parseDouble(s.substring(i,j));
  }
}
