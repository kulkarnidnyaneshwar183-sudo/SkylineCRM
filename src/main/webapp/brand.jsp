<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Brand Identity - Skyline CRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-blue: #0062ff;
            --brand-dark: #0f172a;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .logo-container {
            text-align: center;
            padding: 4rem;
            background: white;
            border-radius: 40px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.05);
            max-width: 600px;
            width: 90%;
            border: 1px solid rgba(0, 98, 255, 0.1);
        }
        .icon-stack {
            position: relative;
            display: inline-block;
            margin-bottom: 2rem;
        }
        .main-icon {
            font-size: 5rem;
            color: var(--brand-blue);
            line-height: 1;
        }
        .growth-overlay {
            position: absolute;
            bottom: -10px;
            right: -15px;
            background: white;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 20px rgba(0, 98, 255, 0.2);
            color: var(--brand-blue);
            font-size: 1.8rem;
            border: 2px solid #f0f4ff;
        }
        .brand-title {
            font-size: 3.5rem;
            font-weight: 800;
            color: var(--brand-dark);
            letter-spacing: -2px;
            margin-bottom: 0.5rem;
        }
        .brand-title span {
            color: var(--brand-blue);
        }
        .brand-tagline {
            font-size: 1.1rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 4px;
            margin-top: 1rem;
        }
        .divider {
            width: 60px;
            height: 4px;
            background: var(--brand-blue);
            margin: 2rem auto;
            border-radius: 10px;
        }
    </style>
</head>
<body>

    <div class="logo-container">
        <div class="icon-stack">
            <i class="bi bi-buildings-fill main-icon"></i>
            <div class="growth-overlay">
                <i class="bi bi-graph-up-arrow"></i>
            </div>
        </div>
        
        <h1 class="brand-title">Skyline <span>CRM</span></h1>
        
        <div class="divider"></div>
        
        <p class="brand-tagline">Accelerate Your Growth</p>
        
        <div class="mt-5">
            <a href="dashboard.jsp" class="btn btn-outline-primary rounded-pill px-4 fw-bold">Enter Dashboard</a>
        </div>
    </div>

</body>
</html>
