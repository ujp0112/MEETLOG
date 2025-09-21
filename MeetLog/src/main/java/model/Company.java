package model;

import java.sql.Timestamp;

public class Company {
    private int id; // DB 컬럼 타입(INT)과 일치시키기 위해 int로 변경했습니다.
    private String name;
    private Timestamp createdAt;

    // Getters and Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}