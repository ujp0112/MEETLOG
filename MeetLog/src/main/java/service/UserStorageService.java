package service;

import model.UserStorage;
import model.UserStorageItem;
import dao.UserStorageDAO;
import java.util.List;

public class UserStorageService {
    private UserStorageDAO userStorageDAO = new UserStorageDAO();
    
    /**
     * 사용자별 저장소 목록 조회
     */
    public List<UserStorage> getUserStorages(int userId) {
        return userStorageDAO.findByUserId(userId);
    }
    
    /**
     * 저장소 상세 조회
     */
    public UserStorage getStorageById(int storageId) {
        return userStorageDAO.findById(storageId);
    }
    
    /**
     * 저장소 생성
     */
    public boolean createStorage(UserStorage storage) {
        return userStorageDAO.insert(storage) > 0;
    }
    
    /**
     * 저장소 수정
     */
    public boolean updateStorage(UserStorage storage) {
        return userStorageDAO.update(storage) > 0;
    }
    
    /**
     * 저장소 삭제
     */
    public boolean deleteStorage(int storageId) {
        return userStorageDAO.delete(storageId) > 0;
    }
    
    /**
     * 저장소에 아이템 추가
     */
    public boolean addToStorage(int storageId, String itemType, int contentId) {
        UserStorageItem item = new UserStorageItem(storageId, itemType, contentId);
        return userStorageDAO.addItem(item) > 0;
    }
    
    /**
     * 저장소에서 아이템 제거
     */
    public boolean removeFromStorage(int storageId, String itemType, int contentId) {
        return userStorageDAO.removeItem(storageId, itemType, contentId) > 0;
    }
    
    /**
     * 저장소의 아이템 목록 조회
     */
    public List<UserStorageItem> getStorageItems(int storageId) {
        return userStorageDAO.findItemsByStorageId(storageId);
    }
    
    /**
     * 특정 아이템이 저장소에 있는지 확인
     */
    public boolean isItemInStorage(int storageId, String itemType, int contentId) {
        return userStorageDAO.isItemInStorage(storageId, itemType, contentId);
    }
    
    /**
     * 사용자의 기본 저장소 조회 (없으면 생성)
     */
    public UserStorage getOrCreateDefaultStorage(int userId) {
        return userStorageDAO.getDefaultStorage(userId);
    }
    
    /**
     * 기본 저장소에 아이템 추가 (찜하기 기능)
     */
    public boolean addToWishlist(int userId, String itemType, int contentId) {
        UserStorage defaultStorage = getOrCreateDefaultStorage(userId);
        return addToStorage(defaultStorage.getStorageId(), itemType, contentId);
    }
    
    /**
     * 기본 저장소에서 아이템 제거 (찜 해제 기능)
     */
    public boolean removeFromWishlist(int userId, String itemType, int contentId) {
        UserStorage defaultStorage = getOrCreateDefaultStorage(userId);
        return removeFromStorage(defaultStorage.getStorageId(), itemType, contentId);
    }

    /**
     * 사용자의 모든 저장소에서 특정 아이템을 제거
     */
    public boolean removeFromAllStorages(int userId, String itemType, int contentId) {
        List<UserStorage> userStorages = getUserStorages(userId);
        boolean removed = false;

        for (UserStorage storage : userStorages) {
            if (isItemInStorage(storage.getStorageId(), itemType, contentId)) {
                removed = removeFromStorage(storage.getStorageId(), itemType, contentId) || removed;
            }
        }

        return removed;
    }
}
