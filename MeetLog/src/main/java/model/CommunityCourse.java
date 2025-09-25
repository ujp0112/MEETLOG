package model;

import java.time.LocalDateTime;
import java.util.List;

public class CommunityCourse {
	private int id;
	private String title;
	private String description;
	private String previewImage;
	private String author;
	private String profileImage;
	private int likes;
	private List<String> tags;
	private int userId;
	private boolean isPublic; // 공개/비공개 여부
	private int courseId; // JSP에서 사용하는 courseId
	private int likeCount; // JSP에서 사용하는 likeCount
	private int restaurantCount; // JSP에서 사용하는 restaurantCount
	private LocalDateTime createdAt; // 생성 날짜

	// --- 모든 필드에 대한 Getter/Setter ---
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPreviewImage() {
		return previewImage;
	}

	public void setPreviewImage(String previewImage) {
		this.previewImage = previewImage;
	}

	public int getLikes() {
		return likes;
	}

	public void setLikes(int likes) {
		this.likes = likes;
	}

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isPublic() {
		return isPublic;
	}

	public void setPublic(boolean isPublic) {
		this.isPublic = isPublic;
	}

	public int getCourseId() {
		return courseId;
	}

	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public int getRestaurantCount() {
		return restaurantCount;
	}

	public void setRestaurantCount(int restaurantCount) {
		this.restaurantCount = restaurantCount;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
}