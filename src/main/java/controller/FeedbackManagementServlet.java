package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;


public class FeedbackManagementServlet extends HttpServlet {
    
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
            
            List<Feedback> feedbacks = createSampleFeedbacks();
            request.setAttribute("feedbacks", feedbacks);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-feedback-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "피드백 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Feedback> createSampleFeedbacks() {
        List<Feedback> feedbacks = new ArrayList<>();
        
        Feedback feedback1 = new Feedback();
        feedback1.setId(1);
        feedback1.setUserName("김피드백");
        feedback1.setContent("서비스가 좋아요!");
        feedback1.setRating(5);
        feedback1.setCreatedAt("2025-09-14");
        feedbacks.add(feedback1);
        
        return feedbacks;
    }
    
    public static class Feedback {
        private int id;
        private String userName;
        private String content;
        private int rating;
        private String createdAt;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}
