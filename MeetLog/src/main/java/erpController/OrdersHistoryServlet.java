package erpController;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import erpDto.PurchaseOrderLine;
import erpService.OrderService;

public class OrdersHistoryServlet extends HttpServlet {
  private final OrderService orderService = new OrderService();

  @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    // /branch/orders/{orderId}/details
    String path = req.getPathInfo();
    String[] parts = (path == null ? "" : path).split("/");
    if (parts.length == 4 && "orders".equals(parts[1]) && "details".equals(parts[3])) {
      long companyId = (Long) req.getAttribute("companyId");
      long orderId = Long.parseLong(parts[2]);
      List<PurchaseOrderLine> list = orderService.listOrderLines(companyId, orderId);

      resp.setContentType("application/json; charset=UTF-8");
      StringBuilder sb = new StringBuilder("[");
      for (int i=0;i<list.size();i++){
        PurchaseOrderLine l = list.get(i);
        if(i>0) sb.append(',');
        sb.append("{\"name\":\"").append(esc(l.getMaterialName()))
          .append("\",\"unit\":\"").append(esc(l.getUnit()))
          .append("\",\"quantity\":").append(l.getQty()==null?0:l.getQty())
          .append(",\"unitPrice\":").append(l.getUnitPrice()==null?0:l.getUnitPrice())
          .append("}");
      }
      sb.append("]");
      resp.getWriter().write(sb.toString());
      return;
    }
    resp.sendError(404);
  }

  private static String esc(String s){
    if(s==null) return "";
    return s.replace("\\", "\\\\").replace("\"","\\\"");
  }
}
