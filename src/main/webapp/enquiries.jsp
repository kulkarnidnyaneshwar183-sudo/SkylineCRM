<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.model.Enquiry" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Enquiry> enquiryList = (List<Enquiry>) request.getAttribute("enquiryList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Enquiries Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-chat-dots me-2"></i>Customer Enquiries</h3>
            <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addEnquiryModal">
                <i class="bi bi-plus-lg me-2"></i>New Enquiry
            </button>
        </div>

        <!-- Enquiries Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Customer</th>
                                <th>Subject</th>
                                <th>Message</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(enquiryList != null && !enquiryList.isEmpty()) { 
                                for(Enquiry e : enquiryList) { %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold"><%= e.getCustomerName() %></div>
                                        <div class="small text-muted"><%= e.getEmail() %></div>
                                    </td>
                                    <td><span class="fw-bold text-primary"><%= e.getSubject() %></span></td>
                                    <td>
                                        <div class="text-truncate" style="max-width: 250px;" title="<%= e.getMessage() %>">
                                            <%= e.getMessage() %>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge <%= e.getStatus().equals("Resolved") ? "bg-success" : "bg-warning text-dark" %> rounded-pill">
                                            <%= e.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="small text-muted"><%= e.getCreatedAt() %></td>
                                    <td class="pe-4 text-end text-nowrap">
                                        <% if(e.getStatus().equals("Open")) { %>
                                            <a href="enquiries?action=resolve&id=<%= e.getEnquiryId() %>" 
                                               class="btn btn-sm btn-outline-success me-1">
                                                <i class="bi bi-check-circle"></i> Resolve
                                            </a>
                                        <% } %>
                                        <a href="enquiries?action=delete&id=<%= e.getEnquiryId() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Are you sure you want to delete this enquiry?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-chat-left-dots display-4"></i>
                                        <p class="mt-2">No enquiries found.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Enquiry Modal -->
    <div class="modal fade" id="addEnquiryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Add New Enquiry</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="enquiries?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Customer Name</label>
                            <input type="text" name="customerName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Subject</label>
                            <input type="text" name="subject" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Message</label>
                            <textarea name="message" class="form-control" rows="4" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Submit Enquiry</button>
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