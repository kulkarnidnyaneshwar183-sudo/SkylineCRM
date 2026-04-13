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
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .table-card { border-radius: 15px; overflow: hidden; }
        .status-available { background-color: #d1e7dd; color: #0f5132; }
        .status-booked { background-color: #f8d7da; color: #842029; }
        .status-reserved { background-color: #fff3cd; color: #664d03; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="bi bi-building me-2"></i>Property Inventory</h3>
            <button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addFlatModal">
                <i class="bi bi-plus-lg me-2"></i>Add Property
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
                <div class="card border-0 shadow-sm p-3 text-center h-100" style="border-radius: 12px;">
                    <div class="text-muted small fw-bold text-uppercase">Total Units</div>
                    <div class="h4 fw-bold mb-0 text-primary"><%= total %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm p-3 text-center h-100" style="border-radius: 12px;">
                    <div class="text-muted small fw-bold text-uppercase">Available</div>
                    <div class="h4 fw-bold mb-0 text-success"><%= available %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm p-3 text-center h-100" style="border-radius: 12px;">
                    <div class="text-muted small fw-bold text-uppercase">Booked</div>
                    <div class="h4 fw-bold mb-0 text-danger"><%= booked %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm p-3 text-center h-100" style="border-radius: 12px;">
                    <div class="text-muted small fw-bold text-uppercase">Reserved</div>
                    <div class="h4 fw-bold mb-0 text-warning"><%= reserved %></div>
                </div>
            </div>
        </div>

        <!-- Inventory Grid -->
        <div class="row g-4">
            <% if(flatList != null && !flatList.isEmpty()) { 
                for(Flat f : flatList) { 
                    String statusBadgeClass = "";
                    if("Available".equals(f.getStatus())) statusBadgeClass = "bg-success";
                    else if("Booked".equals(f.getStatus())) statusBadgeClass = "bg-danger";
                    else if("Reserved".equals(f.getStatus())) statusBadgeClass = "bg-warning text-dark";
            %>
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <div class="card border-0 shadow-sm h-100 overflow-hidden property-card" style="border-radius: 15px; transition: 0.3s;">
                        <div class="position-relative">
                            <img src="<%= f.getImageUrl() %>" class="card-img-top" alt="Property Image" style="height: 200px; object-fit: cover;">
                            <span class="badge <%= statusBadgeClass %> position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill shadow-sm">
                                <%= f.getStatus() %>
                            </span>
                        </div>
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="fw-bold mb-0 text-dark"><%= f.getBuildingName() %> - <%= f.getFlatNumber() %></h5>
                                <div class="dropdown">
                                    <button class="btn btn-link text-muted p-0" data-bs-toggle="dropdown">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                                        <li><button class="dropdown-item" onclick="editFlat(<%= f.getFlatId() %>, '<%= f.getStatus() %>', <%= f.getPrice() %>)" data-bs-toggle="modal" data-bs-target="#editFlatModal"><i class="bi bi-pencil me-2"></i>Edit Details</button></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="inventory?action=delete&id=<%= f.getFlatId() %>" onclick="return confirm('Delete this property?')"><i class="bi bi-trash me-2"></i>Delete</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="mb-3">
                                <span class="badge bg-light text-dark border me-1"><%= f.getBhk() %></span>
                                <span class="badge bg-light text-dark border me-1"><%= f.getFloor() %>th Floor</span>
                                <span class="badge bg-light text-dark border"><%= f.getAreaSqft() %> sqft</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="h5 fw-bold text-primary mb-0">₹<%= String.format("%.2f", f.getPrice()) %></div>
                                <button class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="editFlat(<%= f.getFlatId() %>, '<%= f.getStatus() %>', <%= f.getPrice() %>)" data-bs-toggle="modal" data-bs-target="#editFlatModal">Update</button>
                            </div>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <div class="col-12 text-center py-5 text-muted">
                    <i class="bi bi-building-exclamation display-1"></i>
                    <p class="mt-3 h5">No properties found in inventory.</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Add Flat Modal -->
    <div class="modal fade" id="addFlatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-primary text-white p-4" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Add New Property</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="inventory?action=add" method="POST">
                    <div class="modal-body p-4">
                        <div class="row g-4">
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
                                <div class="form-text">Paste a direct image link from the web.</div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-5 shadow">Save Property</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Flat Modal -->
    <div class="modal fade" id="editFlatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <div class="modal-header bg-dark text-white" style="border-radius: 15px 15px 0 0;">
                    <h5 class="modal-title fw-bold">Update Property</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
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
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Price (₹)</label>
                            <input type="number" step="0.01" name="price" id="editPrice" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary rounded-pill w-100">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editFlat(id, status, price) {
        document.getElementById('editFlatId').value = id;
        document.getElementById('editStatus').value = status;
        document.getElementById('editPrice').value = price;
    }
</script>
</body>
</html>