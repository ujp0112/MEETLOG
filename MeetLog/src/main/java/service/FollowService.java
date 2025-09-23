package service;

import model.Follow;
import dao.FollowDAO;
import java.util.List;

public class FollowService {
    private FollowDAO followDAO = new FollowDAO();
    
    /**
     * 팔로우하기
     */
    public boolean follow(int followerId, int followingId) {
        // 자기 자신을 팔로우할 수 없음
        if (followerId == followingId) {
            return false;
        }
        
        return followDAO.follow(followerId, followingId) > 0;
    }
    
    /**
     * 언팔로우하기
     */
    public boolean unfollow(int followerId, int followingId) {
        return followDAO.unfollow(followerId, followingId) > 0;
    }
    
    /**
     * 팔로우 관계 확인
     */
    public boolean isFollowing(int followerId, int followingId) {
        return followDAO.isFollowing(followerId, followingId);
    }
    
    /**
     * 팔로우/언팔로우 토글
     */
    public boolean toggleFollow(int followerId, int followingId) {
        if (isFollowing(followerId, followingId)) {
            return unfollow(followerId, followingId);
        } else {
            return follow(followerId, followingId);
        }
    }
    
    /**
     * 사용자의 팔로잉 목록 조회
     */
    public List<Follow> getFollowings(int userId) {
        return followDAO.getFollowings(userId);
    }
    
    /**
     * 사용자의 팔로워 목록 조회
     */
    public List<Follow> getFollowers(int userId) {
        return followDAO.getFollowers(userId);
    }
    
    /**
     * 팔로잉 수 조회
     */
    public int getFollowingCount(int userId) {
        return followDAO.getFollowingCount(userId);
    }
    
    /**
     * 팔로워 수 조회
     */
    public int getFollowerCount(int userId) {
        return followDAO.getFollowerCount(userId);
    }
    
    /**
     * 사용자의 팔로잉 ID 목록 조회 (피드용)
     */
    public List<Integer> getFollowingIds(int userId) {
        return followDAO.getFollowingIds(userId);
    }
}