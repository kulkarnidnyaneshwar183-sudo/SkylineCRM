<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, java.sql.Date, java.time.LocalDate, com.crm.model.Booking, com.crm.model.Client, com.crm.model.Flat" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Booking> bookingList = (List<Booking>) request.getAttribute("bookingList");
    List<Client> clientList = (List<Client>) request.getAttribute("clientList");
    List<Flat> flatList = (List<Flat>) request.getAttribute("flatList");
    String today = LocalDate.now().toString();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <!-- Status Alerts -->
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 mb-4 rounded-3" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i><%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 mb-4 rounded-3" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i><%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-calendar-check-fill me-2 text-primary"></i>Real Estate Bookings</h3>
                <p class="text-muted small mb-0">Manage property reservations, payments, and booking statuses.</p>
            </div>
            <div class="d-flex gap-2">
                <div class="search-bar-container">
                    <i class="bi bi-search"></i>
                    <input type="text" id="bookingSearch" class="form-control rounded-pill border-0 shadow-sm px-4 ps-5" placeholder="Search bookings...">
                </div>
                <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addBookingModal">
                    <i class="bi bi-plus-lg me-2"></i>New Booking
                </button>
            </div>
        </div>

        <!-- Bookings Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="bookingTable">
                        <thead>
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
                                    String progressClass = "bg-success";
                                    if(percentage < 50) progressClass = "bg-warning";
                                    else if(percentage < 100) progressClass = "bg-primary";
                                    
                                    String statusBadge = "bg-secondary bg-opacity-10 text-secondary";
                                    if("Pending".equals(b.getStatus())) statusBadge = "bg-warning bg-opacity-10 text-warning";
                                    else if("Approved".equals(b.getStatus())) statusBadge = "bg-info bg-opacity-10 text-info";
                                    else if("Completed".equals(b.getStatus())) statusBadge = "bg-success bg-opacity-10 text-success";
                            %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-primary bg-opacity-10 text-primary rounded-3 me-3">
                                                <%= b.getClientName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <div>
                                                <div class="fw-bold client-name text-nowrap"><%= b.getClientName() %></div>
                                                <div class="text-muted small property-info"><i class="bi bi-building me-1"></i>Flat: <%= b.getFlatNumber() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border rounded-pill">
                                            <%= b.getBookingType() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="dropdown">
                                            <span class="badge <%= statusBadge %> rounded-pill px-3 dropdown-toggle cursor-pointer" role="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                                <%= b.getStatus() %>
                                            </span>
                                            <ul class="dropdown-menu shadow border-0 p-2" style="border-radius: 12px;">
                                                <li><a class="dropdown-item rounded-2" href="bookings?action=updateStatus&id=<%= b.getBookingId() %>&status=Pending">Pending</a></li>
                                                <li><a class="dropdown-item rounded-2" href="bookings?action=updateStatus&id=<%= b.getBookingId() %>&status=Approved">Approved</a></li>
                                                <li><a class="dropdown-item rounded-2" href="bookings?action=updateStatus&id=<%= b.getBookingId() %>&status=Completed">Completed</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex justify-content-between small mb-1">
                                            <span class="fw-medium text-dark">₹<%= String.format("%.0f", b.getPaidAmount()) %> Paid</span>
                                            <span class="text-danger fw-bold">₹<%= String.format("%.0f", b.getRemainingAmount()) %> Due</span>
                                        </div>
                                        <div class="progress progress-sm">
                                            <div class="progress-bar <%= progressClass %>" style="width: <%= percentage %>%"></div>
                                        </div>
                                        <div class="text-muted small mt-1">Total deal: ₹<%= String.format("%.0f", b.getTotalAmount()) %></div>
                                    </td>
                                    <td>
                                        <div class="small fw-medium"><%= b.getBookingDate() %></div>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <li><button class="dropdown-item rounded-2" onclick="viewPaymentHistory(<%= b.getBookingId() %>, '<%= b.getClientName() %>')" data-bs-toggle="modal" data-bs-target="#paymentHistoryModal">
                                                    <i class="bi bi-clock-history me-2 text-info"></i> Payment History</button></li>
                                                <li><button class="dropdown-item rounded-2" onclick="setPaymentBooking(<%= b.getBookingId() %>, '<%= b.getClientName() %>', <%= b.getRemainingAmount() %>)" data-bs-toggle="modal" data-bs-target="#payInstallmentModal">
                                                    <i class="bi bi-currency-rupee me-2 text-success"></i> Record Payment</button></li>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li><a class="dropdown-item rounded-2 text-danger" href="bookings?action=delete&id=<%= b.getBookingId() %>" onclick="return confirm('Delete booking and release flat?')">
                                                    <i class="bi bi-trash me-2"></i> Cancel Booking</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <div class="mb-3">
                                            <i class="bi bi-calendar-x display-1 opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold">No bookings found</h5>
                                        <p class="small">New property bookings will appear here.</p>
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
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Create New Booking</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="bookings?action=add" method="POST" id="bookingForm">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <!-- Client Selection -->
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Select Client</label>
                                <input list="clientOptions" id="clientSearchInput" class="form-control" placeholder="Search client..." required autocomplete="off">
                                <datalist id="clientOptions">
                                    <% if(clientList != null && !clientList.isEmpty()) { 
                                        for(Client c : clientList) { %>
                                            <option value="<%= c.getName() %>" data-id="<%= c.getClientId() %>" data-email="<%= c.getEmail() %>" data-phone="<%= c.getPhone() %>">
                                    <% } } %>
                                </datalist>
                                <input type="hidden" name="clientId" id="hiddenClientId">
                                <div id="clientDetails" class="mt-2 p-3 bg-light rounded-3 small d-none border-0">
                                    <div id="clientEmail" class="mb-1"><i class="bi bi-envelope me-2 text-primary"></i></div>
                                    <div id="clientPhone"><i class="bi bi-phone me-2 text-primary"></i></div>
                                </div>
                            </div>

                            <!-- Flat Selection -->
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Select Flat (Inventory)</label>
                                <input list="flatOptions" id="flatSearchInput" class="form-control" placeholder="Search flat..." required autocomplete="off">
                                <datalist id="flatOptions">
                                    <% if(flatList != null && !flatList.isEmpty()) { 
                                        for(Flat f : flatList) { %>
                                            <option value="<%= f.getFlatNumber() %> - <%= f.getBuildingName() %>" data-id="<%= f.getFlatId() %>" data-price="<%= f.getPrice() %>" data-bhk="<%= f.getBhk() %>" data-area="<%= f.getAreaSqft() %>">
                                    <% } } %>
                                </datalist>
                                <input type="hidden" name="flatId" id="hiddenFlatId">
                                <div id="flatDetails" class="mt-2 p-3 bg-light rounded-3 small d-none border-0">
                                    <span id="flatBhk" class="badge bg-secondary rounded-pill me-1"></span>
                                    <span id="flatArea" class="badge bg-secondary rounded-pill me-1"></span>
                                    <div id="flatPriceInfo" class="fw-bold text-primary mt-2 h6 mb-0"></div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Booking Type</label>
                                <select name="bookingType" class="form-select">
                                    <option value="Flat Booking">Flat Booking</option>
                                    <option value="Site Visit">Site Visit</option>
                                    <option value="Reservation">Reservation</option>
                                    <option value="Final Booking">Final Booking</option>
                                    <option value="Installment">Installment</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Booking Date</label>
                                <input type="date" name="bookingDate" class="form-control" value="<%= today %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Total Deal Price (₹)</label>
                                <input type="number" step="0.01" name="totalAmount" id="totalAmount" class="form-control fw-bold text-primary" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Initial Payment (₹)</label>
                                <input type="number" step="0.01" name="initialPayment" id="initialPayment" class="form-control" value="0">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-5">Confirm Booking</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Pay Installment Modal -->
    <div class="modal fade" id="payInstallmentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Record Installment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="bookings?action=addPayment" method="POST">
                    <input type="hidden" name="bookingId" id="payBookingId">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="text-muted small fw-bold text-uppercase d-block mb-1">Client</label>
                            <div id="payClientName" class="fw-bold"></div>
                        </div>
                        <div class="mb-3">
                            <label class="text-muted small fw-bold text-uppercase d-block mb-1">Remaining Due</label>
                            <div id="payRemaining" class="text-danger fw-bold h5"></div>
                        </div>
                        <hr class="opacity-10 my-3">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Payment Amount (₹)</label>
                            <input type="number" step="0.01" name="amount" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Payment Date</label>
                            <input type="date" name="paymentDate" class="form-control" value="<%= today %>" required>
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
                        <button type="submit" class="btn btn-primary-custom rounded-pill w-100">Submit Payment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Payment History Modal -->
    <div class="modal fade" id="paymentHistoryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-md modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Payment History</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0 mt-3">
                    <div class="px-4 py-3 bg-light border-bottom border-top">
                        <small class="text-muted text-uppercase fw-bold">Client</small>
                        <div id="historyClientName" class="fw-bold text-primary"></div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead>
                                <tr class="small">
                                    <th class="ps-4">Date</th>
                                    <th>Method</th>
                                    <th class="text-end pe-4">Amount</th>
                                </tr>
                            </thead>
                            <tbody id="paymentHistoryBody">
                                <!-- Loaded via AJAX -->
                            </tbody>
                        </table>
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
<script>
    function viewPaymentHistory(bookingId, clientName) {
        document.getElementById('historyClientName').innerText = clientName;
        const tbody = document.getElementById('paymentHistoryBody');
        tbody.innerHTML = '<tr><td colspan="3" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>';
        
        fetch('bookings?action=viewPayments&id=' + bookingId)
            .then(response => response.json())
            .then(data => {
                tbody.innerHTML = '';
                if (data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="3" class="text-center py-5 text-muted"><i class="bi bi-info-circle me-1"></i>No payments recorded yet.</td></tr>';
                } else {
                    data.forEach(p => {
                        const row = `<tr>
                            <td class="ps-4 small fw-medium">\${p.date}</td>
                            <td><span class="badge bg-light text-dark border rounded-pill px-2">\${p.method}</span></td>
                            <td class="text-end pe-4 fw-bold text-success">₹\${parseFloat(p.amount).toLocaleString()}</td>
                        </tr>`;
                        tbody.innerHTML += row;
                    });
                }
            })
            .catch(err => {
                tbody.innerHTML = '<tr><td colspan="3" class="text-center py-5 text-danger">Error loading history.</td></tr>';
            });
    }

    // Searchable Datatables Logic
    function updateClientDetails() {
        const input = document.getElementById('clientSearchInput');
        const value = input.value;
        const options = document.getElementById('clientOptions').options;
        let found = false;
        for (let i = 0; i < options.length; i++) {
            if (options[i].value === value) {
                document.getElementById('hiddenClientId').value = options[i].getAttribute('data-id');
                document.getElementById('clientEmail').innerHTML = '<i class="bi bi-envelope me-2 text-primary"></i>' + options[i].getAttribute('data-email');
                document.getElementById('clientPhone').innerHTML = '<i class="bi bi-phone me-2 text-primary"></i>' + options[i].getAttribute('data-phone');
                document.getElementById('clientDetails').classList.remove('d-none');
                input.classList.remove('is-invalid');
                input.classList.add('is-valid');
                found = true;
                break;
            }
        }
        if (!found) {
            document.getElementById('hiddenClientId').value = "";
            document.getElementById('clientDetails').classList.add('d-none');
            input.classList.remove('is-valid');
            if (value.length > 0) input.classList.add('is-invalid');
        }
    }

    function updateFlatDetails() {
        const input = document.getElementById('flatSearchInput');
        const value = input.value;
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
                input.classList.remove('is-invalid');
                input.classList.add('is-valid');
                found = true;
                break;
            }
        }
        if (!found) {
            document.getElementById('hiddenFlatId').value = "";
            document.getElementById('flatDetails').classList.add('d-none');
            input.classList.remove('is-valid');
            if (value.length > 0) input.classList.add('is-invalid');
        }
    }

    document.getElementById('clientSearchInput').addEventListener('input', updateClientDetails);
    document.getElementById('clientSearchInput').addEventListener('change', updateClientDetails);
    
    document.getElementById('flatSearchInput').addEventListener('input', updateFlatDetails);
    document.getElementById('flatSearchInput').addEventListener('change', updateFlatDetails);

    document.getElementById('bookingForm').addEventListener('submit', function(e) {
        const clientId = document.getElementById('hiddenClientId').value;
        const flatId = document.getElementById('hiddenFlatId').value;
        
        if (!clientId || !flatId) {
            e.preventDefault();
            alert('Please select a valid Client and Flat from the provided lists.');
            if (!clientId) document.getElementById('clientSearchInput').classList.add('is-invalid');
            if (!flatId) document.getElementById('flatSearchInput').classList.add('is-invalid');
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
        document.getElementById('payRemaining').innerText = "₹" + remaining.toLocaleString(undefined, {minimumFractionDigits: 2});
    }
</script>
</body>
</html>