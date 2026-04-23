<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, java.sql.Date, com.crm.model.Vendor" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Vendor> vendorList = (List<Vendor>) request.getAttribute("vendorList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Vendor Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-truck me-2 text-primary"></i>Vendor Management</h3>
                <p class="text-muted small mb-0">Manage your suppliers, contractors, and outstanding payments.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addVendorModal">
                <i class="bi bi-plus-lg me-2"></i>New Vendor
            </button>
        </div>

        <!-- Vendor Summary -->
        <%
            double totalDue = 0;
            if(vendorList != null) {
                for(Vendor v : vendorList) {
                    totalDue += v.getTotalDue();
                }
            }
        %>
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card stat-card border-0 p-4">
                    <div class="d-flex align-items-center">
                        <div class="icon-box bg-danger bg-opacity-10 text-danger me-3 rounded-4">
                            <i class="bi bi-exclamation-octagon-fill"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold text-uppercase">Total Outstanding Due</div>
                            <div class="h4 fw-bold mb-0 text-dark">₹<%= String.format("%.2f", totalDue) %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Vendors Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Vendor Name / Service</th>
                                <th>Contact Person</th>
                                <th>Contact Details</th>
                                <th>Outstanding Due</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(vendorList != null && !vendorList.isEmpty()) { 
                                for(Vendor v : vendorList) { %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-primary bg-opacity-10 text-primary rounded-3 me-3">
                                                <%= v.getVendorName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark"><%= v.getVendorName() %></div>
                                                <div class="small text-muted text-uppercase" style="font-size: 0.7rem;"><%= v.getServiceType() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-medium text-dark small"><%= v.getContactPerson() %></div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="bi bi-envelope text-muted me-2 small"></i>
                                            <span class="small"><%= v.getEmail() %></span>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-telephone text-muted me-2 small"></i>
                                            <span class="text-muted small"><%= v.getPhone() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-bold <%= v.getTotalDue() > 0 ? "text-danger" : "text-success" %>">
                                            ₹<%= String.format("%.2f", v.getTotalDue()) %>
                                        </div>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <li><button class="dropdown-item rounded-2 text-success" onclick="setPaymentVendor(<%= v.getVendorId() %>, '<%= v.getVendorName() %>')" data-bs-toggle="modal" data-bs-target="#payVendorModal">
                                                    <i class="bi bi-cash-coin me-2"></i> Record Payment</button></li>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li><a class="dropdown-item rounded-2 text-danger" href="vendors?action=delete&id=<%= v.getVendorId() %>" onclick="return confirm('Delete this vendor?')">
                                                    <i class="bi bi-trash me-2"></i> Delete Vendor</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <div class="mb-3">
                                            <i class="bi bi-people display-1 opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold">No vendors found</h5>
                                        <p class="small">Add your service providers and vendors here.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Vendor Modal -->
    <div class="modal fade" id="addVendorModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Add New Vendor</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="vendors?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Vendor/Company Name</label>
                            <input type="text" name="vendorName" class="form-control" placeholder="e.g. Acme Constructions" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Contact Person</label>
                            <input type="text" name="contactPerson" class="form-control" placeholder="John Doe" required>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Email</label>
                                <input type="email" name="email" class="form-control" placeholder="vendor@example.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Phone</label>
                                <input type="text" name="phone" class="form-control" placeholder="+91 ..." required>
                            </div>
                        </div>
                        <div class="row g-3 mb-0">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Service Provided</label>
                                <input type="text" name="serviceType" class="form-control" placeholder="e.g. Electrical, Paint" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Initial Balance Due (₹)</label>
                                <input type="number" step="0.01" name="totalDue" class="form-control" value="0">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Save Vendor</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Pay Vendor Modal -->
    <div class="modal fade" id="payVendorModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Record Payment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="vendors?action=pay" method="POST">
                    <input type="hidden" name="vendorId" id="payVendorId">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="text-muted small fw-bold text-uppercase d-block mb-1">Paying To</label>
                            <div id="payVendorName" class="fw-bold"></div>
                        </div>
                        <hr class="opacity-10 my-3">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Amount (₹)</label>
                            <input type="number" step="0.01" name="amount" class="form-control" placeholder="0.00" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Payment Date</label>
                            <input type="date" name="paymentDate" class="form-control" value="<%= new java.sql.Date(new java.util.Date().getTime()) %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Method</label>
                            <select name="paymentMethod" class="form-select">
                                <option value="Bank Transfer">Bank Transfer</option>
                                <option value="Cash">Cash</option>
                                <option value="Cheque">Cheque</option>
                                <option value="UPI">UPI</option>
                            </select>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Reference/TXN No.</label>
                            <input type="text" name="referenceNo" class="form-control" placeholder="Optional">
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary-custom rounded-pill w-100">Submit Payment</button>
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
<script>
    function setPaymentVendor(id, name) {
        document.getElementById('payVendorId').value = id;
        document.getElementById('payVendorName').innerText = name;
    }
</script>
</body>
</html>