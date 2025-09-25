package model;

import java.time.LocalDateTime;

/**
 * 음식점 테이블 관리 모델 클래스
 */
public class RestaurantTable {
    public enum TableType {
        REGULAR("일반"),
        VIP("VIP"),
        PRIVATE("프라이빗"),
        BAR("바테이블");

        private final String koreanName;

        TableType(String koreanName) {
            this.koreanName = koreanName;
        }

        public String getKoreanName() {
            return koreanName;
        }
    }

    private int id;
    private int restaurantId;
    private String tableName;
    private int tableNumber;
    private int capacity;
    private TableType tableType;
    private boolean isActive;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 조인용 필드
    private String restaurantName;

    public RestaurantTable() {
        this.tableType = TableType.REGULAR;
        this.isActive = true;
    }

    public RestaurantTable(int restaurantId, String tableName, int tableNumber, int capacity) {
        this();
        this.restaurantId = restaurantId;
        this.tableName = tableName;
        this.tableNumber = tableNumber;
        this.capacity = capacity;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public int getTableNumber() {
        return tableNumber;
    }

    public void setTableNumber(int tableNumber) {
        if (tableNumber > 0 && tableNumber <= 999) {
            this.tableNumber = tableNumber;
        }
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        if (capacity > 0 && capacity <= 20) {
            this.capacity = capacity;
        }
    }

    public TableType getTableType() {
        return tableType;
    }

    public void setTableType(TableType tableType) {
        this.tableType = tableType != null ? tableType : TableType.REGULAR;
    }

    public String getTableTypeString() {
        return tableType != null ? tableType.name() : TableType.REGULAR.name();
    }

    public void setTableTypeString(String tableTypeString) {
        if (tableTypeString != null && !tableTypeString.trim().isEmpty()) {
            try {
                this.tableType = TableType.valueOf(tableTypeString.toUpperCase());
            } catch (IllegalArgumentException e) {
                this.tableType = TableType.REGULAR;
            }
        }
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    /**
     * 테이블 타입의 한글명 반환
     */
    public String getTableTypeKorean() {
        return tableType != null ? tableType.getKoreanName() : TableType.REGULAR.getKoreanName();
    }

    /**
     * 유효한 테이블 정보인지 검증
     */
    public boolean isValidTable() {
        return tableName != null && !tableName.trim().isEmpty() &&
               tableNumber > 0 && tableNumber <= 999 &&
               capacity > 0 && capacity <= 20;
    }

    /**
     * 테이블 전체 이름 반환 (테이블명 + 번호)
     */
    public String getFullTableName() {
        if (tableName != null && !tableName.trim().isEmpty()) {
            return tableName + " (" + tableNumber + "번)";
        }
        return tableNumber + "번 테이블";
    }

    @Override
    public String toString() {
        return "RestaurantTable{" +
                "id=" + id +
                ", restaurantId=" + restaurantId +
                ", tableName='" + tableName + '\'' +
                ", tableNumber=" + tableNumber +
                ", capacity=" + capacity +
                ", tableType=" + tableType +
                ", isActive=" + isActive +
                '}';
    }
}