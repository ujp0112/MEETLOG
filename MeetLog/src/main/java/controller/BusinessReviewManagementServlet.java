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
import model.Review;
import model.ReviewComment;
import service.RestaurantService;
import service.ReviewService;
import service.ReviewCommentService;
import util.MyBatisSqlSessionFactory;

@WebServlet("/business/review-management")
public class BusinessReviewManagementServlet extends HttpServlet {
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
            
            // sqlSession = MyBatisSqlSessionFactory.getSqlSession();
            
            // 비즈니스 사용자의 음식점 목록 가져오기
            RestaurantService restaurantService = new RestaurantService();
            List<Restaurant> myRestaurants = restaurantService.getRestaurantsByOwnerId(user.getId());
            
                   // 최근 리뷰 가져오기
                   ReviewService reviewService = new ReviewService();
                   List<Review> reviews = reviewService.getRecentReviewsByOwnerId(user.getId(), 20);
                   
                   // 리뷰 통계 가져오기 (임시로 주석 처리)
                   // ReviewStatisticsService statisticsService = new ReviewStatisticsService();
                   // model.ReviewStatistics statistics = statisticsService.getReviewStatisticsByOwnerId(user.getId());
                   
                   // 각 리뷰의 답글 가져오기
                   ReviewCommentService commentService = new ReviewCommentService();
                   for (Review review : reviews) {
                       List<ReviewComment> comments = commentService.getCommentsByReviewId(review.getId());
                       review.setComments(comments);
                   }
                   
                   request.setAttribute("myRestaurants", myRestaurants);
                   request.setAttribute("reviews", reviews);
                   // request.setAttribute("statistics", statistics);
            request.getRequestDispatcher("/WEB-INF/views/business-review-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 관리 페이지를 불러오는 중 오류가 발생했습니다.");
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
            if ("addReply".equals(action)) {
                System.out.println("DEBUG - addReply 처리 시작");
                handleAddReply(request, response, user);
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

    private void handleAddReply(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String content = request.getParameter("content");

            if (content == null || content.trim().isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"답글 내용을 입력해주세요.\"}");
                return;
            }

            ReviewComment comment = new ReviewComment();
            comment.setReviewId(reviewId);
            comment.setUserId(user.getId());
            comment.setAuthor(user.getNickname()); // 사용자 닉네임 설정
            comment.setContent(content.trim());
            comment.setIsOwnerReply(true); // 사장님 답글로 설정
            comment.setResolved(false); // 기본값: 미해결

            ReviewCommentService commentService = new ReviewCommentService();
            boolean success = commentService.addReviewComment(comment);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"답글이 등록되었습니다.\", \"commentId\": " + comment.getId() + "}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"답글 등록에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"잘못된 리뷰 ID입니다.\"}");
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
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            boolean isResolved = Boolean.parseBoolean(request.getParameter("isResolved"));

            ReviewCommentService commentService = new ReviewCommentService();
            boolean success = commentService.updateResolvedStatus(commentId, isResolved);

            if (success) {
                String message = isResolved ? "해결 완료로 표시되었습니다." : "미해결로 표시되었습니다.";
                response.getWriter().write("{\"success\": true, \"message\": \"" + message + "\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"상태 변경에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"잘못된 댓글 ID입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }
}