package erpController;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import service.BranchManagementService;
import dto.BranchManagement;
import util.AdminSessionUtils;

@WebServlet("/admin/branch-management")
public class BranchManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BranchManagementService branchService = new BranchManagementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            System.out.println("DEBUG: BranchManagementServlet - DB 연동 버전 실행 중");

            // 회사 목록 조회
            List<Map<String, Object>> companies = branchService.getAllCompanies();
            request.setAttribute("companies", companies);

            // 선택된 회사 ID
            String companyIdParam = request.getParameter("companyId");
            Integer selectedCompanyId = null;

            if (companyIdParam != null && !companyIdParam.isEmpty()) {
                selectedCompanyId = Integer.parseInt(companyIdParam);
            }

            // 지점 목록 조회
            List<BranchManagement> branches;
            if (selectedCompanyId != null) {
                branches = branchService.getBranchesByCompanyId(selectedCompanyId);
                request.setAttribute("selectedCompanyId", selectedCompanyId);
            } else {
                branches = branchService.getAllBranches();
            }

            request.setAttribute("branches", branches);

            System.out.println("DEBUG: 지점 목록 조회 완료 - 총 " + branches.size() + "개");

            request.getRequestDispatcher("/WEB-INF/views/admin-branch-management.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("ERROR: Branch Management 오류 발생");
            e.printStackTrace();
            request.setAttribute("errorMessage", "지점 목록을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }

            String action = request.getParameter("action");
            String companyIdParam = request.getParameter("companyId");

            if ("add".equals(action)) {
                // 지점 추가
                BranchManagement branch = new BranchManagement();
                branch.setCompanyId(Integer.parseInt(request.getParameter("companyId")));
                branch.setBranchName(request.getParameter("branchName"));
                branch.setAddress(request.getParameter("address"));
                branch.setPhone(request.getParameter("phone"));
                branch.setManagerName(request.getParameter("managerName"));
                branch.setStatus("INACTIVE"); // 기본값: 준비중

                if (branchService.insertBranch(branch)) {
                    request.setAttribute("successMessage", "지점이 추가되었습니다.");
                } else {
                    request.setAttribute("errorMessage", "지점 추가에 실패했습니다.");
                }

            } else if ("update".equals(action)) {
                // 지점 수정
                BranchManagement branch = new BranchManagement();
                branch.setBranchId(Long.parseLong(request.getParameter("branchId")));
                branch.setBranchName(request.getParameter("branchName"));
                branch.setAddress(request.getParameter("address"));
                branch.setPhone(request.getParameter("phone"));
                branch.setManagerName(request.getParameter("managerName"));

                if (branchService.updateBranch(branch)) {
                    request.setAttribute("successMessage", "지점이 수정되었습니다.");
                } else {
                    request.setAttribute("errorMessage", "지점 수정에 실패했습니다.");
                }

            } else if ("activate".equals(action)) {
                // 지점 활성화 (운영 시작)
                long branchId = Long.parseLong(request.getParameter("branchId"));
                if (branchService.activateBranch(branchId)) {
                    request.setAttribute("successMessage", "지점이 운영 시작되었습니다.");
                } else {
                    request.setAttribute("errorMessage", "지점 활성화에 실패했습니다.");
                }

            } else if ("deactivate".equals(action)) {
                // 지점 비활성화 (휴업)
                long branchId = Long.parseLong(request.getParameter("branchId"));
                if (branchService.deactivateBranch(branchId)) {
                    request.setAttribute("successMessage", "지점이 휴업 처리되었습니다.");
                } else {
                    request.setAttribute("errorMessage", "지점 휴업 처리에 실패했습니다.");
                }

            } else if ("delete".equals(action)) {
                // 지점 삭제
                long branchId = Long.parseLong(request.getParameter("branchId"));
                if (branchService.deleteBranch(branchId)) {
                    request.setAttribute("successMessage", "지점이 삭제되었습니다.");
                } else {
                    request.setAttribute("errorMessage", "지점 삭제에 실패했습니다.");
                }
            }

            // Redirect to avoid duplicate form submission
            String redirectUrl = request.getContextPath() + "/admin/branch-management";
            if (companyIdParam != null && !companyIdParam.isEmpty()) {
                redirectUrl += "?companyId=" + companyIdParam;
            }
            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            System.err.println("ERROR: Branch Management POST 처리 오류");
            e.printStackTrace();
            request.setAttribute("errorMessage", "지점 관리 중 오류가 발생했습니다.");
            doGet(request, response);
        }
    }
}
