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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-person-gear me-2 text-primary"></i>User Management</h3>
                <p class="text-muted small mb-0">Control system access and manage team roles.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="bi bi-person-plus-fill me-2"></i>Add System User
            </button>
        </div>

        <!-- User List Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Full Name</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(userList != null && !userList.isEmpty()) { 
                                for(User u : userList) { %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-primary bg-opacity-10 text-primary rounded-3 me-3">
                                                <%= u.getFullName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <div class="fw-bold"><%= u.getFullName() %></div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="text-muted"><%= u.getUsername() %></span>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border rounded-pill px-3">
                                            <%= u.getRole() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% 
                                            boolean isActive = "Active".equalsIgnoreCase(u.getStatus());
                                        %>
                                        <span class="badge <%= isActive ? "bg-success bg-opacity-10 text-success" : "bg-danger bg-opacity-10 text-danger" %> rounded-pill px-3">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                            <%= u.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <li>
                                                    <a class="dropdown-item rounded-2 <%= isActive ? "text-warning" : "text-success" %>" 
                                                       href="users?action=status&id=<%= u.getUserId() %>&status=<%= u.getStatus() %>">
                                                        <i class="bi bi-power me-2"></i> <%= isActive ? "Deactivate" : "Activate" %>
                                                    </a>
                                                </li>
                                                <li><a class="dropdown-item rounded-2" href="users?action=edit&id=<%= u.getUserId() %>">
                                                    <i class="bi bi-pencil me-2"></i> Edit Account</a></li>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li><a class="dropdown-item rounded-2 text-danger" href="users?action=delete&id=<%= u.getUserId() %>" onclick="return confirm('Delete this user permanently?')">
                                                    <i class="bi bi-trash me-2"></i> Delete</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <div class="mb-3">
                                            <i class="bi bi-people display-1 opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold">No users registered</h5>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="users?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Full Name</label>
                            <input type="text" name="fullName" class="form-control" placeholder="John Doe" required>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Username</label>
                                <input type="text" name="username" class="form-control" placeholder="john.doe" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Password</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">System Role</label>
                            <select name="role" class="form-select">
                                <option value="Admin">🔑 Admin</option>
                                <option value="Manager">👔 Manager</option>
                                <option value="Employee">💼 Employee</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Create Account</button>
                    </div>
                </form>
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
