package com.springmvc.model;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationManager {

    public void createNotification(String userId, String userType, String message, String link) {
        String sql = "INSERT INTO notifications (user_id, user_type, message, link, created_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = HibernateConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId); 
            ps.setString(2, userType);
            ps.setString(3, message);
            ps.setString(4, link);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Notification> getUnreadNotifications(String userId, String userType) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? AND user_type = ? AND is_read = 0 ORDER BY created_at DESC";
        
        if ("SELLER".equals(userType)) {
             sql = "SELECT * FROM notifications WHERE user_type = 'SELLER' AND is_read = 0 ORDER BY created_at DESC";
        }

        try (Connection conn = HibernateConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (!"SELLER".equals(userType)) {
                ps.setString(1, userId);
                ps.setString(2, userType);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setUserId(rs.getString("user_id"));
                n.setUserType(rs.getString("user_type"));
                n.setMessage(rs.getString("message"));
                n.setLink(rs.getString("link"));
                n.setRead(rs.getBoolean("is_read"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void markAsRead(int notiId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = ?";
        try (Connection conn = HibernateConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notiId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}