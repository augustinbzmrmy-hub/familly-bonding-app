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
        .nav-link { display: block; padding: 0.75rem 1rem; color: #94a3b8; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: 0.3s; cursor: pointer;}
        .nav-link:hover, .nav-link.active { background: rgba(99, 102, 241, 0.1); color: white; }
        
        .post-card { background: var(--card); padding: 1.5rem; border-radius: 1rem; margin-bottom: 1.5rem; border: 1px solid rgba(255,255,255,0.05); }
        .post-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .user-info { display: flex; align-items: center; gap: 0.75rem; }
        .avatar-small { width: 32px; height: 32px; border-radius: 50%; background: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: bold; color: white;}
        .user-name { font-weight: 600; font-size: 0.95rem; }
        .timestamp { font-size: 0.8rem; color: #94a3b8; }
        .post-content { line-height: 1.6; color: #cbd5e1; }
        
        .search-bar { width: 100%; padding: 0.75rem; border-radius: 0.5rem; border: 1px solid #334155; background: var(--card); color: white; margin-bottom: 1.5rem; box-sizing: border-box; }
        .post-form { background: var(--card); padding: 1.5rem; border-radius: 1rem; margin-bottom: 2.5rem; border: 1px solid var(--primary); }
        textarea { width: 100%; padding: 1rem; border-radius: 0.5rem; border: 1px solid #334155; background: #0f172a; color: white; resize: none; margin-bottom: 1rem; box-sizing: border-box; }
        .btn-post { padding: 0.6rem 1.5rem; background: var(--primary); border: none; border-radius: 0.5rem; color: white; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-post:hover { background: #4f46e5; }
        .delete-btn { background: transparent; border: none; color: #ef4444; cursor: pointer; font-size: 0.8rem; }
        .loading { text-align: center; margin-top: 2rem; color: #94a3b8; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%;">
        <div class="sidebar">
            <div class="logo">Family Bonding</div>
            <nav>
                <a href="dashboard.jsp" class="nav-link">🏠 Overview</a>
                <a href="family.jsp" class="nav-link">👨‍👩‍👧‍👦 My Family</a>
                <a href="chartboard.jsp" class="nav-link active">💬 Chartboard</a>
                <a href="challenges.jsp" class="nav-link">🏆 Challenges</a>
                <a href="education.jsp" class="nav-link">📚 Education</a>
                <a id="logoutBtn" class="nav-link" style="margin-top: 2rem; color: #ef4444;">🚪 Logout</a>
            </nav>
        </div>
        
        <div class="main-content">
            <h1>Family Chartboard</h1>
            
            <input type="text" id="searchInput" class="search-bar" placeholder="Search posts by keyword... (Press Enter)">

            <div class="post-form">
                <form id="createPostForm">
                    <textarea id="postContent" rows="3" placeholder="Share something with your family..." required></textarea>
                    <button type="submit" class="btn-post">Post Message</button>
                </form>
            </div>

            <div id="postsContainer"></div>
        </div>
    </div>
    <div id="loader" class="loading">Loading chartboard...</div>

    <script src="js/api.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }

            const cachedUser = JSON.parse(localStorage.getItem('user'));
            const postsContainer = document.getElementById('postsContainer');
            
            if (!cachedUser.family) {
                document.getElementById('app').style.display = 'flex';
                document.getElementById('loader').style.display = 'none';
                postsContainer.innerHTML = '<p style="color: #94a3b8; text-align:center;">You must join a family to use the Chartboard. <a href="family.jsp" style="color:#6366f1;">Go to Family</a></p>';
                return;
            }

            async function loadPosts(query = '') {
                try {
                    let endpoint = `/posts/family/${cachedUser.family.familyId}`;
                    if (query) {
                        endpoint += `/search?keyword=${encodeURIComponent(query)}`;
                    }

                    const posts = await api.get(endpoint);
                    postsContainer.innerHTML = '';

                    if (!posts || posts.length === 0) {
                        postsContainer.innerHTML = '<p style="color: #94a3b8; text-align:center;">No posts found.</p>';
                        return;
                    }

                    posts.forEach(p => {
                        const isOwner = p.user.userId === cachedUser.userId;
                        let deleteHtml = isOwner ? `<button type="button" class="delete-btn" onclick="deletePost(${p.postId})">Delete</button>` : '';
                        
                        // Parse timestamp if it exists, otherwise provide fallback
                        const ts = p.createdAt ? new Date(p.createdAt).toLocaleString() : 'Just now';
                        const uName = p.user && p.user.fullName ? p.user.fullName : 'Unknown';

                        postsContainer.innerHTML += `
                            <div class="post-card">
                                <div class="post-header">
                                    <div class="user-info">
                                        <div class="avatar-small">${uName.substring(0,1).toUpperCase()}</div>
                                        <div>
                                            <div class="user-name">${uName}</div>
                                            <div class="timestamp">${ts}</div>
                                        </div>
                                    </div>
                                    ${deleteHtml}
                                </div>
                                <div class="post-content">${p.content}</div>
                            </div>
                        `;
                    });
                } catch (error) {
                    console.error("Failed to load posts", error);
                }
            }

            document.getElementById('createPostForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                const contentInput = document.getElementById('postContent');
                try {
                    await api.post('/posts', { userId: cachedUser.userId, content: contentInput.value });
                    contentInput.value = '';
                    loadPosts();
                } catch (error) {
                    alert("Error creating post: " + error.message);
                }
            });

            document.getElementById('searchInput').addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    loadPosts(e.target.value);
                }
            });

            window.deletePost = async (postId) => {
                if (!confirm("Delete this post?")) return;
                try {
                    await api.delete(`/posts/${postId}?userId=${cachedUser.userId}`);
                    loadPosts();
                } catch (error) {
                    alert("Error deleting post: " + error.message);
                }
            };

            await loadPosts();
            
            document.getElementById('loader').style.display = 'none';
            document.getElementById('app').style.display = 'flex';

            document.getElementById('logoutBtn').addEventListener('click', () => {
                api.removeToken();
                localStorage.removeItem('user');
                window.location.href = 'login.jsp';
            });
        });
    </script>
</body>
</html>
