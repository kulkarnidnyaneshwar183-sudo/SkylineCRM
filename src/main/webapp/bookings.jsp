
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.Booking, com.crm.Client" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Booking> bookingList = (List<Booking>) request.getAttribute("bookingList");
    List<Client> clientList = (List<Client>) request.getAttribute("clientList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bookings Management - Skyline CRM</title>
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
            <h3 class="fw-bold m-0"><i class="bi bi-calendar-check me-2"></i>Bookings Management</h3>
            <button class="btn btn-warning rounded-pill px-4 text-dark fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#addBookingModal">
                <i class="bi bi-plus-lg me-2"></i>New Booking
            </button>
        </div>

        <!-- Bookings Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Booking ID</th>
                                <th>Client Name</th>
                                <th>Service</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(bookingList != null && !bookingList.isEmpty()) { 
                                for(Booking b : bookingList) { %>
                                <tr>
                                    <td class="ps-4 fw-bold">#BK-<%= b.getBookingId() %></td>
                                    <td>
                                        <div class="fw-bold"><%= b.getClientName() %></div>
                                    </td>
                                    <td><span class="badge bg-secondary bg-opacity-10 text-secondary border px-3"><%= b.getServiceName() %></span></td>
                                    <td><%= b.getBookingDate() %></td>
                                    <td class="fw-bold text-success">$<%= String.format("%.2f", b.getAmount()) %></td>
                                    <td>
                                        <span class="badge bg-success rounded-pill px-3">
                                            <%= b.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <a href="bookings?action=delete&id=<%= b.getBookingId() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Are you sure you want to cancel this booking?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="bi bi-calendar-x display-4"></i>
                                        <p class="mt-2">No bookings found.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-warning text-dark" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Create New Booking</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="bookings?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Select Client</label>
                            <select name="clientId" class="form-select" required>
                                <option value="">-- Choose Customer --</option>
                                <% if(clientList != null) { 
                                    for(Client c : clientList) { %>
                                    <option value="<%= c.getClientId() %>"><%= c.getName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Service Name</label>
                            <input type="text" name="serviceName" class="form-control" placeholder="e.g. Consulting, Design, Development" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Booking Date</label>
                            <input type="date" name="bookingDate" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Service Amount ($)</label>
                            <input type="number" step="0.01" name="amount" class="form-control" placeholder="0.00" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning rounded-pill px-4 text-dark fw-bold">Confirm Booking</button>
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