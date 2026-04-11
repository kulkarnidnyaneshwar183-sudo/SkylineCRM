<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.model.Task, com.crm.model.User" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Task> taskList = (List<Task>) request.getAttribute("taskList");
    List<User> userList = (List<User>) request.getAttribute("userList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Task Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .task-card { border-radius: 15px; border: none; }
        .completed { text-decoration: line-through; color: #6c757d; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-list-task me-2"></i>Task Management</h3>
            <button class="btn btn-dark rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addTaskModal">
                <i class="bi bi-plus-lg me-2"></i>New Task
            </button>
        </div>

        <div class="row">
            <!-- Task List -->
            <div class="col-12">
                <div class="card border-0 shadow-sm task-card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">Task Details</th>
                                        <th>Assigned To</th>
                                        <th>Deadline</th>
                                        <th>Status</th>
                                        <th class="pe-4 text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(taskList != null && !taskList.isEmpty()) { 
                                        for(Task t : taskList) { %>
                                        <tr>
                                            <td class="ps-4">
                                                <div class="fw-bold <%= t.getStatus().equals("Completed") ? "completed" : "" %>">
                                                    <%= t.getTitle() %>
                                                </div>
                                                <small class="text-muted"><%= t.getDescription() %></small>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border px-3">
                                                    <%= t.getAssignedToName() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="<%= t.getStatus().equals("Pending") ? "text-danger fw-bold" : "text-muted" %>">
                                                    <i class="bi bi-clock me-1"></i><%= t.getDeadline() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge <%= t.getStatus().equals("Completed") ? "bg-success" : "bg-warning text-dark" %> rounded-pill">
                                                    <%= t.getStatus() %>
                                                </span>
                                            </td>
                                            <td class="pe-4 text-end">
                                                <% if(t.getStatus().equals("Pending")) { %>
                                                    <a href="tasks?action=complete&id=<%= t.getTaskId() %>" class="btn btn-sm btn-success me-1">
                                                        <i class="bi bi-check-lg"></i> Complete
                                                    </a>
                                                <% } %>
                                                <a href="tasks?action=delete&id=<%= t.getTaskId() %>" 
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('Remove this task?')">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } } else { %>
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <i class="bi bi-check2-square display-4"></i>
                                                <p class="mt-2">No tasks assigned yet.</p>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Task Modal -->
    <div class="modal fade" id="addTaskModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-dark text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Create New Task</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="tasks?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Task Title</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g. Follow up with Lead" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Description</label>
                            <textarea name="description" class="form-control" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Assign To</label>
                            <select name="assignedTo" class="form-select" required>
                                <% if(userList != null) { 
                                    for(User u : userList) { %>
                                    <option value="<%= u.getUserId() %>"><%= u.getFullName() %> (<%= u.getRole() %>)</option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Deadline</label>
                            <input type="date" name="deadline" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-dark rounded-pill px-4">Assign Task</button>
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