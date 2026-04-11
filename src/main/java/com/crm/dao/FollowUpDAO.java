package com.crm.dao;

import com.crm.model.FollowUp;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FollowUpDAO {
    public List<FollowUp> getAllFollowUps() {
        List<FollowUp> followUps = new ArrayList<>();
        String sql = "SELECT f.*, l.name as lead_name FROM follow_ups f JOIN leads l ON f.lead_id = l.lead_id ORDER BY f.follow_date ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                followUps.add(new FollowUp(
                    rs.getInt("follow_id"),
                    rs.getInt("lead_id"),
                    rs.getString("lead_name"),
                    rs.getTimestamp("follow_date"),
                    rs.getString("follow_type"),
                    rs.getString("notes"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return followUps;
    }

    public boolean addFollowUp(FollowUp f) {
        String sql = "INSERT INTO follow_ups (lead_id, follow_date, follow_type, notes, status) VALUES (?, ?, ?, ?, 'Scheduled')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, f.getLeadId());
            ps.setTimestamp(2, f.getFollowDate());
            ps.setString(3, f.getFollowType());
            ps.setString(4, f.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateStatus(int id, String status) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE follow_ups SET status = ? WHERE follow_id = ?")) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteFollowUp(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM follow_ups WHERE follow_id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}