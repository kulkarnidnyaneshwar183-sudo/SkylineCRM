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
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-list-task me-2 text-primary"></i>Task Management</h3>
                <p class="text-muted small mb-0">Assign, track, and manage team tasks and deadlines.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addTaskModal">
                <i class="bi bi-plus-lg me-2"></i>New Task
            </button>
        </div>

        <!-- Task List -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
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
                                for(Task t : taskList) { 
                                    boolean isCompleted = "Completed".equals(t.getStatus());
                            %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold <%= isCompleted ? "text-strike" : "" %> text-dark">
                                            <%= t.getTitle() %>
                                        </div>
                                        <div class="small text-muted text-truncate" style="max-width: 300px;"><%= t.getDescription() %></div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar bg-info bg-opacity-10 text-info rounded-3 me-2" style="width: 24px; height: 24px; font-size: 0.7rem;">
                                                <%= t.getUserName().substring(0,1).toUpperCase() %>
                                            </div>
                                            <span class="small fw-medium"><%= t.getUserName() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="small <%= !isCompleted ? "text-danger fw-bold" : "text-muted" %>">
                                            <i class="bi bi-clock me-1"></i><%= t.getDeadline() %>
                                        </div>
                                    </td>
                                    <td>
                                        <% 
                                            String statusClass = isCompleted ? "bg-success bg-opacity-10 text-success" : "bg-warning bg-opacity-10 text-warning";
                                        %>
                                        <span class="badge <%= statusClass %> rounded-pill px-3">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                            <%= t.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                                <% if(t.getStatus().equals("Pending")) { %>
                                                    <li><a class="dropdown-item rounded-2 text-success" href="tasks?action=complete&id=<%= t.getTaskId() %>">
                                                        <i class="bi bi-check-circle me-2"></i> Mark Completed</a></li>
                                                <% } %>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li><a class="dropdown-item rounded-2 text-danger" href="tasks?action=delete&id=<%= t.getTaskId() %>" onclick="return confirm('Remove this task?')">
                                                    <i class="bi bi-trash me-2"></i> Delete Task</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <div class="mb-3">
                                            <i class="bi bi-check2-square display-1 opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold">No tasks found</h5>
                                        <p class="small">Assign tasks to your team to stay organized.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Task Modal -->
    <div class="modal fade" id="addTaskModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Create New Task</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="tasks?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Task Title</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g. Follow up with Lead" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Description</label>
                            <textarea name="description" class="form-control" rows="3" placeholder="Add more details about the task..."></textarea>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Assign To</label>
                                <select name="assignedTo" class="form-select" required>
                                    <% if(userList != null) { 
                                        for(User u : userList) { %>
                                        <option value="<%= u.getUserId() %>"><%= u.getFullName() %></option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Deadline</label>
                                <input type="date" name="deadline" class="form-control" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Assign Task</button>
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