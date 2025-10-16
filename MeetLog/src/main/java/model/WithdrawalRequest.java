package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 출금 신청 정보 모델
 */
public class WithdrawalRequest {
    private int id;
    private int ownerId;
    private Integer restaurantId;
    private BigDecimal requestAmount;
    private BigDecimal availableAmount;
    private String bankName;
    private String accountNumber;
    private String accountHolder;
    private String status; // PENDING, APPROVED, REJECTED, COMPLETED
    private Integer adminId;
    private String adminMemo;
    private LocalDateTime processedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 조인된 정보
    private String ownerName;
    private String ownerEmail;
    private String restaurantName;
    private String adminName;

    // 기본 생성자
    public WithdrawalRequest() {}

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public BigDecimal getRequestAmount() {
        return requestAmount;
    }

    public void setRequestAmount(BigDecimal requestAmount) {
        this.requestAmount = requestAmount;
    }

    public BigDecimal getAvailableAmount() {
        return availableAmount;
    }

    public void setAvailableAmount(BigDecimal availableAmount) {
        this.availableAmount = availableAmount;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getAccountHolder() {
        return accountHolder;
    }

    public void setAccountHolder(String accountHolder) {
        this.accountHolder = accountHolder;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAdminId() {
        return adminId;
    }

    public void setAdminId(Integer adminId) {
        this.adminId = adminId;
    }

    public String getAdminMemo() {
        return adminMemo;
    }

    public void setAdminMemo(String adminMemo) {
        this.adminMemo = adminMemo;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getOwnerEmail() {
        return ownerEmail;
    }

    public void setOwnerEmail(String ownerEmail) {
        this.ownerEmail = ownerEmail;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    /**
     * 신청 날짜를 포맷된 문자열로 반환 (yyyy-MM-dd HH:mm)
     */
    public String getFormattedCreatedAt() {
        if (createdAt == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return createdAt.format(formatter);
    }

    /**
     * 처리 날짜를 포맷된 문자열로 반환 (yyyy-MM-dd HH:mm)
     */
    public String getFormattedProcessedAt() {
        if (processedAt == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return processedAt.format(formatter);
    }

    /**
     * 수정 날짜를 포맷된 문자열로 반환 (yyyy-MM-dd HH:mm)
     */
    public String getFormattedUpdatedAt() {
        if (updatedAt == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return updatedAt.format(formatter);
    }

    /**
     * 상태를 한글로 반환
     */
    public String getStatusInKorean() {
        switch (status) {
            case "PENDING":
                return "대기중";
            case "APPROVED":
                return "승인됨";
            case "REJECTED":
                return "거절됨";
            case "COMPLETED":
                return "완료됨";
            default:
                return status;
        }
    }

    /**
     * 금액을 포맷된 문자열로 반환 (천단위 콤마)
     */
    public String getFormattedRequestAmount() {
        if (requestAmount == null) {
            return "0";
        }
        return String.format("%,d", requestAmount.longValue());
    }

    /**
     * 출금 가능 금액을 포맷된 문자열로 반환 (천단위 콤마)
     */
    public String getFormattedAvailableAmount() {
        if (availableAmount == null) {
            return "0";
        }
        return String.format("%,d", availableAmount.longValue());
    }
}
