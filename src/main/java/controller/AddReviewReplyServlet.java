package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import model.ReviewComment;
import service.ReviewCommentService;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;

@WebServlet("/business/review/add-reply")
public class AddReviewReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        SqlSession sqlSession = null;
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || !"BUSINESS".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // 폼 데이터 받기
            String reviewIdStr = request.getParameter("reviewId");
            String content = request.getParameter("content");
            
            // 유효성 검사
            if (reviewIdStr == null || reviewIdStr.trim().isEmpty() ||
                content == null || content.trim().isEmpty()) {
                request.setAttribute("errorMessage", "필수 정보를 모두 입력해주세요.");
                request.getRequestDispatcher("/WEB-INF/views/business/review-management.jsp").forward(request, response);
                return;
            }
            
            try {
                int reviewId = Integer.parseInt(reviewIdStr);
                
                // 리뷰 답글 객체 생성
                ReviewComment reply = new ReviewComment();
                reply.setReviewId(reviewId);
                reply.setUserId(user.getId());
                reply.setAuthor(user.getNickname() != null ? user.getNickname() : user.getName());
                reply.setContent(content.trim());
                reply.setIsOwnerReply(true); // 사업자 답글 표시
                
                sqlSession = MyBatisSqlSessionFactory.getSqlSession();
                ReviewCommentService reviewCommentService = new ReviewCommentService();
                
                // 리뷰 답글 저장
                boolean success = reviewCommentService.addReviewComment(reply, sqlSession);
                
                if (success) {
                    sqlSession.commit();
                    response.sendRedirect(request.getContextPath() + "/business/review-management?success=reply_added");
                } else {
                    sqlSession.rollback();
                    request.setAttribute("errorMessage", "리뷰 답글 추가에 실패했습니다.");
                    request.getRequestDispatcher("/WEB-INF/views/business/review-management.jsp").forward(request, response);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "리뷰 ID는 숫자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/views/business/review-management.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            request.setAttribute("errorMessage", "리뷰 답글 추가 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
}
