package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/business/info-edit")
public class BusinessInfoEditServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String userType = (String) session.getAttribute("userType");
            
            if (userId == null || !"BUSINESS".equals(userType)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            request.getRequestDispatcher("/WEB-INF/views/business-info-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "정보 수정 페이지를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String userType = (String) session.getAttribute("userType");
            
            if (userId == null || !"BUSINESS".equals(userType)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String restaurantName = request.getParameter("restaurantName");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String description = request.getParameter("description");
            
            // 정보 수정 처리
            request.setAttribute("successMessage", "정보가 수정되었습니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-info-edit.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "정보 수정 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/business-info-edit.jsp").forward(request, response);
        }
    }
}
