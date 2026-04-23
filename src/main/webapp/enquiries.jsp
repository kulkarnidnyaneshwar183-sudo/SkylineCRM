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
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-chat-dots-fill me-2 text-primary"></i>Customer Enquiries</h3>
                <p class="text-muted small mb-0">Manage and respond to customer queries and feedback.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addEnquiryModal">
                <i class="bi bi-plus-lg me-2"></i>New Enquiry
            </button>
        </div>

        <!-- Enquiries Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Customer</th>
                                <th>Enquiry Details</th>
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
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-primary bg-opacity-10 text-primary rounded-3 me-3">
                                                <%= e.getCustomerName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <div>
                                                <div class="fw-bold"><%= e.getCustomerName() %></div>
                                                <div class="text-muted small"><%= e.getEmail() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-medium text-primary"><%= e.getSubject() %></div>
                                        <div class="text-muted small">ID: #ENQ-<%= e.getEnquiryId() %></div>
                                    </td>
                                    <td>
                                        <div class="text-muted small text-truncate" style="max-width: 200px;" title="<%= e.getMessage() %>">
                                            <%= e.getMessage() %>
                                        </div>
                                    </td>
                                    <td>
                                        <% 
                                            String statusClass = "bg-warning bg-opacity-10 text-warning";
                                            if("Resolved".equals(e.getStatus())) statusClass = "bg-success bg-opacity-10 text-success";
                                        %>
                                        <span class="badge <%= statusClass %> rounded-pill px-3">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                            <%= e.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="small fw-medium"><%= e.getCreatedAt() %></div>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <% if(e.getStatus().equals("Open")) { %>
                                                    <li><a class="dropdown-item rounded-2 text-success" href="enquiries?action=resolve&id=<%= e.getEnquiryId() %>">
                                                        <i class="bi bi-check-circle me-2"></i> Mark Resolved</a></li>
                                                <% } %>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li><a class="dropdown-item rounded-2 text-danger" href="enquiries?action=delete&id=<%= e.getEnquiryId() %>" onclick="return confirm('Are you sure?')">
                                                    <i class="bi bi-trash me-2"></i> Delete</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <div class="mb-3">
                                            <i class="bi bi-chat-left-dots display-1 opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold">No enquiries found</h5>
                                        <p class="small">New customer enquiries will appear here.</p>
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
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">New Customer Enquiry</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="enquiries?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Customer Name</label>
                            <input type="text" name="customerName" class="form-control" placeholder="Enter name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="customer@example.com" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Subject</label>
                            <input type="text" name="subject" class="form-control" placeholder="What is this about?" required>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Message</label>
                            <textarea name="message" class="form-control" rows="4" placeholder="Type the enquiry message here..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Submit Enquiry</button>
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