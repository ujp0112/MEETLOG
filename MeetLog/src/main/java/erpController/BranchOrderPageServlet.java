package erpController;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import erpDto.Material;
import erpService.MaterialService;
import model.BusinessUser;

@WebServlet(urlPatterns = {"/branch/order", "/branch/order/*"})
public class BranchOrderPageServlet extends HttpServlet {
  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
private final MaterialService materialService = new MaterialService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
    HttpSession session = req.getSession();
    BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
    if (user == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }

    long companyId = user.getCompanyId();

    // 간단 서버사이드 페이징 (pageSize=10 고정: order.jsp 가정과 동일)
    int pageSize = 10;
    int page = 1;
    try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignore) {}
    if (page < 1) page = 1;
    int offset = (page - 1) * pageSize;

    // 최소 구현: 브랜치 재고 수량 대신 회사 재료 목록(step 포함)만 공급
    List<Material> all = materialService.listByCompany(companyId);
    int totalCount = all.size();
    int toIndex = Math.min(offset + pageSize, totalCount);
    List<Material> pageItems = (offset < totalCount) ? all.subList(offset, toIndex) : java.util.Collections.emptyList();

    req.setAttribute("materials", pageItems);
    req.setAttribute("totalCount", totalCount);
    req.setAttribute("page", page);

    req.getRequestDispatcher("/WEB-INF/branch/order.jsp").forward(req, resp);
  }
}
