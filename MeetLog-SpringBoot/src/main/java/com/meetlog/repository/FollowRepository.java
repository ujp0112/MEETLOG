package com.meetlog.repository;

import com.meetlog.dto.follow.FollowDto;
import com.meetlog.model.Follow;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Follow Repository Interface
 * 팔로우 관리용 MyBatis 매퍼
 */
@Mapper
public interface FollowRepository {

    /**
     * ID로 팔로우 조회
     */
    Follow findById(@Param("id") Long id);

    /**
     * 팔로워-팔로잉 쌍으로 조회
     */
    Follow findByFollowerAndFollowing(@Param("followerId") Long followerId,
                                       @Param("followingId") Long followingId);

    /**
     * 팔로워 목록 조회 (나를 팔로우하는 사람들)
     */
    List<FollowDto> findFollowers(@Param("userId") Long userId,
                                   @Param("offset") int offset,
                                   @Param("limit") int limit);

    /**
     * 팔로잉 목록 조회 (내가 팔로우하는 사람들)
     */
    List<FollowDto> findFollowing(@Param("userId") Long userId,
                                   @Param("offset") int offset,
                                   @Param("limit") int limit);

    /**
     * 팔로워 수
     */
    int countFollowers(@Param("userId") Long userId);

    /**
     * 팔로잉 수
     */
    int countFollowing(@Param("userId") Long userId);

    /**
     * 팔로우 생성
     */
    int insert(Follow follow);

    /**
     * 팔로우 취소 (삭제)
     */
    int delete(@Param("followerId") Long followerId,
               @Param("followingId") Long followingId);

    /**
     * 팔로우 여부 확인
     */
    boolean isFollowing(@Param("followerId") Long followerId,
                        @Param("followingId") Long followingId);

    /**
     * 맞팔 여부 확인
     */
    boolean isMutualFollow(@Param("userId1") Long userId1,
                           @Param("userId2") Long userId2);
}
