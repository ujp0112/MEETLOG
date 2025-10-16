package service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.WithdrawalRequestDAO;
import model.WithdrawalRequest;
import util.MyBatisSqlSessionFactory;

/**
 * 출금 신청 비즈니스 로직 처리 서비스
 */
public class WithdrawalService {
    private final WithdrawalRequestDAO withdrawalDAO = new WithdrawalRequestDAO();
    private final ReservationService reservationService = new ReservationService();

    /**
     * 특정 사업자의 출금 가능한 총액 계산
     * (입금 완료된 예약금의 합계 - 이미 신청한 출금 금액)
     */
    public BigDecimal calculateAvailableAmount(int ownerId) {
        // 총 입금된 예약금
        BigDecimal totalDeposit = reservationService.getTotalDepositByOwnerId(ownerId);

        // 이미 승인된 출금 총액
        BigDecimal approvedAmount = withdrawalDAO.getTotalApprovedAmountByOwnerId(ownerId);

        // 대기 중인 출금 총액
        BigDecimal pendingAmount = getTotalPendingAmountByOwnerId(ownerId);

        // 출금 가능 금액 = 총 예약금 - 승인된 출금 - 대기 중인 출금
        return totalDeposit.subtract(approvedAmount).subtract(pendingAmount);
    }

    /**
     * 특정 사업자의 대기 중인 출금 총액
     */
    public BigDecimal getTotalPendingAmountByOwnerId(int ownerId) {
        return withdrawalDAO.getTotalPendingAmountByOwnerId(ownerId);
    }

    /**
     * 새로운 출금 신청 생성
     */
    public boolean createWithdrawalRequest(WithdrawalRequest request) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            // 출금 가능 금액 재계산
            BigDecimal availableAmount = calculateAvailableAmount(request.getOwnerId());
            request.setAvailableAmount(availableAmount);

            // 신청 금액이 출금 가능 금액보다 크면 실패
            if (request.getRequestAmount().compareTo(availableAmount) > 0) {
                return false;
            }

            // 기본 상태 설정
            request.setStatus("PENDING");

            withdrawalDAO.insert(request, session);
            session.commit();
            return true;
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }

    /**
     * 특정 사업자의 출금 신청 목록 조회
     */
    public List<WithdrawalRequest> getWithdrawalsByOwnerId(int ownerId) {
        return withdrawalDAO.findByOwnerId(ownerId);
    }

    /**
     * 특정 ID로 출금 신청 조회
     */
    public WithdrawalRequest getWithdrawalById(int id) {
        return withdrawalDAO.findById(id);
    }

    /**
     * 모든 출금 신청 조회 (관리자용)
     */
    public List<WithdrawalRequest> getAllWithdrawals() {
        return withdrawalDAO.findAll();
    }

    /**
     * 대기 중인 출금 신청만 조회 (관리자용)
     */
    public List<WithdrawalRequest> getPendingWithdrawals() {
        return withdrawalDAO.findByStatus("PENDING");
    }

    /**
     * 출금 신청 승인
     */
    public boolean approveWithdrawal(int withdrawalId, int adminId, String adminMemo) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            withdrawalDAO.updateStatus(withdrawalId, "APPROVED", adminId, adminMemo, session);
            session.commit();
            return true;
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }

    /**
     * 출금 신청 거절
     */
    public boolean rejectWithdrawal(int withdrawalId, int adminId, String adminMemo) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            withdrawalDAO.updateStatus(withdrawalId, "REJECTED", adminId, adminMemo, session);
            session.commit();
            return true;
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }

    /**
     * 출금 완료 처리
     */
    public boolean completeWithdrawal(int withdrawalId, int adminId, String adminMemo) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            withdrawalDAO.updateStatus(withdrawalId, "COMPLETED", adminId, adminMemo, session);
            session.commit();
            return true;
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }

    /**
     * 특정 사업자의 대기 중인 출금 신청 개수
     */
    public int countPendingByOwnerId(int ownerId) {
        return withdrawalDAO.countPendingByOwnerId(ownerId);
    }

    /**
     * 특정 사업자의 승인된 출금 총액
     */
    public BigDecimal getTotalApprovedAmountByOwnerId(int ownerId) {
        return withdrawalDAO.getTotalApprovedAmountByOwnerId(ownerId);
    }

    /**
     * 페이징 및 필터링된 출금 신청 목록 조회
     */
    public List<WithdrawalRequest> getWithdrawalsWithPaging(Map<String, Object> params) {
        return withdrawalDAO.findAllWithPaging(params);
    }

    /**
     * 전체 출금 신청 개수 (필터링 포함)
     */
    public int countWithdrawals(Map<String, Object> params) {
        return withdrawalDAO.countAll(params);
    }
}
