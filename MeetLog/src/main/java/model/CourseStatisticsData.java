package model;

import java.io.Serializable;
import java.util.List;

// 전체 통계 데이터를 담는 최상위 객체
public class CourseStatisticsData implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalCourses;
    private int activeCourses;
    private long totalReservations;
    private long totalRevenue;
    private double averageRating;
    private List<PopularCourse> popularCourses;
    private List<MonthlyReservation> monthlyReservations;
	public int getTotalCourses() {
		return totalCourses;
	}
	public void setTotalCourses(int totalCourses) {
		this.totalCourses = totalCourses;
	}
	public int getActiveCourses() {
		return activeCourses;
	}
	public void setActiveCourses(int activeCourses) {
		this.activeCourses = activeCourses;
	}
	public long getTotalReservations() {
		return totalReservations;
	}
	public void setTotalReservations(long totalReservations) {
		this.totalReservations = totalReservations;
	}
	public long getTotalRevenue() {
		return totalRevenue;
	}
	public void setTotalRevenue(long totalRevenue) {
		this.totalRevenue = totalRevenue;
	}
	public double getAverageRating() {
		return averageRating;
	}
	public void setAverageRating(double averageRating) {
		this.averageRating = averageRating;
	}
	public List<PopularCourse> getPopularCourses() {
		return popularCourses;
	}
	public void setPopularCourses(List<PopularCourse> popularCourses) {
		this.popularCourses = popularCourses;
	}
	public List<MonthlyReservation> getMonthlyReservations() {
		return monthlyReservations;
	}
	public void setMonthlyReservations(List<MonthlyReservation> monthlyReservations) {
		this.monthlyReservations = monthlyReservations;
	}

    
    
}