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

@WebServlet("/admin/faq-management")
public class FaqManagementServlet extends HttpServlet {
    
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
            
            List<Faq> faqs = createSampleFaqs();
            request.setAttribute("faqs", faqs);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-faq-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "FAQ 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Faq> createSampleFaqs() {
        List<Faq> faqs = new ArrayList<>();
        
        Faq faq1 = new Faq();
        faq1.setId(1);
        faq1.setCategory("계정 관련");
        faq1.setQuestion("비밀번호를 잊어버렸어요.");
        faq1.setAnswer("비밀번호 찾기를 이용하세요.");
        faqs.add(faq1);
        
        return faqs;
    }
    
    public static class Faq {
        private int id;
        private String category;
        private String question;
        private String answer;
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getQuestion() { return question; }
        public void setQuestion(String question) { this.question = question; }
        public String getAnswer() { return answer; }
        public void setAnswer(String answer) { this.answer = answer; }
    }
}
