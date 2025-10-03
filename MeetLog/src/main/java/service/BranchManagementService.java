package service;

import dao.BranchManagementDAO;
import dto.BranchManagement;

import java.util.List;
import java.util.Map;

public class BranchManagementService {

    private final BranchManagementDAO dao = new BranchManagementDAO();

    // 모든 회사 조회
    public List<Map<String, Object>> getAllCompanies() {
        return dao.getAllCompanies();
    }

    // 회사별 지점 목록 조회
    public List<BranchManagement> getBranchesByCompanyId(int companyId) {
        return dao.getBranchesByCompanyId(companyId);
    }

    // 모든 지점 조회
    public List<BranchManagement> getAllBranches() {
        return dao.getAllBranches();
    }

    // 지점 ID로 조회
    public BranchManagement getBranchById(long branchId) {
        return dao.getBranchById(branchId);
    }

    // 지점 추가
    public boolean insertBranch(BranchManagement branch) {
        // 기본값 설정
        if (branch.getStatus() == null || branch.getStatus().isEmpty()) {
            branch.setStatus("INACTIVE"); // 기본적으로 준비중 상태로 추가
        }
        return dao.insertBranch(branch) > 0;
    }

    // 지점 수정
    public boolean updateBranch(BranchManagement branch) {
        return dao.updateBranch(branch) > 0;
    }

    // 지점 활성화 (운영 시작)
    public boolean activateBranch(long branchId) {
        return dao.updateBranchStatus(branchId, "ACTIVE") > 0;
    }

    // 지점 비활성화 (휴업)
    public boolean deactivateBranch(long branchId) {
        return dao.updateBranchStatus(branchId, "INACTIVE") > 0;
    }

    // 지점 삭제
    public boolean deleteBranch(long branchId) {
        return dao.deleteBranch(branchId) > 0;
    }
}
