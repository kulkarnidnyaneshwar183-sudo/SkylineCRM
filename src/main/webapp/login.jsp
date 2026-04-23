<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Skyline CRM - Secure Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="auth-page">

<div class="auth-card">
    <div class="text-center mb-4">
        <h2 class="fw-bold text-dark">🏢 Skyline CRM</h2>
        <p class="text-muted small">Real Estate Management System</p>
    </div>

    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-danger border-0 shadow-sm rounded-3 mb-4">
            <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">
        <div class="mb-3">
            <label class="form-label small fw-bold text-uppercase tracking-wider">Username</label>
            <div class="input-group">
                <span class="input-group-text bg-light border-0"><i class="bi bi-person"></i></span>
                <input type="text" name="username" class="form-control form-control-lg bg-light border-0" placeholder="Enter username" required>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label small fw-bold text-uppercase tracking-wider">Password</label>
            <div class="input-group">
                <span class="input-group-text bg-light border-0"><i class="bi bi-shield-lock"></i></span>
                <input type="password" name="password" class="form-control form-control-lg bg-light border-0" placeholder="••••••••" required>
            </div>
        </div>

        <button type="submit" class="btn btn-primary-custom w-100 py-3 rounded-pill shadow mb-4">
            Sign In <i class="bi bi-arrow-right ms-2"></i>
        </button>

        <div class="text-center">
            <p class="text-muted small mb-0">Don't have an account? <a href="register" class="text-primary fw-bold text-decoration-none">Create Account</a></p>
        </div>
    </form>
</div>

</body>
</html>
