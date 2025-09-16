package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.AdminCourseReview;
import model.User;
import service.CourseReviewManagementService; // Service 계층 사용

public class CourseReviewManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CourseReviewManagementService reviewService = new CourseReviewManagementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }
        
        List<AdminCourseReview> reviews = reviewService.getAllReviewsForAdmin();
        request.setAttribute("reviews", reviews);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/course-review-management.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
            return;
        }
        
        String action = request.getParameter("action");
        int reviewId = Integer.parseInt(request.getParameter("id"));
        
        try {
            switch (action) {
                case "respond":
                    String responseContent = request.getParameter("responseContent");
                    reviewService.addOrUpdateResponse(reviewId, responseContent);
                    request.setAttribute("successMessage", "리뷰에 대한 답변이 등록되었습니다.");
                    break;
                case "delete":
                    reviewService.deleteReview(reviewId);
                    request.setAttribute("successMessage", "리뷰가 삭제되었습니다.");
                    break;
                default:
                    request.setAttribute("errorMessage", "알 수 없는 요청입니다.");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "작업 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}