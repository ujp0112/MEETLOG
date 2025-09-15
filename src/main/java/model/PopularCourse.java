package model;

// 인기 코스 TOP 5 정보를 담는 객체
public class PopularCourse {
    private String title;
    private long reservationCount;
    private long revenue;
    private double rating;
    
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public long getReservationCount() {
		return reservationCount;
	}
	public void setReservationCount(long reservationCount) {
		this.reservationCount = reservationCount;
	}
	public long getRevenue() {
		return revenue;
	}
	public void setRevenue(long revenue) {
		this.revenue = revenue;
	}
	public double getRating() {
		return rating;
	}
	public void setRating(double rating) {
		this.rating = rating;
	}
    
}