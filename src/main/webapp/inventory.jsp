<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.crm.model.Flat" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    List<Flat> flatList = (List<Flat>) request.getAttribute("flatList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory Management - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold m-0 text-dark"><i class="bi bi-building-fill me-2 text-primary"></i>Property Inventory</h3>
                <p class="text-muted small mb-0">Monitor and manage available units across all projects.</p>
            </div>
            <button class="btn btn-primary-custom rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addFlatModal">
                <i class="bi bi-plus-lg me-2"></i>Add New Property
            </button>
        </div>

        <!-- Availability Summary -->
        <%
            int total = 0, available = 0, booked = 0, reserved = 0;
            if(flatList != null) {
                total = flatList.size();
                for(Flat f : flatList) {
                    if("Available".equals(f.getStatus())) available++;
                    else if("Booked".equals(f.getStatus())) booked++;
                    else if("Reserved".equals(f.getStatus())) reserved++;
                }
            }
        %>
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card stat-card border-0 p-3 text-center h-100">
                    <div class="text-muted small fw-bold text-uppercase mb-1">Total Units</div>
                    <div class="h4 fw-bold mb-0 text-dark"><%= total %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card border-0 p-3 text-center h-100">
                    <div class="text-muted small fw-bold text-uppercase mb-1">Available</div>
                    <div class="h4 fw-bold mb-0 text-success"><%= available %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card border-0 p-3 text-center h-100">
                    <div class="text-muted small fw-bold text-uppercase mb-1">Booked</div>
                    <div class="h4 fw-bold mb-0 text-danger"><%= booked %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card border-0 p-3 text-center h-100">
                    <div class="text-muted small fw-bold text-uppercase mb-1">Reserved</div>
                    <div class="h4 fw-bold mb-0 text-warning"><%= reserved %></div>
                </div>
            </div>
        </div>

        <!-- Inventory Grid -->
        <div class="row g-4 mb-5">
            <% if(flatList != null && !flatList.isEmpty()) { 
                for(Flat f : flatList) { 
                    String statusBadgeClass = "bg-success bg-opacity-10 text-success";
                    if("Booked".equals(f.getStatus())) statusBadgeClass = "bg-danger bg-opacity-10 text-danger";
                    else if("Reserved".equals(f.getStatus())) statusBadgeClass = "bg-warning bg-opacity-10 text-warning";
            %>
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <div class="card border-0 shadow-sm h-100 overflow-hidden rounded-4 property-card">
                        <div class="position-relative">
                            <img src="<%= f.getImageUrl() %>" class="card-img-top" alt="Property Image" style="height: 200px; object-fit: cover;">
                            <span class="badge <%= statusBadgeClass %> position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill shadow-sm">
                                <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                <%= f.getStatus() %>
                            </span>
                        </div>
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="fw-bold mb-0 text-dark text-truncate" style="max-width: 80%;"><%= f.getBuildingName() %> - <%= f.getFlatNumber() %></h5>
                                <div class="dropdown">
                                    <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px;">
                                        <li><button class="dropdown-item rounded-2" onclick="editFlat(<%= f.getFlatId() %>, '<%= f.getStatus() %>', <%= f.getPrice() %>)" data-bs-toggle="modal" data-bs-target="#editFlatModal">
                                            <i class="bi bi-pencil me-2"></i> Update Status</button></li>
                                        <li><hr class="dropdown-divider opacity-50"></li>
                                        <li><a class="dropdown-item rounded-2 text-danger" href="inventory?action=delete&id=<%= f.getFlatId() %>" onclick="return confirm('Delete this property?')">
                                            <i class="bi bi-trash me-2"></i> Delete Unit</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="mb-3 d-flex flex-wrap gap-2">
                                <span class="badge bg-light text-dark border rounded-pill"><i class="bi bi-door-closed me-1"></i><%= f.getBhk() %></span>
                                <span class="badge bg-light text-dark border rounded-pill"><i class="bi bi-layers me-1"></i><%= f.getFloor() %>F</span>
                                <span class="badge bg-light text-dark border rounded-pill"><i class="bi bi-aspect-ratio me-1"></i><%= f.getAreaSqft() %> sqft</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mt-auto pt-3 border-top">
                                <div class="h5 fw-bold text-primary mb-0">₹<%= String.format("%.2f", f.getPrice()) %></div>
                                <button class="btn btn-sm btn-primary-custom rounded-pill px-3" onclick="editFlat(<%= f.getFlatId() %>, '<%= f.getStatus() %>', <%= f.getPrice() %>)" data-bs-toggle="modal" data-bs-target="#editFlatModal">Update</button>
                            </div>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <div class="col-12">
                    <div class="empty-state card border-0 p-large">
                        <i class="bi bi-building-add display-1 mb-4 opacity-50"></i>
                        <h2 class="fw-bold mb-2">No Properties Yet</h2>
                        <p class="text-muted mb-4 fs-5">Your inventory is currently empty. Start adding properties to manage your sales.</p>
                        <button class="btn btn-primary-custom btn-lg rounded-pill px-5" data-bs-toggle="modal" data-bs-target="#addFlatModal">
                            <i class="bi bi-plus-lg me-2"></i>Add First Property
                        </button>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Add Flat Modal -->
    <div class="modal fade" id="addFlatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Add New Property</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="inventory?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Building Name</label>
                                <input type="text" name="buildingName" class="form-control" placeholder="e.g. Skyline Heights" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Flat Number</label>
                                <input type="text" name="flatNumber" class="form-control" placeholder="e.g. A-101" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Floor</label>
                                <input type="number" name="floor" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">BHK</label>
                                <select name="bhk" class="form-select">
                                    <option value="1BHK">1 BHK</option>
                                    <option value="2BHK">2 BHK</option>
                                    <option value="3BHK">3 BHK</option>
                                    <option value="4BHK">4 BHK</option>
                                    <option value="Penthouse">Penthouse</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Initial Status</label>
                                <select name="status" class="form-select">
                                    <option value="Available">Available</option>
                                    <option value="Reserved">Reserved</option>
                                    <option value="Booked">Booked</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Area (sqft)</label>
                                <input type="number" step="0.01" name="areaSqft" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Price (₹)</label>
                                <input type="number" step="0.01" name="price" class="form-control" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold">Property Image URL</label>
                                <input type="url" name="imageUrl" class="form-control" placeholder="https://example.com/image.jpg">
                                <div class="form-text small">Paste a direct image link from the web.</div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-5">Save Property</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Flat Modal -->
    <div class="modal fade" id="editFlatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-bold">Update Property</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="inventory?action=update" method="POST">
                    <input type="hidden" name="flatId" id="editFlatId">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Status</label>
                            <select name="status" id="editStatus" class="form-select">
                                <option value="Available">Available</option>
                                <option value="Reserved">Reserved</option>
                                <option value="Booked">Booked</option>
                            </select>
                        </div>
                        <div class="mb-0">
                            <label class="form-label small fw-bold">Price (₹)</label>
                            <input type="number" step="0.01" name="price" id="editPrice" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary-custom rounded-pill w-100">Update Property</button>
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
<script>
    function editFlat(id, status, price) {
        document.getElementById('editFlatId').value = id;
        document.getElementById('editStatus').value = status;
        document.getElementById('editPrice').value = price;
    }
</script>
</body>
</html>