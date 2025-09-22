package controller;

import java.io.IOException;

// [수정] jakarta -> javax로 변경
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.CourseStatisticsData;
import service.CourseStatisticsService;

// [수정] 
public class CourseStatisticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // [신규] Service 계층 객체 생성
    private CourseStatisticsService statisticsService = new CourseStatisticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 관리자 인증
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }
        
        try {
            // [수정] Service를 통해 실제 DB에서 통계 데이터를 가져옴
            CourseStatisticsData statisticsData = statisticsService.getCourseStatistics();
            request.setAttribute("statisticsData", statisticsData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/course-statistics.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "통계 데이터를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}