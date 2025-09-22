package model;

public class News {
    private String type;
    private String title;
    private String content;
    private String date;

    public News() {}

    public News(String type, String title, String content, String date) {
        this.type = type;
        this.title = title;
        this.content = content;
        this.date = date;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
