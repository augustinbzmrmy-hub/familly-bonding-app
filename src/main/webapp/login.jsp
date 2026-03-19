<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Family Bonding</title>
    <style>
        :root {
            --primary: #6366f1;
            --bg: #0f172a;
            --card-bg: #1e293b;
            --text-main: #f8fafc;
        }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg); color: var(--text-main); display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .card { background: var(--card-bg); padding: 2.5rem; border-radius: 1rem; box-shadow: 0 10px 25px rgba(0,0,0,0.3); width: 100%; max-width: 400px; }
        h2 { margin-bottom: 1.5rem; text-align: center; }
        .form-group { margin-bottom: 1.2rem; }
        label { display: block; margin-bottom: 0.5rem; color: #94a3b8; }
        input { width: 100%; padding: 0.75rem; border-radius: 0.5rem; border: 1px solid #334155; background: #0f172a; color: white; box-sizing: border-box; }
        button { width: 100%; padding: 0.75rem; border: none; border-radius: 0.5rem; background: var(--primary); color: white; font-weight: bold; cursor: pointer; transition: 0.3s; margin-top: 1rem; }
        button:hover { background: #4f46e5; }
        .error { color: #ef4444; background: rgba(239, 68, 68, 0.1); padding: 0.75rem; border-radius: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; text-align: center; }
        .footer { text-align: center; margin-top: 1.5rem; color: #94a3b8; font-size: 0.9rem; }
        .footer a { color: var(--primary); text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Welcome Back</h2>
        <div id="errorMessage" class="error" style="display: none;"></div>
        
        <form id="loginForm">
            <div class="form-group">
                <label>Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Login</button>
        </form>
        <div class="footer">
            Don't have an account? <a href="register.jsp">Sign up</a>
        </div>
    </div>

    <script src="js/api.js"></script>
    <script>
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const errorDiv = document.getElementById('errorMessage');
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            try {
                const response = await api.post('/auth/login', { email, password }, false);
                api.setToken(response.token);
                localStorage.setItem('user', JSON.stringify(response.user));
                window.location.href = 'dashboard.jsp';
            } catch (error) {
                errorDiv.textContent = error.message;
                errorDiv.style.display = 'block';
            }
        });
    </script>
</body>
</html>
