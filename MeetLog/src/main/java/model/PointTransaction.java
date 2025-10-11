package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 포인트 거래 내역 모델
 */
public class PointTransaction {
    private Long id;
    private int userId;
    private int changeAmount;      // 양수: 적립, 음수: 차감
    private String type;           // EARN, REDEEM, REFUND, EXPIRE, ADMIN
    private String referenceType;  // RESERVATION, REVIEW, PAYMENT, CANCEL, MANUAL
    private Long referenceId;
    private int balanceAfter;      // 거래 후 잔액 (검증용)
    private LocalDate expiresAt;   // 만료일 (적립 시에만 설정)
    private String memo;
    private LocalDateTime createdAt;

    // 기본 생성자
    public PointTransaction() {}

    // 전체 생성자
    public PointTransaction(Long id, int userId, int changeAmount, String type,
                           String referenceType, Long referenceId, int balanceAfter,
                           LocalDate expiresAt, String memo, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.changeAmount = changeAmount;
        this.type = type;
        this.referenceType = referenceType;
        this.referenceId = referenceId;
        this.balanceAfter = balanceAfter;
        this.expiresAt = expiresAt;
        this.memo = memo;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getChangeAmount() {
        return changeAmount;
    }

    public void setChangeAmount(int changeAmount) {
        this.changeAmount = changeAmount;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(String referenceType) {
        this.referenceType = referenceType;
    }

    public Long getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Long referenceId) {
        this.referenceId = referenceId;
    }

    public int getBalanceAfter() {
        return balanceAfter;
    }

    public void setBalanceAfter(int balanceAfter) {
        this.balanceAfter = balanceAfter;
    }

    public LocalDate getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDate expiresAt) {
        this.expiresAt = expiresAt;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "PointTransaction{" +
                "id=" + id +
                ", userId=" + userId +
                ", changeAmount=" + changeAmount +
                ", type='" + type + '\'' +
                ", referenceType='" + referenceType + '\'' +
                ", referenceId=" + referenceId +
                ", balanceAfter=" + balanceAfter +
                ", expiresAt=" + expiresAt +
                ", memo='" + memo + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
