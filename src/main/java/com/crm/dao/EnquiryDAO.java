package com.crm.dao;

import com.crm.model.Enquiry;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnquiryDAO {
    public List<Enquiry> getAllEnquiries() {
        List<Enquiry> enquiries = new ArrayList<>();
        String sql = "SELECT * FROM enquiries ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                enquiries.add(new Enquiry(
                    rs.getInt("enquiry_id"),
                    rs.getString("customer_name"),
                    rs.getString("email"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return enquiries;
    }
}