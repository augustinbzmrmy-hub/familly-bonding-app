<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Family Challenges - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        .challenge-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.5rem; margin-top: 2rem; }
        .challenge-card { padding: 2rem; display: flex; flex-direction: column; justify-content: space-between; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .challenge-card:hover { transform: translateY(-5px); box-shadow: 0 25px 50px -12px rgba(16, 185, 129, 0.15); }
        .challenge-title { font-size: 1.35rem; font-weight: bold; color: white; margin-bottom: 0.75rem; }
        .challenge-desc { font-size: 0.95rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 2rem; flex: 1; }
        
        .status-badge { display: inline-block; padding: 0.35rem 0.85rem; border-radius: 999px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin-bottom: 1.5rem; letter-spacing: 1px;}
        .status-not_joined { background: rgba(148, 163, 184, 0.1); color: var(--text-secondary); border: 1px solid rgba(148, 163, 184, 0.2); }
        .status-in_progress { background: rgba(99, 102, 241, 0.15); color: var(--primary); border: 1px solid rgba(99, 102, 241, 0.3); }
        .status-completed { background: rgba(16, 185, 129, 0.15); color: var(--success); border: 1px solid rgba(16, 185, 129, 0.3); }
        
        .btn-action { padding: 0.8rem 1rem; border: none; border-radius: 0.75rem; font-weight: 600; cursor: pointer; transition: 0.3s; width: 100%; font-size: 0.95rem; }
        .btn-join { background: var(--primary); color: white; }
        .btn-join:hover { background: var(--primary-hover); transform: translateY(-2px); box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3); }
        .btn-complete { background: linear-gradient(135deg, #10b981, #059669); color: white; }
        .btn-complete:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3); }
        .btn-disabled { background: rgba(255,255,255,0.05); color: var(--text-secondary); border: 1px solid var(--border); cursor: not-allowed; }
        
        .loading { text-align: center; margin-top: 4rem; color: var(--text-secondary); font-size: 1.2rem; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%; height: 100%;" class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />
        
        <div class="main-content">
            <div class="delay-100 animate-fade-in">
                <h1 style="font-size: 2.2rem; margin: 0; font-weight: 700;">Family Challenges</h1>
                <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.1rem;">Take part in fun activities to strengthen your family ties!</p>
            </div>
            
            <div class="challenge-grid delay-200 animate-fade-in" id="challengeGrid"></div>
        </div>
    </div>
    <div id="loader" class="loading animate-float">Loading exciting challenges...</div>

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
                    const challenges = await api.get(`/challenges?userId=\${cachedUser.userId}`);
                    const grid = document.getElementById('challengeGrid');
                    grid.innerHTML = '';

                    if (!challenges || challenges.length === 0) {
                        grid.innerHTML = '<div class="glass-card" style="grid-column: 1/-1; padding: 3rem; text-align:center;"><h3 style="margin-bottom: 1rem;">No Active Challenges</h3><p style="color: var(--text-secondary);">There are no challenges available at the moment. Check back later!</p></div>';
                        return;
                    }

                    challenges.forEach(c => {
                        const statusClass = c.status.toLowerCase();
                        const statusText = c.status.replace("_", " ");
                        
                        let buttonHtml = '';
                        if (c.status === 'NOT_JOINED') {
                            buttonHtml = `<button onclick="actionChallenge(\${c.challengeId}, 'join')" class="btn-action btn-join">Join Challenge</button>`;
                        } else if (c.status === 'IN_PROGRESS') {
                            buttonHtml = `<button onclick="actionChallenge(\${c.challengeId}, 'complete')" class="btn-action btn-complete">Mark as Completed</button>`;
                        } else {
                            buttonHtml = `<button type="button" class="btn-action btn-disabled" disabled>Completed! 🎉</button>`;
                        }

                        grid.innerHTML += `
                            <div class="glass-card challenge-card animate-fade-in" style="animation-duration: 0.6s;">
                                <div>
                                    <span class="status-badge status-\${statusClass}">\${statusText}</span>
                                    <div class="challenge-title">\${c.title}</div>
                                    <div class="challenge-desc">\${c.description}</div>
                                </div>
                                <div style="margin-top: 1rem;">
                                    \${buttonHtml}
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
                    await api.post(`/challenges/\${challengeId}/\${action}`, { userId: cachedUser.userId });
                    loadChallenges(); 
                } catch (error) {
                    alert("Error updating challenge: " + error.message);
                }
            };

            loadChallenges();

            // Logout is now handled in the sidebar fragment
        });
    </script>
</body>
</html>
