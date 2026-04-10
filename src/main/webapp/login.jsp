<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Skyline CRM - Login</title>

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
        .login-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            width: 400px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .btn-login {
            background: #1a1a2e;
            color: white;
            width: 100%;
            padding: 10px;
        }
    </style>
</head>
<body>

<div class="login-card">
    <h3 class="text-center mb-2">🏢 Skyline CRM</h3>

    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <!-- ✅ FIXED ACTION -->
    <form action="<%= request.getContextPath() %>/login" method="post">

        <div class="mb-3">
            <label>Username</label>
            <input type="text"
                   name="username"
                   class="form-control"
                   required>
        </div>

        <div class="mb-3">
            <label>Password</label>
            <input type="password"
                   name="password"
                   class="form-control"
                   required>
        </div>

        <button type="submit" class="btn btn-login">
            Login
        </button>

        <div class="text-center mt-3">
            <small>Don't have an account? <a href="register">Register here</a></small>
        </div>

    </form>
</div>

</body>
</html>