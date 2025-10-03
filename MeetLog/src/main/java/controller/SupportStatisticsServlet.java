package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import service.AdminStatisticsService;
import dto.SupportDashboardData;
import util.AdminSessionUtils;

@WebServlet("/admin/support-dashboard")
public class SupportStatisticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final AdminStatisticsService statisticsService = new AdminStatisticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 관리자 인증 체크
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            System.out.println("DEBUG: SupportStatisticsServlet - 새 버전 실행 중");

            // DB에서 고객 지원 통계 데이터 조회
            SupportDashboardData dashboardData = statisticsService.getSupportDashboardData();

            System.out.println("DEBUG: dashboardData 생성 완료 - totalInquiries=" + dashboardData.getTotalInquiries());

            request.setAttribute("dashboardData", dashboardData);

            request.getRequestDispatcher("/WEB-INF/views/admin-support-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("ERROR: Support Dashboard 오류 발생");
            e.printStackTrace();
            request.setAttribute("errorMessage", "고객 지원 통계를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
