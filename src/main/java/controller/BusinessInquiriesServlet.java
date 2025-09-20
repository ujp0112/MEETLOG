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

public class BusinessInquiriesServlet extends HttpServlet {
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
            int totalInquiries = 5;
            int pendingInquiries = 2;
            int answeredInquiries = 3;

            // JSP로 데이터 전달
            request.setAttribute("inquiries", new ArrayList<>());
            request.setAttribute("totalInquiries", totalInquiries);
            request.setAttribute("pendingInquiries", pendingInquiries);
            request.setAttribute("answeredInquiries", answeredInquiries);

            request.getRequestDispatcher("/WEB-INF/views/business-inquiries.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "문의 페이지 로딩 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
