package dao;

import model.UserStorage;
import model.UserStorageItem;
import util.MyBatisSqlSessionFactory;
import org.apache.ibatis.session.SqlSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class UserStorageDAO {
    private static final String NAMESPACE = "dao.UserStorageDAO";
    
    /**
     * 사용자별 저장소 목록 조회
     */
    public List<UserStorage> findByUserId(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findByUserId", userId);
        }
    }
    
    /**
     * 저장소 ID로 조회
     */
    public UserStorage findById(int storageId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectOne(NAMESPACE + ".findById", storageId);
        }
    }
    
    /**
     * 저장소 생성
     */
    public int insert(UserStorage storage) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".insert", storage);
            sqlSession.commit();
            return result;
        }
    }
    
    /**
     * 저장소 수정
     */
    public int update(UserStorage storage) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.update(NAMESPACE + ".update", storage);
            sqlSession.commit();
            return result;
        }
    }
    
    /**
     * 저장소 삭제
     */
    public int delete(int storageId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".delete", storageId);
            sqlSession.commit();
            return result;
        }
    }
    
    /**
     * 저장소에 아이템 추가
     */
    public int addItem(UserStorageItem item) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.insert(NAMESPACE + ".addItem", item);
            sqlSession.commit();
            return result;
        }
    }
    
    /**
     * 저장소에서 아이템 제거
     */
    public int removeItem(int storageId, String itemType, int contentId) {
        Map<String, Object> params = new HashMap<>();
        params.put("storageId", storageId);
        params.put("itemType", itemType);
        params.put("contentId", contentId);
        
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            int result = sqlSession.delete(NAMESPACE + ".removeItem", params);
            sqlSession.commit();
            return result;
        }
    }
    
    /**
     * 저장소의 아이템 목록 조회
     */
    public List<UserStorageItem> findItemsByStorageId(int storageId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            return sqlSession.selectList(NAMESPACE + ".findItemsByStorageId", storageId);
        }
    }
    
    /**
     * 특정 아이템이 저장소에 있는지 확인
     */
    public boolean isItemInStorage(int storageId, String itemType, int contentId) {
        Map<String, Object> params = new HashMap<>();
        params.put("storageId", storageId);
        params.put("itemType", itemType);
        params.put("contentId", contentId);
        
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            Integer count = sqlSession.selectOne(NAMESPACE + ".countItem", params);
            return count != null && count > 0;
        }
    }
    
    /**
     * 사용자의 기본 저장소 조회 (없으면 생성)
     */
    public UserStorage getDefaultStorage(int userId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession()) {
            UserStorage defaultStorage = sqlSession.selectOne(NAMESPACE + ".findDefaultStorage", userId);
            
            if (defaultStorage == null) {
                // 기본 저장소가 없으면 생성
                defaultStorage = new UserStorage(userId, "내가 찜한 로그", "bg-blue-100");
                sqlSession.insert(NAMESPACE + ".insert", defaultStorage);
                sqlSession.commit();
            }
            
            return defaultStorage;
        }
    }
}
