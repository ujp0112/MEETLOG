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

@WebServlet("/admin/user-analysis")
public class UserAnalysisServlet extends HttpServlet {
    
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
            
            // 사용자 분석 데이터
            UserAnalysisData analysisData = createUserAnalysisData();
            request.setAttribute("analysisData", analysisData);
            
            request.getRequestDispatcher("/WEB-INF/views/admin-user-analysis.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "사용자 분석을 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private UserAnalysisData createUserAnalysisData() {
        UserAnalysisData data = new UserAnalysisData();
        
        // 전체 사용자 통계
        data.setTotalUsers(1250);
        data.setActiveUsers(980);
        data.setNewUsersThisMonth(120);
        data.setUserGrowthRate(12.5);
        
        // 사용자 유형별 분포
        List<UserTypeDistribution> userTypes = new ArrayList<>();
        
        UserTypeDistribution type1 = new UserTypeDistribution();
        type1.setUserType("일반 사용자");
        type1.setCount(1000);
        type1.setPercentage(80.0);
        userTypes.add(type1);
        
        UserTypeDistribution type2 = new UserTypeDistribution();
        type2.setUserType("비즈니스 사용자");
        type2.setCount(200);
        type2.setPercentage(16.0);
        userTypes.add(type2);
        
        UserTypeDistribution type3 = new UserTypeDistribution();
        type3.setUserType("관리자");
        type3.setCount(50);
        type3.setPercentage(4.0);
        userTypes.add(type3);
        
        data.setUserTypes(userTypes);
        
        // 월별 사용자 가입 현황
        List<MonthlyUserRegistration> monthlyRegistrations = new ArrayList<>();
        
        MonthlyUserRegistration month1 = new MonthlyUserRegistration();
        month1.setMonth("2025-07");
        month1.setNewUsers(95);
        month1.setActiveUsers(850);
        monthlyRegistrations.add(month1);
        
        MonthlyUserRegistration month2 = new MonthlyUserRegistration();
        month2.setMonth("2025-08");
        month2.setNewUsers(110);
        month2.setActiveUsers(920);
        monthlyRegistrations.add(month2);
        
        MonthlyUserRegistration month3 = new MonthlyUserRegistration();
        month3.setMonth("2025-09");
        month3.setNewUsers(120);
        month3.setActiveUsers(980);
        monthlyRegistrations.add(month3);
        
        data.setMonthlyRegistrations(monthlyRegistrations);
        
        // 사용자 활동 통계
        UserActivityStats activityStats = new UserActivityStats();
        activityStats.setAverageSessionDuration(15.5);
        activityStats.setAveragePagesPerSession(4.2);
        activityStats.setBounceRate(25.0);
        activityStats.setReturningUsers(65.0);
        data.setActivityStats(activityStats);
        
        // 지역별 사용자 분포
        List<RegionalDistribution> regionalDistribution = new ArrayList<>();
        
        RegionalDistribution region1 = new RegionalDistribution();
        region1.setRegion("서울");
        region1.setUserCount(450);
        region1.setPercentage(36.0);
        regionalDistribution.add(region1);
        
        RegionalDistribution region2 = new RegionalDistribution();
        region2.setRegion("경기");
        region2.setUserCount(280);
        region2.setPercentage(22.4);
        regionalDistribution.add(region2);
        
        RegionalDistribution region3 = new RegionalDistribution();
        region3.setRegion("인천");
        region3.setUserCount(150);
        region3.setPercentage(12.0);
        regionalDistribution.add(region3);
        
        RegionalDistribution region4 = new RegionalDistribution();
        region4.setRegion("기타");
        region4.setUserCount(370);
        region4.setPercentage(29.6);
        regionalDistribution.add(region4);
        
        data.setRegionalDistribution(regionalDistribution);
        
        return data;
    }
    
    // 사용자 분석 데이터 클래스
    public static class UserAnalysisData {
        private int totalUsers;
        private int activeUsers;
        private int newUsersThisMonth;
        private double userGrowthRate;
        private List<UserTypeDistribution> userTypes;
        private List<MonthlyUserRegistration> monthlyRegistrations;
        private UserActivityStats activityStats;
        private List<RegionalDistribution> regionalDistribution;
        
        // Getters and Setters
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        public int getActiveUsers() { return activeUsers; }
        public void setActiveUsers(int activeUsers) { this.activeUsers = activeUsers; }
        public int getNewUsersThisMonth() { return newUsersThisMonth; }
        public void setNewUsersThisMonth(int newUsersThisMonth) { this.newUsersThisMonth = newUsersThisMonth; }
        public double getUserGrowthRate() { return userGrowthRate; }
        public void setUserGrowthRate(double userGrowthRate) { this.userGrowthRate = userGrowthRate; }
        public List<UserTypeDistribution> getUserTypes() { return userTypes; }
        public void setUserTypes(List<UserTypeDistribution> userTypes) { this.userTypes = userTypes; }
        public List<MonthlyUserRegistration> getMonthlyRegistrations() { return monthlyRegistrations; }
        public void setMonthlyRegistrations(List<MonthlyUserRegistration> monthlyRegistrations) { this.monthlyRegistrations = monthlyRegistrations; }
        public UserActivityStats getActivityStats() { return activityStats; }
        public void setActivityStats(UserActivityStats activityStats) { this.activityStats = activityStats; }
        public List<RegionalDistribution> getRegionalDistribution() { return regionalDistribution; }
        public void setRegionalDistribution(List<RegionalDistribution> regionalDistribution) { this.regionalDistribution = regionalDistribution; }
    }
    
    // 사용자 유형 분포 클래스
    public static class UserTypeDistribution {
        private String userType;
        private int count;
        private double percentage;
        
        // Getters and Setters
        public String getUserType() { return userType; }
        public void setUserType(String userType) { this.userType = userType; }
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }
    
    // 월별 사용자 가입 클래스
    public static class MonthlyUserRegistration {
        private String month;
        private int newUsers;
        private int activeUsers;
        
        // Getters and Setters
        public String getMonth() { return month; }
        public void setMonth(String month) { this.month = month; }
        public int getNewUsers() { return newUsers; }
        public void setNewUsers(int newUsers) { this.newUsers = newUsers; }
        public int getActiveUsers() { return activeUsers; }
        public void setActiveUsers(int activeUsers) { this.activeUsers = activeUsers; }
    }
    
    // 사용자 활동 통계 클래스
    public static class UserActivityStats {
        private double averageSessionDuration;
        private double averagePagesPerSession;
        private double bounceRate;
        private double returningUsers;
        
        // Getters and Setters
        public double getAverageSessionDuration() { return averageSessionDuration; }
        public void setAverageSessionDuration(double averageSessionDuration) { this.averageSessionDuration = averageSessionDuration; }
        public double getAveragePagesPerSession() { return averagePagesPerSession; }
        public void setAveragePagesPerSession(double averagePagesPerSession) { this.averagePagesPerSession = averagePagesPerSession; }
        public double getBounceRate() { return bounceRate; }
        public void setBounceRate(double bounceRate) { this.bounceRate = bounceRate; }
        public double getReturningUsers() { return returningUsers; }
        public void setReturningUsers(double returningUsers) { this.returningUsers = returningUsers; }
    }
    
    // 지역별 분포 클래스
    public static class RegionalDistribution {
        private String region;
        private int userCount;
        private double percentage;
        
        // Getters and Setters
        public String getRegion() { return region; }
        public void setRegion(String region) { this.region = region; }
        public int getUserCount() { return userCount; }
        public void setUserCount(int userCount) { this.userCount = userCount; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }
}
