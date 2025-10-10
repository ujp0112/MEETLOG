package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import service.AdminStatisticsService;
import dto.StatisticsDashboardData;
import util.AdminSessionUtils;

@WebServlet("/admin/statistics-dashboard")
public class StatisticsDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final AdminStatisticsService statisticsService = new AdminStatisticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            System.out.println("DEBUG: StatisticsDashboardServlet - DB 연동 버전 실행 중");

            // DB에서 통계 데이터 조회
            StatisticsDashboardData statisticsData = statisticsService.getStatisticsDashboardData();

            System.out.println("DEBUG: statisticsData 생성 완료 - totalUsers=" + statisticsData.getTotalUsers());

            request.setAttribute("statisticsData", statisticsData);
            
            System.out.println("))))))))))))))))))))))))))))"+statisticsData);

            request.getRequestDispatcher("/WEB-INF/views/admin-statistics-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("ERROR: Statistics Dashboard 오류 발생");
            e.printStackTrace();
            request.setAttribute("errorMessage", "통계 대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
