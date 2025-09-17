package model;

public class Coupon {
    private String title;
    private String description;
    private String validity;

    public Coupon() {}

    public Coupon(String title, String description, String validity) {
        this.title = title;
        this.description = description;
        this.validity = validity;
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

    public String getValidity() {
        return validity;
    }

    public void setValidity(String validity) {
        this.validity = validity;
    }
}
