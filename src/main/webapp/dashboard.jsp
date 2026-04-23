<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        body { display: flex; margin: 0; height: 100vh; overflow: hidden; }
        .card-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 1.5rem; }
        .loading { text-align: center; margin-top: 3rem; color: var(--text-secondary); font-size: 1.2rem; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%; height: 100%;" class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />
        
        <div class="main-content">
            <div class="header delay-100 animate-fade-in">
                <div>
                    <h1 style="margin:0; font-size: 2.2rem; font-weight: 700;" id="welcomeText">Welcome back!</h1>
                    <p style="color: var(--text-secondary); margin: 0.5rem 0 0; font-size: 1.1rem;" id="roleText"></p>
                </div>
                <div class="user-profile">
                    <div class="avatar" id="avatarText">U</div>
                </div>
            </div>

            <div class="card-grid">
                <div class="glass-card delay-200 animate-fade-in" style="padding: 2rem;">
                    <h3 style="margin-top:0; margin-bottom: 1rem;" class="text-gradient">Family Status</h3>
                    <div id="familyStatusBox"></div>
                    <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid rgba(255,255,255,0.1);">
                        <p style="color: var(--text-secondary); margin-bottom: 0.5rem;">Your Bonding Points</p>
                        <h2 id="userPoints" style="margin:0; font-size: 2.5rem; color: var(--accent-primary);">0</h2>
                    </div>
                </div>


                <div class="glass-card delay-400 animate-fade-in" style="padding: 2rem;">
                    <h3 style="margin-top:0; margin-bottom: 1rem;" class="text-gradient">Quick Actions</h3>
                    <p style="color: var(--text-secondary); line-height: 1.6; margin-bottom: 1.5rem;">Manage chores, shopping lists, or see what's new on the chartboard!</p>
                    <div style="display:flex; flex-wrap: wrap; gap:0.75rem;">
                        <a href="chartboard.jsp" class="badge" style="text-decoration:none;">New Post</a>
                        <a href="shopping.jsp" class="badge" style="text-decoration:none;">Shopping List</a>
                        <a href="challenges.jsp" class="badge" style="text-decoration:none;">Challenges</a>
                        <a href="#" class="badge" style="text-decoration:none; background: var(--accent-secondary);" onclick="getAIAdvice()">🤖 Ask AI Assistant</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="loader" class="loading animate-float">Loading your beautiful dashboard...</div>

    <script src="js/api.js"></script>
    <script src="js/notifications.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }

            // Start Real-time Notifications
            const user = JSON.parse(localStorage.getItem('user'));
            if (user) notifications.connect(user);

            try {
                // Use data cached at login/registration time — avoids an extra authenticated API call
                const user = JSON.parse(localStorage.getItem('user'));
                if (!user || !user.userId) throw new Error("No user session found. Please log in again.");

                document.getElementById('welcomeText').textContent = `Welcome back, \${user.fullName}!`;
                document.getElementById('roleText').textContent = (user.role || '').replace("_", " ");
                document.getElementById('avatarText').textContent = user.fullName.substring(0, 1).toUpperCase();
                document.getElementById('userPoints').textContent = user.points || 0;

                const familyStatusBox = document.getElementById('familyStatusBox');

                if (!user.family) {
                    familyStatusBox.innerHTML = `
                        <p style="color: var(--text-secondary); margin-bottom: 1rem;">You aren't in a family group yet. Let's fix that!</p>
                        <a href="family.jsp" class="btn-primary" style="padding: 0.6rem 1.2rem; width: auto; display: inline-block; font-size: 0.9rem;">Get Started</a>
                    `;
                } else {
                    const familyName = user.family.familyName || user.family.name || 'Your Family';
                    familyStatusBox.innerHTML = `
                        <p style="font-size: 1.1rem; margin-bottom: 1rem;">Connected to <strong style="color: white;">\${familyName}</strong></p>
                        <span class="badge" style="background: rgba(16, 185, 129, 0.2); color: var(--success);">Active Member</span>
                    `;
                }

                document.getElementById('loader').style.display = 'none';
                document.getElementById('app').style.display = 'flex';
                
                // Show a welcome toast only once per session
                if (!sessionStorage.getItem('welcomed')) {
                    api.showToast(`Welcome back, \${user.fullName}!`, 'info');
                    sessionStorage.setItem('welcomed', 'true');
                }

            } catch (error) {
                console.error("Dashboard error:", error);
                api.removeToken();
                localStorage.removeItem('user');
                window.location.href = 'login.jsp';
            }
        });

        async function getAIAdvice() {
            try {
                const response = await api.get('/ai/advice');
                alert(response.message); // Simple for now, can be a custom modal
            } catch (error) {
                api.showToast("AI Assistant is offline.", "error");
            }
        }

        document.getElementById('logoutBtn').addEventListener('click', () => {
            api.removeToken();
            localStorage.removeItem('user');
            window.location.href = 'login.jsp';
        });
    </script>
</body>
</html>
