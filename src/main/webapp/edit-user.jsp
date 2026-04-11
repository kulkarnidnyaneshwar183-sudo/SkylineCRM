<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.crm.model.User" %>
<%
    if(session.getAttribute("userId") == null || !"Admin".equalsIgnoreCase((String)session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    User user = (User) request.getAttribute("user");
    if(user == null) {
        response.sendRedirect("users");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark px-4">
        <a class="navbar-brand" href="dashboard.jsp">🏢 Skyline CRM</a>
        <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Edit User: <%= user.getUsername() %></h5>
                    </div>
                    <div class="card-body">
                        <form action="users?action=update" method="POST">
                            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                            <div class="mb-3">
                                <label>Full Name</label>
                                <input type="text" name="fullName" class="form-control" value="<%= user.getFullName() %>" required>
                            </div>
                            <div class="mb-3">
                                <label>Username (Read-only)</label>
                                <input type="text" class="form-control" value="<%= user.getUsername() %>" readonly>
                            </div>
                            <div class="mb-3">
                                <label>Role</label>
                                <select name="role" class="form-select">
                                    <option value="Admin" <%= user.getRole().equals("Admin") ? "selected" : "" %>>Admin</option>
                                    <option value="Manager" <%= user.getRole().equals("Manager") ? "selected" : "" %>>Manager</option>
                                    <option value="Employee" <%= user.getRole().equals("Employee") ? "selected" : "" %>>Employee</option>
                                </select>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-success flex-grow-1">Update User</button>
                                <a href="users" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>