package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class NoticeManagementServlet extends HttpServlet {
    
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
            
            List<Notice> notices = createSampleNotices();
            request.setAttribute("notices", notices);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-notice-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "공지사항 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Notice> createSampleNotices() {
        List<Notice> notices = new ArrayList<>();
        
        Notice notice1 = new Notice();
        notice1.setId(1);
        notice1.setTitle("시스템 점검 안내");
        notice1.setContent("9월 20일 새벽 2시부터 4시까지 시스템 점검이 있습니다.");
        notice1.setAuthor("관리자");
        notice1.setCreatedAt("2025-09-14");
        notices.add(notice1);
        
        return notices;
    }
    
    public static class Notice {
        private int id;
        private String title;
        private String content;
        private String author;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public String getAuthor() { return author; }
        public void setAuthor(String author) { this.author = author; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}
