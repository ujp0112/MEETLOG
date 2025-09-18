package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class AdminMemberManagementServlet extends HttpServlet {
    
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
            
            // 회원 목록 데이터
            List<Member> members = createSampleMembers();
            request.setAttribute("members", members);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-member-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "회원 목록을 불러오는 중 오류가 발생했습니다.");
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
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            
            if ("suspend".equals(action)) {
                // 회원 정지 처리
                request.setAttribute("successMessage", "회원이 정지되었습니다.");
            } else if ("activate".equals(action)) {
                // 회원 활성화 처리
                request.setAttribute("successMessage", "회원이 활성화되었습니다.");
            } else if ("delete".equals(action)) {
                // 회원 삭제 처리
                request.setAttribute("successMessage", "회원이 삭제되었습니다.");
            }
            
            // 회원 목록 다시 로드
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "회원 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
    
    private List<Member> createSampleMembers() {
        List<Member> members = new ArrayList<>();
        
        Member member1 = new Member();
        member1.setId(1);
        member1.setUsername("김회원");
        member1.setEmail("member1@example.com");
        member1.setPhone("010-1234-5678");
        member1.setUserType("USER");
        member1.setStatus("ACTIVE");
        member1.setCreatedAt("2025-08-01");
        member1.setLastLoginAt("2025-09-14 15:30");
        member1.setReviewCount(5);
        members.add(member1);
        
        Member member2 = new Member();
        member2.setId(2);
        member2.setUsername("이회원");
        member2.setEmail("member2@example.com");
        member2.setPhone("010-2345-6789");
        member2.setUserType("USER");
        member2.setStatus("SUSPENDED");
        member2.setCreatedAt("2025-07-15");
        member2.setLastLoginAt("2025-09-10 10:20");
        member2.setReviewCount(2);
        members.add(member2);
        
        return members;
    }
    
    // 회원 클래스
    public static class Member {
        private int id;
        private String username;
        private String email;
        private String phone;
        private String userType;
        private String status;
        private String createdAt;
        private String lastLoginAt;
        private int reviewCount;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        public String getUserType() { return userType; }
        public void setUserType(String userType) { this.userType = userType; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        public String getLastLoginAt() { return lastLoginAt; }
        public void setLastLoginAt(String lastLoginAt) { this.lastLoginAt = lastLoginAt; }
        public int getReviewCount() { return reviewCount; }
        public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    }
}
