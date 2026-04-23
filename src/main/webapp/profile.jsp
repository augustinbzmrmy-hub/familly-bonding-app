<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        .profile-header { display: flex; align-items: center; gap: 2rem; margin-bottom: 3rem; }
        .profile-img-container { position: relative; width: 150px; height: 150px; }
        .profile-img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; border: 4px solid var(--accent-primary); box-shadow: 0 10px 25px rgba(0,0,0,0.2); }
        .upload-btn { position: absolute; bottom: 5px; right: 5px; background: var(--primary); color: white; border: none; border-radius: 50%; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        .upload-btn:hover { transform: scale(1.1); background: var(--primary-hover); }

        .profile-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-top: 2rem; }
        .stat-card { padding: 1.5rem; text-align: center; }
        .stat-value { font-size: 2rem; font-weight: 800; color: var(--accent-primary); margin-bottom: 0.5rem; }
        .stat-label { font-size: 0.9rem; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 1px; }

        .form-section { max-width: 600px; margin-top: 3rem; }
        .save-btn { margin-top: 2rem; width: auto; padding: 1rem 3rem; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%; height: 100%;" class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />
        
        <div class="main-content">
            <div class="profile-header animate-fade-in">
                <div class="profile-img-container">
                    <img id="displayImg" src="https://ui-avatars.com/api/?name=User&background=random" class="profile-img" alt="Profile">
                    <label for="profileUpload" class="upload-btn">📷</label>
                    <input type="file" id="profileUpload" accept="image/*" style="display: none;">
                </div>
                <div>
                    <h1 id="userName" class="text-gradient" style="margin: 0; font-size: 2.5rem;">User Name</h1>
                    <p id="userRole" style="color: var(--text-secondary); font-size: 1.1rem; margin-top: 0.5rem;">Family Member</p>
                </div>
            </div>

            <div class="profile-stats delay-200 animate-fade-in">
                <div class="glass-card stat-card">
                    <div id="pointsValue" class="stat-value">0</div>
                    <div class="stat-label">Bonding Points</div>
                </div>
                <div class="glass-card stat-card">
                    <div id="familyName" class="stat-value">Family</div>
                    <div class="stat-label">Your Clan</div>
                </div>
            </div>

            <div class="glass-card form-section delay-300 animate-fade-in">
                <h3 style="margin-bottom: 1.5rem;">Edit Profile Details</h3>
                <form id="profileForm">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" id="fullNameInput" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" id="phoneInput" class="form-control" placeholder="+123 456 7890">
                    </div>
                    <div class="form-group">
                        <label>Email Address (Cannot be changed)</label>
                        <input type="email" id="emailInput" class="form-control" disabled>
                    </div>
                    <button type="submit" class="btn-primary save-btn">Save Changes</button>
                </form>
            </div>
        </div>
    </div>

    <div id="loader" class="loading animate-float">Loading your profile...</div>

    <script src="js/api.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }

            const cachedUser = JSON.parse(localStorage.getItem('user'));
            
            async function loadProfile() {
                try {
                    // Refresh user data from API
                    const user = await api.get(`/users/\${cachedUser.userId}`);
                    localStorage.setItem('user', JSON.stringify(user));

                    document.getElementById('displayImg').src = user.profilePictureUrl || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.fullName) + '&background=random';
                    document.getElementById('userName').textContent = user.fullName;
                    document.getElementById('userRole').textContent = user.role.replace('_', ' ');
                    document.getElementById('pointsValue').textContent = user.points;
                    document.getElementById('familyName').textContent = user.family ? user.family.familyName : 'No Family';
                    
                    document.getElementById('fullNameInput').value = user.fullName;
                    document.getElementById('phoneInput').value = user.phoneNumber || '';
                    document.getElementById('emailInput').value = user.email;

                    document.getElementById('loader').style.display = 'none';
                    document.getElementById('app').style.display = 'flex';
                } catch (error) {
                    console.error("Error loading profile", error);
                }
            }

            document.getElementById('profileForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                const btn = e.target.querySelector('button');
                btn.disabled = true;
                btn.textContent = 'Saving...';

                const formData = new FormData();
                formData.append('fullName', document.getElementById('fullNameInput').value);
                formData.append('phoneNumber', document.getElementById('phoneInput').value);
                
                const fileInput = document.getElementById('profileUpload');
                if (fileInput.files[0]) {
                    formData.append('image', fileInput.files[0]);
                }

                try {
                    const response = await fetch('/api/users/profile', {
                        method: 'POST',
                        headers: {
                            'Authorization': `Bearer \${api.getToken()}`
                        },
                        body: formData
                    });

                    if (!response.ok) throw new Error("Update failed");

                    api.showToast("Profile updated successfully!", "success");
                    await loadProfile();
                } catch (error) {
                    api.showToast("Error updating profile", "error");
                } finally {
                    btn.disabled = false;
                    btn.textContent = 'Save Changes';
                }
            });

            // Preview image on selection
            document.getElementById('profileUpload').addEventListener('change', (e) => {
                if (e.target.files[0]) {
                    const reader = new FileReader();
                    reader.onload = (re) => {
                        document.getElementById('displayImg').src = re.target.result;
                    };
                    reader.readAsDataURL(e.target.files[0]);
                }
            });

            loadProfile();
        });
    </script>
</body>
</html>
