<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.model.FollowUp, com.crm.model.Lead" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<FollowUp> followUpList = (List<FollowUp>) request.getAttribute("followUpList");
    List<Lead> leadList = (List<Lead>) request.getAttribute("leadList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Follow-ups - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
        .follow-type-call { color: #0d6efd; }
        .follow-type-meeting { color: #198754; }
        .follow-type-email { color: #6f42c1; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-calendar-event me-2"></i>Follow-up Schedule</h3>
            <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addFollowUpModal">
                <i class="bi bi-plus-lg me-2"></i>Schedule Follow-up
            </button>
        </div>

        <!-- Follow-ups Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Lead Name</th>
                                <th>Date & Time</th>
                                <th>Type</th>
                                <th>Notes</th>
                                <th>Status</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(followUpList != null && !followUpList.isEmpty()) { 
                                for(FollowUp f : followUpList) { 
                                    String typeIcon = "bi-telephone";
                                    String typeClass = "follow-type-call";
                                    if("Meeting".equalsIgnoreCase(f.getFollowType())) {
                                        typeIcon = "bi-people";
                                        typeClass = "follow-type-meeting";
                                    } else if("Email".equalsIgnoreCase(f.getFollowType())) {
                                        typeIcon = "bi-envelope";
                                        typeClass = "follow-type-email";
                                    }
                            %>
                                <tr>
                                    <td class="ps-4"><strong><%= f.getLeadName() %></strong></td>
                                    <td class="small text-muted"><%= f.getFollowDate() %></td>
                                    <td>
                                        <i class="bi <%= typeIcon %> <%= typeClass %> me-2"></i>
                                        <%= f.getFollowType() %>
                                    </td>
                                    <td class="small text-wrap" style="max-width: 250px;"><%= f.getNotes() != null ? f.getNotes() : "-" %></td>
                                    <td>
                                        <% if("Scheduled".equals(f.getStatus())) { %>
                                            <span class="badge bg-primary rounded-pill">Scheduled</span>
                                        <% } else if("Completed".equals(f.getStatus())) { %>
                                            <span class="badge bg-success rounded-pill">Completed</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary rounded-pill"><%= f.getStatus() %></span>
                                        <% } %>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <% if("Scheduled".equals(f.getStatus())) { %>
                                            <a href="followups?action=complete&id=<%= f.getFollowId() %>" 
                                               class="btn btn-sm btn-outline-success me-1" title="Mark as Completed">
                                                <i class="bi bi-check-lg"></i>
                                            </a>
                                        <% } %>
                                        <a href="followups?action=delete&id=<%= f.getFollowId() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Delete this follow-up?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-calendar-x display-4"></i>
                                        <p class="mt-2">No follow-ups scheduled.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Follow-up Modal -->
    <div class="modal fade" id="addFollowUpModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Schedule Follow-up</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="followups?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Select Lead</label>
                            <select name="leadId" class="form-select" required>
                                <% if(leadList != null) { for(Lead l : leadList) { %>
                                    <option value="<%= l.getLeadId() %>"><%= l.getName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Date & Time</label>
                                <input type="datetime-local" name="followDate" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Follow-up Type</label>
                                <select name="followType" class="form-select">
                                    <option value="Call">Call</option>
                                    <option value="Site Visit">Site Visit</option>
                                    <option value="Meeting">Meeting</option>
                                    <option value="Email">Email</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Notes / Agenda</label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="Add specific notes..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Save Follow-up</button>
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