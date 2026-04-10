package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/vendors")
public class VendorServlet extends HttpServlet {

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
            listVendors(request, response);
        } else if (action.equals("delete")) {
            deleteVendor(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addVendor(request, response);
        } else if ("pay".equals(action)) {
            recordPayment(request, response);
        }
    }

    private void listVendors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Vendor> vendors = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM vendors ORDER BY vendor_name";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
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
            request.setAttribute("vendorList", vendors);
            request.getRequestDispatcher("vendors.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        }
    }

    private void addVendor(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String name = request.getParameter("vendorName");
        String contact = request.getParameter("contactPerson");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String service = request.getParameter("serviceType");
        double due = Double.parseDouble(request.getParameter("totalDue"));

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO vendors (vendor_name, contact_person, email, phone, service_type, total_due) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, contact);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, service);
            ps.setDouble(6, due);
            ps.executeUpdate();
            response.sendRedirect("vendors");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("vendors?error=add");
        }
    }

    private void recordPayment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        
        int vendorId = Integer.parseInt(request.getParameter("vendorId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        Date date = Date.valueOf(request.getParameter("paymentDate"));
        String method = request.getParameter("paymentMethod");
        String ref = request.getParameter("referenceNo");

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Insert payment record
            String sql1 = "INSERT INTO vendor_payments (vendor_id, amount, payment_date, payment_method, reference_no, recorded_by) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps1 = con.prepareStatement(sql1);
            ps1.setInt(1, vendorId);
            ps1.setDouble(2, amount);
            ps1.setDate(3, date);
            ps1.setString(4, method);
            ps1.setString(5, ref);
            ps1.setString(6, userId);
            ps1.executeUpdate();

            // 2. Update vendor due balance
            String sql2 = "UPDATE vendors SET total_due = total_due - ? WHERE vendor_id = ?";
            PreparedStatement ps2 = con.prepareStatement(sql2);
            ps2.setDouble(1, amount);
            ps2.setInt(2, vendorId);
            ps2.executeUpdate();

            con.commit();
            response.sendRedirect("vendors");
        } catch (SQLException e) {
            if(con != null) try { con.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
            response.sendRedirect("vendors?error=pay");
        } finally {
            if(con != null) try { con.setAutoCommit(true); con.close(); } catch(SQLException e) {}
        }
    }

    private void deleteVendor(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM vendors WHERE vendor_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("vendors");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("vendors?error=delete");
        }
    }
}