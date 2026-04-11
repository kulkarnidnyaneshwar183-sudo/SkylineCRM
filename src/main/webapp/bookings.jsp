<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.model.Booking, com.crm.model.Client, com.crm.model.Flat" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Booking> bookingList = (List<Booking>) request.getAttribute("bookingList");
    List<Client> clientList = (List<Client>) request.getAttribute("clientList");
    List<Flat> flatList = (List<Flat>) request.getAttribute("flatList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
        .progress { height: 10px; border-radius: 5px; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-calendar-check me-2"></i>Real Estate Bookings</h3>
            <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addBookingModal">
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
                                <th class="ps-4">Client / Property</th>
                                <th>Booking Type</th>
                                <th>Total Price</th>
                                <th>Payment Status</th>
                                <th>Date</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(bookingList != null && !bookingList.isEmpty()) { 
                                for(Booking b : bookingList) { 
                                    double percentage = (b.getPaidAmount() / b.getTotalAmount()) * 100;
                                    String progressClass = percentage >= 100 ? "bg-success" : percentage > 50 ? "bg-primary" : "bg-warning";
                            %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-primary"><%= b.getClientName() %></div>
                                        <div class="small text-muted">Flat No: <%= b.getFlatNumber() %></div>
                                    </td>
                                    <td>
                                        <span class="badge <%= "Reservation".equals(b.getBookingType()) ? "bg-info" : "bg-dark" %> rounded-pill">
                                            <%= b.getBookingType() %>
                                        </span>
                                    </td>
                                    <td><strong>₹<%= String.format("%.2f", b.getTotalAmount()) %></strong></td>
                                    <td style="min-width: 150px;">
                                        <div class="small mb-1">₹<%= String.format("%.0f", b.getPaidAmount()) %> Paid (<%= Math.round(percentage) %>%)</div>
                                        <div class="progress">
                                            <div class="progress-bar <%= progressClass %>" style="width: <%= percentage %>%"></div>
                                        </div>
                                    </td>
                                    <td class="small"><%= b.getBookingDate() %></td>
                                    <td class="pe-4 text-end">
                                        <button class="btn btn-sm btn-outline-success me-1" 
                                                onclick="setPaymentBooking(<%= b.getBookingId() %>, '<%= b.getClientName() %>', <%= b.getRemainingAmount() %>)"
                                                data-bs-toggle="modal" data-bs-target="#payInstallmentModal"
                                                title="Record Installment">
                                            <i class="bi bi-currency-rupee"></i>
                                        </button>
                                        <a href="bookings?action=delete&id=<%= b.getBookingId() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Delete booking and release flat?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
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

    <!-- New Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Create New Booking</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="bookings?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-12">
                                <label class="form-label small fw-bold">Select Client</label>
                                <select name="clientId" class="form-select" required>
                                    <% if(clientList != null) { for(Client c : clientList) { %>
                                        <option value="<%= c.getClientId() %>"><%= c.getName() %> (<%= c.getCompany() %>)</option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label small fw-bold">Select Flat (Inventory)</label>
                                <select name="flatId" class="form-select" required>
                                    <% if(flatList != null) { for(Flat f : flatList) { %>
                                        <option value="<%= f.getFlatId() %>"><%= f.getFlatNumber() %> - <%= f.getBuildingName() %> (₹<%= f.getPrice() %>)</option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Booking Type</label>
                                <select name="bookingType" class="form-select">
                                    <option value="Final Booking">Final Booking</option>
                                    <option value="Reservation">Reservation</option>
                                    <option value="Installment Plan">Installment Plan</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Booking Date</label>
                                <input type="date" name="bookingDate" class="form-control" value="<%= new java.sql.Date(java.lang.System.currentTimeMillis()) %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Total Deal Price (₹)</label>
                                <input type="number" step="0.01" name="totalAmount" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Initial Payment (₹)</label>
                                <input type="number" step="0.01" name="initialPayment" class="form-control" value="0">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Confirm Booking</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Pay Installment Modal -->
    <div class="modal fade" id="payInstallmentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-success text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Record Installment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="bookings?action=addPayment" method="POST">
                    <input type="hidden" name="bookingId" id="payBookingId">
                    <div class="modal-body p-4">
                        <p class="small text-muted mb-2">Client: <strong id="payClientName" class="text-dark"></strong></p>
                        <p class="small text-danger mb-3">Remaining Due: <strong id="payRemaining"></strong></p>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Payment Amount (₹)</label>
                            <input type="number" step="0.01" name="amount" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Payment Date</label>
                            <input type="date" name="paymentDate" class="form-control" value="<%= new java.sql.Date(java.lang.System.currentTimeMillis()) %>" required>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Payment Method</label>
                            <select name="paymentMethod" class="form-select">
                                <option value="Bank Transfer">Bank Transfer</option>
                                <option value="Cash">Cash</option>
                                <option value="Cheque">Cheque</option>
                                <option value="UPI">UPI</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-success rounded-pill w-100">Submit Payment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function setPaymentBooking(id, name, remaining) {
        document.getElementById('payBookingId').value = id;
        document.getElementById('payClientName').innerText = name;
        document.getElementById('payRemaining').innerText = "₹" + remaining.toFixed(2);
    }
</script>
</body>
</html>