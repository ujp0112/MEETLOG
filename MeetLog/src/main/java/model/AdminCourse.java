package model;

import java.util.Date;

public class AdminCourse {
	private int id;
	private String title;
	private String description;
	private String area;
	private String duration;
	private int price;
	private int maxParticipants;
	private String status; // "ACTIVE", "PENDING", "INACTIVE"
	private Date createdAt;
	private int participantCount;
	private String type; // "COMMUNITY", "OFFICIAL"
	private String previewImage;
	private Integer authorId;
	private String authorName;
	private int reservationCount;

	// --- Getters and Setters ---
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getMaxParticipants() {
		return maxParticipants;
	}

	public void setMaxParticipants(int maxParticipants) {
		this.maxParticipants = maxParticipants;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public int getParticipantCount() {
		return participantCount;
	}

	public void setParticipantCount(int participantCount) {
		this.participantCount = participantCount;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPreviewImage() {
		return previewImage;
	}

	public void setPreviewImage(String previewImage) {
		this.previewImage = previewImage;
	}

	public Integer getAuthorId() {
		return authorId;
	}

	public void setAuthorId(Integer authorId) {
		this.authorId = authorId;
	}

	public String getAuthorName() {
		return authorName;
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	public int getReservationCount() {
		return reservationCount;
	}

	public void setReservationCount(int reservationCount) {
		this.reservationCount = reservationCount;
	}
}