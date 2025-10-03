package dto;

import java.math.BigDecimal;

public class CategoryStatistics {
    private String categoryName;
    private int restaurantCount;
    private int reservationCount;
    private BigDecimal revenue;

    public CategoryStatistics() {}

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
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
