package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {
            
            // Check if user already exists
            String checkSql = "SELECT * FROM users WHERE username=?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, username);
            if (checkPs.executeQuery().next()) {
                request.setAttribute("error", "Username already taken!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Insert new user
            String sql = "INSERT INTO users (user_id, full_name, username, password, role, status) VALUES (?, ?, ?, ?, ?, 'Active')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, UUID.randomUUID().toString().substring(0, 8)); // Simple ID
            ps.setString(2, fullName);
            ps.setString(3, username);
            ps.setString(4, password); // Note: Should be hashed in production
            ps.setString(5, role);

            int result = ps.executeUpdate();

            if (result > 0) {
                request.setAttribute("message", "Registration successful!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}