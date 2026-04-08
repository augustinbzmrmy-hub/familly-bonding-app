<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Family Management - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        .container { width: 100%; max-width: 800px; margin: 0 auto; display: none; }
        .error { color: var(--error); background: rgba(239, 68, 68, 0.1); padding: 1rem; border-radius: 0.5rem; margin-bottom: 1.5rem; display: none; border: 1px solid rgba(239, 68, 68, 0.2); }
        .loading { text-align: center; margin-top: 5rem; color: var(--text-secondary); font-size: 1.2rem; }
    </style>
</head>
<body>
    <div id="loader" class="loading animate-float">Loading family manager...</div>
    
    <div class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />

        <div class="main-content">
            <div class="container animate-fade-in" id="app">
                <div class="header animate-fade-in">
                    <div>
                        <h1 style="margin:0; font-size: 2.2rem; font-weight: 700;">Family Management</h1>
                        <p style="color: var(--text-secondary); margin: 0.5rem 0 0; font-size: 1.1rem;">Manage your family group or join a new one.</p>
                    </div>
                </div>
                
                <div id="errorMessage" class="error"></div>
        
                <div class="glass-card delay-200 animate-fade-in" style="padding: 2.5rem; margin-bottom: 2rem;">
                    <h2 class="text-gradient" style="margin-bottom: 1.5rem;">Create a Family Group</h2>
                    <form id="createFamilyForm">
                        <div class="form-group">
                            <label>Family Name</label>
                            <input type="text" id="familyName" class="form-control" placeholder="e.g. The Smith Family" required>
                        </div>
                        <button type="submit" class="btn-primary" style="width: auto; padding: 0.75rem 2rem;">Create Family</button>
                    </form>
                </div>
        
                <div class="glass-card delay-300 animate-fade-in" style="padding: 2.5rem;">
                    <h2 class="text-gradient" style="margin-bottom: 1.5rem;">Join an Existing Family</h2>
                    <div class="form-group">
                        <label>Family ID</label>
                        <input type="text" id="familyId" class="form-control" placeholder="Enter Family ID from your family admin">
                    </div>
                    <button id="joinCodeBtn" type="button" class="btn-primary" style="width: auto; padding: 0.75rem 2rem; background: linear-gradient(135deg, #10b981, #059669);">Join Family</button>
                </div>
            </div>
        </div>
    </div>

    <script src="js/api.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }

            const cachedUser = JSON.parse(localStorage.getItem('user'));
            const errorDiv = document.getElementById('errorMessage');

            if (cachedUser.family) {
                const fName = cachedUser.family.familyName || cachedUser.family.name || "Your Family";
                document.getElementById('app').innerHTML = `
                    <div class="header animate-fade-in">
                        <div>
                            <h1 style="margin:0; font-size: 2.2rem; font-weight: 700;">Family Management</h1>
                            <p style="color: var(--text-secondary); margin: 0.5rem 0 0; font-size: 1.1rem;">You are part of \${fName}.</p>
                        </div>
                    </div>
                    <div class="glass-card animate-fade-in" style="text-align:center; padding: 4rem 2rem;">
                        <h2 class="text-gradient" style="font-size: 2rem; margin-bottom: 1rem;">You're in a Family!</h2>
                        <p style="font-size: 1.2rem; margin-bottom: 2rem;">You belong to <strong style="color:white;">\${fName}</strong>.</p>
                        <div style="background: rgba(0,0,0,0.3); border: 1px dashed var(--primary); padding: 1.5rem; border-radius: 0.75rem; display: inline-block;">
                            <p style="color: var(--text-secondary); margin-bottom: 0.5rem; font-size: 0.9rem;">Share this Family ID for others to join:</p>
                            <span style="font-size: 1.5rem; font-weight: bold; color: var(--primary); letter-spacing: 2px;">\${cachedUser.family.familyId}</span>
                        </div>
                    </div>
                `;
            }

            document.getElementById('loader').style.display = 'none';
            document.getElementById('app').style.display = 'block';

            function showError(msg) {
                errorDiv.textContent = msg;
                errorDiv.style.display = 'block';
            }

            document.getElementById('createFamilyForm')?.addEventListener('submit', async (e) => {
                e.preventDefault();
                const name = document.getElementById('familyName').value;
                try {
                    await api.post('/families/create', { familyName: name, userId: cachedUser.userId });
                    api.showToast("Family created successfully!", "success");
                    await api.refreshSession();
                    window.location.href = 'dashboard.jsp';
                } catch (error) {
                    showError(error.message);
                }
            });
    
            document.getElementById('joinCodeBtn')?.addEventListener('click', async () => {
                const fId = document.getElementById('familyId').value;
                if (!fId) return showError("Family ID is required");
                try {
                    await api.post(`/families/\${fId}/join`, { userId: cachedUser.userId });
                    api.showToast("Joined family successfullly!", "success");
                    await api.refreshSession();
                    window.location.href = 'dashboard.jsp';
                } catch (error) {
                    showError(error.message);
                }
            });

            // Logout is now handled in the sidebar fragment
        });
    </script>
</body>
</html>
