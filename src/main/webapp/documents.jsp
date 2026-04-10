<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, com.crm.DBConnection" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Document Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-file-earmark-text me-2"></i>Documents Management</h3>
            <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#uploadDocModal">
                <i class="bi bi-cloud-arrow-up me-2"></i>Upload Document
            </button>
        </div>

        <!-- Documents Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Title</th>
                                <th>File Name</th>
                                <th>Uploaded By</th>
                                <th>Date</th>
                                <th class="pe-4 text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try (Connection con = DBConnection.getConnection()) {
                                    String sql = "SELECT d.*, u.full_name as user_name FROM documents d JOIN users u ON d.uploaded_by = u.user_id ORDER BY d.uploaded_at DESC";
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery(sql);
                                    boolean hasDocs = false;
                                    while (rs.next()) {
                                        hasDocs = true;
                            %>
                                    <tr>
                                        <td class="ps-4"><strong><%= rs.getString("title") %></strong></td>
                                        <td><i class="bi bi-file-earmark-pdf me-2 text-danger"></i><%= rs.getString("file_name") %></td>
                                        <td><%= rs.getString("user_name") %></td>
                                        <td><%= rs.getTimestamp("uploaded_at") %></td>
                                        <td class="pe-4 text-end">
                                            <a href="uploads/<%= rs.getString("file_path") %>" class="btn btn-sm btn-outline-primary rounded-pill px-3" target="_blank">
                                                <i class="bi bi-download"></i> View
                                            </a>
                                        </td>
                                    </tr>
                            <%
                                    }
                                    if (!hasDocs) {
                            %>
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="bi bi-folder2-open display-4"></i>
                                            <p class="mt-2">No documents uploaded yet.</p>
                                        </td>
                                    </tr>
                            <%
                                    }
                                } catch (Exception e) { e.printStackTrace(); }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Upload Document Modal -->
    <div class="modal fade" id="uploadDocModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Upload Document</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="upload?type=document" method="POST" enctype="multipart/form-data">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Document Title</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g. Sales Report 2024" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Choose File</label>
                            <input type="file" name="file" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Upload Now</button>
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