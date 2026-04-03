<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar animate-fade-in" style="animation-duration: 0.8s;">
    <div class="logo text-gradient delay-100 animate-fade-in">Family Bonding</div>
    <nav class="delay-200 animate-fade-in">
        <a href="dashboard.jsp" class="nav-link" id="nav-dashboard">🏠 Overview</a>
        <a href="family.jsp" class="nav-link" id="nav-family">👨‍👩‍👧‍👦 My Family</a>
        <a href="chartboard.jsp" class="nav-link" id="nav-chartboard">💬 Chartboard</a>
        <a href="challenges.jsp" class="nav-link" id="nav-challenges">🏆 Challenges</a>
        <a href="education.jsp" class="nav-link" id="nav-education">📚 Education</a>
        <a id="logoutBtn" class="nav-link" style="margin-top: auto; color: var(--error);">🚪 Logout</a>
    </nav>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Highlight active link
        const currentPath = window.location.pathname;
        const page = currentPath.split("/").pop() || "dashboard.jsp";
        
        const navMap = {
            'dashboard.jsp': 'nav-dashboard',
            'family.jsp': 'nav-family',
            'chartboard.jsp': 'nav-chartboard',
            'challenges.jsp': 'nav-challenges',
            'education.jsp': 'nav-education'
        };
        
        const activeId = navMap[page];
        if (activeId) {
            document.getElementById(activeId).classList.add('active');
        }
        
        // Setup logout
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', () => {
                if (typeof api !== 'undefined') {
                    api.removeToken();
                }
                localStorage.removeItem('user');
                localStorage.removeItem('jwt_token');
                window.location.href = 'login.jsp';
            });
        }
    });
</script>
