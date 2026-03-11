<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Family Bonding</title>
    <style>
        :root {
            --primary: #6366f1;
            --bg: #0f172a;
            --card-bg: #1e293b;
            --text-main: #f8fafc;
        }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg); color: var(--text-main); display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .card { background: var(--card-bg); padding: 2.5rem; border-radius: 1rem; box-shadow: 0 10px 25px rgba(0,0,0,0.3); width: 100%; max-width: 450px; }
        h2 { margin-bottom: 1.5rem; text-align: center; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-group { margin-bottom: 1.2rem; }
        label { display: block; margin-bottom: 0.5rem; color: #94a3b8; }
        input, select { width: 100%; padding: 0.75rem; border-radius: 0.5rem; border: 1px solid #334155; background: #0f172a; color: white; box-sizing: border-box; }
        button { width: 100%; padding: 0.75rem; border: none; border-radius: 0.5rem; background: var(--primary); color: white; font-weight: bold; cursor: pointer; transition: 0.3s; margin-top: 1rem; }
        button:hover { background: #4f46e5; }
        .error { color: #ef4444; background: rgba(239, 68, 68, 0.1); padding: 0.75rem; border-radius: 0.5rem; margin-bottom: 1rem; font-size: 0.85rem; text-align: center; }
        .footer { text-align: center; margin-top: 1.5rem; color: #94a3b8; font-size: 0.9rem; }
        .footer a { color: var(--primary); text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Create Account</h2>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="register" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" required>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <select name="role">
                        <option value="FAMILY_MEMBER">Family Member</option>
                        <option value="FAMILY_ADMIN">Parent/Guardian</option>
                    </select>
                </div>
            </div>
            <button type="submit">Sign Up</button>
        </form>
        <div class="footer">
            Already have an account? <a href="login">Login here</a>
        </div>
    </div>
</body>
</html>
