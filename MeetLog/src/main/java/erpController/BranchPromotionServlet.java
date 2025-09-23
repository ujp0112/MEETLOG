package erpController;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import erpDto.Promotion;
import erpService.PromotionService;
import model.BusinessUser;

@WebServlet("/branch/promotion/*")
public class BranchPromotionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
        if (user == null || !"BRANCH".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        long companyId = user.getCompanyId();
        String pathInfo = request.getPathInfo();

        // 상세 보기 페이지 요청 (GET /branch/promotion/view?id=123)
        if ("/view".equals(pathInfo)) {
            long id = Long.parseLong(request.getParameter("id"));
            Promotion promotion = promotionService.getPromotionById(companyId, id);
            request.setAttribute("promotion", promotion);
            // HQ와 지점이 공통으로 사용할 상세 페이지로 포워딩
            request.getRequestDispatcher("/WEB-INF/branch/promotion-view.jsp").forward(request, response);
            return;
        }
        
        // 목록 페이지 요청 (GET /branch/promotion)
        List<Promotion> promotions = promotionService.listActivePromotionsForBranch(companyId);
        request.setAttribute("promotions", promotions);
        request.getRequestDispatcher("/WEB-INF/branch/branch-promotions.jsp").forward(request, response);
    }
}