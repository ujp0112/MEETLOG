package service;

import dao.FollowDAO;
import dao.FeedDAO;
import model.Follow;
import model.FeedItem;
import model.User;
import java.util.List;

/**
 * 팔로우 시스템을 위한 서비스 클래스
 */
public class FollowService {
    
    private FollowDAO followDAO = new FollowDAO();
    private FeedDAO feedDAO = new FeedDAO();

    /**
     * 사용자 팔로우
     */
    public boolean followUser(int followerId, int followingId) {
        try {
            // 자기 자신을 팔로우할 수 없음
            if (followerId == followingId) {
                return false;
            }

            // 이미 팔로우 중인지 확인
            if (followDAO.isFollowing(followerId, followingId)) {
                return true; // 이미 팔로우 중
            }

            // 팔로우 관계 생성
            int result = followDAO.followUser(followerId, followingId);
            
            if (result > 0) {
                // 피드에 팔로우 활동 추가
                createFollowFeedItem(followerId, followingId);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 사용자 언팔로우
     */
    public boolean unfollowUser(int followerId, int followingId) {
        try {
            int result = followDAO.unfollowUser(followerId, followingId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 팔로우 관계 확인
     */
    public boolean isFollowing(int followerId, int followingId) {
        try {
            return followDAO.isFollowing(followerId, followingId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 팔로워 목록 조회
     */
    public List<User> getFollowers(int userId, int limit, int offset) {
        try {
            return followDAO.getFollowers(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 팔로잉 목록 조회
     */
    public List<User> getFollowing(int userId, int limit, int offset) {
        try {
            return followDAO.getFollowing(userId, limit, offset);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * 팔로워 수 조회
     */
    public int getFollowerCount(int userId) {
        try {
            return followDAO.getFollowerCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 팔로잉 수 조회
     */
    public int getFollowingCount(int userId) {
        try {
            return followDAO.getFollowingCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 팔로잉 목록 조회 (간편 메소드)
     */
    public List<User> getFollowingUsers(int userId) {
        return getFollowing(userId, 50, 0); // 기본값: 50개, 첫 페이지
    }

    /**
     * 팔로워 목록 조회 (간편 메소드 오버로드)
     */
    public List<User> getFollowers(int userId) {
        return getFollowers(userId, 50, 0); // 기본값: 50개, 첫 페이지
    }

    /**
     * 팔로우 피드 아이템 생성
     */
    private void createFollowFeedItem(int followerId, int followingId) {
        try {
            // TODO: 사용자 정보 조회하여 닉네임 등 가져오기
            FeedItem feedItem = new FeedItem();
            feedItem.setUserId(followerId);
            feedItem.setUserNickname("사용자"); // 실제로는 DB에서 조회
            feedItem.setActionType("follow");
            feedItem.setContent("새로운 사용자를 팔로우했습니다");
            feedItem.setTargetType("user");
            feedItem.setTargetId(followingId);
            feedItem.setTargetName("사용자"); // 실제로는 DB에서 조회
            
            feedDAO.createFeedItem(feedItem);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
