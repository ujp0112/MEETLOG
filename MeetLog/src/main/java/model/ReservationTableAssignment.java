package model;

import java.time.LocalDateTime;

/**
 * 예약-테이블 배정 정보
 */
public class ReservationTableAssignment {
    private int id;
    private int reservationId;
    private int tableId;
    private LocalDateTime assignedAt;

    public ReservationTableAssignment() {
    }

    public ReservationTableAssignment(int reservationId, int tableId) {
        this.reservationId = reservationId;
        this.tableId = tableId;
        this.assignedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public LocalDateTime getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(LocalDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }
}