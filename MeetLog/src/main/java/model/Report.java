package model;

import java.sql.Timestamp;

public class Report {
    private int reportId;
    private int reporterId;
    private String reporterNickname;
    private String reportedType;
    private int reportedId;
    private Integer reportedUserId;
    private String reportedUserNickname;
    private String reason;
    private String status;
    private String adminNote;
    private Timestamp createdAt;
    private Timestamp processedAt;
    private Integer processedBy;
    private String processedByNickname;

    // Getters and Setters
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getReporterId() {
        return reporterId;
    }

    public void setReporterId(int reporterId) {
        this.reporterId = reporterId;
    }

    public String getReporterNickname() {
        return reporterNickname;
    }

    public void setReporterNickname(String reporterNickname) {
        this.reporterNickname = reporterNickname;
    }

    public String getReportedType() {
        return reportedType;
    }

    public void setReportedType(String reportedType) {
        this.reportedType = reportedType;
    }

    public int getReportedId() {
        return reportedId;
    }

    public void setReportedId(int reportedId) {
        this.reportedId = reportedId;
    }

    public Integer getReportedUserId() {
        return reportedUserId;
    }

    public void setReportedUserId(Integer reportedUserId) {
        this.reportedUserId = reportedUserId;
    }

    public String getReportedUserNickname() {
        return reportedUserNickname;
    }

    public void setReportedUserNickname(String reportedUserNickname) {
        this.reportedUserNickname = reportedUserNickname;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Timestamp processedAt) {
        this.processedAt = processedAt;
    }

    public Integer getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Integer processedBy) {
        this.processedBy = processedBy;
    }

    public String getProcessedByNickname() {
        return processedByNickname;
    }

    public void setProcessedByNickname(String processedByNickname) {
        this.processedByNickname = processedByNickname;
    }
}
