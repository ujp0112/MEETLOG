package service;

import dao.PointDAO;
import model.PointBalance;
import model.PointTransaction;

import java.time.LocalDate;
import java.util.List;

/**
 * 포인트 서비스
 * 포인트 적립, 사용, 환불, 만료 등의 비즈니스 로직 처리
 */
public class PointService {
    private final PointDAO pointDAO = new PointDAO();
    private static final int EXPIRE_DAYS = 365; // 포인트 만료 기간 (1년)

    /**
     * 포인트 적립
     *
     * @param userId 사용자 ID
     * @param amount 적립 포인트
     * @param referenceType 참조 타입 (RESERVATION, REVIEW 등)
     * @param referenceId 참조 ID
     * @return 성공 여부
     */
    public boolean awardPoints(int userId, int amount, String referenceType, Long referenceId) {
        return awardPoints(userId, amount, referenceType, referenceId, null);
    }

    /**
     * 포인트 적립 (메모 포함)
     *
     * @param userId 사용자 ID
     * @param amount 적립 포인트
     * @param referenceType 참조 타입
     * @param referenceId 참조 ID
     * @param memo 메모
     * @return 성공 여부
     */
    public boolean awardPoints(int userId, int amount, String referenceType, Long referenceId, String memo) {
        try {
            // 1. 잔액 초기화 (없으면)
            PointBalance balance = pointDAO.getBalance(userId);
            if (balance == null) {
                pointDAO.initBalance(userId);
            }

            // 2. 원자적 업데이트
            int rows = pointDAO.updateBalance(userId, amount);
            if (rows == 0) {
                throw new IllegalStateException("포인트 업데이트 실패");
            }

            // 3. 거래 내역 기록
            balance = pointDAO.getBalance(userId);
            PointTransaction transaction = new PointTransaction();
            transaction.setUserId(userId);
            transaction.setChangeAmount(amount);
            transaction.setType("EARN");
            transaction.setReferenceType(referenceType);
            transaction.setReferenceId(referenceId);
            transaction.setBalanceAfter(balance.getBalance());
            transaction.setExpiresAt(LocalDate.now().plusDays(EXPIRE_DAYS));
            transaction.setMemo(memo != null ? memo : "적립: " + referenceType);

            pointDAO.insertTransaction(transaction);
            return true;
        } catch (Exception e) {
            System.err.println("포인트 적립 실패: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 포인트 차감 (사용)
     *
     * @param userId 사용자 ID
     * @param amount 차감 포인트
     * @param referenceType 참조 타입
     * @param referenceId 참조 ID
     * @return 성공 여부
     */
    public boolean redeemPoints(int userId, int amount, String referenceType, Long referenceId) {
        return redeemPoints(userId, amount, referenceType, referenceId, null);
    }

    /**
     * 포인트 차감 (메모 포함)
     *
     * @param userId 사용자 ID
     * @param amount 차감 포인트
     * @param referenceType 참조 타입
     * @param referenceId 참조 ID
     * @param memo 메모
     * @return 성공 여부
     */
    public boolean redeemPoints(int userId, int amount, String referenceType, Long referenceId, String memo) {
        try {
            PointBalance balance = pointDAO.getBalance(userId);
            if (balance == null || balance.getBalance() < amount) {
                throw new IllegalArgumentException("포인트 잔액 부족");
            }

            // 원자적 차감 (잔액 부족 시 실패)
            int rows = pointDAO.redeemBalance(userId, amount, amount);
            if (rows == 0) {
                throw new IllegalStateException("포인트 잔액 부족 또는 동시성 충돌");
            }

            // 거래 내역 기록
            PointBalance newBalance = pointDAO.getBalance(userId);
            PointTransaction transaction = new PointTransaction();
            transaction.setUserId(userId);
            transaction.setChangeAmount(-amount);
            transaction.setType("REDEEM");
            transaction.setReferenceType(referenceType);
            transaction.setReferenceId(referenceId);
            transaction.setBalanceAfter(newBalance.getBalance());
            transaction.setMemo(memo != null ? memo : "사용: " + referenceType);

            pointDAO.insertTransaction(transaction);
            return true;
        } catch (Exception e) {
            System.err.println("포인트 차감 실패: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 포인트 환불
     *
     * @param userId 사용자 ID
     * @param amount 환불 포인트
     * @param referenceType 참조 타입
     * @param referenceId 참조 ID
     * @return 성공 여부
     */
    public boolean refundPoints(int userId, int amount, String referenceType, Long referenceId) {
        try {
            // 잔액 초기화 (없으면)
            PointBalance balance = pointDAO.getBalance(userId);
            if (balance == null) {
                pointDAO.initBalance(userId);
            }

            // 원자적 업데이트
            int rows = pointDAO.updateBalance(userId, amount);
            if (rows == 0) {
                throw new IllegalStateException("포인트 환불 실패");
            }

            // 거래 내역 기록 (환불은 만료일 없음)
            balance = pointDAO.getBalance(userId);
            PointTransaction transaction = new PointTransaction();
            transaction.setUserId(userId);
            transaction.setChangeAmount(amount);
            transaction.setType("REFUND");
            transaction.setReferenceType(referenceType);
            transaction.setReferenceId(referenceId);
            transaction.setBalanceAfter(balance.getBalance());
            transaction.setMemo("환불: " + referenceType);

            pointDAO.insertTransaction(transaction);
            return true;
        } catch (Exception e) {
            System.err.println("포인트 환불 실패: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 포인트 잔액 조회
     *
     * @param userId 사용자 ID
     * @return 포인트 잔액
     */
    public int getBalance(int userId) {
        PointBalance balance = pointDAO.getBalance(userId);
        return balance != null ? balance.getBalance() : 0;
    }

    /**
     * 포인트 거래 내역 조회
     *
     * @param userId 사용자 ID
     * @param type 거래 타입 필터 (null이면 전체)
     * @param page 페이지 번호 (1부터 시작)
     * @param pageSize 페이지 크기
     * @return 거래 내역 리스트
     */
    public List<PointTransaction> listTransactions(int userId, String type, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return pointDAO.findTransactions(userId, type, offset, pageSize);
    }

    /**
     * 만료 예정 포인트 조회
     *
     * @param userId 사용자 ID
     * @param days 며칠 이내 만료
     * @return 만료 예정 포인트
     */
    public int getExpiringPoints(int userId, int days) {
        LocalDate expiryDate = LocalDate.now().plusDays(days);
        return pointDAO.sumExpiringPoints(userId, expiryDate);
    }

    /**
     * 포인트 만료 처리 (배치 작업용)
     * 이 메서드는 스케줄러나 크론 작업에서 호출됩니다.
     *
     * @return 만료 처리된 거래 건수
     */
    public int expirePoints() {
        int expiredCount = 0;

        try {
            // 1. 만료일이 지난 EARN 거래를 찾기
            List<PointTransaction> expiredTransactions = pointDAO.findExpiredTransactions();

            for (PointTransaction expired : expiredTransactions) {
                try {
                    // 2. 해당 포인트를 차감
                    int userId = expired.getUserId();
                    int expiredAmount = expired.getChangeAmount(); // EARN 타입이므로 양수

                    // 잔액 확인
                    PointBalance balance = pointDAO.getBalance(userId);
                    if (balance == null || balance.getBalance() < expiredAmount) {
                        System.err.println("포인트 만료 실패 (잔액 부족): userId=" + userId + ", amount=" + expiredAmount);
                        continue; // 다음 거래로
                    }

                    // 원자적 차감
                    int rows = pointDAO.updateBalance(userId, -expiredAmount);
                    if (rows == 0) {
                        System.err.println("포인트 만료 실패 (업데이트 실패): userId=" + userId);
                        continue;
                    }

                    // 3. EXPIRE 타입의 거래 내역 생성
                    PointBalance newBalance = pointDAO.getBalance(userId);
                    PointTransaction expireTransaction = new PointTransaction();
                    expireTransaction.setUserId(userId);
                    expireTransaction.setChangeAmount(-expiredAmount);
                    expireTransaction.setType("EXPIRE");
                    expireTransaction.setReferenceType("EARN");
                    expireTransaction.setReferenceId(expired.getId() != null ? Long.valueOf(expired.getId()) : null);
                    expireTransaction.setBalanceAfter(newBalance.getBalance());
                    expireTransaction.setMemo("포인트 만료 (적립일: " + expired.getCreatedAt() + ")");

                    pointDAO.insertTransaction(expireTransaction);
                    expiredCount++;

                    System.out.println("포인트 만료 완료: userId=" + userId + ", amount=" + expiredAmount);

                } catch (Exception e) {
                    System.err.println("포인트 만료 처리 중 오류: transactionId=" + expired.getId());
                    e.printStackTrace();
                    // 다음 거래 계속 처리
                }
            }

            System.out.println("포인트 만료 배치 작업 완료: " + expiredCount + "건 처리");

        } catch (Exception e) {
            System.err.println("포인트 만료 배치 작업 실패: " + e.getMessage());
            e.printStackTrace();
        }

        return expiredCount;
    }
}
