package model;

import java.time.LocalDateTime;

/**
 * 예약 알림 모델 클래스
 */
public class ReservationNotification {

    // 알림 타입 enum
    public enum NotificationType {
        SMS("SMS"),
        EMAIL("이메일"),
        PUSH("푸시");

        private final String description;

        NotificationType(String description) {
            this.description = description;
        }

        public String getDescription() {
            return description;
        }
    }

    // 알림 상태 enum
    public enum NotificationStatus {
        PENDING("대기"),
        SENT("발송완료"),
        FAILED("실패");

        private final String description;

        NotificationStatus(String description) {
            this.description = description;
        }

        public String getDescription() {
            return description;
        }
    }

    private int id;
    private int reservationId;
    private NotificationType notificationType;
    private String recipient;
    private String message;
    private NotificationStatus status;
    private LocalDateTime sentAt;
    private LocalDateTime createdAt;

    // 조인용 필드
    private String restaurantName;
    private String customerName;
    private LocalDateTime reservationTime;

    // 기본 생성자
    public ReservationNotification() {
        this.status = NotificationStatus.PENDING;
    }

    // 생성자
    public ReservationNotification(int reservationId, NotificationType notificationType, String recipient, String message) {
        this();
        this.reservationId = reservationId;
        this.notificationType = notificationType;
        this.recipient = recipient;
        this.message = message;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public NotificationType getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(NotificationType notificationType) {
        this.notificationType = notificationType;
    }

    public String getNotificationTypeString() {
        return notificationType != null ? notificationType.name() : NotificationType.SMS.name();
    }

    public void setNotificationTypeString(String notificationTypeString) {
        if (notificationTypeString != null && !notificationTypeString.trim().isEmpty()) {
            try {
                this.notificationType = NotificationType.valueOf(notificationTypeString.toUpperCase());
            } catch (IllegalArgumentException e) {
                this.notificationType = NotificationType.SMS;
            }
        }
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public NotificationStatus getStatus() {
        return status;
    }

    public void setStatus(NotificationStatus status) {
        this.status = status;
    }

    public String getStatusString() {
        return status != null ? status.name() : NotificationStatus.PENDING.name();
    }

    public void setStatusString(String statusString) {
        if (statusString != null && !statusString.trim().isEmpty()) {
            try {
                this.status = NotificationStatus.valueOf(statusString.toUpperCase());
            } catch (IllegalArgumentException e) {
                this.status = NotificationStatus.PENDING;
            }
        }
    }

    public LocalDateTime getSentAt() {
        return sentAt;
    }

    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public LocalDateTime getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(LocalDateTime reservationTime) {
        this.reservationTime = reservationTime;
    }

    /**
     * 알림 타입의 한글명 반환
     */
    public String getNotificationTypeKorean() {
        return notificationType != null ? notificationType.getDescription() : NotificationType.SMS.getDescription();
    }

    /**
     * 알림 상태의 한글명 반환
     */
    public String getStatusKorean() {
        return status != null ? status.getDescription() : NotificationStatus.PENDING.getDescription();
    }

    /**
     * 알림 발송 성공 여부
     */
    public boolean isSuccess() {
        return status == NotificationStatus.SENT;
    }

    /**
     * 알림 발송 실패 여부
     */
    public boolean isFailed() {
        return status == NotificationStatus.FAILED;
    }

    /**
     * 알림 발송 대기 여부
     */
    public boolean isPending() {
        return status == NotificationStatus.PENDING;
    }

    /**
     * 유효한 수신자 정보인지 검증
     */
    public boolean isValidRecipient() {
        if (recipient == null || recipient.trim().isEmpty()) {
            return false;
        }

        switch (notificationType) {
            case SMS:
                // 전화번호 형식 검증 (간단한 체크)
                return recipient.matches("^01[0-9]-?[0-9]{4}-?[0-9]{4}$");
            case EMAIL:
                // 이메일 형식 검증 (간단한 체크)
                return recipient.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,}$");
            case PUSH:
                // 푸시는 사용자 ID 등으로 검증
                return recipient.length() > 0;
            default:
                return false;
        }
    }

    /**
     * 알림 발송 완료 처리
     */
    public void markAsSent() {
        this.status = NotificationStatus.SENT;
        this.sentAt = LocalDateTime.now();
    }

    /**
     * 알림 발송 실패 처리
     */
    public void markAsFailed() {
        this.status = NotificationStatus.FAILED;
    }

    @Override
    public String toString() {
        return "ReservationNotification{" +
                "id=" + id +
                ", reservationId=" + reservationId +
                ", notificationType=" + notificationType +
                ", recipient='" + recipient + '\'' +
                ", status=" + status +
                ", sentAt=" + sentAt +
                '}';
    }
}