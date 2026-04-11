package com.crm.dao;

import com.crm.model.Booking;
import com.crm.model.Payment;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.name as client_name, f.flat_number FROM bookings b " +
                     "JOIN clients c ON b.client_id = c.client_id " +
                     "JOIN flats f ON b.flat_id = f.flat_id ORDER BY b.booking_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                bookings.add(new Booking(
                    rs.getInt("booking_id"),
                    rs.getInt("client_id"),
                    rs.getString("client_name"),
                    rs.getInt("flat_id"),
                    rs.getString("flat_number"),
                    rs.getString("booking_type"),
                    rs.getDate("booking_date"),
                    rs.getDouble("total_amount"),
                    rs.getDouble("paid_amount"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public boolean addBooking(Booking booking, double initialPayment) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Insert booking
            String sql = "INSERT INTO bookings (client_id, flat_id, booking_type, booking_date, total_amount, paid_amount, status) VALUES (?, ?, ?, ?, ?, ?, 'Confirmed')";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, booking.getClientId());
            ps.setInt(2, booking.getFlatId());
            ps.setString(3, booking.getBookingType());
            ps.setDate(4, booking.getBookingDate());
            ps.setDouble(5, booking.getTotalAmount());
            ps.setDouble(6, initialPayment);
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            int bookingId = 0;
            if(rs.next()) bookingId = rs.getInt(1);

            // 2. Insert initial payment record
            if(initialPayment > 0) {
                PreparedStatement psPay = con.prepareStatement("INSERT INTO payments (booking_id, amount, payment_date, payment_method, notes) VALUES (?, ?, ?, 'Initial', 'Down Payment')");
                psPay.setInt(1, bookingId);
                psPay.setDouble(2, initialPayment);
                psPay.setDate(3, booking.getBookingDate());
                psPay.executeUpdate();
            }

            // 3. Update flat status
            String flatStatus = "Reservation".equals(booking.getBookingType()) ? "Reserved" : "Booked";
            PreparedStatement psFlat = con.prepareStatement("UPDATE flats SET status = ? WHERE flat_id = ?");
            psFlat.setString(1, flatStatus);
            psFlat.setInt(2, booking.getFlatId());
            psFlat.executeUpdate();

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

    public boolean addPayment(int bookingId, double amount, Date date, String method) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Insert payment
            PreparedStatement ps = con.prepareStatement("INSERT INTO payments (booking_id, amount, payment_date, payment_method) VALUES (?, ?, ?, ?)");
            ps.setInt(1, bookingId);
            ps.setDouble(2, amount);
            ps.setDate(3, date);
            ps.setString(4, method);
            ps.executeUpdate();

            // 2. Update booking paid_amount
            ps = con.prepareStatement("UPDATE bookings SET paid_amount = paid_amount + ? WHERE booking_id = ?");
            ps.setDouble(1, amount);
            ps.setInt(2, bookingId);
            ps.executeUpdate();

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

    public boolean deleteBooking(int id) {
        try (Connection con = DBConnection.getConnection()) {
            // Get flat_id first to reset status
            PreparedStatement ps1 = con.prepareStatement("SELECT flat_id FROM bookings WHERE booking_id = ?");
            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();
            if(rs.next()) {
                int flatId = rs.getInt(1);
                PreparedStatement ps2 = con.prepareStatement("UPDATE flats SET status = 'Available' WHERE flat_id = ?");
                ps2.setInt(1, flatId);
                ps2.executeUpdate();
            }
            
            PreparedStatement ps3 = con.prepareStatement("DELETE FROM bookings WHERE booking_id = ?");
            ps3.setInt(1, id);
            return ps3.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}