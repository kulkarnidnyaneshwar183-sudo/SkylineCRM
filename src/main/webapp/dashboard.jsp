<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, com.crm.util.DBConnection" %>
<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    String role = (String) session.getAttribute("role");
    
    int enquiryCount = 0, leadCount = 0, bookingCount = 0, pendingTaskCount = 0;
    int clientCount = 0, inventoryCount = 0;
    double totalRevenue = 0, totalCollection = 0;
    Connection con = null;
    Statement st = null;
    try {
        con = DBConnection.getConnection();
        st = con.createStatement();
        
        // 1. Total Enquiries
        ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM enquiries");
        if(rs1.next()) enquiryCount = rs1.getInt(1);
        rs1.close();
        
        // 2. Total Leads
        ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM leads");
        if(rs2.next()) leadCount = rs2.getInt(1);
        rs2.close();
        
        // 3. Total Bookings
        ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM bookings");
        if(rs3.next()) bookingCount = rs3.getInt(1);
        rs3.close();
        
        // 4. Tasks Pending
        ResultSet rs4 = st.executeQuery("SELECT COUNT(*) FROM tasks WHERE status = 'Pending'");
        if(rs4.next()) pendingTaskCount = rs4.getInt(1);
        rs4.close();

        // 5. Total Clients
        ResultSet rs5 = st.executeQuery("SELECT COUNT(*) FROM clients");
        if(rs5.next()) clientCount = rs5.getInt(1);
        rs5.close();

        // 6. Total Inventory
        ResultSet rs6 = st.executeQuery("SELECT COUNT(*) FROM flats");
        if(rs6.next()) inventoryCount = rs6.getInt(1);
        rs6.close();

        // 7. Revenue & Collection
        ResultSet rs7 = st.executeQuery("SELECT SUM(total_amount), SUM(paid_amount) FROM bookings");
        if(rs7.next()) {
            totalRevenue = rs7.getDouble(1);
            totalCollection = rs7.getDouble(2);
        }
        rs7.close();
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if(st != null) try { st.close(); } catch(SQLException e) {}
        if(con != null) try { con.close(); } catch(SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-effect:hover { background-color: #0d6efd !important; border-radius: 5px; margin: 0 10px; transition: 0.3s; }
        .stat-card { border-radius: 15px; border: none; transition: 0.3s; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
        .icon-box { width: 50px; height: 50px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
    </style>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <h3 class="mb-4 fw-bold">Performance Overview</h3>
        
        <div class="row g-4">
            <!-- Revenue Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100 bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="icon-box bg-white bg-opacity-20 text-white">
                                <i class="bi bi-currency-dollar"></i>
                            </div>
                            <span class="badge bg-white text-primary rounded-pill">Revenue</span>
                        </div>
                        <h6 class="text-white-50 mb-1">Total Sales</h6>
                        <h2 class="fw-bold mb-0">₹<%= String.format("%.0f", totalRevenue) %></h2>
                    </div>
                </div>
            </div>

            <!-- Collection Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100 bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="icon-box bg-white bg-opacity-20 text-white">
                                <i class="bi bi-piggy-bank"></i>
                            </div>
                            <span class="badge bg-white text-success rounded-pill">Collection</span>
                        </div>
                        <h6 class="text-white-50 mb-1">Total Collection</h6>
                        <h2 class="fw-bold mb-0">₹<%= String.format("%.0f", totalCollection) %></h2>
                    </div>
                </div>
            </div>

            <!-- Leads Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="icon-box bg-danger bg-opacity-10 text-danger">
                                <i class="bi bi-person-plus"></i>
                            </div>
                            <span class="badge bg-danger rounded-pill">Leads</span>
                        </div>
                        <h6 class="text-muted mb-1">Total Leads</h6>
                        <h2 class="fw-bold mb-0 text-danger"><%= leadCount %></h2>
                    </div>
                </div>
            </div>

            <!-- Bookings Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="icon-box bg-info bg-opacity-10 text-info">
                                <i class="bi bi-calendar-check"></i>
                            </div>
                            <span class="badge bg-info rounded-pill">Bookings</span>
                        </div>
                        <h6 class="text-muted mb-1">Total Bookings</h6>
                        <h2 class="fw-bold mb-0 text-info"><%= bookingCount %></h2>
                    </div>
                </div>
            </div>

            <!-- Enquiries Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100 border-start border-4 border-info">
                    <div class="card-body py-3">
                        <div class="d-flex align-items-center">
                            <div class="icon-box bg-info bg-opacity-10 text-info me-3">
                                <i class="bi bi-chat-dots fs-5"></i>
                            </div>
                            <div>
                                <h6 class="text-muted mb-0 small">Enquiries</h6>
                                <h4 class="fw-bold mb-0"><%= enquiryCount %></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Clients Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100 border-start border-4 border-primary">
                    <div class="card-body py-3">
                        <div class="d-flex align-items-center">
                            <div class="icon-box bg-primary bg-opacity-10 text-primary me-3">
                                <i class="bi bi-people fs-5"></i>
                            </div>
                            <div>
                                <h6 class="text-muted mb-0 small">Total Clients</h6>
                                <h4 class="fw-bold mb-0"><%= clientCount %></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Inventory Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100 border-start border-4 border-secondary">
                    <div class="card-body py-3">
                        <div class="d-flex align-items-center">
                            <div class="icon-box bg-secondary bg-opacity-10 text-secondary me-3">
                                <i class="bi bi-building fs-5"></i>
                            </div>
                            <div>
                                <h6 class="text-muted mb-0 small">Inventory Units</h6>
                                <h4 class="fw-bold mb-0"><%= inventoryCount %></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Tasks Card -->
            <div class="col-md-3">
                <div class="card stat-card shadow-sm h-100 border-start border-4 border-warning">
                    <div class="card-body py-3">
                        <div class="d-flex align-items-center">
                            <div class="icon-box bg-warning bg-opacity-10 text-warning me-3">
                                <i class="bi bi-list-task fs-5"></i>
                            </div>
                            <div>
                                <h6 class="text-muted mb-0 small">Pending Tasks</h6>
                                <h4 class="fw-bold mb-0 text-warning"><%= pendingTaskCount %></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-5">
            <div class="col-md-8">
                <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: 15px;">
                    <h5 class="fw-bold mb-4">Quick Navigation</h5>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="enquiries" class="btn btn-outline-info px-4 rounded-pill">
                            <i class="bi bi-chat-dots me-2"></i>Enquiries
                        </a>
                        <a href="leads" class="btn btn-outline-danger px-4 rounded-pill">
                            <i class="bi bi-plus-circle me-2"></i>Leads
                        </a>
                        <a href="bookings" class="btn btn-outline-success px-4 rounded-pill">
                            <i class="bi bi-calendar-check me-2"></i>Bookings
                        </a>
                        <a href="tasks" class="btn btn-outline-warning text-dark px-4 rounded-pill">
                            <i class="bi bi-list-check me-2"></i>Tasks
                        </a>
                        <a href="inventory" class="btn btn-outline-primary px-4 rounded-pill">
                            <i class="bi bi-building me-2"></i>Inventory
                        </a>
                        <a href="expenses" class="btn btn-outline-secondary px-4 rounded-pill">
                            <i class="bi bi-wallet2 me-2"></i>Expenses
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-4 h-100 text-center bg-dark text-white" style="border-radius: 15px;">
                    <div class="my-auto">
                        <i class="bi bi-rocket-takeoff text-primary display-4"></i>
                        <h5 class="mt-3 fw-bold">Skyline Performance</h5>
                        <p class="text-white-50 small">Monitor your company's growth and team productivity in real-time.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

</body>
</html>