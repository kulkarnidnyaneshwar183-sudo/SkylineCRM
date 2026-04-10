<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.Vendor" %>
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
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
        .vendor-name { color: #0d6efd; font-weight: bold; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-truck me-2"></i>Vendor Management</h3>
            <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addVendorModal">
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
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-4 text-center bg-white" style="border-radius: 15px; border-left: 5px solid #dc3545 !important;">
                    <div class="text-muted small fw-bold text-uppercase">Total Outstanding Due</div>
                    <div class="h2 fw-bold mb-0 text-danger">₹<%= String.format("%.2f", totalDue) %></div>
                </div>
            </div>
        </div>

        <!-- Vendors Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
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
                                        <div class="vendor-name"><%= v.getVendorName() %></div>
                                        <div class="small text-muted text-uppercase"><%= v.getServiceType() %></div>
                                    </td>
                                    <td><%= v.getContactPerson() %></td>
                                    <td>
                                        <div class="small"><i class="bi bi-envelope me-1"></i><%= v.getEmail() %></div>
                                        <div class="small"><i class="bi bi-telephone me-1"></i><%= v.getPhone() %></div>
                                    </td>
                                    <td>
                                        <div class="fw-bold <%= v.getTotalDue() > 0 ? "text-danger" : "text-success" %>">
                                            ₹<%= String.format("%.2f", v.getTotalDue()) %>
                                        </div>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <button class="btn btn-sm btn-outline-success me-1 rounded-pill px-3" 
                                                onclick="setPaymentVendor(<%= v.getVendorId() %>, '<%= v.getVendorName() %>')"
                                                data-bs-toggle="modal" data-bs-target="#payVendorModal">
                                            <i class="bi bi-cash-coin me-1"></i> Pay
                                        </button>
                                        <a href="vendors?action=delete&id=<%= v.getVendorId() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Delete this vendor?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <i class="bi bi-people display-4"></i>
                                        <p class="mt-2">No vendors added yet.</p>
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
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Add New Vendor</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="vendors?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Vendor/Company Name</label>
                            <input type="text" name="vendorName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Contact Person</label>
                            <input type="text" name="contactPerson" class="form-control" required>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Email</label>
                                <input type="email" name="email" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Phone</label>
                                <input type="text" name="phone" class="form-control" required>
                            </div>
                        </div>
                        <div class="row g-3">
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
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Save Vendor</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Pay Vendor Modal -->
    <div class="modal fade" id="payVendorModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-success text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Record Payment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="vendors?action=pay" method="POST">
                    <input type="hidden" name="vendorId" id="payVendorId">
                    <div class="modal-body p-4">
                        <p class="small text-muted mb-3">Paying to: <strong id="payVendorName" class="text-dark"></strong></p>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Amount (₹)</label>
                            <input type="number" step="0.01" name="amount" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Payment Date</label>
                            <input type="date" name="paymentDate" class="form-control" value="<%= new java.sql.Date(System.currentTimeMillis()) %>" required>
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
    function setPaymentVendor(id, name) {
        document.getElementById('payVendorId').value = id;
        document.getElementById('payVendorName').innerText = name;
    }
</script>
</body>
</html>