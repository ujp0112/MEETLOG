package dto;

import java.math.BigDecimal;

public class MonthlyStatistics {
    private String yearMonth;
    private int totalUsers;
    private int newUsers;
    private int totalRestaurants;
    private int newRestaurants;
    private int totalReservations;
    private BigDecimal totalRevenue;
    

    @Override
	public String toString() {
		return "MonthlyStatistics [yearMonth=" + yearMonth + ", totalUsers=" + totalUsers + ", newUsers=" + newUsers
				+ ", totalRestaurants=" + totalRestaurants + ", newRestaurants=" + newRestaurants
				+ ", totalReservations=" + totalReservations + ", totalRevenue=" + totalRevenue + "]";
	}

	public MonthlyStatistics() {}

    public String getYearMonth() {
        return yearMonth;
    }

    public void setYearMonth(String yearMonth) {
        this.yearMonth = yearMonth;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getNewUsers() {
        return newUsers;
    }

    public void setNewUsers(int newUsers) {
        this.newUsers = newUsers;
    }

    public int getTotalRestaurants() {
        return totalRestaurants;
    }

    public void setTotalRestaurants(int totalRestaurants) {
        this.totalRestaurants = totalRestaurants;
    }

    public int getNewRestaurants() {
        return newRestaurants;
    }

    public void setNewRestaurants(int newRestaurants) {
        this.newRestaurants = newRestaurants;
    }

    public int getTotalReservations() {
        return totalReservations;
    }

    public void setTotalReservations(int totalReservations) {
        this.totalReservations = totalReservations;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
