package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;

public class CouponManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // 임시 데이터 (추후 실제 데이터로 교체)
            int totalCoupons = 5;
            int activeCoupons = 3;
            int expiredCoupons = 2;
            int usedCoupons = 1;

            // JSP로 데이터 전달
            request.setAttribute("totalCoupons", totalCoupons);
            request.setAttribute("activeCoupons", activeCoupons);
            request.setAttribute("expiredCoupons", expiredCoupons);
            request.setAttribute("usedCoupons", usedCoupons);
            request.setAttribute("coupons", new ArrayList<>());

            request.getRequestDispatcher("/WEB-INF/views/coupon-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "쿠폰 관리 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
