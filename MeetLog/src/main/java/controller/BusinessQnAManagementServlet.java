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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        System.out.println("DEBUG - POST 요청 받음");
        System.out.println("DEBUG - User: " + (user != null ? user.getEmail() : "null"));
        System.out.println("DEBUG - UserType: " + (user != null ? user.getUserType() : "null"));

        if (user == null || !"BUSINESS".equals(user.getUserType())) {
            System.out.println("DEBUG - 인증 실패 - 리다이렉트");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("DEBUG - Action: " + action);

        try {
            if ("addAnswer".equals(action)) {
                System.out.println("DEBUG - addAnswer 처리 시작");
                handleAddAnswer(request, response, user);
            } else if ("toggleResolved".equals(action)) {
                System.out.println("DEBUG - toggleResolved 처리 시작");
                handleToggleResolved(request, response, user);
            } else {
                System.out.println("DEBUG - 유효하지 않은 action: " + action);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }

    private void handleAddAnswer(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int qnaId = Integer.parseInt(request.getParameter("qnaId"));
            String answer = request.getParameter("answer");

            if (answer == null || answer.trim().isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"답변 내용을 입력해주세요.\"}");
                return;
            }

            BusinessQnAService qnaService = new BusinessQnAService();
            boolean success = qnaService.addAnswer(qnaId, answer.trim(), user.getId());

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"답변이 등록되었습니다.\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"답변 등록에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"잘못된 Q&A ID입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    private void handleToggleResolved(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int qnaId = Integer.parseInt(request.getParameter("qnaId"));
            boolean isResolved = Boolean.parseBoolean(request.getParameter("isResolved"));

            BusinessQnAService qnaService = new BusinessQnAService();
            boolean success = qnaService.updateResolvedStatus(qnaId, isResolved);

            if (success) {
                String message = isResolved ? "해결 완료로 표시되었습니다." : "미해결로 표시되었습니다.";
                response.getWriter().write("{\"success\": true, \"message\": \"" + message + "\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"상태 변경에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"잘못된 Q&A ID입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }
}
