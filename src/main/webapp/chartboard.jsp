<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chartboard - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
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
        
        /* Thumbnail and Preview Styles */
        .post-image-thumbnail { 
            max-width: 200px; 
            max-height: 150px; 
            border-radius: 8px; 
            margin-top: 1rem; 
            cursor: pointer; 
            object-fit: cover; 
            transition: transform 0.2s;
            border: 2px solid rgba(255,255,255,0.1);
        }
        .post-image-thumbnail:hover { transform: scale(1.05); border-color: var(--accent-primary); }

        #imagePreviewModal {
            display: none;
            position: fixed;
            z-index: 1000;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.9);
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(5px);
        }
        #imagePreviewModal img { max-width: 90%; max-height: 90%; border-radius: 8px; box-shadow: 0 0 50px rgba(0,0,0,0.5); }
        .close-modal { position: absolute; top: 20px; right: 30px; color: white; font-size: 40px; cursor: pointer; }
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

            <div id="postsContainer" class="delay-300 animate-fade-in" style="margin-bottom: 2rem;"></div>

            <div class="glass-card post-form delay-300 animate-fade-in" style="margin-top: auto; position: sticky; bottom: 1rem; z-index: 100;">
                <form id="createPostForm" enctype="multipart/form-data">
                    <textarea id="postContent" rows="3" placeholder="Share something wonderful with your family..." required></textarea>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <input type="file" id="postImage" accept="image/*" style="font-size: 0.9rem; color: var(--text-secondary);">
                        <button type="submit" class="btn-primary" style="width: auto; padding: 0.75rem 2rem;">Post Message</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div id="loader" class="loading animate-float">Loading chartboard...</div>

    <!-- Image Preview Modal -->
    <div id="imagePreviewModal" onclick="closeImagePreview()">
        <span class="close-modal">&times;</span>
        <img id="modalImage" src="" alt="Full Preview">
    </div>

    <script src="js/api.js"></script>
    <script src="js/notifications.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }

            const cachedUser = JSON.parse(localStorage.getItem('user'));
            const postsContainer = document.getElementById('postsContainer');
            
            // Connect to real-time updates
            notifications.connect(cachedUser, {
                onFamilyMessage: (msg) => {
                    if (msg.includes("Chartboard")) loadPosts();
                }
            });

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
                        const imgHtml = p.imageUrl ? `<img src="\${p.imageUrl}" class="post-image-thumbnail" onclick="previewImage('\${p.imageUrl}')">` : '';

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
                                <div class="post-content">
                                    \${p.content}
                                    \${imgHtml}
                                </div>
                            </div>
                        `;
                    });
                    
                    // Auto-scroll to latest message at the bottom
                    window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
                } catch (error) {
                    console.error("Failed to load posts", error);
                }
            }

            document.getElementById('createPostForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                const contentInput = document.getElementById('postContent');
                const imageInput = document.getElementById('postImage');
                
                const formData = new FormData();
                formData.append('content', contentInput.value);
                if (imageInput.files[0]) {
                    formData.append('image', imageInput.files[0]);
                }

                try {
                    // Use standard fetch for multipart
                    const response = await fetch('/api/posts', {
                        method: 'POST',
                        headers: {
                            'Authorization': `Bearer \${api.getToken()}`
                        },
                        body: formData
                    });

                    if (!response.ok) throw new Error("Upload failed");

                    api.showToast("Post shared with family!", "success");
                    contentInput.value = '';
                    imageInput.value = '';
                    loadPosts();
                } catch (error) {
                    api.showToast("Error creating post", "error");
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

            window.previewImage = (url) => {
                const modal = document.getElementById('imagePreviewModal');
                const modalImg = document.getElementById('modalImage');
                modalImg.src = url;
                modal.style.display = 'flex';
            };

            window.closeImagePreview = () => {
                document.getElementById('imagePreviewModal').style.display = 'none';
            };

            await loadPosts();
            
            document.getElementById('loader').style.display = 'none';
            document.getElementById('app').style.display = 'flex';

            // Logout is now handled in the sidebar fragment
        });
    </script>
</body>
</html>
