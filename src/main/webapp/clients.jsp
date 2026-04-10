<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.Client" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Client> clientList = (List<Client>) request.getAttribute("clientList");
    String searchQuery = (String) request.getAttribute("searchQuery");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
        .search-bar { border-radius: 20px; padding-left: 40px; }
        .search-icon { position: absolute; left: 15px; top: 10px; color: #6c757d; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-people me-2"></i>Customer Management</h3>
            <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                <i class="bi bi-plus-lg me-2"></i>Add Customer
            </button>
        </div>

        <!-- Search Bar -->
        <div class="row mb-4">
            <div class="col-md-6 position-relative">
                <form action="clients" method="GET" class="d-flex">
                    <input type="hidden" name="action" value="search">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" name="query" class="form-control search-bar shadow-sm" 
                           placeholder="Search by name, email or company..." 
                           value="<%= searchQuery != null ? searchQuery : "" %>">
                    <button type="submit" class="btn btn-dark rounded-pill ms-2 px-4">Search</button>
                    <% if(searchQuery != null) { %>
                        <a href="clients" class="btn btn-outline-secondary rounded-pill ms-2">Clear</a>
                    <% } %>
                </form>
            </div>
        </div>

        <!-- Customer Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Customer Name</th>
                                <th>Contact Details</th>
                                <th>Company</th>
                                <th>Status</th>
                                <th>Joined Date</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(clientList != null && !clientList.isEmpty()) { 
                                for(Client c : clientList) { %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                                <%= c.getName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <div class="fw-bold"><%= c.getName() %></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="small"><i class="bi bi-envelope me-1"></i><%= c.getEmail() %></div>
                                        <div class="text-muted small"><i class="bi bi-telephone me-1"></i><%= c.getPhone() %></div>
                                    </td>
                                    <td><%= c.getCompany() != null ? c.getCompany() : "-" %></td>
                                    <td>
                                        <span class="badge <%= c.getStatus().equals("Active") ? "bg-success" : "bg-secondary" %> rounded-pill">
                                            <%= c.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="small text-muted"><%= c.getCreatedAt() %></td>
                                    <td class="pe-4 text-end">
                                        <a href="clients?action=edit&id=<%= c.getClientId() %>" class="btn btn-sm btn-outline-primary me-1">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="clients?action=delete&id=<%= c.getClientId() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Are you sure you want to delete this customer?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-people display-4"></i>
                                        <p class="mt-2">No customers found.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Customer Modal -->
    <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Add New Customer</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="clients?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Full Name</label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Phone Number</label>
                            <input type="text" name="phone" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Company Name</label>
                            <input type="text" name="company" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Save Customer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>