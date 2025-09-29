package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import model.Review;
import service.ReviewService;

@WebServlet("/admin/review-management")
public class ReviewManagementServlet extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            
            // 실제 DB에서 모든 리뷰 조회 (관리자용)
            List<Review> reviews = reviewService.findAll();
            System.out.println("DEBUG: 관리자 리뷰 관리 - 조회된 리뷰 수: " + reviews.size());
            request.setAttribute("reviews", reviews);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-review-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "리뷰 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    // 임시데이터 생성 메서드 제거 - 이제 실제 DB에서 조회
}
