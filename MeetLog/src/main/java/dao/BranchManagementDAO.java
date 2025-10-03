package dao;

import dto.BranchManagement;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BranchManagementDAO {

    private static final String MAPPER = "mapper.BranchManagementMapper";

    // 모든 회사 조회
    public List<Map<String, Object>> getAllCompanies() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getAllCompanies");
        }
    }

    // 회사별 지점 목록 조회
    public List<BranchManagement> getBranchesByCompanyId(int companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getBranchesByCompanyId", companyId);
        }
    }

    // 모든 지점 조회
    public List<BranchManagement> getAllBranches() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(MAPPER + ".getAllBranches");
        }
    }

    // 지점 ID로 조회
    public BranchManagement getBranchById(long branchId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(MAPPER + ".getBranchById", branchId);
        }
    }

    // 지점 추가
    public int insertBranch(BranchManagement branch) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.insert(MAPPER + ".insertBranch", branch);
            session.commit();
            return result;
        }
    }

    // 지점 수정
    public int updateBranch(BranchManagement branch) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.update(MAPPER + ".updateBranch", branch);
            session.commit();
            return result;
        }
    }

    // 지점 상태 변경
    public int updateBranchStatus(long branchId, String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchId", branchId);
            params.put("status", status);
            int result = session.update(MAPPER + ".updateBranchStatus", params);
            session.commit();
            return result;
        }
    }

    // 지점 삭제
    public int deleteBranch(long branchId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = session.delete(MAPPER + ".deleteBranch", branchId);
            session.commit();
            return result;
        }
    }
}
