package model;

import java.util.Date;

/**
 * course-recommendation.jsp (사용자 화면)에서 사용할 코스 모델 클래스입니다.
 * AdminCourse와는 별도로 사용자 화면에 필요한 정보(아이콘, 평점 등)를 담습니다.
 */
public class Course {

    private int id;
    private String icon = "🎓"; // JSP에서 아이콘을 사용하므로 기본값 설정
    private String title;
    private String description;
    private String duration;
    private int price;
    private double rating; // 평균 평점

    // --- Getters and Setters ---
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }
}