<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        body { display: flex; align-items: center; justify-content: center; }
        .card-wrapper { width: 100%; max-width: 400px; padding: 2rem; }
        .error { color: var(--error); background: rgba(239, 68, 68, 0.1); padding: 0.8rem; border-radius: 0.5rem; margin-bottom: 1.5rem; font-size: 0.9rem; text-align: center; border: 1px solid rgba(239, 68, 68, 0.2); }
        .footer { text-align: center; margin-top: 2rem; color: var(--text-secondary); font-size: 0.9rem; }
        .footer a { color: var(--primary); text-decoration: none; font-weight: 500; transition: color 0.3s; }
        .footer a:hover { color: var(--primary-hover); }
        .header-title { margin-bottom: 2rem; text-align: center; font-size: 2rem; font-weight: 700; }
    </style>
</head>
<body>
    <div class="card-wrapper animate-fade-in">
        <div class="glass-card" style="padding: 2.5rem;">
            <h2 class="header-title text-gradient">Welcome Back</h2>
            <div id="errorMessage" class="error" style="display: none;"></div>
            
            <form id="loginForm">
                <div class="form-group delay-100 animate-fade-in">
                    <label>Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" required placeholder="you@example.com">
                </div>
                <div class="form-group delay-200 animate-fade-in">
                    <label>Password</label>
                    <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••">
                </div>
                <button type="submit" class="btn-primary delay-300 animate-fade-in" style="margin-top: 1rem;">Login securely</button>
            </form>
            <div class="footer delay-300 animate-fade-in">
                Don't have an account? <a href="register.jsp">Sign up</a>
            </div>
        </div>
    </div>

    <script src="js/api.js"></script>
    <script>
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.target.querySelector('button');
            const originalText = btn.textContent;
            btn.textContent = 'Logging in...';
            btn.disabled = true;

            const errorDiv = document.getElementById('errorMessage');
            errorDiv.style.display = 'none';
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            try {
                const response = await api.post('/auth/login', { email, password }, false);
                api.setToken(response.token);
                localStorage.setItem('user', JSON.stringify(response.user));
                window.location.href = 'dashboard.jsp';
            } catch (error) {
                errorDiv.textContent = error.message || 'Login failed';
                errorDiv.style.display = 'block';
                btn.textContent = originalText;
                btn.disabled = false;
            }
        });
    </script>
</body>
</html>
