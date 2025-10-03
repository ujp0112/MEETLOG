package dto;

import java.util.List;

public class StatisticsDashboardData {
    private int totalUsers;
    private int totalRestaurants;
    private int totalReservations;
    private int totalReviews;
    private double totalRevenue;
    private int totalBranches;
    private int totalEmployees;
    private double averageRating;
    private double userGrowthRate;
    private double revenueGrowthRate;
    private double restaurantGrowthRate;
    private double reservationGrowthRate;

    private List<CategoryStatistics> popularCategories;
    private List<MonthlyStatistics> monthlyGrowths;
    private List<RegionalStatistics> regionalDistributions;

    // Getters and Setters
    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalRestaurants() {
        return totalRestaurants;
    }

    public void setTotalRestaurants(int totalRestaurants) {
        this.totalRestaurants = totalRestaurants;
    }

    public int getTotalReservations() {
        return totalReservations;
    }

    public void setTotalReservations(int totalReservations) {
        this.totalReservations = totalReservations;
    }

    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalBranches() {
        return totalBranches;
    }

    public void setTotalBranches(int totalBranches) {
        this.totalBranches = totalBranches;
    }

    public int getTotalEmployees() {
        return totalEmployees;
    }

    public void setTotalEmployees(int totalEmployees) {
        this.totalEmployees = totalEmployees;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public double getUserGrowthRate() {
        return userGrowthRate;
    }

    public void setUserGrowthRate(double userGrowthRate) {
        this.userGrowthRate = userGrowthRate;
    }

    public double getRevenueGrowthRate() {
        return revenueGrowthRate;
    }

    public void setRevenueGrowthRate(double revenueGrowthRate) {
        this.revenueGrowthRate = revenueGrowthRate;
    }

    public double getRestaurantGrowthRate() {
        return restaurantGrowthRate;
    }

    public void setRestaurantGrowthRate(double restaurantGrowthRate) {
        this.restaurantGrowthRate = restaurantGrowthRate;
    }

    public double getReservationGrowthRate() {
        return reservationGrowthRate;
    }

    public void setReservationGrowthRate(double reservationGrowthRate) {
        this.reservationGrowthRate = reservationGrowthRate;
    }

    public List<CategoryStatistics> getPopularCategories() {
        return popularCategories;
    }

    public void setPopularCategories(List<CategoryStatistics> popularCategories) {
        this.popularCategories = popularCategories;
    }

    public List<MonthlyStatistics> getMonthlyGrowths() {
        return monthlyGrowths;
    }

    public void setMonthlyGrowths(List<MonthlyStatistics> monthlyGrowths) {
        this.monthlyGrowths = monthlyGrowths;
    }

    public List<RegionalStatistics> getRegionalDistributions() {
        return regionalDistributions;
    }

    public void setRegionalDistributions(List<RegionalStatistics> regionalDistributions) {
        this.regionalDistributions = regionalDistributions;
    }
}
