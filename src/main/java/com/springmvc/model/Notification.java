package com.springmvc.model;
import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private String userId; 
    private String userType;
    private String message;
    private String link;
    private boolean isRead;
    private Timestamp createdAt;

    // Getter & Setter
    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }
    
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    
    public String getUserType() { return userType; }
    public void setUserType(String userType) { this.userType = userType; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}