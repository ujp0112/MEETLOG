package model;

import java.util.List;

/**
 * 사용자 저장소(찜 폴더) 모델 클래스
 */
public class UserStorage {
    private int storageId;
    private int userId;
    private String name;
    private String colorClass;
    private int itemCount; // 저장된 아이템 개수
    private List<UserStorageItem> items; // 저장된 아이템들

    public UserStorage() {
    }

    public UserStorage(int userId, String name, String colorClass) {
        this.userId = userId;
        this.name = name;
        this.colorClass = colorClass;
    }

    // Getters and Setters
    public int getStorageId() {
        return storageId;
    }

    public void setStorageId(int storageId) {
        this.storageId = storageId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColorClass() {
        return colorClass;
    }

    public void setColorClass(String colorClass) {
        this.colorClass = colorClass;
    }

    public int getItemCount() {
        return itemCount;
    }

    public void setItemCount(int itemCount) {
        this.itemCount = itemCount;
    }

    public List<UserStorageItem> getItems() {
        return items;
    }

    public void setItems(List<UserStorageItem> items) {
        this.items = items;
    }
}
