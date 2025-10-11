package model;

import java.time.LocalDateTime;

/**
 * 텔레그램 메시지 발송 로그
 * 디버깅 및 통계 목적으로 사용
 */
public class TelegramMessageLog {
    private Long id;
    private Long tgLinkId;
    private String chatId;
    private String messageType;      // RESERVATION_CONFIRM, PAYMENT_SUCCESS 등
    private String messageText;
    private String referenceType;    // reservation, payment 등
    private Long referenceId;
    private String status;           // SENT, FAILED, BLOCKED
    private String errorMessage;
    private LocalDateTime sentAt;

    // 메시지 타입 상수
    public static final String TYPE_RESERVATION_CONFIRM = "RESERVATION_CONFIRM";
    public static final String TYPE_RESERVATION_CANCEL = "RESERVATION_CANCEL";
    public static final String TYPE_PAYMENT_SUCCESS = "PAYMENT_SUCCESS";
    public static final String TYPE_PAYMENT_FAIL = "PAYMENT_FAIL";
    public static final String TYPE_WELCOME = "WELCOME";
    public static final String TYPE_CUSTOM = "CUSTOM";

    // 발송 상태 상수
    public static final String STATUS_SENT = "SENT";
    public static final String STATUS_FAILED = "FAILED";
    public static final String STATUS_BLOCKED = "BLOCKED";

    // 기본 생성자
    public TelegramMessageLog() {
        this.status = STATUS_SENT;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getTgLinkId() {
        return tgLinkId;
    }

    public void setTgLinkId(Long tgLinkId) {
        this.tgLinkId = tgLinkId;
    }

    public String getChatId() {
        return chatId;
    }

    public void setChatId(String chatId) {
        this.chatId = chatId;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public String getMessageText() {
        return messageText;
    }

    public void setMessageText(String messageText) {
        this.messageText = messageText;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public LocalDateTime getSentAt() {
        return sentAt;
    }

    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }

    @Override
    public String toString() {
        return "TelegramMessageLog{" +
                "id=" + id +
                ", chatId='" + chatId + '\'' +
                ", messageType='" + messageType + '\'' +
                ", status='" + status + '\'' +
                ", sentAt=" + sentAt +
                '}';
    }
}
