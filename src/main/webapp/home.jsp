<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Skyline CRM - Smart Real Estate Solutions</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-blue: #0062ff;
            --brand-dark: #0f172a;
            --nav-dark: #1e293b;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: var(--brand-dark);
            margin: 0;
            overflow-x: hidden;
        }

        /* 2. Top Navigation Bar */
        .navbar {
            background-color: var(--nav-dark) !important;
            padding: 1rem 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .navbar-brand {
            font-weight: 800;
            color: white !important;
            display: flex;
            align-items: center;
        }
        .navbar-nav .nav-link {
            color: rgba(255,255,255,0.8) !important;
            font-weight: 600;
            font-size: 0.9rem;
            margin-left: 1.5rem;
            transition: all 0.3s ease;
        }
        .navbar-nav .nav-link:hover {
            color: var(--brand-blue) !important;
        }

        /* 3 & 4. Main Center Section & Background */
        .hero-section {
            padding: 100px 20px;
            text-align: center;
            background: radial-gradient(circle at center, rgba(0, 98, 255, 0.05) 0%, #f8fafc 70%);
            position: relative;
        }
        /* Optional faint skyline effect */
        .hero-section::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-image: url('https://www.transparenttextures.com/patterns/city.png');
            opacity: 0.03;
            pointer-events: none;
        }

        .hero-icon {
            font-size: 6rem;
            color: var(--brand-blue);
            margin-bottom: 1.5rem;
            display: block;
        }
        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            letter-spacing: -2px;
            margin-bottom: 0.5rem;
        }
        .hero-title span {
            color: var(--brand-blue);
        }
        .hero-tagline {
            font-size: 1.5rem;
            color: #64748b;
            font-weight: 500;
            margin-bottom: 1.5rem;
        }
        .title-divider {
            width: 80px;
            height: 4px;
            background: var(--brand-blue);
            margin: 0 auto;
            border-radius: 10px;
        }

        /* 5 & 6. Feature Boxes & Effects */
        .features-container {
            padding: 60px 0;
            max-width: 1200px;
            margin: 0 auto;
        }
        .feature-card {
            background: white;
            border: none;
            border-radius: 24px;
            padding: 2.5rem 2rem;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 20px 40px rgba(0, 98, 255, 0.1);
        }
        .feature-icon-wrapper {
            width: 80px;
            height: 80px;
            background: rgba(0, 98, 255, 0.1);
            color: var(--brand-blue);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2rem;
            transition: all 0.3s ease;
        }
        .feature-card:hover .feature-icon-wrapper {
            background: var(--brand-blue);
            color: white;
        }
        .feature-title {
            font-weight: 700;
            font-size: 1.25rem;
            margin-bottom: 0.75rem;
        }
        .feature-desc {
            color: #64748b;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        /* 7. Footer */
        .footer {
            padding: 60px 20px 40px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.05);
            margin-top: 40px;
        }
        .footer-quote {
            font-weight: 600;
            color: var(--brand-blue);
            margin-bottom: 1rem;
            font-style: italic;
        }
        .footer-copyright {
            color: #94a3b8;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <!-- 2. Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-building-fill me-2 text-primary"></i>
                Skyline CRM
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="dropdown">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end">
                <ul class="navbar-nav">
                    <li class="nav-link"><i class="bi bi-grid-1x2 me-1"></i> Dashboard</li>
                    <li class="nav-link"><i class="bi bi-people me-1"></i> Customers</li>
                    <li class="nav-link"><i class="bi bi-house-door me-1"></i> Properties</li>
                    <li class="nav-link"><i class="bi bi-bar-chart-line me-1"></i> Reports</li>
                    <li class="nav-link"><i class="bi bi-gear me-1"></i> Settings</li>
                    <li class="nav-item ms-lg-4">
                        <a href="login" class="btn btn-primary rounded-pill px-4">Sign In</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 3 & 4. Hero Section -->
    <section class="hero-section">
        <i class="bi bi-buildings-fill hero-icon"></i>
        <h1 class="hero-title">Skyline <span>CRM</span></h1>
        <p class="hero-tagline">Smart Real Estate. Better Relationships.</p>
        <div class="title-divider"></div>
    </section>

    <!-- 5 & 6. Feature Boxes -->
    <div class="container features-container">
        <div class="row g-4 justify-content-center">
            <div class="col-md-3">
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <h3 class="feature-title">Manage Customers</h3>
                    <p class="feature-desc">Complete client lifecycle management with advanced profiling.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="bi bi-building-fill"></i>
                    </div>
                    <h3 class="feature-title">Manage Properties</h3>
                    <p class="feature-desc">Interactive inventory control for apartments and complexes.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="bi bi-clipboard-check-fill"></i>
                    </div>
                    <h3 class="feature-title">Track Deals</h3>
                    <p class="feature-desc">Monitor sales pipelines and booking status in real-time.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="bi bi-pie-chart-fill"></i>
                    </div>
                    <h3 class="feature-title">Reports</h3>
                    <p class="feature-desc">Deep analytics and financial reporting at your fingertips.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- 7. Footer -->
    <footer class="footer">
        <p class="footer-quote">"Secure. Reliable. Built for Real Estate Professionals."</p>
        <p class="footer-copyright">© 2025 Skyline CRM</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
