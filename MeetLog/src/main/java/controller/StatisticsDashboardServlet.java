package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import util.AdminSessionUtils;


public class StatisticsDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }
            
            StatisticsData statisticsData = createStatisticsData();
            request.setAttribute("statisticsData", statisticsData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-statistics-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "통계 대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private StatisticsData createStatisticsData() {
        StatisticsData data = new StatisticsData();

        data.setTotalUsers(1250);
        data.setTotalRestaurants(45);
        data.setTotalReservations(3200);
        data.setTotalReviews(890);
        data.setTotalRevenue(45000000.0);
        data.setTotalBranches(12);
        data.setTotalEmployees(85);
        data.setAverageRating(4.3);
        data.setUserGrowthRate(12.5);
        data.setRevenueGrowthRate(8.3);
        data.setRestaurantGrowthRate(5.2);
        data.setReservationGrowthRate(15.8);

        List<DailyStats> dailyStats = new ArrayList<>();
        DailyStats day1 = new DailyStats();
        day1.setDate("2025-09-14");
        day1.setReservations(25);
        day1.setReviews(12);
        dailyStats.add(day1);
        data.setDailyStats(dailyStats);

        List<CategoryStats> categories = new ArrayList<>();
        categories.add(new CategoryStats("한식", 15, 890, 12000000.0));
        categories.add(new CategoryStats("양식", 12, 720, 9500000.0));
        categories.add(new CategoryStats("중식", 8, 450, 6200000.0));
        categories.add(new CategoryStats("일식", 6, 380, 5800000.0));
        categories.add(new CategoryStats("카페", 4, 210, 3100000.0));
        data.setPopularCategories(categories);

        List<MonthlyGrowth> monthlyGrowths = new ArrayList<>();
        monthlyGrowths.add(new MonthlyGrowth("2025-06", 980, 38, 2450, 32000000.0));
        monthlyGrowths.add(new MonthlyGrowth("2025-07", 1050, 41, 2780, 37500000.0));
        monthlyGrowths.add(new MonthlyGrowth("2025-08", 1180, 43, 3050, 42000000.0));
        monthlyGrowths.add(new MonthlyGrowth("2025-09", 1250, 45, 3200, 45000000.0));
        data.setMonthlyGrowths(monthlyGrowths);

        List<RegionalDistribution> regions = new ArrayList<>();
        regions.add(new RegionalDistribution("서울", 20, 1800, 25000000.0));
        regions.add(new RegionalDistribution("경기", 12, 850, 12000000.0));
        regions.add(new RegionalDistribution("부산", 8, 450, 6000000.0));
        regions.add(new RegionalDistribution("대구", 3, 180, 1500000.0));
        regions.add(new RegionalDistribution("인천", 2, 120, 500000.0));
        data.setRegionalDistributions(regions);

        return data;
    }
    
    public static class StatisticsData {
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
        private List<DailyStats> dailyStats;
        private List<CategoryStats> popularCategories;
        private List<MonthlyGrowth> monthlyGrowths;
        private List<RegionalDistribution> regionalDistributions;

        // Getters and Setters
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        public int getTotalRestaurants() { return totalRestaurants; }
        public void setTotalRestaurants(int totalRestaurants) { this.totalRestaurants = totalRestaurants; }
        public int getTotalReservations() { return totalReservations; }
        public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }
        public int getTotalReviews() { return totalReviews; }
        public void setTotalReviews(int totalReviews) { this.totalReviews = totalReviews; }
        public double getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
        public int getTotalBranches() { return totalBranches; }
        public void setTotalBranches(int totalBranches) { this.totalBranches = totalBranches; }
        public int getTotalEmployees() { return totalEmployees; }
        public void setTotalEmployees(int totalEmployees) { this.totalEmployees = totalEmployees; }
        public double getAverageRating() { return averageRating; }
        public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
        public double getUserGrowthRate() { return userGrowthRate; }
        public void setUserGrowthRate(double userGrowthRate) { this.userGrowthRate = userGrowthRate; }
        public double getRevenueGrowthRate() { return revenueGrowthRate; }
        public void setRevenueGrowthRate(double revenueGrowthRate) { this.revenueGrowthRate = revenueGrowthRate; }
        public double getRestaurantGrowthRate() { return restaurantGrowthRate; }
        public void setRestaurantGrowthRate(double restaurantGrowthRate) { this.restaurantGrowthRate = restaurantGrowthRate; }
        public double getReservationGrowthRate() { return reservationGrowthRate; }
        public void setReservationGrowthRate(double reservationGrowthRate) { this.reservationGrowthRate = reservationGrowthRate; }
        public List<DailyStats> getDailyStats() { return dailyStats; }
        public void setDailyStats(List<DailyStats> dailyStats) { this.dailyStats = dailyStats; }
        public List<CategoryStats> getPopularCategories() { return popularCategories; }
        public void setPopularCategories(List<CategoryStats> popularCategories) { this.popularCategories = popularCategories; }
        public List<MonthlyGrowth> getMonthlyGrowths() { return monthlyGrowths; }
        public void setMonthlyGrowths(List<MonthlyGrowth> monthlyGrowths) { this.monthlyGrowths = monthlyGrowths; }
        public List<RegionalDistribution> getRegionalDistributions() { return regionalDistributions; }
        public void setRegionalDistributions(List<RegionalDistribution> regionalDistributions) { this.regionalDistributions = regionalDistributions; }
    }
    
    public static class DailyStats {
        private String date;
        private int reservations;
        private int reviews;

        // Getters and Setters
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public int getReservations() { return reservations; }
        public void setReservations(int reservations) { this.reservations = reservations; }
        public int getReviews() { return reviews; }
        public void setReviews(int reviews) { this.reviews = reviews; }
    }

    public static class CategoryStats {
        private String name;
        private int restaurantCount;
        private int reservationCount;
        private double revenue;

        public CategoryStats(String name, int restaurantCount, int reservationCount, double revenue) {
            this.name = name;
            this.restaurantCount = restaurantCount;
            this.reservationCount = reservationCount;
            this.revenue = revenue;
        }

        // Getters and Setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public int getRestaurantCount() { return restaurantCount; }
        public void setRestaurantCount(int restaurantCount) { this.restaurantCount = restaurantCount; }
        public int getReservationCount() { return reservationCount; }
        public void setReservationCount(int reservationCount) { this.reservationCount = reservationCount; }
        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }
    }

    public static class MonthlyGrowth {
        private String month;
        private int users;
        private int restaurants;
        private int reservations;
        private double revenue;

        public MonthlyGrowth(String month, int users, int restaurants, int reservations, double revenue) {
            this.month = month;
            this.users = users;
            this.restaurants = restaurants;
            this.reservations = reservations;
            this.revenue = revenue;
        }

        // Getters and Setters
        public String getMonth() { return month; }
        public void setMonth(String month) { this.month = month; }
        public int getUsers() { return users; }
        public void setUsers(int users) { this.users = users; }
        public int getRestaurants() { return restaurants; }
        public void setRestaurants(int restaurants) { this.restaurants = restaurants; }
        public int getReservations() { return reservations; }
        public void setReservations(int reservations) { this.reservations = reservations; }
        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }
    }

    public static class RegionalDistribution {
        private String region;
        private int restaurantCount;
        private int reservationCount;
        private double revenue;

        public RegionalDistribution(String region, int restaurantCount, int reservationCount, double revenue) {
            this.region = region;
            this.restaurantCount = restaurantCount;
            this.reservationCount = reservationCount;
            this.revenue = revenue;
        }

        // Getters and Setters
        public String getRegion() { return region; }
        public void setRegion(String region) { this.region = region; }
        public int getRestaurantCount() { return restaurantCount; }
        public void setRestaurantCount(int restaurantCount) { this.restaurantCount = restaurantCount; }
        public int getReservationCount() { return reservationCount; }
        public void setReservationCount(int reservationCount) { this.reservationCount = reservationCount; }
        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }
    }
}
