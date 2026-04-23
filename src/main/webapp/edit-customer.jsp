<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.crm.model.Client" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    Client client = (Client) request.getAttribute("client");
    if(client == null) {
        response.sendRedirect("clients");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="row justify-content-center mt-4">
            <div class="col-lg-8 col-xl-6">
                <div class="card table-card border-0 shadow-sm overflow-hidden">
                    <div class="p-4 bg-white border-bottom d-flex align-items-center justify-content-between">
                        <div>
                            <h4 class="fw-bold m-0 text-dark"><i class="bi bi-pencil-square me-2 text-primary"></i>Edit Customer Details</h4>
                            <p class="text-muted small mb-0">Update information for: <strong><%= client.getName() %></strong></p>
                        </div>
                        <a href="clients" class="btn btn-light btn-sm rounded-circle shadow-sm border">
                            <i class="bi bi-x-lg"></i>
                        </a>
                    </div>
                    
                    <div class="card-body p-4 p-md-5">
                        <form action="clients?action=update" method="POST">
                            <input type="hidden" name="clientId" value="<%= client.getClientId() %>">
                            
                            <div class="row g-4 mb-4">
                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Full Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-person"></i></span>
                                        <input type="text" name="name" class="form-control form-control-lg bg-light border-0" value="<%= client.getName() %>" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-envelope"></i></span>
                                        <input type="email" name="email" class="form-control form-control-lg bg-light border-0" value="<%= client.getEmail() %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Phone Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-telephone"></i></span>
                                        <input type="text" name="phone" class="form-control form-control-lg bg-light border-0" value="<%= client.getPhone() %>" required>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Company Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-briefcase"></i></span>
                                        <input type="text" name="company" class="form-control form-control-lg bg-light border-0" value="<%= client.getCompany() != null ? client.getCompany() : "" %>">
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Customer Status</label>
                                    <select name="status" class="form-select form-select-lg bg-light border-0">
                                        <option value="Active" <%= "Active".equals(client.getStatus()) ? "selected" : "" %>>✅ Active</option>
                                        <option value="Inactive" <%= "Inactive".equals(client.getStatus()) ? "selected" : "" %>>❌ Inactive</option>
                                    </select>
                                </div>
                            </div>

                            <hr class="my-5 opacity-50">

                            <div class="d-flex flex-column flex-md-row gap-3">
                                <button type="submit" class="btn btn-primary-custom btn-lg rounded-pill flex-grow-1 shadow">
                                    <i class="bi bi-check2-circle me-2"></i>Update Customer
                                </button>
                                <a href="clients" class="btn btn-light btn-lg rounded-pill px-5 border">
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
