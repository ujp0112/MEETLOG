package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.CourseStatisticsData;
import service.CourseStatisticsService;
import util.AdminSessionUtils;

@WebServlet("/admin/course-statistics")
public class CourseStatisticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // [신규] Service 계층 객체 생성
    private CourseStatisticsService statisticsService = new CourseStatisticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            System.out.println("DEBUG: CourseStatisticsServlet - DB 연동 버전 실행 중");

            // Service를 통해 실제 DB에서 통계 데이터를 가져옴
            CourseStatisticsData statisticsData = statisticsService.getCourseStatistics();

            System.out.println("DEBUG: statisticsData 생성 완료 - totalCourses=" + statisticsData.getTotalCourses());

            request.setAttribute("statisticsData", statisticsData);

            request.getRequestDispatcher("/WEB-INF/views/admin-course-statistics.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("ERROR: Course Statistics 오류 발생");
            e.printStackTrace();
            request.setAttribute("errorMessage", "코스 통계를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}