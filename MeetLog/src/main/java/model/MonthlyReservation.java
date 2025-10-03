package model;

import java.io.Serializable;

// 월별 예약/매출 정보를 담는 객체
public class MonthlyReservation implements Serializable {
    private static final long serialVersionUID = 1L;

    private String month; // 예: "2025-09"
    private long reservationCount;
    private long revenue;
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
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
    
 
}