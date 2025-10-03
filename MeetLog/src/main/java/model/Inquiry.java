package model;

import java.sql.Timestamp;

public class Inquiry {
    private int id;              // inquiry_id
    private String userName;     // user_name
    private String subject;      // subject
    private String content;      // content
    private String status;       // status (PENDING, IN_PROGRESS, RESOLVED)
    private String reply;        // reply
    private Timestamp createdAt; // created_at
    private Timestamp updatedAt; // updated_at

    public Inquiry() {}

    public Inquiry(String userName, String subject, String content) {
        this.userName = userName;
        this.subject = subject;
        this.content = content;
        this.status = "PENDING";
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Alias getter for JSP compatibility
    public int getInquiryId() {
        return id;
    }

    public void setInquiryId(int inquiryId) {
        this.id = inquiryId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Inquiry{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", subject='" + subject + '\'' +
                ", content='" + content + '\'' +
                ", status='" + status + '\'' +
                ", reply='" + reply + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}