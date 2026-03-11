<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.family.model.Challenge, java.util.List" %>
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
        .nav-link { display: block; padding: 0.75rem 1rem; color: #94a3b8; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(99, 102, 241, 0.1); color: white; }
        
        .challenge-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; }
        .challenge-card { background: var(--card); padding: 1.5rem; border-radius: 1rem; border: 1px solid rgba(255,255,255,0.05); display: flex; flex-direction: column; justify-content: space-between; }
        .challenge-title { font-size: 1.25rem; font-weight: bold; color: var(--primary); margin-bottom: 0.5rem; }
        .challenge-desc { font-size: 0.9rem; color: #cbd5e1; line-height: 1.5; margin-bottom: 1.5rem; }
        .status-badge { display: inline-block; padding: 0.2rem 0.6rem; border-radius: 999px; font-size: 0.7rem; font-weight: 600; text-transform: uppercase; margin-bottom: 1rem; }
        .status-not_joined { background: rgba(148, 163, 184, 0.1); color: #94a3b8; }
        .status-in_progress { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .status-completed { background: rgba(16, 185, 129, 0.1); color: var(--success); }
        
        .btn-action { padding: 0.6rem 1rem; border: none; border-radius: 0.5rem; font-weight: bold; cursor: pointer; transition: 0.3s; width: 100%; }
        .btn-join { background: var(--primary); color: white; }
        .btn-complete { background: var(--success); color: white; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="logo">Family Bonding</div>
        <nav>
            <a href="dashboard" class="nav-link">🏠 Overview</a>
            <a href="family" class="nav-link">👨‍👩‍👧‍👦 My Family</a>
            <a href="chartboard" class="nav-link">💬 Chartboard</a>
            <a href="challenges" class="nav-link active">🏆 Challenges</a>
            <a href="education" class="nav-link">📚 Education</a>
            <a href="logout" class="nav-link" style="margin-top: 2rem; color: #ef4444;">🚪 Logout</a>
        </nav>
    </div>
    
    <div class="main-content">
        <h1>Family Challenges</h1>
        <p style="color: #94a3b8; margin-bottom: 2rem;">Take part in fun activities to strengthen your family ties!</p>
        
        <div class="challenge-grid">
            <% 
                List<Challenge> challenges = (List<Challenge>) request.getAttribute("challenges");
                if (challenges != null && !challenges.isEmpty()) {
                    for (Challenge c : challenges) {
            %>
                <div class="challenge-card">
                    <div>
                        <span class="status-badge status-<%= c.getStatus().toLowerCase() %>"><%= c.getStatus().replace("_", " ") %></span>
                        <div class="challenge-title"><%= c.getTitle() %></div>
                        <div class="challenge-desc"><%= c.getDescription() %></div>
                    </div>
                    
                    <form action="challenges" method="post">
                        <input type="hidden" name="challengeId" value="<%= c.getChallengeId() %>">
                        <% if ("NOT_JOINED".equals(c.getStatus())) { %>
                            <input type="hidden" name="action" value="join">
                            <button type="submit" class="btn-action btn-join">Join Challenge</button>
                        <% } else if ("IN_PROGRESS".equals(c.getStatus())) { %>
                            <input type="hidden" name="action" value="complete">
                            <button type="submit" class="btn-action btn-complete">Mark as Completed</button>
                        <% } else { %>
                            <button type="button" class="btn-action" disabled style="background: rgba(255,255,255,0.05); color: #94a3b8;">Well Done!</button>
                        <% } %>
                    </form>
                </div>
            <% 
                    }
                } else {
            %>
                <p style="color: #94a3b8; grid-column: 1/-1; text-align:center;">No challenges available at the moment. Check back later!</p>
            <% } %>
        </div>
    </div>
</body>
</html>
