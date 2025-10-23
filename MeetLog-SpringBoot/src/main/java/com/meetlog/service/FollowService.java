package com.meetlog.service;

import com.meetlog.dto.follow.FollowDto;
import com.meetlog.model.Follow;
import com.meetlog.model.User;
import com.meetlog.repository.FollowRepository;
import com.meetlog.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * 팔로우 서비스
 */
@Service
@RequiredArgsConstructor
public class FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    /**
     * 팔로우
     */
    @Transactional
    public void follow(Long followerId, Long followingId) {
        // 자기 자신 팔로우 방지
        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("Cannot follow yourself");
        }

        // 이미 팔로우 중인지 확인
        Follow existing = followRepository.findByFollowerAndFollowing(followerId, followingId);
        if (existing != null && existing.getIsActive()) {
            throw new IllegalStateException("Already following");
        }

        // 팔로우 생성
        Follow follow = Follow.builder()
                .followerId(followerId)
                .followingId(followingId)
                .isActive(true)
                .build();

        followRepository.insert(follow);

        // 알림 생성
        User follower = userRepository.findById(followerId)
                .orElseThrow(() -> new RuntimeException("Follower not found"));
        notificationService.notifyFollow(followerId, followingId, follower.getName());
    }

    /**
     * 언팔로우
     */
    @Transactional
    public void unfollow(Long followerId, Long followingId) {
        int deleted = followRepository.delete(followerId, followingId);
        if (deleted == 0) {
            throw new RuntimeException("Follow relationship not found");
        }
    }

    /**
     * 팔로워 목록 (나를 팔로우하는 사람들)
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getFollowers(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        List<FollowDto> followers = followRepository.findFollowers(userId, offset, size);
        int totalCount = followRepository.countFollowers(userId);

        return Map.of(
            "followers", followers,
            "totalCount", totalCount,
            "page", page,
            "size", size,
            "totalPages", (int) Math.ceil((double) totalCount / size)
        );
    }

    /**
     * 팔로잉 목록 (내가 팔로우하는 사람들)
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getFollowing(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        List<FollowDto> following = followRepository.findFollowing(userId, offset, size);
        int totalCount = followRepository.countFollowing(userId);

        return Map.of(
            "following", following,
            "totalCount", totalCount,
            "page", page,
            "size", size,
            "totalPages", (int) Math.ceil((double) totalCount / size)
        );
    }

    /**
     * 팔로우 여부 확인
     */
    @Transactional(readOnly = true)
    public boolean isFollowing(Long followerId, Long followingId) {
        return followRepository.isFollowing(followerId, followingId);
    }

    /**
     * 맞팔 여부 확인
     */
    @Transactional(readOnly = true)
    public boolean isMutualFollow(Long userId1, Long userId2) {
        return followRepository.isMutualFollow(userId1, userId2);
    }

    /**
     * 팔로우 통계
     */
    @Transactional(readOnly = true)
    public Map<String, Integer> getFollowStats(Long userId) {
        int followersCount = followRepository.countFollowers(userId);
        int followingCount = followRepository.countFollowing(userId);

        return Map.of(
            "followers", followersCount,
            "following", followingCount
        );
    }
}
