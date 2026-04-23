<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar animate-fade-in" style="animation-duration: 0.8s;">
    <div class="logo text-gradient delay-100 animate-fade-in" style="display: flex; align-items: center; gap: 0.8rem;">
        <img src="images/logo.png" alt="Logo" style="width: 32px; height: auto;">
        Family Bond
    </div>
    
    <div id="sidebarUser" class="delay-150 animate-fade-in" style="padding: 1.5rem; display: flex; align-items: center; gap: 1rem; border-bottom: 1px solid rgba(255,255,255,0.05); margin-bottom: 1rem;">
        <img id="sidebarAvatar" src="https://ui-avatars.com/api/?name=User&background=random" style="width: 45px; height: 45px; border-radius: 50%; object-fit: cover; border: 2px solid var(--accent-primary);">
        <div>
            <div id="sidebarName" style="font-weight: 600; font-size: 0.9rem; color: white;">User</div>
            <a href="profile.jsp" style="font-size: 0.75rem; color: var(--accent-primary); text-decoration: none;">View Profile</a>
        </div>
    </div>

    <nav class="delay-200 animate-fade-in">
        <a href="dashboard.jsp" class="nav-link" id="nav-dashboard">🏠 Overview</a>
        <a href="profile.jsp" class="nav-link" id="nav-profile">👤 My Profile</a>
        <a href="family.jsp" class="nav-link" id="nav-family">👨‍👩‍👧‍👦 My Family</a>
        <a href="chartboard.jsp" class="nav-link" id="nav-chartboard">💬 Chartboard</a>
        <a href="shopping.jsp" class="nav-link" id="nav-shopping">🛒 Shopping</a>
        <a href="calendar.jsp" class="nav-link" id="nav-calendar">📅 Calendar</a>
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
            'profile.jsp': 'nav-profile',
            'family.jsp': 'nav-family',
            'chartboard.jsp': 'nav-chartboard',
            'shopping.jsp': 'nav-shopping',
            'calendar.jsp': 'nav-calendar',
            'challenges.jsp': 'nav-challenges',
            'education.jsp': 'nav-education'
        };
        
        const activeId = navMap[page];
        if (activeId) {
            document.getElementById(activeId).classList.add('active');
        }

        // Load user info for sidebar
        const cachedUser = JSON.parse(localStorage.getItem('user'));
        if (cachedUser) {
            document.getElementById('sidebarName').textContent = cachedUser.fullName;
            if (cachedUser.profilePictureUrl) {
                document.getElementById('sidebarAvatar').src = cachedUser.profilePictureUrl;
            } else {
                document.getElementById('sidebarAvatar').src = 'https://ui-avatars.com/api/?name=' + encodeURIComponent(cachedUser.fullName) + '&background=random';
            }
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
