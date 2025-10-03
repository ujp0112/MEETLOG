package dto;

import java.math.BigDecimal;

public class RegionalStatistics {
    private String region;
    private int restaurantCount;
    private int reservationCount;
    private BigDecimal revenue;

    public RegionalStatistics() {}

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public int getRestaurantCount() {
        return restaurantCount;
    }

    public void setRestaurantCount(int restaurantCount) {
        this.restaurantCount = restaurantCount;
    }

    public int getReservationCount() {
        return reservationCount;
    }

    public void setReservationCount(int reservationCount) {
        this.reservationCount = reservationCount;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }
}
