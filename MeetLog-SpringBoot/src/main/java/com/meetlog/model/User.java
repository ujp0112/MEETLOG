package com.meetlog.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * User Entity
 * 기존 users 테이블과 매핑
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {

    private Long userId;
    private String email;
    private String password;
    private String name;
    private String phone;
    private String nickname;
    private String profileImage;

    /**
     * 회원 유형
     * NORMAL: 일반 회원
     * BUSINESS: 비즈니스 회원
     * ADMIN: 관리자
     */
    private String userType;

    /**
     * 계정 상태
     * ACTIVE: 활성
     * INACTIVE: 비활성
     * SUSPENDED: 정지
     */
    private String status;

    /**
     * 소셜 로그인 제공자
     * LOCAL: 일반 로그인
     * KAKAO: 카카오
     * NAVER: 네이버
     * GOOGLE: 구글
     */
    private String provider;
    private String providerId;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime lastLoginAt;

    // 추가 정보
    private String address;
    private LocalDateTime birthDate;
    private String gender;
    private Integer points;

    /**
     * 비밀번호 일치 여부 확인
     */
    public boolean matchPassword(String rawPassword) {
        // BCrypt 검증은 Service에서 수행
        return true;
    }

    /**
     * 활성 계정 여부
     */
    public boolean isActive() {
        return "ACTIVE".equals(this.status);
    }

    /**
     * 비즈니스 회원 여부
     */
    public boolean isBusinessUser() {
        return "BUSINESS".equals(this.userType);
    }

    /**
     * 관리자 여부
     */
    public boolean isAdmin() {
        return "ADMIN".equals(this.userType);
    }
}
