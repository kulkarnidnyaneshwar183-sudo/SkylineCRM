<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, java.sql.Date, com.crm.model.Expense" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Expense> expenseList = (List<Expense>) request.getAttribute("expenseList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
        .card-expense { border-left: 5px solid #0d6efd; }
        .card-petty { border-left: 5px solid #198754; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-wallet2 me-2"></i>Expense Tracker</h3>
            <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
                <i class="bi bi-plus-lg me-2"></i>Record Expense
            </button>
        </div>

        <!-- Expense Summary -->
        <%
            double totalExp = 0, pettyCashUsed = 0;
            if(expenseList != null) {
                for(Expense e : expenseList) {
                    totalExp += e.getAmount();
                    if("Petty Cash".equalsIgnoreCase(e.getPaymentMethod())) {
                        pettyCashUsed += e.getAmount();
                    }
                }
            }
        %>
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3 card-expense" style="border-radius: 12px;">
                    <div class="text-muted small fw-bold text-uppercase">Total Expenses</div>
                    <div class="h3 fw-bold mb-0 text-primary">₹<%= String.format("%.2f", totalExp) %></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3 card-petty" style="border-radius: 12px;">
                    <div class="text-muted small fw-bold text-uppercase">Petty Cash Used</div>
                    <div class="h3 fw-bold mb-0 text-success">₹<%= String.format("%.2f", pettyCashUsed) %></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3 text-center bg-dark text-white" style="border-radius: 12px;">
                    <div class="text-white-50 small fw-bold text-uppercase">Monthly Budget Left</div>
                    <div class="h3 fw-bold mb-0">₹<%= String.format("%.2f", 50000 - totalExp) %></div>
                </div>
            </div>
        </div>

        <!-- Expenses Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Title / Category</th>
                                <th>Amount</th>
                                <th>Method</th>
                                <th>Date</th>
                                <th>Recorded By</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(expenseList != null && !expenseList.isEmpty()) { 
                                for(Expense e : expenseList) { %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold"><%= e.getTitle() %></div>
                                        <div class="small text-muted"><%= e.getCategory() %></div>
                                    </td>
                                    <td><span class="fw-bold text-danger">₹<%= String.format("%.2f", e.getAmount()) %></span></td>
                                    <td><span class="badge bg-secondary rounded-pill"><%= e.getPaymentMethod() %></span></td>
                                    <td class="small text-muted"><%= e.getExpenseDate() %></td>
                                    <td class="small"><%= e.getRecorderName() %></td>
                                    <td class="pe-4 text-end">
                                        <a href="expenses?action=delete&id=<%= e.getExpenseId() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Delete this record?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-cash-stack display-4"></i>
                                        <p class="mt-2">No expenses recorded yet.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Expense Modal -->
    <div class="modal fade" id="addExpenseModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Record New Expense</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="expenses?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Expense Title</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g. Office Stationery" required>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Category</label>
                                <select name="category" class="form-select">
                                    <option value="Office">Office</option>
                                    <option value="Travel">Travel</option>
                                    <option value="Marketing">Marketing</option>
                                    <option value="Maintenance">Maintenance</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Amount (₹)</label>
                                <input type="number" step="0.01" name="amount" class="form-control" required>
                            </div>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Payment Method</label>
                                <select name="paymentMethod" class="form-select">
                                    <option value="Cash">Cash</option>
                                    <option value="Petty Cash">Petty Cash</option>
                                    <option value="Bank Transfer">Bank Transfer</option>
                                    <option value="Card">Card</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Expense Date</label>
                                <input type="date" name="expenseDate" class="form-control" value="<%= new java.sql.Date(new java.util.Date().getTime()) %>" required>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Description</label>
                            <textarea name="description" class="form-control" rows="2"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Record Expense</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>ipt>
</body>
</html>