<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.family.model.ChartboardPost, com.family.model.User, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chartboard - Family Bonding</title>
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
        
        .post-card { background: var(--card); padding: 1.5rem; border-radius: 1rem; margin-bottom: 1.5rem; border: 1px solid rgba(255,255,255,0.05); }
        .post-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .user-info { display: flex; align-items: center; gap: 0.75rem; }
        .avatar-small { width: 32px; height: 32px; border-radius: 50%; background: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: bold; }
        .user-name { font-weight: 600; font-size: 0.95rem; }
        .timestamp { font-size: 0.8rem; color: #94a3b8; }
        .post-content { line-height: 1.6; color: #cbd5e1; }
        
        .post-form { background: var(--card); padding: 1.5rem; border-radius: 1rem; margin-bottom: 2.5rem; border: 1px solid var(--primary); }
        textarea { width: 100%; padding: 1rem; border-radius: 0.5rem; border: 1px solid #334155; background: #0f172a; color: white; resize: none; margin-bottom: 1rem; box-sizing: border-box; }
        .btn-post { padding: 0.6rem 1.5rem; background: var(--primary); border: none; border-radius: 0.5rem; color: white; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-post:hover { background: #4f46e5; }
        .delete-btn { background: transparent; border: none; color: #ef4444; cursor: pointer; font-size: 0.8rem; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="logo">Family Bonding</div>
        <nav>
            <a href="dashboard" class="nav-link">🏠 Overview</a>
            <a href="family" class="nav-link">👨‍👩‍👧‍👦 My Family</a>
            <a href="chartboard" class="nav-link active">💬 Chartboard</a>
            <a href="challenges" class="nav-link">🏆 Challenges</a>
            <a href="education" class="nav-link">📚 Education</a>
            <a href="logout" class="nav-link" style="margin-top: 2rem; color: #ef4444;">🚪 Logout</a>
        </nav>
    </div>
    
    <div class="main-content">
        <h1>Family Chartboard</h1>
        
        <div class="post-form">
            <form action="chartboard" method="post">
                <input type="hidden" name="action" value="add">
                <textarea name="content" rows="3" placeholder="Share something with your family..." required></textarea>
                <button type="submit" class="btn-post">Post Message</button>
            </form>
        </div>

        <% 
            List<ChartboardPost> posts = (List<ChartboardPost>) request.getAttribute("posts");
            User currentUser = (User) session.getAttribute("user");
            if (posts != null && !posts.isEmpty()) {
                for (ChartboardPost p : posts) {
        %>
            <div class="post-card">
                <div class="post-header">
                    <div class="user-info">
                        <div class="avatar-small"><%= p.getUserName().substring(0,1).toUpperCase() %></div>
                        <div>
                            <div class="user-name"><%= p.getUserName() %></div>
                            <div class="timestamp"><%= p.getCreatedAt() %></div>
                        </div>
                    </div>
                    <% if (p.getUserId() == currentUser.getUserId()) { %>
                        <form action="chartboard" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="postId" value="<%= p.getPostId() %>">
                            <button type="submit" class="delete-btn">Delete</button>
                        </form>
                    <% } %>
                </div>
                <div class="post-content"><%= p.getContent() %></div>
            </div>
        <% 
                }
            } else {
        %>
            <p style="color: #94a3b8; text-align:center;">No posts yet. Start the conversation!</p>
        <% } %>
    </div>
</body>
</html>
