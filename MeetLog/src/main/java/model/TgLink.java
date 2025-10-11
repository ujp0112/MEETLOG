package model;

import java.time.LocalDateTime;

/**
 * 텔레그램 사용자 연결 정보
 * 사용자와 텔레그램 채팅방을 매핑하고 연결 상태를 관리
 */
public class TgLink {
    private Long id;
    private int userId;
    private Long tgUserId;          // 텔레그램 사용자 ID
    private String chatId;           // 채팅방 ID (DM용)
    private String startToken;       // 온보딩 토큰
    private String state;            // PENDING, ACTIVE, BLOCKED
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 연결 상태 상수
    public static final String STATE_PENDING = "PENDING";
    public static final String STATE_ACTIVE = "ACTIVE";
    public static final String STATE_BLOCKED = "BLOCKED";

    // 기본 생성자
    public TgLink() {
        this.state = STATE_PENDING;
    }

    // 생성자 (토큰 발급용)
    public TgLink(int userId, String startToken) {
        this.userId = userId;
        this.startToken = startToken;
        this.state = STATE_PENDING;
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

    public Long getTgUserId() {
        return tgUserId;
    }

    public void setTgUserId(Long tgUserId) {
        this.tgUserId = tgUserId;
    }

    public String getChatId() {
        return chatId;
    }

    public void setChatId(String chatId) {
        this.chatId = chatId;
    }

    public String getStartToken() {
        return startToken;
    }

    public void setStartToken(String startToken) {
        this.startToken = startToken;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
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

    // 상태 체크 헬퍼 메서드
    public boolean isPending() {
        return STATE_PENDING.equals(this.state);
    }

    public boolean isActive() {
        return STATE_ACTIVE.equals(this.state);
    }

    public boolean isBlocked() {
        return STATE_BLOCKED.equals(this.state);
    }

    @Override
    public String toString() {
        return "TgLink{" +
                "id=" + id +
                ", userId=" + userId +
                ", tgUserId=" + tgUserId +
                ", chatId='" + chatId + '\'' +
                ", state='" + state + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
