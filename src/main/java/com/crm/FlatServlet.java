package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/inventory")
public class FlatServlet extends HttpServlet {

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
            listFlats(request, response);
        } else if (action.equals("delete")) {
            deleteFlat(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addFlat(request, response);
        } else if ("update".equals(action)) {
            updateFlat(request, response);
        }
    }

    private void listFlats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Flat> flats = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM flats ORDER BY building_name, flat_number";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
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
            request.setAttribute("flatList", flats);
            request.getRequestDispatcher("inventory.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        }
    }

    private void addFlat(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String flatNumber = request.getParameter("flatNumber");
        String buildingName = request.getParameter("buildingName");
        int floor = Integer.parseInt(request.getParameter("floor"));
        String bhk = request.getParameter("bhk");
        double areaSqft = Double.parseDouble(request.getParameter("areaSqft"));
        double price = Double.parseDouble(request.getParameter("price"));
        String status = request.getParameter("status");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO flats (flat_number, building_name, floor, bhk, area_sqft, price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, flatNumber);
            ps.setString(2, buildingName);
            ps.setInt(3, floor);
            ps.setString(4, bhk);
            ps.setDouble(5, areaSqft);
            ps.setDouble(6, price);
            ps.setString(7, status);
            ps.executeUpdate();
            response.sendRedirect("inventory");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("inventory?error=add");
        }
    }

    private void updateFlat(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int flatId = Integer.parseInt(request.getParameter("flatId"));
        String status = request.getParameter("status");
        double price = Double.parseDouble(request.getParameter("price"));

        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE flats SET status = ?, price = ? WHERE flat_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setDouble(2, price);
            ps.setInt(3, flatId);
            ps.executeUpdate();
            response.sendRedirect("inventory");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("inventory?error=update");
        }
    }

    private void deleteFlat(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM flats WHERE flat_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("inventory");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("inventory?error=delete");
        }
    }
}