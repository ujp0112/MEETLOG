package com.meetlog.security;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

@Getter
public class CustomUserDetails extends User {
    private final Long userId;
    private final String name;
    private final String nickname;
    private final String userType;

    public CustomUserDetails(
            Long userId,
            String username,
            String password,
            String name,
            String nickname,
            String userType,
            Collection<? extends GrantedAuthority> authorities
    ) {
        super(username, password, authorities);
        this.userId = userId;
        this.name = name;
        this.nickname = nickname;
        this.userType = userType;
    }
}
