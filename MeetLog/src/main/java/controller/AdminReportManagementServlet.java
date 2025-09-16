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

@WebServlet("/admin/report-management")
public class AdminReportManagementServlet extends HttpServlet {
    
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
            
            // 신고 목록 데이터
            List<Report> reports = createSampleReports();
            request.setAttribute("reports", reports);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-report-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "신고 목록을 불러오는 중 오류가 발생했습니다.");
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
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            
            if ("process".equals(action)) {
                // 신고 처리
                request.setAttribute("successMessage", "신고가 처리되었습니다.");
            } else if ("dismiss".equals(action)) {
                // 신고 기각
                request.setAttribute("successMessage", "신고가 기각되었습니다.");
            }
            
            // 신고 목록 다시 로드
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "신고 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
    
    private List<Report> createSampleReports() {
        List<Report> reports = new ArrayList<>();
        
        Report report1 = new Report();
        report1.setId(1);
        report1.setReporterName("김신고");
        report1.setReportedContent("부적절한 리뷰");
        report1.setReason("욕설 사용");
        report1.setStatus("PENDING");
        report1.setCreatedAt("2025-09-14 16:30");
        reports.add(report1);
        
        Report report2 = new Report();
        report2.setId(2);
        report2.setReporterName("이신고");
        report2.setReportedContent("가짜 정보 게시");
        report2.setReason("허위 정보");
        report2.setStatus("PROCESSED");
        report2.setCreatedAt("2025-09-13 14:20");
        reports.add(report2);
        
        return reports;
    }
    
    // 신고 클래스
    public static class Report {
        private int id;
        private String reporterName;
        private String reportedContent;
        private String reason;
        private String status;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getReporterName() { return reporterName; }
        public void setReporterName(String reporterName) { this.reporterName = reporterName; }
        public String getReportedContent() { return reportedContent; }
        public void setReportedContent(String reportedContent) { this.reportedContent = reportedContent; }
        public String getReason() { return reason; }
        public void setReason(String reason) { this.reason = reason; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}