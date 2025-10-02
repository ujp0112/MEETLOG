// src/main/java/model/User.java

package model;

import java.time.LocalDateTime;

public class User {
	private int id;
	// [수정] 'username'을 DB 컬럼명과 일치하는 'nickname'으로 변경
	private String nickname;
	private String password;
	private String email;
	private String phone;
	private String userType; // PERSONAL, BUSINESS, ADMIN
	private int level;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private String name;
	private String address;

	// [추가] 소셜 로그인 정보 저장을 위한 필드
	private String socialProvider; // "KAKAO", "NAVER", "GOOGLE"
	private String socialId; // 소셜 서비스에서 제공하는 고유 ID

	// 기본 생성자
	public User() {
	}

	// 생성자 (nickname으로 수정)
	public User(String nickname, String password, String email, String userType) {
		this.nickname = nickname;
		this.password = password;
		this.email = email;
		this.userType = userType;
	}

	// Getters and Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	// [수정] get/setUsername -> get/setNickname
	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public LocalDateTime getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(LocalDateTime updatedAt) {
		this.updatedAt = updatedAt;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	// [추가] socialProvider, socialId의 Getters/Setters
	public String getSocialProvider() {
		return socialProvider;
	}

	public void setSocialProvider(String socialProvider) {
		this.socialProvider = socialProvider;
	}

	public String getSocialId() {
		return socialId;
	}

	public void setSocialId(String socialId) {
		this.socialId = socialId;
	}

	// --- 나머지 추가 필드들 ---
	private String profileImage;
	private int restaurantId;
	private int followerCount;
	private int followingCount;
	private boolean isActive;
	private boolean isFollowing;

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

	public int getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public int getFollowerCount() {
		return followerCount;
	}

	public void setFollowerCount(int followerCount) {
		this.followerCount = followerCount;
	}

	public int getFollowingCount() {
		return followingCount;
	}

	public void setFollowingCount(int followingCount) {
		this.followingCount = followingCount;
	}

	public boolean isActive() {
		return isActive;
	}

	public boolean getIsActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public void setIsActive(boolean isActive) {
		this.isActive = isActive;
	}

	public boolean isFollowing() {
		return isFollowing;
	}

	public boolean getIsFollowing() {
		return isFollowing;
	}

	public void setIsFollowing(boolean isFollowing) {
		this.isFollowing = isFollowing;
	}
	
	@Override
    public String toString() {
        return "User{" +
               "id=" + id +
               ", nickname='" + nickname + '\'' +
               ", email='" + email + '\'' +
               ", userType='" + userType + '\'' +
               ", isActive=" + isActive +
               ", socialProvider='" + socialProvider + '\'' +
               ", socialId='" + socialId + '\'' +
               '}';
    }
}