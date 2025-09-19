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

@WebServlet("/mypage/*")
public class MypageServlet extends HttpServlet {
    
    private UserService userService = new UserService();
    private ReservationService reservationService = new ReservationService();
    private ReviewService reviewService = new ReviewService();
    private ColumnService columnService = new ColumnService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setAttribute("user", user);
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleMyPageMain(request, response, user.getId()); 
            } else if (pathInfo.equals("/reservations")) {
                handleMyReservations(request, response, user.getId()); 
            } else if (pathInfo.equals("/reviews")) {
                handleMyReviews(request, response, user.getId()); 
            } else if (pathInfo.equals("/columns")) {
                handleMyColumns(request, response, user.getId()); 
            } else if (pathInfo.equals("/settings")) {
                handleSettings(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "페이지 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (pathInfo != null && pathInfo.equals("/settings")) {
            String action = request.getParameter("action");

            if ("updateProfile".equals(action)) {
                String nickname = request.getParameter("nickname");
                String profileImage = request.getParameter("profileImage");
                boolean success = userService.updateProfile(user.getId(), nickname, profileImage);
                
                if (success) {
                    request.setAttribute("successMessage", "프로필이 성공적으로 수정되었습니다.");
                    user.setNickname(nickname);
                    user.setProfileImage(profileImage);
                    session.setAttribute("user", user);
                } else {
                    request.setAttribute("errorMessage", "프로필 수정 중 오류가 발생했습니다.");
                }
                
            } else if ("changePassword".equals(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                
                if (!newPassword.equals(confirmPassword)) {
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
    
    private void handleMyPageMain(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        List<Reservation> recentReservations = reservationService.getRecentReservations(userId, 3);
        List<Review> recentReviews = reviewService.getRecentReviews(userId, 3);
        List<Column> recentColumns = columnService.getRecentColumns(userId, 3);
        
        request.setAttribute("recentReservations", recentReservations);
        request.setAttribute("recentReviews", recentReviews);
        request.setAttribute("recentColumns", recentColumns);
        
        request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);
    }
    
    private void handleMyReservations(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        List<Reservation> reservations = reservationService.getReservationsByUserId(userId);
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("/WEB-INF/views/my-reservations.jsp").forward(request, response);
    }
    
    private void handleMyReviews(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        List<Review> reviews = reviewService.getReviewsByUserId(userId);
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/views/my-reviews.jsp").forward(request, response);
    }
    
    private void handleMyColumns(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        List<Column> columns = columnService.getColumnsByUserId(userId);
        request.setAttribute("columns", columns);
        request.getRequestDispatcher("/WEB-INF/views/my-columns.jsp").forward(request, response);
    }
    
    private void handleSettings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(request, response);
    }
}