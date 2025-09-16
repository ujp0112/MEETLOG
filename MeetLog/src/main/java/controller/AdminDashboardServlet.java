package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
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
        
        // 통계 데이터
        data.setTotalUsers(1250);
        data.setTotalRestaurants(89);
        data.setTotalReviews(3420);
        data.setTotalReservations(156);
        
        // 최근 활동
        List<RecentActivity> activities = new ArrayList<>();
        
        RecentActivity activity1 = new RecentActivity();
        activity1.setType("user_register");
        activity1.setDescription("새로운 사용자가 가입했습니다");
        activity1.setTime("2분 전");
        activities.add(activity1);
        
        RecentActivity activity2 = new RecentActivity();
        activity2.setType("restaurant_add");
        activity2.setDescription("새로운 맛집이 등록되었습니다");
        activity2.setTime("15분 전");
        activities.add(activity2);
        
        RecentActivity activity3 = new RecentActivity();
        activity3.setType("review_add");
        activity3.setDescription("새로운 리뷰가 작성되었습니다");
        activity3.setTime("1시간 전");
        activities.add(activity3);
        
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
