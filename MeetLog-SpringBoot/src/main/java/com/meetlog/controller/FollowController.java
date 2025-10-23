package com.meetlog.controller;

import com.meetlog.security.CustomUserDetails;
import com.meetlog.service.FollowService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 팔로우 API 컨트롤러
 */
@RestController
@RequestMapping("/api/follows")
@RequiredArgsConstructor
@Tag(name = "Follow", description = "팔로우 API")
public class FollowController {

    private final FollowService followService;

    @Operation(summary = "팔로우", description = "사용자를 팔로우합니다.")
    @PostMapping("/{userId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> follow(
            @PathVariable Long userId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        followService.follow(userDetails.getUserId(), userId);
        return ResponseEntity.ok(Map.of("message", "Successfully followed"));
    }

    @Operation(summary = "언팔로우", description = "사용자 팔로우를 취소합니다.")
    @DeleteMapping("/{userId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> unfollow(
            @PathVariable Long userId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        followService.unfollow(userDetails.getUserId(), userId);
        return ResponseEntity.ok(Map.of("message", "Successfully unfollowed"));
    }

    @Operation(summary = "팔로워 목록", description = "사용자의 팔로워 목록을 조회합니다.")
    @GetMapping("/{userId}/followers")
    public ResponseEntity<Map<String, Object>> getFollowers(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        Map<String, Object> result = followService.getFollowers(userId, page, size);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "팔로잉 목록", description = "사용자가 팔로우하는 목록을 조회합니다.")
    @GetMapping("/{userId}/following")
    public ResponseEntity<Map<String, Object>> getFollowing(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        Map<String, Object> result = followService.getFollowing(userId, page, size);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "팔로우 여부", description = "팔로우 여부를 확인합니다.")
    @GetMapping("/{userId}/is-following")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Boolean>> isFollowing(
            @PathVariable Long userId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        boolean following = followService.isFollowing(userDetails.getUserId(), userId);
        return ResponseEntity.ok(Map.of("isFollowing", following));
    }

    @Operation(summary = "팔로우 통계", description = "팔로워/팔로잉 수를 조회합니다.")
    @GetMapping("/{userId}/stats")
    public ResponseEntity<Map<String, Integer>> getFollowStats(@PathVariable Long userId) {
        Map<String, Integer> stats = followService.getFollowStats(userId);
        return ResponseEntity.ok(stats);
    }

    @Operation(summary = "맞팔 여부", description = "맞팔 여부를 확인합니다.")
    @GetMapping("/{userId}/is-mutual")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Boolean>> isMutual(
            @PathVariable Long userId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        boolean mutual = followService.isMutualFollow(userDetails.getUserId(), userId);
        return ResponseEntity.ok(Map.of("isMutual", mutual));
    }
}
