// Skyline CRM - Main Scripts
document.addEventListener('DOMContentLoaded', function() {
    
    // Theme Toggle Logic
    const themeToggle = document.getElementById('theme-toggle');
    const themeIcon = document.getElementById('theme-icon');
    const currentTheme = localStorage.getItem('theme') || 'light';

    // Apply theme on load
    document.documentElement.setAttribute('data-theme', currentTheme);
    updateThemeIcon(currentTheme);

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            let theme = document.documentElement.getAttribute('data-theme');
            let newTheme = theme === 'light' ? 'dark' : 'light';
            
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeIcon(newTheme);
        });
    }

    function updateThemeIcon(theme) {
        if (!themeIcon) return;
        if (theme === 'dark') {
            themeIcon.classList.replace('bi-moon-fill', 'bi-sun-fill');
        } else {
            themeIcon.classList.replace('bi-sun-fill', 'bi-moon-fill');
        }
    }

    // Sidebar Toggle
    const menuToggle = document.getElementById('menu-toggle');
    const wrapper = document.getElementById('wrapper');
    
    if (menuToggle) {
        menuToggle.addEventListener('click', e => {
            e.preventDefault();
            wrapper.classList.toggle('toggled');
            
            // Local storage to remember sidebar state
            const isToggled = wrapper.classList.contains('toggled');
            localStorage.setItem('sidebar-toggled', isToggled);
        });
        
        // Restore sidebar state
        if (localStorage.getItem('sidebar-toggled') === 'true') {
            wrapper.classList.add('toggled');
        }
    }

    // Initialize Bootstrap Tooltips & Popovers
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Add smooth load animation to cards
    const cards = document.querySelectorAll('.stat-card, .table-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'all 0.5s ease ' + (index * 0.1) + 's';
        
        setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 100);
    });

    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-success, .alert-info');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Extraordinary Features: Live Clock & Dynamic Greeting
    function updateLiveFeatures() {
        const timeElement = document.getElementById('liveTime');
        const dateElement = document.getElementById('liveDate');
        const greetingElement = document.getElementById('greeting');
        
        if (!timeElement) return;

        const now = new Date();
        
        // Update Time
        timeElement.innerText = now.toLocaleTimeString();
        
        // Update Date
        const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateElement.innerText = now.toLocaleDateString(undefined, dateOptions);
        
        // Update Greeting
        const hour = now.getHours();
        let greeting = "Good Evening";
        if (hour < 12) greeting = "Good Morning";
        else if (hour < 17) greeting = "Good Afternoon";
        
        if (greetingElement) {
            const userName = greetingElement.innerText.split(',')[1] || "User!";
            greetingElement.innerHTML = `${greeting}, <span class="text-primary">${userName}</span>`;
        }
    }

    if (document.getElementById('liveTime')) {
        setInterval(updateLiveFeatures, 1000);
        updateLiveFeatures();
    }

    console.log('Skyline CRM Pro UI Initialized');
});
