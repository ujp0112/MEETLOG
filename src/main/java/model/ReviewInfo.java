package model;

import java.sql.Timestamp; // 시간까지 표현하려면 Timestamp가 더 좋습니다.

public class ReviewInfo {

	// --- 기존 Review 정보 ---
	private int id;
	private String content;
	private int rating;
	private String author;
	private Timestamp createdAt; // java.sql.Timestamp 사용

	// --- JOIN으로 추가된 Restaurant 정보 ---
	private int restaurantId;
	private String restaurantName;
	
	public String authorImage;


	// 기본 생성자
	public ReviewInfo() {
	}

	// Getters and Setters (모든 필드에 대해 생성해주세요)
	public String getAuthorImage() {
		return authorImage;
	}
	
	public void setAuthorImage(String authorImage) {
		this.authorImage = authorImage;
	}
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public int getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}

	public String getRestaurantName() {
		return restaurantName;
	}

	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}
}