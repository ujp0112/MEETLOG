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
    private UserService userService = new UserService();

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
            // 사용자 정보 조회
            User follower = userService.getUserById(followerId);
            User following = userService.getUserById(followingId);

            if (follower == null || following == null) {
                System.err.println("사용자 정보를 찾을 수 없습니다. followerId: " + followerId + ", followingId: " + followingId);
                return;
            }

            FeedItem feedItem = new FeedItem();
            feedItem.setUserId(followerId);
            feedItem.setUserNickname(follower.getNickname() != null ? follower.getNickname() : "사용자");
            feedItem.setActionType("follow");
            feedItem.setContent(following.getNickname() + "님을 팔로우했습니다");
            feedItem.setTargetType("user");
            feedItem.setTargetId(followingId);
            feedItem.setTargetName(following.getNickname() != null ? following.getNickname() : "사용자");
            //createFeedItem 수정
            // 현재 sql이 user_nickname을 받지 못하고 있음.
            feedDAO.createSimpleFeedItem(feedItem.getId(), "FOLLOW", feedItem.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 특정 사용자 정보 조회 (FollowService에서 필요한 경우)
     */
    public User getUserInfo(int userId) {
        try {
            return userService.getUserById(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 사용자 닉네임 조회 (편의 메서드)
     */
    public String getUserNickname(int userId) {
        try {
            User user = userService.getUserById(userId);
            return user != null ? user.getNickname() : "사용자";
        } catch (Exception e) {
            e.printStackTrace();
            return "사용자";
        }
    }
}
