package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {

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
            listTasks(request, response);
        } else if (action.equals("complete")) {
            completeTask(request, response);
        } else if (action.equals("delete")) {
            deleteTask(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addTask(request, response);
        }
    }

    private void listTasks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Task> tasks = new ArrayList<>();
        List<User> userList = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            
            // Get all tasks with assigned user name
            String sql = "SELECT t.*, u.full_name as user_name FROM tasks t JOIN users u ON t.assigned_to = u.user_id ORDER BY t.deadline ASC";
            ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                tasks.add(new Task(
                    rs.getInt("task_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("assigned_to"),
                    rs.getString("user_name"),
                    rs.getDate("deadline"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
            rs.close();
            ps.close();

            // Get all users for assignment
            ps = con.prepareStatement("SELECT user_id, full_name, username, password, role, status FROM users");
            rs = ps.executeQuery();
            while (rs.next()) {
                userList.add(new User(
                    rs.getString("user_id"),
                    rs.getString("full_name"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("status"),
                    rs.getString("profile_image")
                ));
            }

            request.setAttribute("taskList", tasks);
            request.setAttribute("userList", userList);
            request.getRequestDispatcher("tasks.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        } finally {
            closeResources(con, ps);
        }
    }

    private void addTask(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String assignedTo = request.getParameter("assignedTo");
        Date deadline = Date.valueOf(request.getParameter("deadline"));

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("INSERT INTO tasks (title, description, assigned_to, deadline, status) VALUES (?, ?, ?, ?, 'Pending')");
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, assignedTo);
            ps.setDate(4, deadline);
            ps.executeUpdate();
            response.sendRedirect("tasks");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("tasks?error=add");
        } finally {
            closeResources(con, ps);
        }
    }

    private void completeTask(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE tasks SET status = 'Completed' WHERE task_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("tasks");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("tasks?error=complete");
        } finally {
            closeResources(con, ps);
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM tasks WHERE task_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("tasks");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("tasks?error=delete");
        } finally {
            closeResources(con, ps);
        }
    }

    private void closeResources(Connection con, PreparedStatement ps) {
        if(ps != null) try { ps.close(); } catch(SQLException e) {}
        if(con != null) try { con.close(); } catch(SQLException e) {}
    }
}