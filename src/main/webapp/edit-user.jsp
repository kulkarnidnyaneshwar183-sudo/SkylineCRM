<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.crm.model.User" %>
<%
    if(session.getAttribute("userId") == null || !"Admin".equalsIgnoreCase((String)session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    User editUser = (User) request.getAttribute("user");
    if(editUser == null) {
        response.sendRedirect("users");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="row justify-content-center mt-4">
            <div class="col-lg-8 col-xl-5">
                <div class="card table-card border-0 shadow-sm overflow-hidden">
                    <div class="p-4 bg-white border-bottom d-flex align-items-center justify-content-between">
                        <div>
                            <h4 class="fw-bold m-0 text-dark"><i class="bi bi-person-gear me-2 text-primary"></i>Edit System User</h4>
                            <p class="text-muted small mb-0">Updating profile for: <strong><%= editUser.getUsername() %></strong></p>
                        </div>
                        <a href="users" class="btn btn-light btn-sm rounded-circle shadow-sm border">
                            <i class="bi bi-x-lg"></i>
                        </a>
                    </div>
                    
                    <div class="card-body p-4 p-md-5">
                        <form action="users?action=update" method="POST">
                            <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                            
                            <div class="row g-4 mb-4">
                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Full Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-person-badge"></i></span>
                                        <input type="text" name="fullName" class="form-control form-control-lg bg-light border-0" value="<%= editUser.getFullName() %>" required>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Username (Identifier)</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-at"></i></span>
                                        <input type="text" class="form-control form-control-lg bg-light border-0" value="<%= editUser.getUsername() %>" readonly style="cursor: not-allowed;">
                                    </div>
                                    <div class="form-text small">Username cannot be changed after creation.</div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Assigned Role</label>
                                    <select name="role" class="form-select form-select-lg bg-light border-0">
                                        <option value="Admin" <%= "Admin".equals(editUser.getRole()) ? "selected" : "" %>>🔑 Admin</option>
                                        <option value="Manager" <%= "Manager".equals(editUser.getRole()) ? "selected" : "" %>>👔 Manager</option>
                                        <option value="Employee" <%= "Employee".equals(editUser.getRole()) ? "selected" : "" %>>💼 Employee</option>
                                    </select>
                                </div>
                            </div>

                            <hr class="my-5 opacity-50">

                            <div class="d-flex flex-column flex-md-row gap-3">
                                <button type="submit" class="btn btn-primary-custom btn-lg rounded-pill flex-grow-1 shadow">
                                    <i class="bi bi-shield-check me-2"></i>Update Account
                                </button>
                                <a href="users" class="btn btn-light btn-lg rounded-pill px-5 border">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </div><!-- Close p-4 p-md-5 -->
    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/main.js"></script>
</body>
</html>
