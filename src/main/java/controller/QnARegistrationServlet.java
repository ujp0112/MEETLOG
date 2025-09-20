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

@WebServlet("/restaurant/qna/register")
public class QnARegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            String restaurantIdStr = request.getParameter("restaurantId");
            String question = request.getParameter("question");
            
            if (restaurantIdStr == null || question == null || question.trim().isEmpty()) {
                request.setAttribute("errorMessage", "필수 정보를 모두 입력해주세요.");
                response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantIdStr + "?error=missing_info");
                return;
            }
            
            try {
                int restaurantId = Integer.parseInt(restaurantIdStr);
                
                // Q&A 객체 생성
                BusinessQnA qna = new BusinessQnA();
                qna.setRestaurantId(restaurantId);
                qna.setUserId(user.getId());
                qna.setUserName(user.getName());
                qna.setUserEmail(user.getEmail());
                qna.setQuestion(question.trim());
                qna.setStatus("PENDING");
                qna.setIsOwner(false);
                qna.setIsActive(true);
                
                BusinessQnAService qnaService = new BusinessQnAService();
                
                // Q&A 등록
                boolean success = qnaService.addQnA(qna);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId + "?success=qna_added");
                } else {
                    response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId + "?error=qna_failed");
                }
                
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantIdStr + "?error=invalid_id");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + request.getParameter("restaurantId") + "?error=server_error");
        }
    }
}
