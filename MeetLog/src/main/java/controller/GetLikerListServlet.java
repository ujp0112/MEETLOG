package controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import model.User;
import service.FollowService;
import service.ReviewLikeService;

@WebServlet("/review/getLikers/*")
public class GetLikerListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReviewLikeService reviewLikeService = new ReviewLikeService();
    private final FollowService followService = new FollowService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                throw new IllegalArgumentException("리뷰 ID가 필요합니다.");
            }
            int reviewId = Integer.parseInt(pathInfo.substring(1));

            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

            List<User> likerList = reviewLikeService.getUsersWhoLikedReview(reviewId);
            
            // [안정성 강화] 서비스에서 null을 반환할 경우를 대비해 빈 리스트로 처리
            if (likerList == null) {
                likerList = Collections.emptyList();
            }

            if (currentUser != null) {
                for (User liker : likerList) {
                    boolean isFollowing = followService.isFollowing(currentUser.getId(), liker.getId());
                    // User 모델에 isFollowing 필드와 setIsFollowing 메서드가 있어야 합니다.
                    liker.setIsFollowing(isFollowing);
                }
            }

            response.getWriter().write(gson.toJson(likerList));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"잘못된 리뷰 ID 형식입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"좋아요 목록을 불러오는 중 오류가 발생했습니다.\"}");
        }
    }
}