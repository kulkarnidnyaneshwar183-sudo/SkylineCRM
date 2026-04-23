<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, com.crm.util.DBConnection, java.util.*, java.text.SimpleDateFormat" %>
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

    } catch(Exception e) {
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
    <link rel="stylesheet" href="assets/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light">

    <%@ include file="WEB-INF/sidebar.jspf" %>

    <div class="container-fluid">
        <!-- Pro Greeting & Live Clock -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h2 class="fw-bold mb-1" id="greeting">Hello, <%= session.getAttribute("username") %>!</h2>
                <p class="text-muted mb-0"><i class="bi bi-calendar3 me-2"></i><span id="liveDate"></span></p>
            </div>
            <div class="text-md-end">
                <div class="h3 fw-bold mb-0 text-primary" id="liveTime">00:00:00</div>
                <span class="badge bg-success bg-opacity-10 text-success border-0 px-3 py-2 rounded-pill">
                    <i class="bi bi-shield-check me-1"></i>System Secure & Active
                </span>
            </div>
        </div>

        <!-- Performance Metrics Row -->
        <div class="row g-4 mb-4">
            <div class="col-12">
                <div class="card p-4 border-0 shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0"><i class="bi bi-graph-up-arrow me-2 text-primary"></i>Monthly Performance Targets</h5>
                        <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-2">Fiscal Year 2024-25</span>
                    </div>
                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="small fw-bold text-muted">Revenue Goal (₹50L)</span>
                                <span class="small fw-bold text-primary">₹<%= String.format("%.0f", totalRevenue/100000) %>L / 50L</span>
                            </div>
                            <div class="progress pro-progress">
                                <div class="progress-bar pro-progress-bar" style="width: <%= Math.min(100, (totalRevenue/5000000)*100) %>%"></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="small fw-bold text-muted">Booking Target (50 Units)</span>
                                <span class="small fw-bold text-danger"><%= bookingCount %> / 50</span>
                            </div>
                            <div class="progress pro-progress">
                                <div class="progress-bar bg-danger" style="width: <%= Math.min(100, (bookingCount/50.0)*100) %>%"></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="small fw-bold text-muted">Lead Pipeline (100)</span>
                                <span class="small fw-bold text-success"><%= leadCount %> / 100</span>
                            </div>
                            <div class="progress pro-progress">
                                <div class="progress-bar bg-success" style="width: <%= Math.min(100, (leadCount/100.0)*100) %>%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-large">
            <!-- Available Card (Inventory) -->
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-available d-inline-block">
                        <i class="bi bi-building-check"></i>
                    </div>
                    <h6 class="text-muted fw-bold small text-uppercase">Available Flats</h6>
                    <h2 class="text-dark"><%= inventoryCount %></h2>
                    <span class="badge bg-success bg-opacity-10 text-success rounded-pill">Ready to sell</span>
                </div>
            </div>

            <!-- Booked Card -->
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-booked d-inline-block">
                        <i class="bi bi-journal-check"></i>
                    </div>
                    <h6 class="text-muted fw-bold small text-uppercase">Total Bookings</h6>
                    <h2 class="text-dark"><%= bookingCount %></h2>
                    <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill">Closed Deals</span>
                </div>
            </div>

            <!-- Leads Card (Reserved/Yellow context) -->
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-reserved d-inline-block">
                        <i class="bi bi-person-plus-fill"></i>
                    </div>
                    <h6 class="text-muted fw-bold small text-uppercase">Active Leads</h6>
                    <h2 class="text-dark"><%= leadCount %></h2>
                    <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill">In Progress</span>
                </div>
            </div>

            <!-- Revenue Card -->
            <div class="col-md-3">
                <div class="stat-card bg-primary text-white">
                    <div class="stat-icon bg-white bg-opacity-20 d-inline-block text-white">
                        <i class="bi bi-currency-dollar"></i>
                    </div>
                    <h6 class="text-white-50 fw-bold small text-uppercase">Total Revenue</h6>
                    <h2 class="text-white">₹<%= String.format("%.0f", totalRevenue) %></h2>
                    <span class="badge bg-white text-primary rounded-pill">Gross Sales</span>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row g-4 mt-2 justify-content-center">
            <div class="col-md-6">
                <div class="card table-card p-4">
                    <h5 class="fw-bold mb-3 text-center">Business Distribution</h5>
                    <div style="height: 200px;">
                        <canvas id="distributionChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4 g-4">
            <div class="col-md-8">
                <div class="card table-card p-4">
                    <h5 class="fw-bold mb-4">Quick Navigation</h5>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="enquiries" class="btn btn-light border px-4 py-2 rounded-pill shadow-sm">
                            <i class="bi bi-chat-left-text me-2 text-info"></i>Enquiries
                        </a>
                        <a href="leads" class="btn btn-light border px-4 py-2 rounded-pill shadow-sm">
                            <i class="bi bi-person-plus me-2 text-danger"></i>Leads
                        </a>
                        <a href="bookings" class="btn btn-light border px-4 py-2 rounded-pill shadow-sm">
                            <i class="bi bi-journal-check me-2 text-success"></i>Bookings
                        </a>
                        <a href="tasks" class="btn btn-light border px-4 py-2 rounded-pill shadow-sm">
                            <i class="bi bi-check2-square me-2 text-warning"></i>Tasks
                        </a>
                        <a href="inventory" class="btn btn-light border px-4 py-2 rounded-pill shadow-sm">
                            <i class="bi bi-building me-2 text-primary"></i>Inventory
                        </a>
                        <a href="expenses" class="btn btn-light border px-4 py-2 rounded-pill shadow-sm">
                            <i class="bi bi-wallet2 me-2 text-secondary"></i>Expenses
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card table-card p-4 bg-dark text-white border-0">
                    <div class="d-flex align-items-center mb-3">
                        <div class="icon-box bg-primary rounded-circle me-3">
                            <i class="bi bi-lightning-charge-fill text-white"></i>
                        </div>
                        <h5 class="fw-bold mb-0">Skyline Pro</h5>
                    </div>
                    <p class="text-white-50 small mb-4">Unlock advanced analytics and automated reporting for your real estate business.</p>
                    <button class="btn btn-primary w-100 rounded-pill">Upgrade Now</button>
                </div>
            </div>
        </div>
    </div><!-- Close p-4 p-md-5 -->
    </div><!-- Close page-content-wrapper -->
</div><!-- Close d-flex wrapper -->

<script src="assets/js/main.js"></script>
<script>
    // Distribution Chart
    const distCtx = document.getElementById('distributionChart').getContext('2d');
    new Chart(distCtx, {
        type: 'doughnut',
        data: {
            labels: ['Enquiries', 'Leads', 'Bookings'],
            datasets: [{
                data: [<%= enquiryCount %>, <%= leadCount %>, <%= bookingCount %>],
                backgroundColor: ['#0dcaf0', '#dc3545', '#198754'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' }
            },
            cutout: '70%'
        }
    });
</script>
</body>
</html>