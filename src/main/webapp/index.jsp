<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // If already logged in, go to dashboard
    if(session.getAttribute("userId") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Skyline CRM</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="login-page">
    <div class="welcome-card card shadow-lg p-5 bg-white text-dark" style="border-radius: 20px; max-width: 500px;">
        <img src="assets/img/flat-placeholder.jpg" class="img-fluid rounded-4 mb-4 shadow" alt="Flat Image">
        <h1 class="mb-2 fw-bold">🏢 Skyline CRM</h1>
        <p class="mb-1 fs-5 text-secondary">Real Estate Management</p>
        <p class="text-muted mb-4 small">
            Manage Enquiries, Leads, Clients, Flats & More with ease.
        </p>
        <a href="login" class="btn btn-primary btn-lg rounded-pill px-5 shadow-sm">🚀 Sign In</a>
    </div>
</body>
</html>