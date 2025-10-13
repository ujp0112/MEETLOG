package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

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
	private String cancelReason;
	private LocalDateTime cancelledAt;
	private String customerName;
	private String customerPhone;
	private String reservationDate;
	private String reservationTimeStr;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private boolean depositRequired;
	private BigDecimal depositAmount;
	private Integer userCouponId;  // 사용된 사용자 쿠폰 ID
	private BigDecimal couponDiscountAmount;  // 쿠폰 할인 금액
	private String couponName;  // 쿠폰 이름
	private String couponDiscountType;  // 쿠폰 할인 타입 (PERCENTAGE, FIXED)
	private Boolean couponIsUsed;  // 쿠폰 사용 여부
	private Integer pointsUsed;  // 사용한 포인트
	private Integer pointsEarned;  // 적립된 포인트
	private String paymentStatus;
	private String paymentOrderId;
	private LocalDateTime paymentApprovedAt;
	private String paymentProvider;
	private transient Date reservationTimeAsDate;
	private transient Date createdAtAsDate;
	private transient Date updatedAtAsDate;
	private transient Date cancelledAtAsDate;
	private transient Date paymentApprovedAtAsDate;
	private transient List<Reservation> reservations;
	
	
	
	@Override
	public String toString() {
		return "Reservation [id=" + id + ", restaurantId=" + restaurantId + ", userId=" + userId + ", restaurantName="
				+ restaurantName + ", userName=" + userName + ", reservationTime=" + reservationTime + ", partySize="
				+ partySize + ", status=" + status + ", specialRequests=" + specialRequests + ", contactPhone="
				+ contactPhone + ", cancelReason=" + cancelReason + ", cancelledAt=" + cancelledAt + ", customerName="
				+ customerName + ", customerPhone=" + customerPhone + ", reservationDate=" + reservationDate
				+ ", reservationTimeStr=" + reservationTimeStr + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt
				+ ", depositRequired=" + depositRequired + ", depositAmount=" + depositAmount + ", userCouponId="
				+ userCouponId + ", couponDiscountAmount=" + couponDiscountAmount + ", couponName=" + couponName
				+ ", couponDiscountType=" + couponDiscountType + ", couponIsUsed=" + couponIsUsed + ", pointsUsed="
				+ pointsUsed + ", pointsEarned=" + pointsEarned + ", paymentStatus=" + paymentStatus
				+ ", paymentOrderId=" + paymentOrderId + ", paymentApprovedAt=" + paymentApprovedAt
				+ ", paymentProvider=" + paymentProvider + ", reservationTimeAsDate=" + reservationTimeAsDate
				+ ", createdAtAsDate=" + createdAtAsDate + ", updatedAtAsDate=" + updatedAtAsDate
				+ ", cancelledAtAsDate=" + cancelledAtAsDate + ", paymentApprovedAtAsDate=" + paymentApprovedAtAsDate
				+ ", reservations=" + reservations + "]";
	}

	public List<Reservation> getReservations() {
        return reservations;
    }

    public void setReservations(List<Reservation> reservations) {
        this.reservations = reservations;
    }
	
	public Date getReservationTimeAsDate() {
		return reservationTimeAsDate;
	}

	public void setReservationTimeAsDate(Date reservationTimeAsDate) {
		this.reservationTimeAsDate = reservationTimeAsDate;
	}

	public Date getUpdatedAtAsDate() {
		return updatedAtAsDate;
	}

	public void setUpdatedAtAsDate(Date updatedAtAsDate) {
		this.updatedAtAsDate = updatedAtAsDate;
	}

	public String getReservationTimeStr() {
		return reservationTimeStr;
	}

	public void setReservationTimeStr(String reservationTimeStr) {
		this.reservationTimeStr = reservationTimeStr;
	}

	public void setReservationTime(LocalDateTime reservationTime) {
		this.reservationTime = reservationTime;
	}

	public Date getCreatedAtAsDate() {
		return createdAtAsDate;
	}

	public Reservation() {
		// Default constructor - IDE cache refresh
		this.depositAmount = BigDecimal.ZERO;
		this.paymentStatus = "NONE";
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
		this.depositAmount = BigDecimal.ZERO;
		this.depositRequired = false;
		this.paymentStatus = "NONE";
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

	public String getCancelReason() {
		return cancelReason;
	}

	public void setCancelReason(String cancelReason) {
		this.cancelReason = cancelReason;
	}

	public LocalDateTime getCancelledAt() {
		return cancelledAt;
	}

	public void setCancelledAt(LocalDateTime cancelledAt) {
		this.cancelledAt = cancelledAt;
		if (cancelledAt != null) {
			this.cancelledAtAsDate = Timestamp.valueOf(cancelledAt);
		} else {
			this.cancelledAtAsDate = null;
		}
	}

	public Date getCancelledAtAsDate() {
		return cancelledAtAsDate;
	}

	public void setCancelledAtAsDate(Date cancelledAtAsDate) {
		if (cancelledAtAsDate != null) {
			this.cancelledAtAsDate = cancelledAtAsDate;
		} else if (this.cancelledAt != null) {
			this.cancelledAtAsDate = Timestamp.valueOf(this.cancelledAt);
		} else {
			this.cancelledAtAsDate = null;
		}
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

	public boolean isDepositRequired() {
		return depositRequired;
	}

	public void setDepositRequired(boolean depositRequired) {
		this.depositRequired = depositRequired;
	}

	public BigDecimal getDepositAmount() {
		return depositAmount;
	}

	public void setDepositAmount(BigDecimal depositAmount) {
		this.depositAmount = depositAmount;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public String getPaymentOrderId() {
		return paymentOrderId;
	}

	public void setPaymentOrderId(String paymentOrderId) {
		this.paymentOrderId = paymentOrderId;
	}

	public LocalDateTime getPaymentApprovedAt() {
		return paymentApprovedAt;
	}

	public void setPaymentApprovedAt(LocalDateTime paymentApprovedAt) {
		this.paymentApprovedAt = paymentApprovedAt;
	}

	public String getPaymentProvider() {
		return paymentProvider;
	}

	public void setPaymentProvider(String paymentProvider) {
		this.paymentProvider = paymentProvider;
	}

	public Date getPaymentApprovedAtAsDate() {
		return paymentApprovedAtAsDate;
	}

	public void setPaymentApprovedAtAsDate(Date paymentApprovedAtAsDate) {
		this.paymentApprovedAtAsDate = paymentApprovedAtAsDate;
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

	public LocalDateTime getReservationTime() {
		return reservationTime;
	}

	public void setReservationTime(String reservationTime) {
		this.reservationTimeStr = reservationTime;
	}

	// 쿠폰 및 포인트 관련 메서드
	public Integer getUserCouponId() {
		return userCouponId;
	}

	public void setUserCouponId(Integer userCouponId) {
		this.userCouponId = userCouponId;
	}

	public BigDecimal getCouponDiscountAmount() {
		return couponDiscountAmount;
	}

	public void setCouponDiscountAmount(BigDecimal couponDiscountAmount) {
		this.couponDiscountAmount = couponDiscountAmount;
	}

	public Integer getPointsUsed() {
		return pointsUsed;
	}

	public void setPointsUsed(Integer pointsUsed) {
		this.pointsUsed = pointsUsed;
	}

	public Integer getPointsEarned() {
		return pointsEarned;
	}

	public void setPointsEarned(Integer pointsEarned) {
		this.pointsEarned = pointsEarned;
	}

	public String getCouponName() {
		return couponName;
	}

	public void setCouponName(String couponName) {
		this.couponName = couponName;
	}

	public String getCouponDiscountType() {
		return couponDiscountType;
	}

	public void setCouponDiscountType(String couponDiscountType) {
		this.couponDiscountType = couponDiscountType;
	}

	public Boolean getCouponIsUsed() {
		return couponIsUsed;
	}

	public void setCouponIsUsed(Boolean couponIsUsed) {
		this.couponIsUsed = couponIsUsed;
	}

	// 편의 메서드
	public String getFormattedReservationTime() {
		if (reservationTime == null)
			return "";
		return reservationTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
	}

	public void setCreatedAtAsDate(Date createdAtAsDate) {
		if (createdAtAsDate != null) {
			this.createdAtAsDate = createdAtAsDate;
		} else if (this.createdAt != null) {
			this.createdAtAsDate = Timestamp.valueOf(this.createdAt);
		} else {
			this.createdAtAsDate = null;
		}
	}
}
