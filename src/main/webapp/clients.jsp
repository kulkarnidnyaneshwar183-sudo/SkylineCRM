<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.model.Client" %>
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
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-people-fill me-2 text-primary"></i>Customer Management</h3>
                <p class="text-muted small mb-0">Maintain your database of valued customers and their history.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                <i class="bi bi-person-plus-fill me-2"></i>Add New Customer
            </button>
        </div>

        <!-- Search Bar -->
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-3">
                <form action="clients" method="GET" class="row g-3">
                    <input type="hidden" name="action" value="search">
                    <div class="col-md-8 col-lg-6">
                        <div class="search-bar-container">
                            <i class="bi bi-search"></i>
                            <input type="text" name="query" class="form-control form-control-lg border-0 bg-light" 
                                   placeholder="Search by name, email or company..." 
                                   value="<%= searchQuery != null ? searchQuery : "" %>">
                        </div>
                    </div>
                    <div class="col-md-4 col-lg-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary-custom flex-grow-1 rounded-pill">Search</button>
                        <% if(searchQuery != null) { %>
                            <a href="clients" class="btn btn-light border flex-grow-1 rounded-pill">Clear</a>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>

        <!-- Customer Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
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
                                            <div class="avatar bg-primary bg-opacity-10 text-primary rounded-3 me-3">
                                                <%= c.getName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <div>
                                                <div class="fw-bold"><%= c.getName() %></div>
                                                <div class="text-muted small">ID: #C-<%= c.getClientId() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="bi bi-envelope text-muted me-2 small"></i>
                                            <span class="small"><%= c.getEmail() %></span>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-telephone text-muted me-2 small"></i>
                                            <span class="text-muted small"><%= c.getPhone() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="text-dark fw-medium"><%= c.getCompany() != null && !c.getCompany().isEmpty() ? c.getCompany() : "N/A" %></span>
                                    </td>
                                    <td>
                                        <% 
                                            String statusClass = "bg-success bg-opacity-10 text-success";
                                            if(!"Active".equals(c.getStatus())) statusClass = "bg-secondary bg-opacity-10 text-secondary";
                                        %>
                                        <span class="badge <%= statusClass %> rounded-pill px-3">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                            <%= c.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="small fw-medium"><%= c.getCreatedAt() %></div>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <li><a class="dropdown-item rounded-2" href="clients?action=edit&id=<%= c.getClientId() %>">
                                                    <i class="bi bi-pencil me-2"></i> Edit Details</a></li>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li><a class="dropdown-item rounded-2 text-danger" href="clients?action=delete&id=<%= c.getClientId() %>" onclick="return confirm('Are you sure?')">
                                                    <i class="bi bi-trash me-2"></i> Delete</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <div class="mb-3">
                                            <i class="bi bi-people display-1 opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold">No customers found</h5>
                                        <p class="small">Try adjusting your search or add a new customer.</p>
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
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Add New Customer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="clients?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Full Name</label>
                            <input type="text" name="name" class="form-control" placeholder="Enter full name" required>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Email Address</label>
                                <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Phone Number</label>
                                <input type="text" name="phone" class="form-control" placeholder="+91 ..." required>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Company Name</label>
                            <input type="text" name="company" class="form-control" placeholder="Enter company name (optional)">
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Save Customer</button>
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