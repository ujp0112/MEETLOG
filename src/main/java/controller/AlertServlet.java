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

@WebServlet("/alert")
public class AlertServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // 샘플 알림 데이터
            List<Alert> alerts = createSampleAlerts();
            request.setAttribute("alerts", alerts);
            
            request.getRequestDispatcher("/WEB-INF/views/alert.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "알림을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Alert> createSampleAlerts() {
        List<Alert> alerts = new ArrayList<>();
        
        Alert alert1 = new Alert();
        alert1.setId(1);
        alert1.setTitle("새로운 리뷰가 등록되었습니다");
        alert1.setContent("고미정에 대한 리뷰가 새로 등록되었습니다.");
        alert1.setCreatedAt("2025-09-14 15:30");
        alert1.setIsRead(false);
        alerts.add(alert1);
        
        Alert alert2 = new Alert();
        alert2.setId(2);
        alert2.setTitle("예약이 확정되었습니다");
        alert2.setContent("파스타 팩토리 예약이 확정되었습니다. (2025-09-16 19:00)");
        alert2.setCreatedAt("2025-09-14 14:20");
        alert2.setIsRead(true);
        alerts.add(alert2);
        
        Alert alert3 = new Alert();
        alert3.setId(3);
        alert3.setTitle("칼럼이 추천되었습니다");
        alert3.setContent("작성하신 '강남 맛집 베스트 5' 칼럼이 추천 목록에 등록되었습니다.");
        alert3.setCreatedAt("2025-09-14 10:15");
        alert3.setIsRead(false);
        alerts.add(alert3);
        
        return alerts;
    }
    
    // Alert 클래스 (간단한 모델)
    public static class Alert {
        private int id;
        private String title;
        private String content;
        private String createdAt;
        private boolean isRead;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        public boolean getIsRead() { return isRead; }
        public void setIsRead(boolean isRead) { this.isRead = isRead; }
    }
}
