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
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .welcome-card {
            text-align: center;
            padding: 60px;
        }
        .btn-start {
            background: white;
            color: #1a1a2e;
            padding: 12px 40px;
            border-radius: 30px;
            font-weight: bold;
            font-size: 18px;
            text-decoration: none;
        }
        .btn-start:hover {
            background: #f0f0f0;
            color: #1a1a2e;
        }
    </style>
</head>
<body>
    <div class="welcome-card">
        <h1 class="mb-2">🏢 Skyline CRM</h1>
        <p class="mb-1 fs-5">Construction & Real Estate Management System</p>
        <p class="text-muted mb-4">
            Manage Enquiries, Leads, Clients, Flats & More
        </p>
        <a href="login" class="btn-start">🚀 Get Started</a>
    </div>
</body>
</html>