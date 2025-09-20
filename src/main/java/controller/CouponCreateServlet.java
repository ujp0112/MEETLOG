package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;

public class CouponCreateServlet extends HttpServlet {
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

            request.getRequestDispatcher("/WEB-INF/views/coupon-create.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "쿠폰 생성 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // 쿠폰 생성 로직 (임시)
            String couponName = request.getParameter("couponName");
            String discountType = request.getParameter("discountType");
            String discountValue = request.getParameter("discountValue");
            String validFrom = request.getParameter("validFrom");
            String validTo = request.getParameter("validTo");
            String description = request.getParameter("description");
            
            // 성공 메시지 설정
            request.setAttribute("successMessage", "쿠폰이 성공적으로 생성되었습니다!");
            
            // 쿠폰 관리 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/coupon-management");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "쿠폰 생성 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/coupon-create.jsp").forward(request, response);
        }
    }
}
