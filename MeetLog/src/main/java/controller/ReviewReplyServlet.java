package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Restaurant; // [추가] Restaurant 모델 임포트
import model.User;
import service.RestaurantService; // [추가] Restaurant 서비스 임포트
import service.ReviewService;

@WebServlet("/review/reply")
public class ReviewReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReviewService reviewService = new ReviewService();
    private final RestaurantService restaurantService = new RestaurantService(); // [추가]

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false); // 세션이 없으면 새로 만들지 않음

        // 1. 로그인 여부 확인
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("user");

        // 2. 폼 데이터 받기
        String reviewIdStr = request.getParameter("reviewId");
        String restaurantIdStr = request.getParameter("restaurantId");
        String replyContent = request.getParameter("replyContent");
        
        // 2-1. 데이터 유효성 검사
        if (reviewIdStr == null || restaurantIdStr == null || replyContent == null || replyContent.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantIdStr + "?reply_error=invalid_data");
            return;
        }
        
        int reviewId = Integer.parseInt(reviewIdStr);
        int restaurantId = Integer.parseInt(restaurantIdStr);

        try {
            // 3. [보안 강화] 현재 사용자가 정말 해당 가게의 주인인지 서버에서 직접 확인
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant == null || restaurant.getOwnerId() != currentUser.getId()) {
                // 권한이 없는 경우, 에러 처리 또는 메인으로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/?error=auth");
                return;
            }

            // 4. 서비스 호출하여 답글 저장 (수정된 메소드 호출)
            boolean isSuccess = reviewService.addOwnerReply(reviewId, replyContent);
            
            // 5. 결과에 따라 리다이렉트
            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId + "?reply_success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId + "?reply_error=true");
            }

        } catch (Exception e) {
            // 6. 예외 발생 시 에러 처리
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/restaurant/detail/" + restaurantId + "?reply_error=exception");
        }
    }
}