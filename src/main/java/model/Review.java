package model;

import java.time.LocalDateTime;
import java.util.List;

public class Review {
	// IDE Cache Refresh - v2.0
	private int id;
	private int restaurantId;
	private int userId;
	private String author;
	private String restaurantName;
	private String authorImage;
	private int rating;
	private String content;
	private List<String> images;
	private List<String> keywords;
	private int likes;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private boolean isActive;

	// 상세 평점 필드들 추가
	private int tasteRating; // 맛 평점 (1-5)
	private int serviceRating; // 서비스 평점 (1-5)
	private int atmosphereRating; // 분위기 평점 (1-5)
	private int priceRating; // 가격 평점 (1-5)
	private String visitDate; // 방문 날짜
	private int partySize; // 인원수
	private String visitPurpose; // 방문 목적 ("데이트", "비즈니스", "가족모임", "친구모임", "혼밥")
	
	// 답글 목록
	private List<ReviewComment> comments;

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

	// --- 모든 Getters and Setters ---
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

	public String getRestaurantName() {
		return restaurantName;
	}

	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}

	public String getAuthorImage() {
		return authorImage;
	}

	public void setAuthorImage(String authorImage) {
		this.authorImage = authorImage;
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

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean active) {
		isActive = active;
	}

	// 상세 평점 필드들의 Getter/Setter
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
}