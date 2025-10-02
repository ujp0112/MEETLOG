package controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import service.UserService;
import service.RestaurantService;
import service.ReviewService;
import service.ReservationService;
import model.User;
import model.Reservation;
import model.Review;

import util.AdminSessionUtils;

public class AdminDashboardServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final RestaurantService restaurantService = new RestaurantService();
    private final ReviewService reviewService = new ReviewService();
    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (AdminSessionUtils.requireAdmin(request, response) == null) {
                return;
            }
            
            // 관리자 대시보드 데이터
            DashboardData dashboardData = createDashboardData();
            request.setAttribute("dashboardData", dashboardData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "대시보드를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private DashboardData createDashboardData() {
        DashboardData data = new DashboardData();

        List<User> users = userService.getAllUsersIncludingInactive();
        data.setTotalUsers(users != null ? users.size() : 0);
        data.setTotalRestaurants(restaurantService.findAll().size());
        data.setTotalReviews(reviewService.findAll().size());

        List<Reservation> reservations = reservationService.searchReservations(new HashMap<>());
        data.setTotalReservations(reservations != null ? reservations.size() : 0);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        List<RecentActivity> activities = new ArrayList<>();

        if (users != null) {
            users.stream()
                    .filter(u -> u.getCreatedAt() != null)
                    .sorted(Comparator.comparing(User::getCreatedAt).reversed())
                    .limit(5)
                    .forEach(user -> {
                        RecentActivity activity = new RecentActivity();
                        String nickname = user.getNickname() != null ? user.getNickname() : user.getEmail();
                        activity.setType("USER");
                        activity.setDescription(nickname + " 회원 가입");
                        activity.setTime(user.getCreatedAt().format(formatter));
                        activities.add(activity);
                    });
        }

        if (reservations != null) {
            reservations.stream()
                    .filter(r -> r.getCreatedAt() != null)
                    .sorted(Comparator.comparing(Reservation::getCreatedAt).reversed())
                    .limit(5)
                    .forEach(reservation -> {
                        RecentActivity activity = new RecentActivity();
                        String customer = reservation.getUserName() != null ? reservation.getUserName() : "예약";
                        activity.setType("RESERVATION");
                        activity.setDescription(customer + " 님 예약 생성");
                        activity.setTime(reservation.getCreatedAt().format(formatter));
                        activities.add(activity);
                    });
        }

        reviewService.findAll().stream()
                .filter(review -> review.getCreatedAt() != null)
                .sorted(Comparator.comparing(Review::getCreatedAt).reversed())
                .limit(5)
                .forEach(review -> {
                    RecentActivity activity = new RecentActivity();
                    String author = review.getAuthor() != null ? review.getAuthor() : "회원";
                    activity.setType("REVIEW");
                    activity.setDescription(author + " 님 리뷰 작성");
                    activity.setTime(review.getCreatedAt().format(formatter));
                    activities.add(activity);
                });

        activities.sort((a, b) -> b.getTime().compareTo(a.getTime()));
        if (activities.size() > 10) {
            activities.subList(10, activities.size()).clear();
        }

        data.setRecentActivities(activities);
        return data;
    }
    
    // 대시보드 데이터 클래스
    public static class DashboardData {
        private int totalUsers;
        private int totalRestaurants;
        private int totalReviews;
        private int totalReservations;
        private List<RecentActivity> recentActivities;
        
        // Getters and Setters
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        public int getTotalRestaurants() { return totalRestaurants; }
        public void setTotalRestaurants(int totalRestaurants) { this.totalRestaurants = totalRestaurants; }
        public int getTotalReviews() { return totalReviews; }
        public void setTotalReviews(int totalReviews) { this.totalReviews = totalReviews; }
        public int getTotalReservations() { return totalReservations; }
        public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }
        public List<RecentActivity> getRecentActivities() { return recentActivities; }
        public void setRecentActivities(List<RecentActivity> recentActivities) { this.recentActivities = recentActivities; }
    }
    
    // 최근 활동 클래스
    public static class RecentActivity {
        private String type;
        private String description;
        private String time;
        
        // Getters and Setters
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public String getTime() { return time; }
        public void setTime(String time) { this.time = time; }
    }
}
