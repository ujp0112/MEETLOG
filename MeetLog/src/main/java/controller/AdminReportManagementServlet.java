package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.ReportDAO;
import model.Report;
import model.User;
import util.AdminSessionUtils;

public class AdminReportManagementServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User adminUser = AdminSessionUtils.requireAdmin(request, response);
            if (adminUser == null) {
                return;
            }

            String statusFilter = request.getParameter("status");
            List<Report> reports;

            if (statusFilter != null && !statusFilter.isEmpty()) {
                reports = reportDAO.selectReportsByStatus(statusFilter);
            } else {
                reports = reportDAO.selectAllReports();
            }

            Map<String, Integer> statistics = reportDAO.getReportStatistics();

            request.setAttribute("reports", reports);
            request.setAttribute("statistics", statistics);
            request.setAttribute("currentStatus", statusFilter);

            request.getRequestDispatcher("/WEB-INF/views/admin-report-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "신고 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            User adminUser = AdminSessionUtils.requireAdmin(request, response);
            if (adminUser == null) {
                return;
            }

            String action = request.getParameter("action");
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            String adminNote = request.getParameter("adminNote");

            String newStatus = null;
            String successMessage = null;

            if ("process".equals(action)) {
                newStatus = "PROCESSED";
                successMessage = "신고가 처리되었습니다.";
            } else if ("dismiss".equals(action)) {
                newStatus = "DISMISSED";
                successMessage = "신고가 기각되었습니다.";
            }

            if (newStatus != null) {
                reportDAO.updateReportStatus(reportId, newStatus, adminUser.getId(), adminNote);
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", successMessage);
            }

            response.sendRedirect(request.getContextPath() + "/admin/report-management");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "신고 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
}
