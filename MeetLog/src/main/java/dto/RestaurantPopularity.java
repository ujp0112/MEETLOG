package dto;

import java.math.BigDecimal;
import java.sql.Date;

public class RestaurantPopularity {
    private int restaurantId;
    private String restaurantName;
    private Date weekStartDate;
    private int reservationCount;
    private int reviewCount;
    private BigDecimal rating;
    private BigDecimal reservationGrowthRate;

    public RestaurantPopularity() {}

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

    public Date getWeekStartDate() {
        return weekStartDate;
    }

    public void setWeekStartDate(Date weekStartDate) {
        this.weekStartDate = weekStartDate;
    }

    public int getReservationCount() {
        return reservationCount;
    }

    public void setReservationCount(int reservationCount) {
        this.reservationCount = reservationCount;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public void setRating(BigDecimal rating) {
        this.rating = rating;
    }

    public BigDecimal getReservationGrowthRate() {
        return reservationGrowthRate;
    }

    public void setReservationGrowthRate(BigDecimal reservationGrowthRate) {
        this.reservationGrowthRate = reservationGrowthRate;
    }
}
