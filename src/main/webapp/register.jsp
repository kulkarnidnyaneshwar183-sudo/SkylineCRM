<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Skyline CRM - Create Account</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="auth-page">

<div class="auth-card" style="max-width: 500px;">
    <div class="text-center mb-4">
        <h2 class="fw-bold text-dark">🏢 Skyline CRM</h2>
        <p class="text-muted small">Join our Real Estate Management Platform</p>
    </div>

    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-danger border-0 shadow-sm rounded-3 mb-4">
            <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
        </div>
    <% } %>

    <% if(request.getAttribute("message") != null) { %>
        <div class="alert alert-success border-0 shadow-sm rounded-3 mb-4">
            <i class="bi bi-check-circle me-2"></i><%= request.getAttribute("message") %>
            <div class="mt-2"><a href="login" class="btn btn-sm btn-success rounded-pill px-3">Login Now</a></div>
        </div>
    <% } %>

    <form action="register" method="post">
        <div class="mb-3">
            <label class="form-label small fw-bold text-uppercase tracking-wider">Full Name</label>
            <div class="input-group">
                <span class="input-group-text bg-light border-0"><i class="bi bi-person-badge"></i></span>
                <input type="text" name="fullName" class="form-control form-control-lg bg-light border-0" placeholder="John Doe" required>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label small fw-bold text-uppercase tracking-wider">Username</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-0"><i class="bi bi-at"></i></span>
                    <input type="text" name="username" class="form-control form-control-lg bg-light border-0" placeholder="john.doe" required>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-bold text-uppercase tracking-wider">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-0"><i class="bi bi-shield-lock"></i></span>
                    <input type="password" name="password" class="form-control form-control-lg bg-light border-0" placeholder="••••••••" required>
                </div>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label small fw-bold text-uppercase tracking-wider">Select Role</label>
            <select name="role" class="form-select form-select-lg bg-light border-0">
                <option value="Admin">🔑 Admin</option>
                <option value="Sales">💼 Sales Executive</option>
                <option value="Manager">👔 Manager</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary-custom w-100 py-3 rounded-pill shadow mb-4">
            Create Account <i class="bi bi-person-plus ms-2"></i>
        </button>
        
        <div class="text-center">
            <p class="text-muted small mb-0">Already have an account? <a href="login" class="text-primary fw-bold text-decoration-none">Sign In</a></p>
        </div>
    </form>
</div>

</body>
</html>
