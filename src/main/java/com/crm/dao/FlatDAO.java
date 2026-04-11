package com.crm.dao;

import com.crm.model.Flat;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FlatDAO {
    public List<Flat> getAllFlats() {
        List<Flat> flats = new ArrayList<>();
        String sql = "SELECT * FROM flats ORDER BY building_name, flat_number";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                flats.add(new Flat(
                    rs.getInt("flat_id"),
                    rs.getString("flat_number"),
                    rs.getString("building_name"),
                    rs.getInt("floor"),
                    rs.getString("bhk"),
                    rs.getDouble("area_sqft"),
                    rs.getDouble("price"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return flats;
    }

    public boolean addFlat(Flat flat) {
        String sql = "INSERT INTO flats (flat_number, building_name, floor, bhk, area_sqft, price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, flat.getFlatNumber());
            ps.setString(2, flat.getBuildingName());
            ps.setInt(3, flat.getFloor());
            ps.setString(4, flat.getBhk());
            ps.setDouble(5, flat.getAreaSqft());
            ps.setDouble(6, flat.getPrice());
            ps.setString(7, flat.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateFlatStatus(int flatId, String status, double price) {
        String sql = "UPDATE flats SET status = ?, price = ? WHERE flat_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setDouble(2, price);
            ps.setInt(3, flatId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteFlat(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM flats WHERE flat_id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}