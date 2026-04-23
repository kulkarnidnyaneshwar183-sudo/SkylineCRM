<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, com.crm.util.DBConnection" %>
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
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-file-earmark-text-fill me-2 text-primary"></i>Document Repository</h3>
                <p class="text-muted small mb-0">Centralized storage for all client and project documents.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#uploadDocModal">
                <i class="bi bi-cloud-arrow-up me-2"></i>Upload New File
            </button>
        </div>

        <!-- Documents Table -->
        <div class="card table-card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Document Title</th>
                                <th>File Name</th>
                                <th>Uploaded By</th>
                                <th>Upload Date</th>
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
                                        String fileName = rs.getString("file_name");
                                        String iconClass = "bi-file-earmark";
                                        String iconColor = "text-secondary";
                                        
                                        if(fileName.endsWith(".pdf")) { iconClass = "bi-file-earmark-pdf-fill"; iconColor = "text-danger"; }
                                        else if(fileName.endsWith(".doc") || fileName.endsWith(".docx")) { iconClass = "bi-file-earmark-word-fill"; iconColor = "text-primary"; }
                                        else if(fileName.endsWith(".xls") || fileName.endsWith(".xlsx")) { iconClass = "bi-file-earmark-excel-fill"; iconColor = "text-success"; }
                                        else if(fileName.endsWith(".jpg") || fileName.endsWith(".png")) { iconClass = "bi-file-earmark-image-fill"; iconColor = "text-info"; }
                            %>
                                    <tr>
                                        <td class="ps-4">
                                            <div class="fw-bold"><%= rs.getString("title") %></div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="bi <%= iconClass %> <%= iconColor %> fs-5 me-2"></i>
                                                <span class="small text-muted"><%= fileName %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border rounded-pill px-3">
                                                <i class="bi bi-person me-1"></i><%= rs.getString("user_name") %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="small text-muted"><%= rs.getTimestamp("uploaded_at") %></div>
                                        </td>
                                        <td class="pe-4 text-end">
                                            <a href="uploads/<%= rs.getString("file_path") %>" class="btn btn-light btn-sm rounded-pill px-3 shadow-sm border" target="_blank">
                                                <i class="bi bi-eye-fill me-1 text-primary"></i> View
                                            </a>
                                        </td>
                                    </tr>
                            <%
                                    }
                                    if (!hasDocs) {
                            %>
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <div class="mb-3">
                                                <i class="bi bi-folder2-open display-1 opacity-25"></i>
                                            </div>
                                            <h5 class="fw-bold">No documents found</h5>
                                            <p class="small">Start by uploading your first document.</p>
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
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Upload Document</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="upload?type=document" method="POST" enctype="multipart/form-data">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Document Title</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g. Sales Report 2024" required>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Choose File</label>
                            <div class="border rounded-3 p-4 text-center bg-light">
                                <i class="bi bi-cloud-arrow-up display-4 text-primary opacity-50 mb-2"></i>
                                <input type="file" name="file" class="form-control" required>
                                <p class="text-muted small mt-2 mb-0">Supported formats: PDF, DOC, XLS, Images</p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4">Upload Now</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

<script src="assets/js/main.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
