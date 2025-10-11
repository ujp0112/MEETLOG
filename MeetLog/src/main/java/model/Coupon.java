package model;

import java.util.Date;

/**
 * 비즈니스 쿠폰 도메인 모델.
 */
public class Coupon {
    private int id;
    private int restaurantId;
    private String title;
    private String description;
    private String validity;
    private boolean active;
    private Date createdAt;

    // 새로운 필드
    private String discountType;    // PERCENTAGE, FIXED
    private Integer discountValue;
    private Integer minOrderAmount;
    private Integer maxDiscountAmount;  // 최대 할인 금액
    private Date validFrom;
    private Date validTo;
    private Integer usageLimit;
    private Integer perUserLimit;
    private int usageCount;

    public Coupon() {}

    public Coupon(String title, String description, String validity) {
        this.title = title;
        this.description = description;
        this.validity = validity;
    }

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

    public String getValidity() {
        return validity;
    }

    public void setValidity(String validity) {
        this.validity = validity;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public Integer getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(Integer discountValue) {
        this.discountValue = discountValue;
    }

    public Integer getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(Integer minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public Integer getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(Integer maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public Integer getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(Integer usageLimit) {
        this.usageLimit = usageLimit;
    }

    public Integer getPerUserLimit() {
        return perUserLimit;
    }

    public void setPerUserLimit(Integer perUserLimit) {
        this.perUserLimit = perUserLimit;
    }

    public int getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(int usageCount) {
        this.usageCount = usageCount;
    }

    /**
     * 쿠폰이 현재 사용 가능한지 확인
     * - is_active가 true이고
     * - 만료되지 않았고
     * - 사용 횟수가 제한을 초과하지 않은 경우
     */
    public boolean isAvailable() {
        if (!active) {
            return false;
        }

        // 만료 여부 확인
        if (isExpired()) {
            return false;
        }

        // 사용 횟수 제한 확인
        if (usageLimit != null && usageCount >= usageLimit) {
            return false;
        }

        return true;
    }

    /**
     * 쿠폰이 만료되었는지 확인
     */
    public boolean isExpired() {
        if (validTo == null) {
            return false;
        }

        Date now = new Date();
        return now.after(validTo);
    }

    /**
     * 쿠폰이 아직 시작되지 않았는지 확인
     */
    public boolean isNotStarted() {
        if (validFrom == null) {
            return false;
        }

        Date now = new Date();
        return now.before(validFrom);
    }

    /**
     * 쿠폰 상태를 문자열로 반환 (UI 표시용)
     */
    public String getStatusText() {
        if (!active) {
            return "비활성";
        }

        if (isNotStarted()) {
            return "시작 전";
        }

        if (isExpired()) {
            return "만료됨";
        }

        if (usageLimit != null && usageCount >= usageLimit) {
            return "소진됨";
        }

        return "사용 가능";
    }
}
