<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.family.model.Family, java.util.List" %>
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
        .container { max-width: 800px; margin: 0 auto; }
        .card { background: var(--card-bg); padding: 2rem; border-radius: 1rem; margin-bottom: 2rem; border: 1px solid rgba(255,255,255,0.05); }
        h2 { color: var(--primary); margin-top: 0; }
        .form-group { margin-bottom: 1rem; }
        input, select { width: 100%; padding: 0.75rem; border-radius: 0.5rem; border: 1px solid #334155; background: #0f172a; color: white; box-sizing: border-box; }
        button { padding: 0.75rem 1.5rem; border: none; border-radius: 0.5rem; background: var(--primary); color: white; font-weight: bold; cursor: pointer; transition: 0.3s; }
        button:hover { background: #4f46e5; }
        .family-list { list-style: none; padding: 0; }
        .family-item { display: flex; justify-content: space-between; align-items: center; padding: 1rem; background: rgba(255,255,255,0.02); border-radius: 0.5rem; margin-bottom: 0.5rem; }
        .back-link { color: #94a3b8; text-decoration: none; display: block; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <div class="container">
        <a href="dashboard" class="back-link">← Back to Dashboard</a>
        
        <div class="card">
            <h2>Create a Family Group</h2>
            <form action="family" method="post">
                <input type="hidden" name="action" value="create">
                <div class="form-group">
                    <label>Family Name</label>
                    <input type="text" name="familyName" placeholder="e.g. The Smith Family" required>
                </div>
                <button type="submit">Create Family</button>
            </form>
        </div>

        <div class="card">
            <h2>Join an Existing Family</h2>
            <ul class="family-list">
                <% 
                    List<Family> families = (List<Family>) request.getAttribute("families");
                    if (families != null && !families.isEmpty()) {
                        for (Family f : families) {
                %>
                    <li class="family-item">
                        <span><%= f.getFamilyName() %></span>
                        <form action="family" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="join">
                            <input type="hidden" name="familyId" value="<%= f.getFamilyId() %>">
                            <button type="submit" style="padding: 0.4rem 1rem; font-size: 0.8rem;">Join</button>
                        </form>
                    </li>
                <% 
                        }
                    } else {
                %>
                    <p style="color: #94a3b8;">No family groups found. Why not create one?</p>
                <% } %>
            </ul>
        </div>
    </div>
</body>
</html>
