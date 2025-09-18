package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class AdminCsManagementServlet extends HttpServlet {
    
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
            
            // 고객 문의 목록 데이터
            List<Inquiry> inquiries = createSampleInquiries();
            request.setAttribute("inquiries", inquiries);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-cs-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 문의 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            
            String action = request.getParameter("action");
            int inquiryId = Integer.parseInt(request.getParameter("inquiryId"));
            String responseContent = request.getParameter("responseContent");
            
            if ("respond".equals(action)) {
                // 문의 답변 처리
                request.setAttribute("successMessage", "답변이 등록되었습니다.");
            } else if ("close".equals(action)) {
                // 문의 종료 처리
                request.setAttribute("successMessage", "문의가 종료되었습니다.");
            }
            
            // 문의 목록 다시 로드
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 문의 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
    
    private List<Inquiry> createSampleInquiries() {
        List<Inquiry> inquiries = new ArrayList<>();
        
        Inquiry inquiry1 = new Inquiry();
        inquiry1.setId(1);
        inquiry1.setUserName("김문의");
        inquiry1.setEmail("user1@example.com");
        inquiry1.setCategory("계정 관련");
        inquiry1.setSubject("비밀번호 변경 문의");
        inquiry1.setContent("비밀번호를 변경하고 싶은데 방법을 모르겠습니다.");
        inquiry1.setStatus("PENDING");
        inquiry1.setCreatedAt("2025-09-14 14:30");
        inquiries.add(inquiry1);
        
        Inquiry inquiry2 = new Inquiry();
        inquiry2.setId(2);
        inquiry2.setUserName("이문의");
        inquiry2.setEmail("user2@example.com");
        inquiry2.setCategory("예약 관련");
        inquiry2.setSubject("예약 취소 문의");
        inquiry2.setContent("예약을 취소하고 싶은데 어떻게 해야 하나요?");
        inquiry2.setStatus("RESPONDED");
        inquiry2.setCreatedAt("2025-09-13 16:20");
        inquiry2.setResponseContent("예약 상세 페이지에서 취소 버튼을 클릭하시면 됩니다.");
        inquiry2.setResponseAt("2025-09-13 17:30");
        inquiries.add(inquiry2);
        
        Inquiry inquiry3 = new Inquiry();
        inquiry3.setId(3);
        inquiry3.setUserName("박문의");
        inquiry3.setEmail("user3@example.com");
        inquiry3.setCategory("기술적 문제");
        inquiry3.setSubject("앱 오류 문의");
        inquiry3.setContent("앱이 자꾸 종료되는 문제가 있습니다.");
        inquiry3.setStatus("CLOSED");
        inquiry3.setCreatedAt("2025-09-12 10:15");
        inquiry3.setResponseContent("최신 버전으로 업데이트해주시기 바랍니다.");
        inquiry3.setResponseAt("2025-09-12 11:00");
        inquiries.add(inquiry3);
        
        return inquiries;
    }
    
    // 문의 클래스
    public static class Inquiry {
        private int id;
        private String userName;
        private String email;
        private String category;
        private String subject;
        private String content;
        private String status;
        private String createdAt;
        private String responseContent;
        private String responseAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getSubject() { return subject; }
        public void setSubject(String subject) { this.subject = subject; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        public String getResponseContent() { return responseContent; }
        public void setResponseContent(String responseContent) { this.responseContent = responseContent; }
        public String getResponseAt() { return responseAt; }
        public void setResponseAt(String responseAt) { this.responseAt = responseAt; }
    }
}
