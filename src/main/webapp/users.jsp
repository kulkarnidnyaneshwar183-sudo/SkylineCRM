<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.model.User" %>
<%
    if(session.getAttribute("userId") == null || !"Admin".equalsIgnoreCase((String)session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    List<User> userList = (List<User>) request.getAttribute("userList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark px-4">
        <a class="navbar-brand" href="dashboard.jsp">🏢 Skyline CRM</a>
        <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <!-- Add User Form -->
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Add New User</h5>
                    </div>
                    <div class="card-body">
                        <form action="users?action=add" method="POST">
                            <div class="mb-3">
                                <label>Full Name</label>
                                <input type="text" name="fullName" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Username</label>
                                <input type="text" name="username" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Password</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Role</label>
                                <select name="role" class="form-select">
                                    <option value="Admin">Admin</option>
                                    <option value="Manager">Manager</option>
                                    <option value="Employee">Employee</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Add User</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- User List -->
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">Existing Users</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(userList != null) { 
                                    for(User u : userList) { %>
                                    <tr>
                                        <td><%= u.getFullName() %></td>
                                        <td><%= u.getUsername() %></td>
                                        <td><span class="badge bg-secondary"><%= u.getRole() %></span></td>
                                        <td>
                                            <span class="badge <%= u.getStatus().equals("Active") ? "bg-success" : "bg-danger" %>">
                                                <%= u.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="users?action=status&id=<%= u.getUserId() %>&status=<%= u.getStatus() %>" 
                                               class="btn btn-sm <%= u.getStatus().equals("Active") ? "btn-warning" : "btn-info" %>">
                                                <%= u.getStatus().equals("Active") ? "Deactivate" : "Activate" %>
                                            </a>
                                            <a href="users?action=edit&id=<%= u.getUserId() %>" class="btn btn-sm btn-primary">Edit</a>
                                            <a href="users?action=delete&id=<%= u.getUserId() %>" 
                                               class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Are you sure?')">Delete</a>
                                        </td>
                                    </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>