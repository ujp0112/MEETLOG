package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/inquiry-management")
public class InquiryManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            
            List<Inquiry> inquiries = createSampleInquiries();
            request.setAttribute("inquiries", inquiries);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-inquiry-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "문의 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Inquiry> createSampleInquiries() {
        List<Inquiry> inquiries = new ArrayList<>();
        
        Inquiry inquiry1 = new Inquiry();
        inquiry1.setId(1);
        inquiry1.setUserName("김문의");
        inquiry1.setSubject("계정 문의");
        inquiry1.setContent("비밀번호를 변경하고 싶어요.");
        inquiry1.setStatus("PENDING");
        inquiry1.setCreatedAt("2025-09-14");
        inquiries.add(inquiry1);
        
        return inquiries;
    }
    
    public static class Inquiry {
        private int id;
        private String userName;
        private String subject;
        private String content;
        private String status;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getSubject() { return subject; }
        public void setSubject(String subject) { this.subject = subject; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}
