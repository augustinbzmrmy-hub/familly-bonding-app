<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Family Management - Family Bonding</title>
    <style>
        :root {
            --primary: #6366f1;
            --bg: #0f172a;
            --card-bg: #1e293b;
            --text-main: #f8fafc;
        }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg); color: var(--text-main); margin: 0; padding: 2rem; }
        .container { max-width: 800px; margin: 0 auto; display: none; }
        .card { background: var(--card-bg); padding: 2rem; border-radius: 1rem; margin-bottom: 2rem; border: 1px solid rgba(255,255,255,0.05); }
        h2 { color: var(--primary); margin-top: 0; }
        .form-group { margin-bottom: 1rem; }
        label { display: block; margin-bottom: 0.5rem; color: #94a3b8; }
        input, select { width: 100%; padding: 0.75rem; border-radius: 0.5rem; border: 1px solid #334155; background: #0f172a; color: white; box-sizing: border-box; }
        button { padding: 0.75rem 1.5rem; border: none; border-radius: 0.5rem; background: var(--primary); color: white; font-weight: bold; cursor: pointer; transition: 0.3s; }
        button:hover { background: #4f46e5; }
        .family-list { list-style: none; padding: 0; }
        .family-item { display: flex; justify-content: space-between; align-items: center; padding: 1rem; background: rgba(255,255,255,0.02); border-radius: 0.5rem; margin-bottom: 0.5rem; }
        .back-link { color: #94a3b8; text-decoration: none; display: block; margin-bottom: 1rem; }
        .error { color: #ef4444; background: rgba(239, 68, 68, 0.1); padding: 0.75rem; border-radius: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; display: none; }
        .loading { text-align: center; margin-top: 2rem; color: #94a3b8; }
    </style>
</head>
<body>
    <div id="loader" class="loading">Loading family manager...</div>
    <div class="container" id="app">
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
        
        <div id="errorMessage" class="error"></div>

        <div class="card">
            <h2>Create a Family Group</h2>
            <form id="createFamilyForm">
                <div class="form-group">
                    <label>Family Name</label>
                    <input type="text" id="familyName" placeholder="e.g. The Smith Family" required>
                </div>
                <button type="submit">Create Family</button>
            </form>
        </div>

        <div class="card">
            <h2>Join an Existing Family</h2>
            <div class="form-group">
                <label>Family ID</label>
                <input type="text" id="familyId" placeholder="Enter Family ID from your family admin">
            </div>
            <button id="joinCodeBtn" type="button">Join Family</button>
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
                document.getElementById('app').innerHTML = `
                    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
                    <div class="card" style="text-align:center;">
                        <h2>You are already in a Family Group!</h2>
                        <p>You belong to <strong>${cachedUser.family.name}</strong>.</p>
                        <p>Share this Family ID with members you want to join: <strong>${cachedUser.family.familyId}</strong></p>
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
                    const response = await api.post('/families/create', { familyName: name, userId: cachedUser.userId });
                    cachedUser.family = response;
                    localStorage.setItem('user', JSON.stringify(cachedUser));
                    window.location.href = 'dashboard.jsp';
                } catch (error) {
                    showError(error.message);
                }
            });

            document.getElementById('joinCodeBtn')?.addEventListener('click', async () => {
                const fId = document.getElementById('familyId').value;
                if (!fId) return showError("Family ID is required");
                try {
                    const response = await api.post(`/families/${fId}/join`, { userId: cachedUser.userId });
                    cachedUser.family = response;
                    localStorage.setItem('user', JSON.stringify(cachedUser));
                    window.location.href = 'dashboard.jsp';
                } catch (error) {
                    showError(error.message);
                }
            });
        });
    </script>
</body>
</html>
