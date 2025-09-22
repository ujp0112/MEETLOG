package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class SupportDashboardServlet extends HttpServlet {
    
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
            
            // 고객 지원 대시보드 데이터
            SupportDashboardData dashboardData = createSupportDashboardData();
            request.setAttribute("dashboardData", dashboardData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-support-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 지원 대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private SupportDashboardData createSupportDashboardData() {
        SupportDashboardData data = new SupportDashboardData();
        
        // 전체 통계
        data.setTotalInquiries(150);
        data.setPendingInquiries(25);
        data.setResolvedInquiries(120);
        data.setAverageResponseTime(2.5);
        
        // 카테고리별 문의 현황
        List<InquiryCategory> categories = new ArrayList<>();
        
        InquiryCategory category1 = new InquiryCategory();
        category1.setCategory("계정 관련");
        category1.setCount(45);
        category1.setPercentage(30.0);
        categories.add(category1);
        
        InquiryCategory category2 = new InquiryCategory();
        category2.setCategory("예약 관련");
        category2.setCount(60);
        category2.setPercentage(40.0);
        categories.add(category2);
        
        InquiryCategory category3 = new InquiryCategory();
        category3.setCategory("기술 지원");
        category3.setCount(30);
        category3.setPercentage(20.0);
        categories.add(category3);
        
        InquiryCategory category4 = new InquiryCategory();
        category4.setCategory("기타");
        category4.setCount(15);
        category4.setPercentage(10.0);
        categories.add(category4);
        
        data.setInquiryCategories(categories);
        
        // 최근 문의 목록
        List<RecentInquiry> recentInquiries = new ArrayList<>();
        
        RecentInquiry inquiry1 = new RecentInquiry();
        inquiry1.setId(1);
        inquiry1.setUserName("김문의");
        inquiry1.setSubject("비밀번호 변경 문의");
        inquiry1.setCategory("계정 관련");
        inquiry1.setStatus("PENDING");
        inquiry1.setCreatedAt("2025-09-14 16:30");
        recentInquiries.add(inquiry1);
        
        RecentInquiry inquiry2 = new RecentInquiry();
        inquiry2.setId(2);
        inquiry2.setUserName("이문의");
        inquiry2.setSubject("예약 취소 문의");
        inquiry2.setCategory("예약 관련");
        inquiry2.setStatus("RESOLVED");
        inquiry2.setCreatedAt("2025-09-14 14:20");
        recentInquiries.add(inquiry2);
        
        data.setRecentInquiries(recentInquiries);
        
        return data;
    }
    
    // 고객 지원 대시보드 데이터 클래스
    public static class SupportDashboardData {
        private int totalInquiries;
        private int pendingInquiries;
        private int resolvedInquiries;
        private double averageResponseTime;
        private List<InquiryCategory> inquiryCategories;
        private List<RecentInquiry> recentInquiries;
        
        // Getters and Setters
        public int getTotalInquiries() { return totalInquiries; }
        public void setTotalInquiries(int totalInquiries) { this.totalInquiries = totalInquiries; }
        public int getPendingInquiries() { return pendingInquiries; }
        public void setPendingInquiries(int pendingInquiries) { this.pendingInquiries = pendingInquiries; }
        public int getResolvedInquiries() { return resolvedInquiries; }
        public void setResolvedInquiries(int resolvedInquiries) { this.resolvedInquiries = resolvedInquiries; }
        public double getAverageResponseTime() { return averageResponseTime; }
        public void setAverageResponseTime(double averageResponseTime) { this.averageResponseTime = averageResponseTime; }
        public List<InquiryCategory> getInquiryCategories() { return inquiryCategories; }
        public void setInquiryCategories(List<InquiryCategory> inquiryCategories) { this.inquiryCategories = inquiryCategories; }
        public List<RecentInquiry> getRecentInquiries() { return recentInquiries; }
        public void setRecentInquiries(List<RecentInquiry> recentInquiries) { this.recentInquiries = recentInquiries; }
    }
    
    // 문의 카테고리 클래스
    public static class InquiryCategory {
        private String category;
        private int count;
        private double percentage;
        
        // Getters and Setters
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }
    
    // 최근 문의 클래스
    public static class RecentInquiry {
        private int id;
        private String userName;
        private String subject;
        private String category;
        private String status;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getSubject() { return subject; }
        public void setSubject(String subject) { this.subject = subject; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}
