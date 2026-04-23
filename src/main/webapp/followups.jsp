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
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-calendar-event-fill me-2 text-primary"></i>Follow-up Schedule</h3>
                <p class="text-muted small mb-0">Track and manage your interactions with potential leads.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addFollowUpModal">
                <i class="bi bi-plus-lg me-2"></i>Schedule Follow-up
            </button>
        </div>

        <!-- Follow-ups Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
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
                                    String typeIcon = "bi-telephone-fill";
                                    String typeBadgeClass = "bg-primary bg-opacity-10 text-primary";
                                    if("Meeting".equalsIgnoreCase(f.getFollowType()) || "Site Visit".equalsIgnoreCase(f.getFollowType())) {
                                        typeIcon = "bi-people-fill";
                                        typeBadgeClass = "bg-success bg-opacity-10 text-success";
                                    } else if("Email".equalsIgnoreCase(f.getFollowType())) {
                                        typeIcon = "bi-envelope-fill";
                                        typeBadgeClass = "bg-purple bg-opacity-10 text-purple";
                                    }
                            %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-light text-dark rounded-3 me-3">
                                                <%= f.getLeadName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <div class="fw-bold"><%= f.getLeadName() %></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="small fw-medium text-dark"><%= f.getFollowDate() %></div>
                                    </td>
                                    <td>
                                        <span class="badge <%= typeBadgeClass %> rounded-pill px-3">
                                            <i class="bi <%= typeIcon %> me-1"></i>
                                            <%= f.getFollowType() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="text-muted small text-truncate" style="max-width: 200px;" title="<%= f.getNotes() %>">
                                            <%= f.getNotes() != null && !f.getNotes().isEmpty() ? f.getNotes() : "No notes" %>
                                        </div>
                                    </td>
                                    <td>
                                        <% 
                                            String statusBadgeClass = "bg-secondary bg-opacity-10 text-secondary";
                                            if("Scheduled".equals(f.getStatus())) statusBadgeClass = "bg-primary bg-opacity-10 text-primary";
                                            else if("Completed".equals(f.getStatus())) statusBadgeClass = "bg-success bg-opacity-10 text-success";
                                        %>
                                        <span class="badge <%= statusBadgeClass %> rounded-pill px-3">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                            <%= f.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <% if("Scheduled".equals(f.getStatus())) { %>
                                                    <li><a class="dropdown-item rounded-2 text-success" href="followups?action=complete&id=<%= f.getFollowId() %>">
                                                        <i class="bi bi-check-circle me-2"></i> Mark Completed</a></li>
                                                <% } %>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li><a class="dropdown-item rounded-2 text-danger" href="followups?action=delete&id=<%= f.getFollowId() %>" onclick="return confirm('Delete this follow-up?')">
                                                    <i class="bi bi-trash me-2"></i> Delete</a></li>
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
                                        <h5 class="fw-bold">No follow-ups scheduled</h5>
                                        <p class="small">Stay on top of your leads by scheduling follow-ups.</p>
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
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Schedule Follow-up</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Save Follow-up</button>
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