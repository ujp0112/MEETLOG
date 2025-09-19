package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/faq")
public class FaqServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 샘플 FAQ 데이터
            List<Faq> faqs = createSampleFaqs();
            request.setAttribute("faqs", faqs);
            
            request.getRequestDispatcher("/WEB-INF/views/faq.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "FAQ를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private List<Faq> createSampleFaqs() {
        List<Faq> faqs = new ArrayList<>();
        
        Faq faq1 = new Faq();
        faq1.setId(1);
        faq1.setCategory("계정 관련");
        faq1.setQuestion("비밀번호를 잊어버렸어요. 어떻게 해야 하나요?");
        faq1.setAnswer("로그인 페이지에서 '비밀번호 찾기'를 클릭하시면 이메일로 재설정 링크를 보내드립니다.");
        faqs.add(faq1);
        
        Faq faq2 = new Faq();
        faq2.setId(2);
        faq2.setCategory("예약 관련");
        faq2.setQuestion("예약을 취소하고 싶어요.");
        faq2.setAnswer("마이페이지 > 예약 관리에서 취소하고 싶은 예약을 선택하여 취소할 수 있습니다.");
        faqs.add(faq2);
        
        Faq faq3 = new Faq();
        faq3.setId(3);
        faq3.setCategory("리뷰 관련");
        faq3.setQuestion("리뷰를 수정할 수 있나요?");
        faq3.setAnswer("리뷰는 작성 후 24시간 이내에만 수정 가능합니다.");
        faqs.add(faq3);
        
        return faqs;
    }
    
    // FAQ 클래스
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
