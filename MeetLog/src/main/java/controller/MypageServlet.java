package controller;

import java.io.IOException;
import java.util.List;
import model.Column;
import model.Reservation;
import model.Review;
import model.User;
import service.ColumnService;
import service.ReservationService;
import service.ReviewService;
import service.UserService; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//@WebServlet("/mypage/*")
public class MypageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();
    private final ReservationService reservationService = new ReservationService();
    private final ReviewService reviewService = new ReviewService();
    private final ColumnService columnService = new ColumnService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirectUrl=" + request.getRequestURI());
            return;
        }
        
        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        
        try {
            String forwardPath = null;
            if (pathInfo == null || pathInfo.equals("/")) {
                handleMyPageMain(request, user.getId()); 
                forwardPath = "/WEB-INF/views/mypage.jsp";
            } else {
                switch (pathInfo) {
                    case "/reservations":
                        handleMyReservations(request, user.getId()); 
                        forwardPath = "/WEB-INF/views/my-reservations.jsp";
                        break;
                    case "/reviews":
                        handleMyReviews(request, user.getId()); 
                        forwardPath = "/WEB-INF/views/my-reviews.jsp";
                        break;
                    case "/columns":
                        handleMyColumns(request, user.getId()); 
                        forwardPath = "/WEB-INF/views/my-columns.jsp";
                        break;
                    case "/settings":
                        forwardPath = "/WEB-INF/views/settings.jsp";
                        break;
                    default:
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                        return;
                }
            }
            request.getRequestDispatcher(forwardPath).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "페이지 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");

        if ("/settings".equals(pathInfo)) {
            String action = request.getParameter("action");

            if ("updateProfile".equals(action)) {
                String nickname = request.getParameter("nickname");
                String profileImage = request.getParameter("profileImage"); // 파일 업로드 로직이 필요하다면 별도 구현 필요
                boolean success = userService.updateProfile(user.getId(), nickname, profileImage);
                
                if (success) {
                    request.setAttribute("successMessage", "프로필이 성공적으로 수정되었습니다.");
                    // 세션의 user 객체도 업데이트
                    user.setNickname(nickname);
                    if (profileImage != null) user.setProfileImage(profileImage);
                    session.setAttribute("user", user);
                } else {
                    request.setAttribute("errorMessage", "프로필 수정 중 오류가 발생했습니다.");
                }
                
            } else if ("changePassword".equals(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                
                if (newPassword == null || !newPassword.equals(confirmPassword)) {
                    request.setAttribute("errorMessage", "새 비밀번호가 일치하지 않습니다.");
                } else {
                    boolean success = userService.changePassword(user.getId(), currentPassword, newPassword);
                    if (success) {
                        request.setAttribute("successMessage", "비밀번호가 성공적으로 변경되었습니다.");
                    } else {
                        request.setAttribute("errorMessage", "현재 비밀번호가 올바르지 않거나 오류가 발생했습니다.");
                    }
                }
            }
            request.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleMyPageMain(HttpServletRequest request, int userId) {
        request.setAttribute("recentReservations", reservationService.getRecentReservations(userId, 3));
        request.setAttribute("recentReviews", reviewService.getRecentReviews(userId, 3));
        request.setAttribute("recentColumns", columnService.getRecentColumns(userId, 3));
    }
    
    private void handleMyReservations(HttpServletRequest request, int userId) {
        request.setAttribute("reservations", reservationService.getReservationsByUserId(userId));
    }
    
    private void handleMyReviews(HttpServletRequest request, int userId) {
        request.setAttribute("reviews", reviewService.getReviewsByUserId(userId));
    }
    
    private void handleMyColumns(HttpServletRequest request, int userId) {
        request.setAttribute("columns", columnService.getColumnsByUserId(userId));
    }
}