<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Skyline CRM - Register</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            width: 450px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .btn-register {
            background: #1a1a2e;
            color: white;
            width: 100%;
            padding: 10px;
        }
    </style>
</head>
<body>

<div class="register-card">
    <h3 class="text-center mb-2">📝 Register</h3>
    <p class="text-muted text-center mb-4">Create your Skyline CRM account</p>

    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <% if(request.getAttribute("message") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("message") %>
            <a href="login">Login now</a>
        </div>
    <% } %>

    <form action="register" method="post">
        <div class="mb-3">
            <label>Full Name</label>
            <input type="text" name="fullName" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Username</label>
            <input type="text" name="username" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Role</label>
            <select name="role" class="form-select">
                <option value="Admin">Admin</option>
                <option value="Sales">Sales</option>
                <option value="Manager">Manager</option>
            </select>
        </div>

        <button type="submit" class="btn btn-register">
            Sign Up
        </button>
        
        <div class="text-center mt-3">
            <small>Already have an account? <a href="login">Login</a></small>
        </div>
    </form>
</div>

</body>
</html>