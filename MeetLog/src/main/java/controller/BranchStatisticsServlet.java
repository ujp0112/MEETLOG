package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import service.AdminStatisticsService;
import service.BranchManagementService;
import dto.BranchStatisticsData;
import util.AdminSessionUtils;

import java.util.List;
import java.util.Map;

@WebServlet("/admin/branch-statistics")
public class BranchStatisticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final AdminStatisticsService statisticsService = new AdminStatisticsService();
    private final BranchManagementService branchService = new BranchManagementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            System.out.println("DEBUG: BranchStatisticsServlet - DB 연동 버전 실행 중");

            // 회사 목록 조회
            List<Map<String, Object>> companies = branchService.getAllCompanies();
            request.setAttribute("companies", companies);

            // 선택된 회사 ID
            String companyIdParam = request.getParameter("companyId");
            Integer selectedCompanyId = null;

            if (companyIdParam != null && !companyIdParam.isEmpty()) {
                selectedCompanyId = Integer.parseInt(companyIdParam);
                request.setAttribute("selectedCompanyId", selectedCompanyId);
            }

            // DB에서 지점 통계 데이터 조회 (회사 필터 적용)
            BranchStatisticsData statisticsData = statisticsService.getBranchStatisticsData(selectedCompanyId);

            System.out.println("DEBUG: statisticsData 생성 완료 - totalBranches=" + statisticsData.getTotalBranches());

            request.setAttribute("statisticsData", statisticsData);

            request.getRequestDispatcher("/WEB-INF/views/admin-branch-statistics.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("ERROR: Branch Statistics 오류 발생");
            e.printStackTrace();
            request.setAttribute("errorMessage", "지점 통계를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
