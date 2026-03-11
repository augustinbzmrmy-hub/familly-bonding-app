<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.family.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Family Bonding</title>
    <style>
        :root {
            --primary: #6366f1;
            --bg: #0f172a;
            --sidebar: #1e293b;
            --card: #1e293b;
            --text-main: #f8fafc;
        }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg); color: var(--text-main); margin: 0; display: flex; }
        .sidebar { width: 260px; height: 100vh; background: var(--sidebar); padding: 2rem 1.5rem; box-sizing: border-box; border-right: 1px solid rgba(255,255,255,0.05); }
        .main-content { flex: 1; padding: 2.5rem; overflow-y: auto; }
        .logo { font-size: 1.5rem; font-weight: bold; margin-bottom: 2.5rem; background: linear-gradient(to right, #818cf8, #c084fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .nav-link { display: block; padding: 0.75rem 1rem; color: #94a3b8; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(99, 102, 241, 0.1); color: white; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .user-profile { display: flex; align-items: center; gap: 1rem; }
        .avatar { width: 40px; height: 40px; border-radius: 50%; background: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: bold; }
        .card-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; }
        .card { background: var(--sidebar); padding: 1.5rem; border-radius: 1rem; border: 1px solid rgba(255,255,255,0.05); }
        .card h3 { margin-top: 0; color: var(--primary); }
        .badge { display: inline-block; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; background: rgba(99, 102, 241, 0.2); color: var(--primary); }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="logo">Family Bonding</div>
        <nav>
            <a href="dashboard" class="nav-link active">🏠 Overview</a>
            <a href="family" class="nav-link">👨‍👩‍👧‍👦 My Family</a>
            <a href="chartboard" class="nav-link">💬 Chartboard</a>
            <a href="challenges" class="nav-link">🏆 Challenges</a>
            <a href="education" class="nav-link">📚 Education</a>
            <a href="logout" class="nav-link" style="margin-top: 2rem; color: #ef4444;">🚪 Logout</a>
        </nav>
    </div>
    <div class="main-content">
        <div class="header">
            <div>
                <h1 style="margin:0;">Welcome back, <%= user.getFullName() %>!</h1>
                <p style="color: #94a3b8; margin: 0.5rem 0 0;"><%= user.getRole().replace("_", " ") %></p>
            </div>
            <div class="user-profile">
                <div class="avatar"><%= user.getFullName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="card-grid">
            <div class="card">
                <h3>Family Status</h3>
                <% if (user.getFamilyId() == null) { %>
                    <p>You haven't joined or created a family group yet.</p>
                    <a href="family" class="nav-link active" style="text-align:center;">Get Started</a>
                <% } else { %>
                    <p>Connected to your family group.</p>
                    <span class="badge">Active Member</span>
                <% } %>
            </div>
            <div class="card">
                <h3>Quick Actions</h3>
                <p>Post a message to the chartboard or check out today's family challenge!</p>
                <div style="display:flex; gap:0.5rem;">
                    <a href="chartboard" class="badge" style="text-decoration:none;">New Post</a>
                    <a href="challenges" class="badge" style="text-decoration:none;">View Challenge</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
