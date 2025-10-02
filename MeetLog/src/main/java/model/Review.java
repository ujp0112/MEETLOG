package model;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Date;
import java.sql.Timestamp;

public class Review {
	private int id;
	private int restaurantId;
	private int userId;
	private String author;
	private String restaurantName;
	private String profileImage;
	private int rating;
	private String content;
	private List<String> images;
	private List<String> keywords;
	private int likes;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private boolean isActive;
	private String replyContent;
	private LocalDateTime replyCreatedAt;

	// [추가] 주변 리뷰 검색 시 맛집 위치 정보를 담기 위한 필드
	private String address;
	private Double latitude;
	private Double longitude;

	// 상세 평점 필드들
	private int tasteRating;
	private int serviceRating;
	private int atmosphereRating;
	private int priceRating;
	private String visitDate;
	private int partySize;
	private String visitPurpose;

	// 댓글 목록
	private List<ReviewComment> comments;

	// --- 기능 구현에 필요한 추가 필드들 ---
	private boolean likedByCurrentUser;
	private boolean authorIsFollowedByCurrentUser; // [ ✨ 추가된 부분 ✨ ]

	public Review() {
		// Default constructor
	}

	public Review(int restaurantId, int userId, String author, int rating, String content) {
		this.restaurantId = restaurantId;
		this.userId = userId;
		this.author = author;
		this.rating = rating;
		this.content = content;
	}

	// [추가] Getter/Setter
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}

	public void setKeywords(String keywords) {
		if (keywords != null && !keywords.trim().isEmpty()) {
			this.keywords = Arrays.asList(keywords.split("\\s*,\\s*"));
		} else {
			this.keywords = Collections.emptyList();
		}
	}

	// --- 이하 Getter, Setter 메서드들 ---

	public boolean isLikedByCurrentUser() {
		return likedByCurrentUser;
	}

	public void setLikedByCurrentUser(boolean likedByCurrentUser) {
		this.likedByCurrentUser = likedByCurrentUser;
	}

	// [ ✨ 추가된 부분 ✨ ]
	public boolean isAuthorIsFollowedByCurrentUser() {
		return authorIsFollowedByCurrentUser;
	}

	public void setAuthorIsFollowedByCurrentUser(boolean authorIsFollowedByCurrentUser) {
		this.authorIsFollowedByCurrentUser = authorIsFollowedByCurrentUser;
	}
	// [ ✨ 여기까지 ✨ ]

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public List<String> getImages() {
		return images;
	}

	public void setImages(List<String> images) {
		this.images = images;
	}

	public List<String> getKeywords() {
		return keywords;
	}

	public void setKeywords(List<String> keywords) {
		this.keywords = keywords;
	}

	public int getLikes() {
		return likes;
	}

	public void setLikes(int likes) {
		this.likes = likes;
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

	public String getRestaurantName() {
		return restaurantName;
	}

	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public int getTasteRating() {
		return tasteRating;
	}

	public void setTasteRating(int tasteRating) {
		this.tasteRating = tasteRating;
	}

	public int getServiceRating() {
		return serviceRating;
	}

	public void setServiceRating(int serviceRating) {
		this.serviceRating = serviceRating;
	}

	public int getAtmosphereRating() {
		return atmosphereRating;
	}

	public void setAtmosphereRating(int atmosphereRating) {
		this.atmosphereRating = atmosphereRating;
	}

	public int getPriceRating() {
		return priceRating;
	}

	public void setPriceRating(int priceRating) {
		this.priceRating = priceRating;
	}

	public String getVisitDate() {
		return visitDate;
	}

	public void setVisitDate(String visitDate) {
		this.visitDate = visitDate;
	}

	public int getPartySize() {
		return partySize;
	}

	public void setPartySize(int partySize) {
		this.partySize = partySize;
	}

	public String getVisitPurpose() {
		return visitPurpose;
	}

	public void setVisitPurpose(String visitPurpose) {
		this.visitPurpose = visitPurpose;
	}

	public List<ReviewComment> getComments() {
		return comments;
	}

	public void setComments(List<ReviewComment> comments) {
		this.comments = comments;
	}

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

	public String getReplyContent() {
		return replyContent;
	}

	public Date getCreatedAtAsDate() {
		if (this.createdAt != null) {
			return Timestamp.valueOf(this.createdAt);
		}
		return null;
	}

	public Date getReplyCreatedAtAsDate() {
		if (this.replyCreatedAt != null) {
			return Timestamp.valueOf(this.replyCreatedAt);
		}
		return null;
	}

	public void setReplyContent(String replyContent) {
		this.replyContent = replyContent;
	}

	public LocalDateTime getReplyCreatedAt() {
		return replyCreatedAt;
	}

	public void setReplyCreatedAt(LocalDateTime replyCreatedAt) {
		this.replyCreatedAt = replyCreatedAt;
	}
}
