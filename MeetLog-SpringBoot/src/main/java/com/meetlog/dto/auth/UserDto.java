package com.meetlog.dto.auth;

import com.meetlog.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 사용자 정보 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {

    private Long userId;
    private String email;
    private String name;
    private String nickname;
    private String phone;
    private String profileImage;
    private String userType;
    private String status;
    private String provider;
    private Integer points;
    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;

    /**
     * Entity를 DTO로 변환
     */
    public static UserDto from(User user) {
        return UserDto.builder()
                .userId(user.getUserId())
                .email(user.getEmail())
                .name(user.getName())
                .nickname(user.getNickname())
                .phone(user.getPhone())
                .profileImage(user.getProfileImage())
                .userType(user.getUserType())
                .status(user.getStatus())
                .provider(user.getProvider())
                .points(user.getPoints())
                .createdAt(user.getCreatedAt())
                .lastLoginAt(user.getLastLoginAt())
                .build();
    }
}
