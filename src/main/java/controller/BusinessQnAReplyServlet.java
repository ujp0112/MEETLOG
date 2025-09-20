package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import model.BusinessQnA;
import service.BusinessQnAService;
import util.MyBatisSqlSessionFactory;
// import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/qna/reply")
public class BusinessQnAReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            String qnaIdStr = request.getParameter("qnaId");
            String answer = request.getParameter("answer");
            
            if (qnaIdStr == null || answer == null || answer.trim().isEmpty()) {
                request.setAttribute("errorMessage", "필수 정보를 모두 입력해주세요.");
                request.getRequestDispatcher("/WEB-INF/views/business/qna-management.jsp").forward(request, response);
                return;
            }
            
            try {
                int qnaId = Integer.parseInt(qnaIdStr);
                
                BusinessQnAService qnaService = new BusinessQnAService();
                
                // Q&A 답변 업데이트
                boolean success = qnaService.updateQnAAnswer(qnaId, answer.trim());
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/business/qna-management?success=answer_added");
                } else {
                    request.setAttribute("errorMessage", "Q&A 답변 추가에 실패했습니다.");
                    request.getRequestDispatcher("/WEB-INF/views/business/qna-management.jsp").forward(request, response);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Q&A ID는 숫자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/views/business/qna-management.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Q&A 답변 추가 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
