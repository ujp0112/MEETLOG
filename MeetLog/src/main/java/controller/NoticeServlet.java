package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class NoticeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 샘플 공지사항 데이터
            List<Notice> notices = createSampleNotices();
            request.setAttribute("notices", notices);
            
            request.getRequestDispatcher("/WEB-INF/views/notice.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "공지사항을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Notice> createSampleNotices() {
        List<Notice> notices = new ArrayList<>();
        
        Notice notice1 = new Notice();
        notice1.setId(1);
        notice1.setTitle("서비스 점검 안내");
        notice1.setContent("2025년 9월 20일 02:00~06:00 서비스 점검으로 인해 일시적으로 이용이 제한됩니다.");
        notice1.setCreatedAt("2025-09-14");
        notice1.setIsImportant(true);
        notices.add(notice1);
        
        Notice notice2 = new Notice();
        notice2.setId(2);
        notice2.setTitle("새로운 기능 업데이트");
        notice2.setContent("맛집 추천 기능이 추가되었습니다. 더 정확한 추천을 받아보세요!");
        notice2.setCreatedAt("2025-09-10");
        notice2.setIsImportant(false);
        notices.add(notice2);
        
        Notice notice3 = new Notice();
        notice3.setId(3);
        notice3.setTitle("이벤트 안내");
        notice3.setContent("첫 리뷰 작성 시 1000포인트를 지급해드립니다!");
        notice3.setCreatedAt("2025-09-05");
        notice3.setIsImportant(false);
        notices.add(notice3);
        
        return notices;
    }
    
    // 공지사항 클래스
    public static class Notice {
        private int id;
        private String title;
        private String content;
        private String createdAt;
        private boolean isImportant;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        public boolean getIsImportant() { return isImportant; }
        public void setIsImportant(boolean isImportant) { this.isImportant = isImportant; }
    }
}
