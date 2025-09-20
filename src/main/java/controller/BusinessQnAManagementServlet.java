package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import model.Restaurant;
import model.BusinessQnA;
import service.RestaurantService;
import service.BusinessQnAService;
import util.MyBatisSqlSessionFactory;
// import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/qna-management")
public class BusinessQnAManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // 비즈니스 사용자의 음식점 목록 가져오기
            RestaurantService restaurantService = new RestaurantService();
            List<Restaurant> myRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            
            // Q&A 목록 가져오기
            BusinessQnAService qnaService = new BusinessQnAService();
            List<BusinessQnA> qnaList = qnaService.getQnAByOwnerId(user.getId());
            
            // Q&A 통계 가져오기
            int totalQnA = qnaList.size();
            int pendingQnA = (int) qnaList.stream().filter(qna -> "PENDING".equals(qna.getStatus())).count();
            int answeredQnA = (int) qnaList.stream().filter(qna -> "ANSWERED".equals(qna.getStatus())).count();
            
            request.setAttribute("myRestaurants", myRestaurants);
            request.setAttribute("qnaList", qnaList);
            request.setAttribute("totalQnA", totalQnA);
            request.setAttribute("pendingQnA", pendingQnA);
            request.setAttribute("answeredQnA", answeredQnA);
            
            request.getRequestDispatcher("/WEB-INF/views/business/qna-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Q&A 관리 페이지를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
