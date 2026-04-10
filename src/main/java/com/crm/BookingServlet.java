package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/bookings")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listBookings(request, response);
        } else if (action.equals("delete")) {
            deleteBooking(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addBooking(request, response);
        }
    }

    private void listBookings(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Booking> bookings = new ArrayList<>();
        List<Client> clients = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            
            // Get all bookings with client names
            String sql = "SELECT b.*, c.name as client_name FROM bookings b JOIN clients c ON b.client_id = c.client_id ORDER BY b.booking_date DESC";
            ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(new Booking(
                    rs.getInt("booking_id"),
                    rs.getInt("client_id"),
                    rs.getString("client_name"),
                    rs.getString("service_name"),
                    rs.getDate("booking_date"),
                    rs.getDouble("amount"),
                    rs.getString("status")
                ));
            }
            rs.close();
            ps.close();

            // Also get all clients for the "Add Booking" dropdown
            ps = con.prepareStatement("SELECT client_id, name FROM clients ORDER BY name");
            rs = ps.executeQuery();
            while (rs.next()) {
                clients.add(new Client(rs.getInt("client_id"), rs.getString("name"), null, null, null, null, null));
            }

            request.setAttribute("bookingList", bookings);
            request.setAttribute("clientList", clients);
            request.getRequestDispatcher("bookings.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        } finally {
            closeResources(con, ps);
        }
    }

    private void addBooking(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int clientId = Integer.parseInt(request.getParameter("clientId"));
        String serviceName = request.getParameter("serviceName");
        Date bookingDate = Date.valueOf(request.getParameter("bookingDate"));
        double amount = Double.parseDouble(request.getParameter("amount"));

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("INSERT INTO bookings (client_id, service_name, booking_date, amount, status) VALUES (?, ?, ?, ?, 'Confirmed')");
            ps.setInt(1, clientId);
            ps.setString(2, serviceName);
            ps.setDate(3, bookingDate);
            ps.setDouble(4, amount);
            ps.executeUpdate();
            response.sendRedirect("bookings");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("bookings?error=add");
        } finally {
            closeResources(con, ps);
        }
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM bookings WHERE booking_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("bookings");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("bookings?error=delete");
        } finally {
            closeResources(con, ps);
        }
    }

    private void closeResources(Connection con, PreparedStatement ps) {
        if(ps != null) try { ps.close(); } catch(SQLException e) {}
        if(con != null) try { con.close(); } catch(SQLException e) {}
    }
}