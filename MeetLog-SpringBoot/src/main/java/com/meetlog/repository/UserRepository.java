package com.meetlog.repository;

import com.meetlog.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

/**
 * User Repository (MyBatis Mapper Interface)
 */
@Mapper
public interface UserRepository {

    /**
     * 이메일로 사용자 조회
     */
    Optional<User> findByEmail(@Param("email") String email);

    /**
     * userId로 사용자 조회
     */
    Optional<User> findById(@Param("userId") Long userId);

    /**
     * 닉네임으로 사용자 조회 (중복 확인용)
     */
    Optional<User> findByNickname(@Param("nickname") String nickname);

    /**
     * 사용자 생성
     */
    int insert(User user);

    /**
     * 사용자 정보 업데이트
     */
    int update(User user);

    /**
     * 마지막 로그인 시간 업데이트
     */
    int updateLastLoginAt(@Param("userId") Long userId);

    /**
     * 이메일 중복 체크
     */
    boolean existsByEmail(@Param("email") String email);

    /**
     * 닉네임 중복 체크
     */
    boolean existsByNickname(@Param("nickname") String nickname);
}
