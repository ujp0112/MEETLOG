package model;

import java.time.LocalDateTime;
import java.util.List;

public class Restaurant {
    // 기본 정보
    private int id;
    private String name;
    private String category;
    private String address;
    private String phone;
    private String mainImage;
    private String description;
    private double latitude;
    private double longitude;
    private int ownerId;
    
    // ======================== [추가된 필드 시작] ========================
    /**
     * JSP에서 ${restaurant.averageRating} 으로 사용하기 위한 필드입니다.
     * 이 값은 데이터베이스 쿼리에서 계산되어 채워집니다.
     */
    private double averageRating;
    
    /**
     * JSP에서 ${restaurant.reviewCount} 로 사용하기 위한 필드입니다.
     * 이 값은 데이터베이스 쿼리에서 계산되어 채워집니다.
     */
    private int reviewCount;
    // ======================== [추가된 필드 끝] ==========================

    // 운영 정보
    private String parkingInfo;
    
    // 생성 시각, 수정 시각
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // --- 이하 기존 필드 및 Getter/Setter (필요시 사용) ---
    private String location;
	private String jibunAddress;
	private String hours;
	private String image;
	private String imagePath;
	private String imageUrl;
	private double rating;
	private int likes;
	private boolean parking;
	private boolean isActive;
	private String operatingDays;
    private String operatingTimesText;
    private String breakTimeText;
	private int priceRange;
	private String atmosphere;
	private List<String> dietaryOptions;
	private List<String> paymentMethods;
	private DetailedRatings detailedRatings;
	private List<String> additionalImages;

	// 기본 생성자
    public Restaurant() {}
    
    // ======================== [추가된 Getter/Setter 시작] ========================
    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getReviewCount() {
        return reviewCount;
    }
    
    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }
    
    private List<Menu> menuList;
    private List<Review> reviews;
    private List<Coupon> coupons;
    private List<QnA> qna;
    private List<Reservation> reservationList;

    public List<Menu> getMenuList() {
		return menuList;
	}

	public void setMenuList(List<Menu> menuList) {
		this.menuList = menuList;
	}

	public List<Review> getReviews() {
		return reviews;
	}

	public void setReviews(List<Review> reviews) {
		this.reviews = reviews;
	}

	public List<Coupon> getCoupons() {
		return coupons;
	}

	public void setCoupons(List<Coupon> coupons) {
		this.coupons = coupons;
	}

	public List<QnA> getQna() {
		return qna;
	}

	public void setQna(List<QnA> qna) {
		this.qna = qna;
	}

	public List<Reservation> getReservationList() {
		return reservationList;
	}

	public void setReservationList(List<Reservation> reservationList) {
		this.reservationList = reservationList;
	}
    // ======================== [추가된 Getter/Setter 끝] ==========================


    // --- 이하 기존 Getter/Setter 메서드들 (수정 없음) ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }
    
    public String getParkingInfo() {
		return parkingInfo;
	}

	public void setParkingInfo(String parkingInfo) {
		this.parkingInfo = parkingInfo;
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
    
    public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}
	
	public String getJibunAddress() {
		return jibunAddress;
	}

	public void setJibunAddress(String jibunAddress) {
		this.jibunAddress = jibunAddress;
	}
	
	public String getHours() {
		return hours;
	}

	public void setHours(String hours) {
		this.hours = hours;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public int getLikes() {
		return likes;
	}

	public void setLikes(int likes) {
		this.likes = likes;
	}

	public boolean isParking() {
		return parking;
	}

	public void setParking(boolean parking) {
		this.parking = parking;
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

	public String getOperatingDays() {
		return operatingDays;
	}

	public void setOperatingDays(String operatingDays) {
		this.operatingDays = operatingDays;
	}

	public String getOperatingTimesText() {
		return operatingTimesText;
	}

	public void setOperatingTimesText(String operatingTimesText) {
		this.operatingTimesText = operatingTimesText;
	}

	public String getBreakTimeText() {
		return breakTimeText;
	}

	public void setBreakTimeText(String breakTimeText) {
		this.breakTimeText = breakTimeText;
	}
	
	public int getPriceRange() {
		return priceRange;
	}

	public void setPriceRange(int priceRange) {
		this.priceRange = priceRange;
	}

	public String getAtmosphere() {
		return atmosphere;
	}

	public void setAtmosphere(String atmosphere) {
		this.atmosphere = atmosphere;
	}

	public List<String> getDietaryOptions() {
		return dietaryOptions;
	}

	public void setDietaryOptions(List<String> dietaryOptions) {
		this.dietaryOptions = dietaryOptions;
	}

	public List<String> getPaymentMethods() {
		return paymentMethods;
	}

	public void setPaymentMethods(List<String> paymentMethods) {
		this.paymentMethods = paymentMethods;
	}

	public DetailedRatings getDetailedRatings() {
		return detailedRatings;
	}

	public void setDetailedRatings(DetailedRatings detailedRatings) {
		this.detailedRatings = detailedRatings;
	}
	
	public List<String> getAdditionalImages() {
		return additionalImages;
	}
	
	public void setAdditionalImages(List<String> additionalImages) {
		this.additionalImages = additionalImages;
	}
	
}
