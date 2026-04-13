<<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, java.sql.Date, com.crm.model.Booking, com.crm.model.Client, com.crm.model.Flat" %>
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
        <!-- Status Alerts -->
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i><%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i><%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-calendar-check me-2"></i>Real Estate Bookings</h3>
            <div class="d-flex gap-3">
                <div class="input-group" style="width: 300px;">
                    <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                    <input type="text" id="bookingSearch" class="form-control border-start-0" placeholder="Search bookings...">
                </div>
                <button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addBookingModal">
                    <i class="bi bi-plus-lg me-2"></i>New Booking
                </button>
            </div>
        </div>

        <!-- Bookings Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="bookingTable">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Client / Property</th>
                                <th>Booking Type</th>
                                <th>Status</th>
                                <th>Financial Summary</th>
                                <th>Date</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(bookingList != null && !bookingList.isEmpty()) { 
                                for(Booking b : bookingList) { 
                                    double percentage = b.getTotalAmount() > 0 ? (b.getPaidAmount() / b.getTotalAmount()) * 100 : 0;
                                    String progressClass = percentage >= 100 ? "bg-success" : percentage > 50 ? "bg-primary" : "bg-warning";
                                    String statusBadge = "bg-secondary";
                                    if("Pending".equals(b.getStatus())) statusBadge = "bg-warning text-dark";
                                    else if("Approved".equals(b.getStatus())) statusBadge = "bg-info";
                                    else if("Completed".equals(b.getStatus())) statusBadge = "bg-success";
                            %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-primary client-name"><%= b.getClientName() %></div>
                                        <div class="small text-muted property-info">Flat: <%= b.getFlatNumber() %></div>
                                    </td>
                                    <td>
                                        <span class="badge <%= "Reservation".equals(b.getBookingType()) ? "bg-info" : "bg-dark" %> rounded-pill">
                                            <%= b.getBookingType() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="dropdown">
                                            <span class="badge <%= statusBadge %> rounded-pill dropdown-toggle" role="button" data-bs-toggle="dropdown">
                                                <%= b.getStatus() %>
                                            </span>
                                            <ul class="dropdown-menu shadow border-0">
                                                <li><a class="dropdown-item" href="bookings?action=updateStatus&id=<%= b.getBookingId() %>&status=Pending">Pending</a></li>
                                                <li><a class="dropdown-item" href="bookings?action=updateStatus&id=<%= b.getBookingId() %>&status=Approved">Approved</a></li>
                                                <li><a class="dropdown-item" href="bookings?action=updateStatus&id=<%= b.getBookingId() %>&status=Completed">Completed</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex justify-content-between small mb-1">
                                            <span>₹<%= String.format("%.0f", b.getPaidAmount()) %> / ₹<%= String.format("%.0f", b.getTotalAmount()) %></span>
                                            <span class="fw-bold text-danger">Due: ₹<%= String.format("%.0f", b.getRemainingAmount()) %></span>
                                        </div>
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
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white p-4" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2"></i>Create New Booking</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="bookings?action=add" method="POST" id="bookingForm">
                    <div class="modal-body p-4">
                        <div class="row g-4">
                            <!-- Client Selection -->
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-muted">Select Client</label>
                                <input list="clientOptions" id="clientSearchInput" class="form-control" placeholder="Type to search client..." required autocomplete="off">
                                <datalist id="clientOptions">
                                    <% if(clientList != null && !clientList.isEmpty()) { 
                                        for(Client c : clientList) { %>
                                            <option value="<%= c.getName() %>" data-id="<%= c.getClientId() %>" data-email="<%= c.getEmail() %>" data-phone="<%= c.getPhone() %>">
                                    <% } } else { %>
                                        <option value="No clients found">
                                    <% } %>
                                </datalist>
                                <input type="hidden" name="clientId" id="hiddenClientId">
                                <div id="clientDetails" class="mt-2 p-2 bg-light rounded small d-none border">
                                    <div id="clientEmail"><i class="bi bi-envelope me-2 text-primary"></i></div>
                                    <div id="clientPhone"><i class="bi bi-phone me-2 text-primary"></i></div>
                                </div>
                            </div>

                            <!-- Flat Selection -->
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-muted">Select Flat (Inventory)</label>
                                <input list="flatOptions" id="flatSearchInput" class="form-control" placeholder="Type to search flat..." required autocomplete="off">
                                <datalist id="flatOptions">
                                    <% if(flatList != null && !flatList.isEmpty()) { 
                                        for(Flat f : flatList) { %>
                                            <option value="<%= f.getFlatNumber() %> - <%= f.getBuildingName() %>" data-id="<%= f.getFlatId() %>" data-price="<%= f.getPrice() %>" data-bhk="<%= f.getBhk() %>" data-area="<%= f.getAreaSqft() %>">
                                    <% } } else { %>
                                        <option value="No available flats found">
                                    <% } %>
                                </datalist>
                                <input type="hidden" name="flatId" id="hiddenFlatId">
                                <div id="flatDetails" class="mt-2 p-2 bg-light rounded small d-none border">
                                    <span id="flatBhk" class="badge bg-secondary me-1"></span>
                                    <span id="flatArea" class="badge bg-secondary me-1"></span>
                                    <span id="flatPriceInfo" class="fw-bold text-primary"></span>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-muted">Booking Type</label>
                                <select name="bookingType" class="form-select shadow-sm">
                                    <option value="Flat Booking">Flat Booking</option>
                                    <option value="Site Visit">Site Visit</option>
                                    <option value="Reservation">Reservation</option>
                                    <option value="Final Booking">Final Booking</option>
                                    <option value="Installment">Installment</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-muted">Booking Date</label>
                                <input type="date" name="bookingDate" class="form-control shadow-sm" value="<%= new java.sql.Date(new java.util.Date().getTime()) %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-muted">Total Deal Price (₹)</label>
                                <input type="number" step="0.01" name="totalAmount" id="totalAmount" class="form-control fw-bold text-primary shadow-sm" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-muted">Initial Payment (₹)</label>
                                <input type="number" step="0.01" name="initialPayment" id="initialPayment" class="form-control shadow-sm" value="0">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-lg rounded-pill px-5 shadow">Confirm Booking</button>
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
                            <input type="date" name="paymentDate" class="form-control" value="<%= new java.sql.Date(new java.util.Date().getTime()) %>" required>
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
    // Searchable Datatables Logic
    document.getElementById('clientSearchInput').addEventListener('input', function() {
        const value = this.value;
        const options = document.getElementById('clientOptions').options;
        let found = false;
        for (let i = 0; i < options.length; i++) {
            if (options[i].value === value) {
                document.getElementById('hiddenClientId').value = options[i].getAttribute('data-id');
                document.getElementById('clientEmail').innerHTML = '<i class="bi bi-envelope me-2"></i>' + options[i].getAttribute('data-email');
                document.getElementById('clientPhone').innerHTML = '<i class="bi bi-phone me-2"></i>' + options[i].getAttribute('data-phone');
                document.getElementById('clientDetails').classList.remove('d-none');
                found = true;
                break;
            }
        }
        if (!found) {
            document.getElementById('hiddenClientId').value = "";
            document.getElementById('clientDetails').classList.add('d-none');
        }
    });

    document.getElementById('flatSearchInput').addEventListener('input', function() {
        const value = this.value;
        const options = document.getElementById('flatOptions').options;
        let found = false;
        for (let i = 0; i < options.length; i++) {
            if (options[i].value === value) {
                document.getElementById('hiddenFlatId').value = options[i].getAttribute('data-id');
                document.getElementById('flatBhk').innerText = options[i].getAttribute('data-bhk');
                document.getElementById('flatArea').innerText = options[i].getAttribute('data-area') + " sqft";
                const price = options[i].getAttribute('data-price');
                document.getElementById('flatPriceInfo').innerText = "₹" + parseFloat(price).toLocaleString();
                document.getElementById('totalAmount').value = price;
                document.getElementById('flatDetails').classList.remove('d-none');
                found = true;
                break;
            }
        }
        if (!found) {
            document.getElementById('hiddenFlatId').value = "";
            document.getElementById('flatDetails').classList.add('d-none');
        }
    });

    // Table Filter Logic
    document.getElementById('bookingSearch').addEventListener('keyup', function() {
        const query = this.value.toLowerCase();
        const rows = document.querySelectorAll('#bookingTable tbody tr');
        rows.forEach(row => {
            const client = row.querySelector('.client-name').innerText.toLowerCase();
            const property = row.querySelector('.property-info').innerText.toLowerCase();
            if (client.includes(query) || property.includes(query)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    });

    function setPaymentBooking(id, name, remaining) {
        document.getElementById('payBookingId').value = id;
        document.getElementById('payClientName').innerText = name;
        document.getElementById('payRemaining').innerText = "₹" + remaining.toFixed(2);
    }
</script>
</body>
</html>