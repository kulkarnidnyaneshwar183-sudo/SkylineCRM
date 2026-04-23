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
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-wallet2 me-2 text-primary"></i>Expense Tracker</h3>
                <p class="text-muted small mb-0">Monitor and categorize all business and project-related expenditures.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
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
                <div class="card stat-card border-0 p-4">
                    <div class="d-flex align-items-center">
                        <div class="icon-box bg-primary bg-opacity-10 text-primary me-3 rounded-4">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold text-uppercase">Total Expenses</div>
                            <div class="h4 fw-bold mb-0 text-dark">₹<%= String.format("%.2f", totalExp) %></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card border-0 p-4">
                    <div class="d-flex align-items-center">
                        <div class="icon-box bg-success bg-opacity-10 text-success me-3 rounded-4">
                            <i class="bi bi-coin"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold text-uppercase">Petty Cash</div>
                            <div class="h4 fw-bold mb-0 text-dark">₹<%= String.format("%.2f", pettyCashUsed) %></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card border-0 p-4 bg-primary bg-opacity-10">
                    <div class="d-flex align-items-center">
                        <div class="icon-box bg-primary text-white me-3 rounded-4">
                            <i class="bi bi-graph-down-arrow"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold text-uppercase">Monthly Budget Left</div>
                            <div class="h4 fw-bold mb-0 text-primary">₹<%= String.format("%.2f", 50000 - totalExp) %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Expenses Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
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
                                    <td><span class="badge bg-light text-dark border rounded-pill px-3"><%= e.getPaymentMethod() %></span></td>
                                    <td><div class="small fw-medium text-dark"><%= e.getExpenseDate() %></div></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-secondary bg-opacity-10 text-secondary rounded-3 me-2" style="width: 24px; height: 24px; font-size: 0.7rem;">
                                                <%= e.getRecorderName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <span class="small"><%= e.getRecorderName() %></span>
                                        </div>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <li><a class="dropdown-item rounded-2 text-danger" href="expenses?action=delete&id=<%= e.getExpenseId() %>" onclick="return confirm('Delete this record?')">
                                                    <i class="bi bi-trash me-2"></i> Delete</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <div class="mb-3">
                                            <i class="bi bi-cash-stack display-1 opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold">No expenses found</h5>
                                        <p class="small">Start tracking your business expenditures here.</p>
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
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Record New Expense</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                                    <option value="Office">🏢 Office</option>
                                    <option value="Travel">🚗 Travel</option>
                                    <option value="Marketing">📢 Marketing</option>
                                    <option value="Maintenance">🛠️ Maintenance</option>
                                    <option value="Other">❓ Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Amount (₹)</label>
                                <input type="number" step="0.01" name="amount" class="form-control" placeholder="0.00" required>
                            </div>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Payment Method</label>
                                <select name="paymentMethod" class="form-select">
                                    <option value="Cash">💵 Cash</option>
                                    <option value="Petty Cash">🪙 Petty Cash</option>
                                    <option value="Bank Transfer">🏦 Bank Transfer</option>
                                    <option value="Card">💳 Card</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Expense Date</label>
                                <input type="date" name="expenseDate" class="form-control" value="<%= new java.sql.Date(new java.util.Date().getTime()) %>" required>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Description</label>
                            <textarea name="description" class="form-control" rows="2" placeholder="Add additional details..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Record Expense</button>
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