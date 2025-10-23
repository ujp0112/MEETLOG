package com.meetlog.dto.follow;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 팔로우 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FollowDto {
    private Long id;
    private Long followerId;
    private Long followingId;
    private Boolean isActive;
    private LocalDateTime createdAt;

    // 팔로워 정보 (팔로우하는 사람)
    private String followerName;
    private String followerNickname;
    private String followerEmail;
    private String followerProfileImage;
    private Integer followerLevel;

    // 팔로잉 정보 (팔로우 받는 사람)
    private String followingName;
    private String followingNickname;
    private String followingEmail;
    private String followingProfileImage;
    private Integer followingLevel;

    // 팔로우 통계
    private Long followerFollowersCount; // 팔로워의 팔로워 수
    private Long followerFollowingCount; // 팔로워의 팔로잉 수
    private Long followingFollowersCount; // 팔로잉의 팔로워 수
    private Long followingFollowingCount; // 팔로잉의 팔로잉 수

    // 맞팔 여부
    private Boolean isMutual;
}
