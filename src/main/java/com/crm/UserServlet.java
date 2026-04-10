package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // ✅ Only Admin can access
        if (session.getAttribute("userId") == null || !"Admin".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            listUsers(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("delete")) {
            deleteUser(request, response);
        } else if (action.equals("status")) {
            changeStatus(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (session.getAttribute("userId") == null || !"Admin".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<User> users = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                users.add(new User(
                    rs.getString("user_id"),
                    rs.getString("full_name"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("status"),
                    rs.getString("profile_image")
                ));
            }
            request.setAttribute("userList", users);
            request.getRequestDispatcher("users.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=database");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (user_id, full_name, username, password, role, status) VALUES (?, ?, ?, ?, ?, 'Active')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, UUID.randomUUID().toString().substring(0, 8));
            ps.setString(2, fullName);
            ps.setString(3, username);
            ps.setString(4, password);
            ps.setString(5, role);
            ps.executeUpdate();
            response.sendRedirect("users");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("users?error=add_failed");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String id = request.getParameter("id");
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE user_id = ?");
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                    rs.getString("user_id"),
                    rs.getString("full_name"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("status"),
                    rs.getString("profile_image")
                );
                request.setAttribute("user", user);
                request.getRequestDispatcher("edit-user.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("users");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String id = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE users SET full_name = ?, role = ? WHERE user_id = ?");
            ps.setString(1, fullName);
            ps.setString(2, role);
            ps.setString(3, id);
            ps.executeUpdate();
            response.sendRedirect("users");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("users?error=update_failed");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String id = request.getParameter("id");
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
            ps.setString(1, id);
            ps.executeUpdate();
            response.sendRedirect("users");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("users?error=delete_failed");
        }
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String id = request.getParameter("id");
        String status = request.getParameter("status");
        String newStatus = status.equals("Active") ? "Inactive" : "Active";

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE users SET status = ? WHERE user_id = ?");
            ps.setString(1, newStatus);
            ps.setString(2, id);
            ps.executeUpdate();
            response.sendRedirect("users");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("users?error=status_failed");
        }
    }
}