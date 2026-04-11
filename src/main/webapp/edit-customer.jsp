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
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .edit-card { border-radius: 15px; border: none; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card edit-card shadow-sm">
                    <div class="card-header bg-primary text-white py-3" style="border-radius: 15px 15px 0 0;">
                        <h5 class="mb-0 fw-bold"><i class="bi bi-pencil-square me-2"></i>Edit Customer: <%= client.getName() %></h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="clients?action=update" method="POST">
                            <input type="hidden" name="clientId" value="<%= client.getClientId() %>">
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Full Name</label>
                                <input type="text" name="name" class="form-control" value="<%= client.getName() %>" required>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Email Address</label>
                                    <input type="email" name="email" class="form-control" value="<%= client.getEmail() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Phone Number</label>
                                    <input type="text" name="phone" class="form-control" value="<%= client.getPhone() %>" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold">Company Name</label>
                                <input type="text" name="company" class="form-control" value="<%= client.getCompany() != null ? client.getCompany() : "" %>">
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-bold">Customer Status</label>
                                <select name="status" class="form-select">
                                    <option value="Active" <%= "Active".equals(client.getStatus()) ? "selected" : "" %>>✅ Active</option>
                                    <option value="Inactive" <%= "Inactive".equals(client.getStatus()) ? "selected" : "" %>>❌ Inactive</option>
                                </select>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary rounded-pill flex-grow-1 py-2 fw-bold">Update Customer</button>
                                <a href="clients" class="btn btn-light rounded-pill px-4 py-2">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

</body>
</html>