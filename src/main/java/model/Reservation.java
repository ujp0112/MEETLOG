package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Reservation {
	// IDE Cache Refresh - v2.0
	private int id;
	private int restaurantId;
	private int userId;
	private String restaurantName;
	private String userName;
	private LocalDateTime reservationTime;
	private int partySize;
	private String status; // PENDING, CONFIRMED, COMPLETED, CANCELLED
	private String specialRequests;
	private String contactPhone;
	private String customerName;
	private String customerPhone;
	private String reservationDate;
	private String reservationTimeStr;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;

	public Reservation() {
		// Default constructor - IDE cache refresh
	}

	public Reservation(int restaurantId, int userId, String restaurantName, String userName,
			LocalDateTime reservationTime, int partySize, String contactPhone) {
		this.restaurantId = restaurantId;
		this.userId = userId;
		this.restaurantName = restaurantName;
		this.userName = userName;
		this.reservationTime = reservationTime;
		this.partySize = partySize;
		this.contactPhone = contactPhone;
		this.status = "PENDING";
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

	public String getRestaurantName() {
		return restaurantName;
	}

	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public int getPartySize() {
		return partySize;
	}

	public void setPartySize(int partySize) {
		this.partySize = partySize;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSpecialRequests() {
		return specialRequests;
	}

	public void setSpecialRequests(String specialRequests) {
		this.specialRequests = specialRequests;
	}

	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
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

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerPhone() {
		return customerPhone;
	}

	public void setCustomerPhone(String customerPhone) {
		this.customerPhone = customerPhone;
	}

	public String getReservationDate() {
		return reservationDate;
	}

	public void setReservationDate(String reservationDate) {
		this.reservationDate = reservationDate;
	}

	public String getReservationTime() {
		return reservationTimeStr;
	}

	public void setReservationTime(String reservationTime) {
		this.reservationTimeStr = reservationTime;
	}

	// 편의 메서드
	public String getFormattedReservationTime() {
		if (reservationTime == null)
			return "";
		return reservationTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
	}
}