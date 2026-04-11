package com.crm.dao;

import com.crm.model.Vendor;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VendorDAO {
    public List<Vendor> getAllVendors() {
        List<Vendor> vendors = new ArrayList<>();
        String sql = "SELECT * FROM vendors ORDER BY vendor_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                vendors.add(new Vendor(
                    rs.getInt("vendor_id"),
                    rs.getString("vendor_name"),
                    rs.getString("contact_person"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("service_type"),
                    rs.getDouble("total_due"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return vendors;
    }

    public boolean addVendor(Vendor vendor) {
        String sql = "INSERT INTO vendors (vendor_name, contact_person, email, phone, service_type, total_due) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, vendor.getVendorName());
            ps.setString(2, vendor.getContactPerson());
            ps.setString(3, vendor.getEmail());
            ps.setString(4, vendor.getPhone());
            ps.setString(5, vendor.getServiceType());
            ps.setDouble(6, vendor.getTotalDue());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean recordPayment(int vendorId, double amount, Date date, String method, String ref, String userId) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            PreparedStatement ps1 = con.prepareStatement("INSERT INTO vendor_payments (vendor_id, amount, payment_date, payment_method, reference_no, recorded_by) VALUES (?, ?, ?, ?, ?, ?)");
            ps1.setInt(1, vendorId);
            ps1.setDouble(2, amount);
            ps1.setDate(3, date);
            ps1.setString(4, method);
            ps1.setString(5, ref);
            ps1.setString(6, userId);
            ps1.executeUpdate();

            PreparedStatement ps2 = con.prepareStatement("UPDATE vendors SET total_due = total_due - ? WHERE vendor_id = ?");
            ps2.setDouble(1, amount);
            ps2.setInt(2, vendorId);
            ps2.executeUpdate();

            con.commit();
            return true;
        } catch (SQLException e) {
            if(con != null) try { con.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            if(con != null) try { con.setAutoCommit(true); con.close(); } catch(SQLException e) {}
        }
    }

    public boolean deleteVendor(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM vendors WHERE vendor_id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}