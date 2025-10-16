package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import model.WithdrawalRequest;
import util.MyBatisSqlSessionFactory;

/**
 * 출금 신청 데이터 접근 객체
 */
public class WithdrawalRequestDAO {
    private static final String NAMESPACE = "dao.WithdrawalRequestDAO";

    /**
     * 새로운 출금 신청 생성
     */
    public int insert(WithdrawalRequest request, SqlSession session) {
        return session.insert(NAMESPACE + ".insert", request);
    }

    /**
     * ID로 출금 신청 조회
     */
    public WithdrawalRequest findById(int id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne(NAMESPACE + ".findById", id);
        }
    }

    /**
     * 특정 사업자의 모든 출금 신청 조회
     */
    public List<WithdrawalRequest> findByOwnerId(int ownerId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findByOwnerId", ownerId);
        }
    }

    /**
     * 특정 상태의 출금 신청 조회
     */
    public List<WithdrawalRequest> findByStatus(String status) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findByStatus", status);
        }
    }

    /**
     * 모든 출금 신청 조회 (관리자용, 최신순)
     */
    public List<WithdrawalRequest> findAll() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findAll");
        }
    }

    /**
     * 출금 신청 상태 업데이트
     */
    public int updateStatus(int id, String status, Integer adminId, String adminMemo, SqlSession session) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("status", status);
        params.put("adminId", adminId);
        params.put("adminMemo", adminMemo);
        return session.update(NAMESPACE + ".updateStatus", params);
    }

    /**
     * 출금 신청 삭제
     */
    public int delete(int id, SqlSession session) {
        return session.delete(NAMESPACE + ".delete", id);
    }

    /**
     * 특정 사업자의 대기 중인 출금 신청 개수 조회
     */
    public int countPendingByOwnerId(int ownerId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne(NAMESPACE + ".countPendingByOwnerId", ownerId);
            return count != null ? count : 0;
        }
    }

    /**
     * 특정 사업자의 승인된 출금 총액 조회
     */
    public java.math.BigDecimal getTotalApprovedAmountByOwnerId(int ownerId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            java.math.BigDecimal total = session.selectOne(NAMESPACE + ".getTotalApprovedAmountByOwnerId", ownerId);
            return total != null ? total : java.math.BigDecimal.ZERO;
        }
    }

    /**
     * 특정 사업자의 대기 중인 출금 총액 조회
     */
    public java.math.BigDecimal getTotalPendingAmountByOwnerId(int ownerId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            java.math.BigDecimal total = session.selectOne(NAMESPACE + ".getTotalPendingAmountByOwnerId", ownerId);
            return total != null ? total : java.math.BigDecimal.ZERO;
        }
    }

    /**
     * 페이징된 출금 신청 목록 조회 (관리자용)
     */
    public List<WithdrawalRequest> findAllWithPaging(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList(NAMESPACE + ".findAllWithPaging", params);
        }
    }

    /**
     * 전체 출금 신청 개수 조회 (필터링 포함)
     */
    public int countAll(Map<String, Object> params) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = session.selectOne(NAMESPACE + ".countAll", params);
            return count != null ? count : 0;
        }
    }
}
