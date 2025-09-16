package service;

import dao.CourseStatisticsDAO;
import model.CourseStatisticsData;

public class CourseStatisticsService {
    private CourseStatisticsDAO statisticsDAO = new CourseStatisticsDAO();

    public CourseStatisticsData getCourseStatistics() throws Exception {
        CourseStatisticsData data = new CourseStatisticsData();
        
        // DAO의 각 메소드를 호출하여 데이터를 조합
        data.setTotalCourses(statisticsDAO.countTotalCourses());
        data.setActiveCourses(statisticsDAO.countActiveCourses());
        data.setTotalReservations(statisticsDAO.sumTotalReservations());
        data.setTotalRevenue(statisticsDAO.sumTotalRevenue());
        data.setAverageRating(statisticsDAO.getAverageRating());
        data.setPopularCourses(statisticsDAO.findPopularCoursesTop5());
        data.setMonthlyReservations(statisticsDAO.findMonthlyReservations());
        
        return data;
    }
}