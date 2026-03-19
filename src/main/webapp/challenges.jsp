<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Family Challenges - Family Bonding</title>
    <style>
        :root {
            --primary: #6366f1;
            --bg: #0f172a;
            --sidebar: #1e293b;
            --card: #1e293b;
            --text-main: #f8fafc;
            --success: #10b981;
        }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg); color: var(--text-main); margin: 0; display: flex; }
        .sidebar { width: 260px; height: 100vh; background: var(--sidebar); padding: 2rem 1.5rem; box-sizing: border-box; border-right: 1px solid rgba(255,255,255,0.05); }
        .main-content { flex: 1; padding: 2.5rem; overflow-y: auto; }
        .logo { font-size: 1.5rem; font-weight: bold; margin-bottom: 2.5rem; background: linear-gradient(to right, #818cf8, #c084fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .nav-link { display: block; padding: 0.75rem 1rem; color: #94a3b8; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: 0.3s; cursor: pointer;}
        .nav-link:hover, .nav-link.active { background: rgba(99, 102, 241, 0.1); color: white; }
        
        .challenge-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; }
        .challenge-card { background: var(--card); padding: 1.5rem; border-radius: 1rem; border: 1px solid rgba(255,255,255,0.05); display: flex; flex-direction: column; justify-content: space-between; }
        .challenge-title { font-size: 1.25rem; font-weight: bold; color: var(--primary); margin-bottom: 0.5rem; }
        .challenge-desc { font-size: 0.9rem; color: #cbd5e1; line-height: 1.5; margin-bottom: 1.5rem; }
        .status-badge { display: inline-block; padding: 0.2rem 0.6rem; border-radius: 999px; font-size: 0.7rem; font-weight: 600; text-transform: uppercase; margin-bottom: 1rem; }
        .status-not_joined { background: rgba(148, 163, 184, 0.1); color: #94a3b8; }
        .status-in_progress { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .status-completed { background: rgba(16, 185, 129, 0.1); color: var(--success); }
        
        .btn-action { padding: 0.6rem 1rem; border: none; border-radius: 0.5rem; font-weight: bold; cursor: pointer; transition: 0.3s; width: 100%; margin-top: 1rem; }
        .btn-join { background: var(--primary); color: white; }
        .btn-join:hover { background: #4f46e5; }
        .btn-complete { background: var(--success); color: white; }
        .btn-complete:hover { background: #059669; }
        .loading { text-align: center; margin-top: 2rem; color: #94a3b8; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%;">
        <div class="sidebar">
            <div class="logo">Family Bonding</div>
            <nav>
                <a href="dashboard.jsp" class="nav-link">🏠 Overview</a>
                <a href="family.jsp" class="nav-link">👨‍👩‍👧‍👦 My Family</a>
                <a href="chartboard.jsp" class="nav-link">💬 Chartboard</a>
                <a href="challenges.jsp" class="nav-link active">🏆 Challenges</a>
                <a href="education.jsp" class="nav-link">📚 Education</a>
                <a id="logoutBtn" class="nav-link" style="margin-top: 2rem; color: #ef4444;">🚪 Logout</a>
            </nav>
        </div>
        
        <div class="main-content">
            <h1>Family Challenges</h1>
            <p style="color: #94a3b8; margin-bottom: 2rem;">Take part in fun activities to strengthen your family ties!</p>
            
            <div class="challenge-grid" id="challengeGrid"></div>
        </div>
    </div>
    <div id="loader" class="loading">Loading challenges...</div>

    <script src="js/api.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }

            const cachedUser = JSON.parse(localStorage.getItem('user'));

            async function loadChallenges() {
                try {
                    const challenges = await api.get(`/challenges?userId=${cachedUser.userId}`);
                    const grid = document.getElementById('challengeGrid');
                    grid.innerHTML = '';

                    if (!challenges || challenges.length === 0) {
                        grid.innerHTML = '<p style="color: #94a3b8; grid-column: 1/-1; text-align:center;">No challenges available at the moment. Check back later!</p>';
                        return;
                    }

                    challenges.forEach(c => {
                        const statusClass = c.status.toLowerCase();
                        const statusText = c.status.replace("_", " ");
                        
                        let buttonHtml = '';
                        if (c.status === 'NOT_JOINED') {
                            buttonHtml = `<button onclick="actionChallenge(${c.challengeId}, 'join')" class="btn-action btn-join">Join Challenge</button>`;
                        } else if (c.status === 'IN_PROGRESS') {
                            buttonHtml = `<button onclick="actionChallenge(${c.challengeId}, 'complete')" class="btn-action btn-complete">Mark as Completed</button>`;
                        } else {
                            buttonHtml = `<button type="button" class="btn-action" disabled style="background: rgba(255,255,255,0.05); color: #94a3b8;">Well Done!</button>`;
                        }

                        grid.innerHTML += `
                            <div class="challenge-card">
                                <div>
                                    <span class="status-badge status-${statusClass}">${statusText}</span>
                                    <div class="challenge-title">${c.title}</div>
                                    <div class="challenge-desc">${c.description}</div>
                                </div>
                                <div>
                                    ${buttonHtml}
                                </div>
                            </div>
                        `;
                    });

                    document.getElementById('loader').style.display = 'none';
                    document.getElementById('app').style.display = 'flex';

                } catch (error) {
                    console.error("Error loading challenges", error);
                }
            }

            window.actionChallenge = async (challengeId, action) => {
                try {
                    await api.post(`/challenges/${challengeId}/${action}`, { userId: cachedUser.userId });
                    loadChallenges(); // refresh UI
                } catch (error) {
                    alert("Error updating challenge: " + error.message);
                }
            };

            loadChallenges();

            document.getElementById('logoutBtn').addEventListener('click', () => {
                api.removeToken();
                localStorage.removeItem('user');
                window.location.href = 'login.jsp';
            });
        });
    </script>
</body>
</html>
