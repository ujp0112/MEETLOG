package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import model.ReviewComment;
import model.User;
import service.ReviewCommentService;

@WebServlet("/review/addComment")
public class AddReviewCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReviewCommentService commentService = new ReviewCommentService();
    private static final Logger log = LoggerFactory.getLogger(AddReviewCommentServlet.class);
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // 1. 로그인 여부 확인
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("user");

        // 2. 폼 데이터 받기
        String reviewIdStr = request.getParameter("reviewId");
        String restaurantIdStr = request.getParameter("restaurantId"); // 리다이렉션을 위해 추가
        String content = request.getParameter("content");

        // 3. 유효성 검사
        if (reviewIdStr == null || content == null || content.trim().isEmpty()) {
            // 실패 시 원래 페이지로 돌려보냄
            response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantIdStr + "?comment_error=true");
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            
            // 4. ReviewComment 객체 생성
            ReviewComment newComment = new ReviewComment();
            newComment.setReviewId(reviewId);
            newComment.setUserId(currentUser.getId());
            newComment.setContent(content);
            // newComment.setIsOwnerReply(false); // 사장님 답글이 아니므로 false

            // 5. 서비스 호출하여 댓글 저장
            boolean success = commentService.addReviewComment(newComment);

            // 6. 성공 시 레스토랑 상세 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantIdStr);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantIdStr + "?comment_error=true");
        }
    }
}