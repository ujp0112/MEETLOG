package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import model.User;
import model.AdminBusinessSummary;
import service.BusinessUserService;
import util.AdminSessionUtils;

public class AdminBusinessManagementServlet extends HttpServlet {

    private final BusinessUserService businessUserService = new BusinessUserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            User adminUser = AdminSessionUtils.requireAdmin(request, response);
            if (adminUser == null) {
                return;
            }

            java.util.List<AdminBusinessSummary> businesses = businessUserService.getAdminBusinessSummaries();

            long approvedCount = businesses.stream().filter(b -> "APPROVED".equalsIgnoreCase(b.getStatus())).count();
            long pendingCount = businesses.stream().filter(b -> "PENDING".equalsIgnoreCase(b.getStatus())).count();
            long suspendedCount = businesses.stream().filter(b -> "SUSPENDED".equalsIgnoreCase(b.getStatus())).count();
            long rejectedCount = businesses.stream().filter(b -> "REJECTED".equalsIgnoreCase(b.getStatus())).count();

            request.setAttribute("businesses", businesses);
            request.setAttribute("totalBusinesses", businesses.size());
            request.setAttribute("approvedBusinesses", approvedCount);
            request.setAttribute("pendingBusinesses", pendingCount);
            request.setAttribute("suspendedBusinesses", suspendedCount);
            request.setAttribute("rejectedBusinesses", rejectedCount);

            request.getRequestDispatcher("/WEB-INF/views/admin-business-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "입점 업체 목록을 불러오는 중 오류가 발생했습니다.");
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
            String businessIdParam = request.getParameter("businessId");

            if (action == null || businessIdParam == null) {
                request.setAttribute("errorMessage", "요청 정보가 올바르지 않습니다.");
                doGet(request, response);
                return;
            }

            try {
                int businessId = Integer.parseInt(businessIdParam);
                boolean updated = false;
                String message = null;

                switch (action) {
                    case "approve":
                        updated = businessUserService.updateBusinessStatus(businessId, "APPROVED");
                        message = "입점이 승인되었습니다.";
                        break;
                    case "reject":
                        updated = businessUserService.updateBusinessStatus(businessId, "REJECTED");
                        message = "입점이 거부되었습니다.";
                        break;
                    case "suspend":
                        updated = businessUserService.updateBusinessStatus(businessId, "SUSPENDED");
                        message = "업체가 정지되었습니다.";
                        break;
                    case "reapprove":
                        updated = businessUserService.updateBusinessStatus(businessId, "APPROVED");
                        message = "업체가 재승인되었습니다.";
                        break;
                    default:
                        request.setAttribute("errorMessage", "알 수 없는 작업입니다.");
                        doGet(request, response);
                        return;
                }

                if (updated) {
                    request.setAttribute("successMessage", message);
                } else {
                    request.setAttribute("errorMessage", "상태 변경에 실패했습니다.");
                }
            } catch (NumberFormatException ex) {
                request.setAttribute("errorMessage", "잘못된 업체 ID입니다.");
            }

            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "업체 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }


}
