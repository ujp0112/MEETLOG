package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Inquiry;
import model.User;
import service.InquiryService;

import java.io.IOException;

public class InquiryServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 1:1 문의 페이지로 이동
        request.getRequestDispatcher("/WEB-INF/views/inquiry.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            Integer userId = user.getId();
            String userNickname = user.getNickname();
            String userEmail = user.getEmail();
            
            String category = request.getParameter("category");
            String subject = request.getParameter("subject");
            String content = request.getParameter("content");
            String priority = "MEDIUM";
            if(category.equals("PAYMENT")) {
            	priority = "HIGH";
            } else if(category.equals("GENERAL")) {
            	priority = "LOW";
            }
            
            // 문의 등록 처리 (실제로는 데이터베이스에 저장)
            InquiryService iService = new InquiryService();
            Inquiry inquiry = new Inquiry(userId, userNickname, subject, content, userEmail, category, priority);
            iService.createInquiry(inquiry);
            request.setAttribute("successMessage", "문의가 등록되었습니다. 빠른 시일 내에 답변드리겠습니다.");
            request.getRequestDispatcher("/WEB-INF/views/inquiry.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "문의 등록 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/inquiry.jsp").forward(request, response);
        }
    }
}
