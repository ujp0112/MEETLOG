package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class AdminBusinessManagementServlet extends HttpServlet {
    
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
            
            // 입점 업체 목록 데이터
            List<Business> businesses = createSampleBusinesses();
            request.setAttribute("businesses", businesses);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-business-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "입점 업체 목록을 불러오는 중 오류가 발생했습니다.");
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
            int businessId = Integer.parseInt(request.getParameter("businessId"));
            
            if ("approve".equals(action)) {
                // 입점 승인 처리
                request.setAttribute("successMessage", "입점이 승인되었습니다.");
            } else if ("reject".equals(action)) {
                // 입점 거부 처리
                request.setAttribute("successMessage", "입점이 거부되었습니다.");
            } else if ("suspend".equals(action)) {
                // 업체 정지 처리
                request.setAttribute("successMessage", "업체가 정지되었습니다.");
            }
            
            // 업체 목록 다시 로드
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "업체 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
    
    private List<Business> createSampleBusinesses() {
        List<Business> businesses = new ArrayList<>();
        
        Business business1 = new Business();
        business1.setId(1);
        business1.setBusinessName("고미정");
        business1.setOwnerName("김사장");
        business1.setEmail("business1@example.com");
        business1.setPhone("02-1234-5678");
        business1.setCategory("한식");
        business1.setLocation("강남구");
        business1.setStatus("APPROVED");
        business1.setCreatedAt("2025-08-01");
        business1.setReviewCount(25);
        businesses.add(business1);
        
        Business business2 = new Business();
        business2.setId(2);
        business2.setBusinessName("파스타 팩토리");
        business2.setOwnerName("이사장");
        business2.setEmail("business2@example.com");
        business2.setPhone("02-2345-6789");
        business2.setCategory("양식");
        business2.setLocation("홍대");
        business2.setStatus("PENDING");
        business2.setCreatedAt("2025-09-10");
        business2.setReviewCount(0);
        businesses.add(business2);
        
        Business business3 = new Business();
        business3.setId(3);
        business3.setBusinessName("스시 마에");
        business3.setOwnerName("박사장");
        business3.setEmail("business3@example.com");
        business3.setPhone("02-3456-7890");
        business3.setCategory("일식");
        business3.setLocation("여의도");
        business3.setStatus("SUSPENDED");
        business3.setCreatedAt("2025-07-15");
        business3.setReviewCount(12);
        businesses.add(business3);
        
        return businesses;
    }
    
    // 업체 클래스
    public static class Business {
        private int id;
        private String businessName;
        private String ownerName;
        private String email;
        private String phone;
        private String category;
        private String location;
        private String status;
        private String createdAt;
        private int reviewCount;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getBusinessName() { return businessName; }
        public void setBusinessName(String businessName) { this.businessName = businessName; }
        public String getOwnerName() { return ownerName; }
        public void setOwnerName(String ownerName) { this.ownerName = ownerName; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getLocation() { return location; }
        public void setLocation(String location) { this.location = location; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        public int getReviewCount() { return reviewCount; }
        public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    }
}
