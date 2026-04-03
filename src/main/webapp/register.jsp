<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        body { display: flex; align-items: center; justify-content: center; }
        .card-wrapper { width: 100%; max-width: 500px; padding: 2rem; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 0; }
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
            <h2 class="header-title text-gradient">Create Account</h2>
            <div id="errorMessage" class="error" style="display: none;"></div>
            
            <form id="registerForm">
                <div class="form-group delay-100 animate-fade-in">
                    <label>Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required placeholder="John Doe">
                </div>
                <div class="form-group delay-100 animate-fade-in">
                    <label>Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" required placeholder="you@example.com">
                </div>
                <div class="form-row delay-200 animate-fade-in">
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••">
                    </div>
                    <div class="form-group">
                        <label>Role</label>
                        <select id="role" name="role" class="form-control" style="appearance: none; background-color: var(--surface);">
                            <option value="FAMILY_MEMBER">Family Member</option>
                            <option value="FAMILY_ADMIN">Parent/Guardian</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn-primary delay-300 animate-fade-in" style="margin-top: 1.5rem;">Create Account</button>
            </form>
            <div class="footer delay-300 animate-fade-in">
                Already have an account? <a href="login.jsp">Login here</a>
            </div>
        </div>
    </div>

    <script src="js/api.js"></script>
    <script>
        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.target.querySelector('button');
            const originalText = btn.textContent;
            btn.textContent = 'Creating...';
            btn.disabled = true;

            const errorDiv = document.getElementById('errorMessage');
            errorDiv.style.display = 'none';
            const fullName = document.getElementById('fullName').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const role = document.getElementById('role').value;

            try {
                const response = await api.post('/auth/register', { fullName, email, password, role }, false);
                api.setToken(response.token);
                localStorage.setItem('user', JSON.stringify(response.user));
                window.location.href = 'dashboard.jsp';
            } catch (error) {
                errorDiv.textContent = error.message || 'Registration failed';
                errorDiv.style.display = 'block';
                btn.textContent = originalText;
                btn.disabled = false;
            }
        });
    </script>
</body>
</html>
