<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chartboard - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        .post-card { display: flex; flex-direction: column; padding: 1.5rem; margin-bottom: 1.5rem; transition: transform 0.3s ease; }
        .post-card:hover { transform: translateY(-3px); }
        .post-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.2rem; }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .avatar-small { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #a855f7, #6366f1); display: flex; align-items: center; justify-content: center; font-size: 1rem; font-weight: bold; color: white; box-shadow: 0 4px 10px rgba(168, 85, 247, 0.3);}
        .user-name { font-weight: 600; font-size: 1.05rem; color: var(--text-primary); }
        .timestamp { font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.2rem; }
        .post-content { line-height: 1.7; color: #e2e8f0; font-size: 1rem; background: rgba(0,0,0,0.2); padding: 1rem; border-radius: 0.5rem; }
        
        .search-bar { width: 100%; margin-bottom: 2rem; }
        .post-form { padding: 2rem; margin-bottom: 3rem; }
        textarea { width: 100%; padding: 1.2rem; border-radius: 0.75rem; border: 1px solid var(--surface-light); background: rgba(15, 23, 42, 0.6); color: white; resize: none; margin-bottom: 1rem; font-family: 'Inter', sans-serif; transition: all 0.3s ease; }
        textarea:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(129, 140, 248, 0.2); }
        .delete-btn { background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.2); border-radius: 0.5rem; padding: 0.4rem 0.8rem; color: var(--error); cursor: pointer; font-size: 0.85rem; transition: 0.3s; font-weight: 600; }
        .delete-btn:hover { background: var(--error); color: white; }
        .loading { text-align: center; margin-top: 3rem; color: var(--text-secondary); font-size: 1.2rem; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%; height: 100%;" class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />
        
        <div class="main-content">
            <div class="delay-100 animate-fade-in" style="margin-bottom: 2rem;">
                <h1 style="font-size: 2.2rem; margin: 0; font-weight: 700;">Family Chartboard</h1>
                <p style="color: var(--text-secondary); margin-top: 0.5rem;">Communicate and share moments with your loved ones.</p>
            </div>
            
            <input type="text" id="searchInput" class="form-control search-bar delay-200 animate-fade-in" placeholder="Search posts by keyword... (Press Enter)">

            <div class="glass-card post-form delay-300 animate-fade-in">
                <form id="createPostForm">
                    <textarea id="postContent" rows="3" placeholder="Share something wonderful with your family..." required></textarea>
                    <button type="submit" class="btn-primary" style="width: auto; padding: 0.75rem 2rem;">Post Message</button>
                </form>
            </div>

            <div id="postsContainer" class="delay-300 animate-fade-in"></div>
        </div>
    </div>
    <div id="loader" class="loading animate-float">Loading chartboard...</div>

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
                postsContainer.innerHTML = '<div class="glass-card" style="padding: 3rem; text-align: center;"><h3 style="margin-bottom: 1rem;">No Family Yet</h3><p style="color: var(--text-secondary); margin-bottom: 1.5rem;">You must join a family to use the Chartboard.</p><a href="family.jsp" class="btn-primary" style="width: auto;">Go to Family</a></div>';
                return;
            }

            async function loadPosts(query = '') {
                try {
                    let endpoint = `/posts/family/\${cachedUser.family.familyId}`;
                    if (query) endpoint += `/search?keyword=\${encodeURIComponent(query)}`;

                    const posts = await api.get(endpoint);
                    postsContainer.innerHTML = '';

                    if (!posts || posts.length === 0) {
                        postsContainer.innerHTML = '<p style="color: var(--text-secondary); text-align:center; margin-top: 2rem;">No posts found. Be the first to start a conversation!</p>';
                        return;
                    }

                    posts.forEach(p => {
                        const isOwner = p.user.userId === cachedUser.userId;
                        let deleteHtml = isOwner ? `<button type="button" class="delete-btn" onclick="deletePost(\${p.postId})">Delete</button>` : '';
                        const ts = p.createdAt ? new Date(p.createdAt).toLocaleString() : 'Just now';
                        const uName = p.user && p.user.fullName ? p.user.fullName : 'Unknown';

                        postsContainer.innerHTML += `
                            <div class="glass-card post-card animate-fade-in" style="animation-duration: 0.5s;">
                                <div class="post-header">
                                    <div class="user-info">
                                        <div class="avatar-small">\${uName.substring(0,1).toUpperCase()}</div>
                                        <div>
                                            <div class="user-name">\${uName}</div>
                                            <div class="timestamp">\${ts}</div>
                                        </div>
                                    </div>
                                    \${deleteHtml}
                                </div>
                                <div class="post-content">\${p.content}</div>
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
                    api.showToast("Post shared with family!", "success");
                    contentInput.value = '';
                    loadPosts();
                } catch (error) {
                    console.error("Error creating post", error);
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
                    await api.delete(`/posts/\${postId}?userId=\${cachedUser.userId}`);
                    api.showToast("Post deleted", "info");
                    loadPosts();
                } catch (error) {
                    console.error("Error deleting post", error);
                }
            };

            await loadPosts();
            
            document.getElementById('loader').style.display = 'none';
            document.getElementById('app').style.display = 'flex';

            // Logout is now handled in the sidebar fragment
        });
    </script>
</body>
</html>
