<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.crm.model.Lead" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    Lead lead = (Lead) request.getAttribute("lead");
    if(lead == null) {
        response.sendRedirect("leads");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Lead - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="row justify-content-center mt-4">
            <div class="col-lg-8 col-xl-6">
                <div class="card table-card border-0 shadow-sm overflow-hidden">
                    <div class="p-4 bg-white border-bottom d-flex align-items-center justify-content-between">
                        <div>
                            <h4 class="fw-bold m-0 text-dark"><i class="bi bi-pencil-square me-2 text-danger"></i>Edit Lead Details</h4>
                            <p class="text-muted small mb-0">Update information for: <strong><%= lead.getName() %></strong></p>
                        </div>
                        <a href="leads" class="btn btn-light btn-sm rounded-circle shadow-sm border">
                            <i class="bi bi-x-lg"></i>
                        </a>
                    </div>
                    
                    <div class="card-body p-4 p-md-5">
                        <form action="leads?action=update" method="POST">
                            <input type="hidden" name="leadId" value="<%= lead.getLeadId() %>">
                            
                            <div class="row g-4 mb-4">
                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Full Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-person"></i></span>
                                        <input type="text" name="name" class="form-control form-control-lg bg-light border-0" value="<%= lead.getName() %>" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-envelope"></i></span>
                                        <input type="email" name="email" class="form-control form-control-lg bg-light border-0" value="<%= lead.getEmail() %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Phone Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="bi bi-telephone"></i></span>
                                        <input type="text" name="phone" class="form-control form-control-lg bg-light border-0" value="<%= lead.getPhone() %>" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Lead Source</label>
                                    <select name="source" class="form-select form-select-lg bg-light border-0">
                                        <option value="Website" <%= "Website".equals(lead.getSource()) ? "selected" : "" %>>🌐 Website</option>
                                        <option value="Referral" <%= "Referral".equals(lead.getSource()) ? "selected" : "" %>>🤝 Referral</option>
                                        <option value="Social Media" <%= "Social Media".equals(lead.getSource()) ? "selected" : "" %>>📱 Social Media</option>
                                        <option value="Other" <%= "Other".equals(lead.getSource()) ? "selected" : "" %>>❓ Other</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase tracking-wider">Current Status</label>
                                    <select name="status" class="form-select form-select-lg bg-light border-0">
                                        <option value="New" <%= "New".equals(lead.getStatus()) ? "selected" : "" %>>🆕 New</option>
                                        <option value="Contacted" <%= "Contacted".equals(lead.getStatus()) ? "selected" : "" %>>📞 Contacted</option>
                                        <option value="Qualified" <%= "Qualified".equals(lead.getStatus()) ? "selected" : "" %>>⭐ Qualified</option>
                                        <option value="Negotiating" <%= "Negotiating".equals(lead.getStatus()) ? "selected" : "" %>>🤝 Negotiating</option>
                                    </select>
                                </div>
                            </div>

                            <hr class="my-5 opacity-50">

                            <div class="d-flex flex-column flex-md-row gap-3">
                                <button type="submit" class="btn btn-primary-custom btn-lg rounded-pill flex-grow-1 shadow">
                                    <i class="bi bi-check2-circle me-2"></i>Save Changes
                                </button>
                                <a href="leads" class="btn btn-light btn-lg rounded-pill px-5 border">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="mt-4 text-center">
                    <p class="text-muted small"><i class="bi bi-info-circle me-1"></i>Last updated at <%= lead.getCreatedAt() %></p>
                </div>
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
