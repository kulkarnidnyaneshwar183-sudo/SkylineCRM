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
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .edit-card { border-radius: 15px; border: none; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card edit-card shadow-sm">
                    <div class="card-header bg-danger text-white py-3" style="border-radius: 15px 15px 0 0;">
                        <h5 class="mb-0 fw-bold"><i class="bi bi-pencil-square me-2"></i>Edit Lead: <%= lead.getName() %></h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="leads?action=update" method="POST">
                            <input type="hidden" name="leadId" value="<%= lead.getLeadId() %>">
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Full Name</label>
                                <input type="text" name="name" class="form-control" value="<%= lead.getName() %>" required>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Email Address</label>
                                    <input type="email" name="email" class="form-control" value="<%= lead.getEmail() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Phone Number</label>
                                    <input type="text" name="phone" class="form-control" value="<%= lead.getPhone() %>" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold">Lead Source</label>
                                <select name="source" class="form-select">
                                    <option value="Website" <%= "Website".equals(lead.getSource()) ? "selected" : "" %>>🌐 Website</option>
                                    <option value="Referral" <%= "Referral".equals(lead.getSource()) ? "selected" : "" %>>🤝 Referral</option>
                                    <option value="Social Media" <%= "Social Media".equals(lead.getSource()) ? "selected" : "" %>>📱 Social Media</option>
                                    <option value="Other" <%= "Other".equals(lead.getSource()) ? "selected" : "" %>>❓ Other</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-bold">Lead Status</label>
                                <select name="status" class="form-select">
                                    <option value="New" <%= "New".equals(lead.getStatus()) ? "selected" : "" %>>🆕 New</option>
                                    <option value="Contacted" <%= "Contacted".equals(lead.getStatus()) ? "selected" : "" %>>📞 Contacted</option>
                                    <option value="Qualified" <%= "Qualified".equals(lead.getStatus()) ? "selected" : "" %>>⭐ Qualified</option>
                                    <option value="Negotiating" <%= "Negotiating".equals(lead.getStatus()) ? "selected" : "" %>>🤝 Negotiating</option>
                                </select>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-danger rounded-pill flex-grow-1 py-2 fw-bold">Update Lead</button>
                                <a href="leads" class="btn btn-light rounded-pill px-4 py-2">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

</body>
</html>