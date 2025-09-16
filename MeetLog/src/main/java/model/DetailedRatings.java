package model;

public class DetailedRatings {
    private double taste;
    private double price;
    private double service;

    public DetailedRatings() {}

    public DetailedRatings(double taste, double price, double service) {
        this.taste = taste;
        this.price = price;
        this.service = service;
    }

    public double getTaste() {
        return taste;
    }

    public void setTaste(double taste) {
        this.taste = taste;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getService() {
        return service;
    }

    public void setService(double service) {
        this.service = service;
    }
}
