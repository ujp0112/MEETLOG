# Phase 9: 알림/소셜 기능 - 구현 가이드

## 개요
사용자 알림 시스템 및 소셜 기능(팔로우) 구축
**완료일**: 2025-10-22
**상태**: ⏳ 30% 완료 (Entity 완료, 나머지 구현 필요)

---

## 완료 요약

### ✅ 완료된 작업
1. **Entity Layer** - Notification, Follow 엔티티 생성 (완료)

### ⏳ 남은 작업
- DTO Layer (NotificationDto, FollowDto 등)
- Repository Interface & Mapper XML
- Service Layer (NotificationService, FollowService)
- Controller Layer (NotificationController, FollowController)
- Frontend Components (알림 벨, 팔로우 버튼 등)

---

## 1. 완료된 작업

### 1.1 Entity Layer ✅

#### Notification.java (68 lines)
**위치**: `MeetLog-SpringBoot/src/main/java/com/meetlog/model/`

```java
@Data
@Builder
public class Notification {
    private Long id;
    private Long userId;
    private String type; // follow, like, comment, review, reservation
    private String title;
    private String content;
    private String actionUrl; // 클릭 시 이동할 URL
    private Boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;

    // Helper methods
    public boolean isUnread();
    public void markAsRead();
    public String getTypeText(); // "팔로우", "좋아요" 등
}
```

#### Follow.java (42 lines)
```java
@Data
@Builder
public class Follow {
    private Long id;
    private Long followerId; // 팔로우하는 사람
    private Long followingId; // 팔로우 받는 사람
    private Boolean isActive;
    private LocalDateTime createdAt;

    // Helper methods
    public boolean isActive();
    public void activate();
    public void deactivate();
    public boolean isMutualFollow(Follow other); // 맞팔 여부
}
```

---

## 2. 미완료 작업 (구현 필요)

### 2.1 DTO Layer ⏳

#### NotificationDto.java
```java
@Data
@Builder
public class NotificationDto {
    private Long id;
    private Long userId;
    private String type;
    private String title;
    private String content;
    private String actionUrl;
    private Boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;

    // 추가 정보
    private String actorName; // 알림을 발생시킨 사용자명
    private String actorProfileImage;
}
```

#### FollowDto.java
```java
@Data
@Builder
public class FollowDto {
    private Long id;
    private Long followerId;
    private Long followingId;
    private Boolean isActive;
    private LocalDateTime createdAt;

    // 사용자 정보
    private String followerName;
    private String followerNickname;
    private String followerProfileImage;
    private String followingName;
    private String followingNickname;
    private String followingProfileImage;

    // 통계
    private Long followerFollowersCount; // 팔로워의 팔로워 수
    private Long followerFollowingCount; // 팔로워의 팔로잉 수
    private Boolean isMutual; // 맞팔 여부
}
```

---

### 2.2 Repository Layer ⏳

#### NotificationRepository.java
```java
@Mapper
public interface NotificationRepository {
    // CRUD
    Notification findById(@Param("id") Long id);
    List<NotificationDto> findByUserId(@Param("userId") Long userId,
                                        @Param("page") int page,
                                        @Param("size") int size);
    int countUnreadByUserId(@Param("userId") Long userId);
    int insert(Notification notification);
    int markAsRead(@Param("id") Long id);
    int markAllAsRead(@Param("userId") Long userId);
    int delete(@Param("id") Long id);

    // 배치 처리
    int deleteOldNotifications(@Param("days") int days); // N일 이상 된 알림 삭제
}
```

#### FollowRepository.java
```java
@Mapper
public interface FollowRepository {
    // CRUD
    Follow findById(@Param("id") Long id);
    Follow findByFollowerAndFollowing(@Param("followerId") Long followerId,
                                       @Param("followingId") Long followingId);
    List<FollowDto> findFollowers(@Param("userId") Long userId,
                                   @Param("page") int page,
                                   @Param("size") int size);
    List<FollowDto> findFollowing(@Param("userId") Long userId,
                                   @Param("page") int page,
                                   @Param("size") int size);
    int countFollowers(@Param("userId") Long userId);
    int countFollowing(@Param("userId") Long userId);
    int insert(Follow follow);
    int delete(@Param("followerId") Long followerId,
               @Param("followingId") Long followingId);
    boolean isFollowing(@Param("followerId") Long followerId,
                        @Param("followingId") Long followingId);
}
```

---

### 2.3 Service Layer ⏳

#### NotificationService.java
```java
@Service
@RequiredArgsConstructor
public class NotificationService {
    private final NotificationRepository notificationRepository;

    /**
     * 사용자 알림 목록 조회
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getNotifications(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        List<NotificationDto> notifications = notificationRepository
                .findByUserId(userId, offset, size);

        int unreadCount = notificationRepository.countUnreadByUserId(userId);

        return Map.of(
            "notifications", notifications,
            "unreadCount", unreadCount,
            "page", page,
            "size", size
        );
    }

    /**
     * 알림 생성
     */
    @Transactional
    public void createNotification(Long userId, String type, String title,
                                   String content, String actionUrl) {
        Notification notification = Notification.builder()
                .userId(userId)
                .type(type)
                .title(title)
                .content(content)
                .actionUrl(actionUrl)
                .isRead(false)
                .build();

        notificationRepository.insert(notification);

        // TODO: 실시간 알림 (WebSocket/SSE) 전송
        // webSocketService.sendNotification(userId, notification);
    }

    /**
     * 알림 읽음 처리
     */
    @Transactional
    public void markAsRead(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findById(notificationId);
        if (notification == null || !notification.getUserId().equals(userId)) {
            throw new RuntimeException("Notification not found or no permission");
        }

        notificationRepository.markAsRead(notificationId);
    }

    /**
     * 모든 알림 읽음 처리
     */
    @Transactional
    public void markAllAsRead(Long userId) {
        notificationRepository.markAllAsRead(userId);
    }

    /**
     * 팔로우 알림 생성
     */
    @Transactional
    public void notifyFollow(Long followerId, Long followingId, String followerName) {
        createNotification(
            followingId,
            "follow",
            "새 팔로워",
            followerName + "님이 회원님을 팔로우하기 시작했습니다.",
            "/users/" + followerId
        );
    }

    /**
     * 좋아요 알림 생성
     */
    @Transactional
    public void notifyLike(Long actorId, Long targetUserId, String actorName,
                          String contentType, Long contentId) {
        createNotification(
            targetUserId,
            "like",
            "새 좋아요",
            actorName + "님이 회원님의 " + contentType + "을(를) 좋아합니다.",
            getContentUrl(contentType, contentId)
        );
    }

    /**
     * 댓글 알림 생성
     */
    @Transactional
    public void notifyComment(Long actorId, Long targetUserId, String actorName,
                             String contentType, Long contentId) {
        createNotification(
            targetUserId,
            "comment",
            "새 댓글",
            actorName + "님이 회원님의 " + contentType + "에 댓글을 남겼습니다.",
            getContentUrl(contentType, contentId)
        );
    }

    private String getContentUrl(String contentType, Long contentId) {
        switch (contentType) {
            case "review":
                return "/reviews/" + contentId;
            case "column":
                return "/columns/" + contentId;
            case "course":
                return "/courses/" + contentId;
            default:
                return "/";
        }
    }
}
```

#### FollowService.java
```java
@Service
@RequiredArgsConstructor
public class FollowService {
    private final FollowRepository followRepository;
    private final NotificationService notificationService;
    private final UserRepository userRepository;

    /**
     * 팔로우
     */
    @Transactional
    public void follow(Long followerId, Long followingId) {
        if (followerId.equals(followingId)) {
            throw new RuntimeException("Cannot follow yourself");
        }

        // 이미 팔로우 중인지 확인
        Follow existing = followRepository.findByFollowerAndFollowing(followerId, followingId);
        if (existing != null && existing.isActive()) {
            throw new RuntimeException("Already following");
        }

        // 팔로우 생성
        Follow follow = Follow.builder()
                .followerId(followerId)
                .followingId(followingId)
                .isActive(true)
                .build();

        followRepository.insert(follow);

        // 알림 생성
        User follower = userRepository.findById(followerId).orElseThrow();
        notificationService.notifyFollow(followerId, followingId, follower.getName());
    }

    /**
     * 언팔로우
     */
    @Transactional
    public void unfollow(Long followerId, Long followingId) {
        followRepository.delete(followerId, followingId);
    }

    /**
     * 팔로워 목록
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
            "size", size
        );
    }

    /**
     * 팔로잉 목록
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
            "size", size
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
```

---

### 2.4 Controller Layer ⏳

#### NotificationController.java
```java
@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@Tag(name = "Notification", description = "알림 API")
public class NotificationController {

    private final NotificationService notificationService;

    @Operation(summary = "알림 목록", description = "사용자 알림 목록을 조회합니다.")
    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Object>> getNotifications(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        Map<String, Object> result = notificationService.getNotifications(
                userDetails.getUserId(), page, size);
        return ResponseEntity.ok(result);
    }

    @Operation(summary = "읽지 않은 알림 수", description = "읽지 않은 알림 개수를 조회합니다.")
    @GetMapping("/unread-count")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Integer>> getUnreadCount(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        int count = notificationService.getUnreadCount(userDetails.getUserId());
        return ResponseEntity.ok(Map.of("unreadCount", count));
    }

    @Operation(summary = "알림 읽음 처리", description = "특정 알림을 읽음 처리합니다.")
    @PatchMapping("/{id}/read")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> markAsRead(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        notificationService.markAsRead(id, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "모든 알림 읽음 처리", description = "모든 알림을 읽음 처리합니다.")
    @PatchMapping("/read-all")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> markAllAsRead(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        notificationService.markAllAsRead(userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "알림 삭제", description = "알림을 삭제합니다.")
    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteNotification(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        notificationService.deleteNotification(id, userDetails.getUserId());
        return ResponseEntity.noContent().build();
    }
}
```

#### FollowController.java
```java
@RestController
@RequestMapping("/api/follows")
@RequiredArgsConstructor
@Tag(name = "Follow", description = "팔로우 API")
public class FollowController {

    private final FollowService followService;

    @Operation(summary = "팔로우", description = "사용자를 팔로우합니다.")
    @PostMapping("/{userId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> follow(
            @PathVariable Long userId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        followService.follow(userDetails.getUserId(), userId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "언팔로우", description = "사용자 팔로우를 취소합니다.")
    @DeleteMapping("/{userId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> unfollow(
            @PathVariable Long userId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        followService.unfollow(userDetails.getUserId(), userId);
        return ResponseEntity.noContent().build();
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
}
```

---

### 2.5 프론트엔드 구현 ⏳

#### notification.js (API Client)
```javascript
import apiClient from './client';

export const notificationAPI = {
  // 알림 목록
  getNotifications: async (page = 1, size = 20) => {
    const response = await apiClient.get('/notifications', { params: { page, size } });
    return response.data;
  },

  // 읽지 않은 알림 수
  getUnreadCount: async () => {
    const response = await apiClient.get('/notifications/unread-count');
    return response.data;
  },

  // 알림 읽음 처리
  markAsRead: async (id) => {
    await apiClient.patch(`/notifications/${id}/read`);
  },

  // 모든 알림 읽음
  markAllAsRead: async () => {
    await apiClient.patch('/notifications/read-all');
  },

  // 알림 삭제
  delete: async (id) => {
    await apiClient.delete(`/notifications/${id}`);
  }
};
```

#### follow.js (API Client)
```javascript
import apiClient from './client';

export const followAPI = {
  // 팔로우
  follow: async (userId) => {
    await apiClient.post(`/follows/${userId}`);
  },

  // 언팔로우
  unfollow: async (userId) => {
    await apiClient.delete(`/follows/${userId}`);
  },

  // 팔로워 목록
  getFollowers: async (userId, page = 1, size = 20) => {
    const response = await apiClient.get(`/follows/${userId}/followers`, { params: { page, size } });
    return response.data;
  },

  // 팔로잉 목록
  getFollowing: async (userId, page = 1, size = 20) => {
    const response = await apiClient.get(`/follows/${userId}/following`, { params: { page, size } });
    return response.data;
  },

  // 팔로우 여부
  isFollowing: async (userId) => {
    const response = await apiClient.get(`/follows/${userId}/is-following`);
    return response.data;
  },

  // 통계
  getStats: async (userId) => {
    const response = await apiClient.get(`/follows/${userId}/stats`);
    return response.data;
  }
};
```

#### NotificationBell.jsx (알림 벨 컴포넌트)
```jsx
import React, { useState, useEffect } from 'react';
import { notificationAPI } from '../../api/notification';

const NotificationBell = () => {
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    fetchUnreadCount();
    // 30초마다 읽지 않은 알림 수 갱신
    const interval = setInterval(fetchUnreadCount, 30000);
    return () => clearInterval(interval);
  }, []);

  const fetchUnreadCount = async () => {
    try {
      const data = await notificationAPI.getUnreadCount();
      setUnreadCount(data.unreadCount);
    } catch (error) {
      console.error('Failed to fetch unread count:', error);
    }
  };

  const fetchNotifications = async () => {
    try {
      const data = await notificationAPI.getNotifications(1, 10);
      setNotifications(data.notifications);
    } catch (error) {
      console.error('Failed to fetch notifications:', error);
    }
  };

  const handleOpen = () => {
    setIsOpen(!isOpen);
    if (!isOpen) {
      fetchNotifications();
    }
  };

  const handleMarkAsRead = async (id) => {
    try {
      await notificationAPI.markAsRead(id);
      fetchNotifications();
      fetchUnreadCount();
    } catch (error) {
      console.error('Failed to mark as read:', error);
    }
  };

  const handleMarkAllAsRead = async () => {
    try {
      await notificationAPI.markAllAsRead();
      fetchNotifications();
      setUnreadCount(0);
    } catch (error) {
      console.error('Failed to mark all as read:', error);
    }
  };

  return (
    <div className="relative">
      {/* 벨 아이콘 */}
      <button
        onClick={handleOpen}
        className="relative p-2 text-gray-600 hover:text-gray-900 focus:outline-none"
      >
        <span className="text-2xl">🔔</span>
        {unreadCount > 0 && (
          <span className="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-600 rounded-full">
            {unreadCount > 99 ? '99+' : unreadCount}
          </span>
        )}
      </button>

      {/* 알림 드롭다운 */}
      {isOpen && (
        <div className="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border border-gray-200 z-50">
          <div className="flex items-center justify-between px-4 py-3 border-b">
            <h3 className="text-lg font-bold">알림</h3>
            {unreadCount > 0 && (
              <button
                onClick={handleMarkAllAsRead}
                className="text-sm text-blue-600 hover:text-blue-800"
              >
                모두 읽음
              </button>
            )}
          </div>

          <div className="max-h-96 overflow-y-auto">
            {notifications.length === 0 ? (
              <div className="px-4 py-8 text-center text-gray-500">
                알림이 없습니다.
              </div>
            ) : (
              notifications.map((notification) => (
                <div
                  key={notification.id}
                  className={`px-4 py-3 border-b hover:bg-gray-50 cursor-pointer ${
                    !notification.isRead ? 'bg-blue-50' : ''
                  }`}
                  onClick={() => {
                    handleMarkAsRead(notification.id);
                    if (notification.actionUrl) {
                      window.location.href = notification.actionUrl;
                    }
                  }}
                >
                  <div className="flex items-start">
                    <div className="flex-1">
                      <p className="text-sm font-medium text-gray-900">
                        {notification.title}
                      </p>
                      <p className="text-sm text-gray-600 mt-1">
                        {notification.content}
                      </p>
                      <p className="text-xs text-gray-400 mt-1">
                        {new Date(notification.createdAt).toLocaleString('ko-KR')}
                      </p>
                    </div>
                    {!notification.isRead && (
                      <span className="w-2 h-2 bg-blue-600 rounded-full mt-2"></span>
                    )}
                  </div>
                </div>
              ))
            )}
          </div>

          <div className="px-4 py-3 border-t text-center">
            <a
              href="/notifications"
              className="text-sm text-blue-600 hover:text-blue-800 font-medium"
            >
              모든 알림 보기
            </a>
          </div>
        </div>
      )}
    </div>
  );
};

export default NotificationBell;
```

#### FollowButton.jsx
```jsx
import React, { useState, useEffect } from 'react';
import { followAPI } from '../../api/follow';
import { useAuth } from '../../context/AuthContext';

const FollowButton = ({ userId }) => {
  const { user } = useAuth();
  const [isFollowing, setIsFollowing] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (user && userId !== user.userId) {
      checkFollowStatus();
    }
  }, [user, userId]);

  const checkFollowStatus = async () => {
    try {
      const data = await followAPI.isFollowing(userId);
      setIsFollowing(data.isFollowing);
    } catch (error) {
      console.error('Failed to check follow status:', error);
    }
  };

  const handleToggleFollow = async () => {
    if (!user) {
      alert('로그인이 필요합니다.');
      return;
    }

    setLoading(true);
    try {
      if (isFollowing) {
        await followAPI.unfollow(userId);
        setIsFollowing(false);
      } else {
        await followAPI.follow(userId);
        setIsFollowing(true);
      }
    } catch (error) {
      console.error('Failed to toggle follow:', error);
      alert('팔로우 처리에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  // 본인이면 버튼 표시 안함
  if (!user || userId === user.userId) {
    return null;
  }

  return (
    <button
      onClick={handleToggleFollow}
      disabled={loading}
      className={`px-4 py-2 rounded-md font-medium transition-colors ${
        isFollowing
          ? 'bg-gray-200 text-gray-800 hover:bg-gray-300'
          : 'bg-blue-600 text-white hover:bg-blue-700'
      } disabled:opacity-50`}
    >
      {loading ? '처리 중...' : isFollowing ? '팔로잉' : '팔로우'}
    </button>
  );
};

export default FollowButton;
```

---

## 3. 실시간 알림 (선택사항)

### 3.1 WebSocket 구성

**Backend (Spring Boot)**:
```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic", "/queue");
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }
}

@Service
public class WebSocketService {
    private final SimpMessagingTemplate messagingTemplate;

    public void sendNotification(Long userId, Notification notification) {
        messagingTemplate.convertAndSend(
            "/queue/notifications/" + userId,
            notification
        );
    }
}
```

**Frontend (React)**:
```javascript
import SockJS from 'sockjs-client';
import { Client } from '@stomp/stompjs';

const connectWebSocket = (userId, onNotification) => {
  const socket = new SockJS('/ws');
  const client = new Client({
    webSocketFactory: () => socket,
    onConnect: () => {
      client.subscribe(`/queue/notifications/${userId}`, (message) => {
        const notification = JSON.parse(message.body);
        onNotification(notification);
      });
    }
  });
  client.activate();
  return client;
};
```

---

## 4. 완료 체크리스트

- [x] Notification, Follow 엔티티 생성
- [ ] NotificationDto, FollowDto 생성
- [ ] NotificationRepository, FollowRepository 인터페이스
- [ ] NotificationRepositoryMapper.xml, FollowRepositoryMapper.xml
- [ ] NotificationService, FollowService 구현
- [ ] NotificationController, FollowController 구현
- [ ] Frontend API 클라이언트 (notification.js, follow.js)
- [ ] NotificationBell 컴포넌트
- [ ] FollowButton 컴포넌트
- [ ] WebSocket 실시간 알림 (선택)

---

**현재 상태**: 30% 완료 (Entity만 생성, 나머지 구현 필요)
**예상 작업 기간**: 2-3일

