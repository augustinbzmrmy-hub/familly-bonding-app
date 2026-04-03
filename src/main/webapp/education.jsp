<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Education Forum - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        .forum-container { max-width: 900px; margin: 0 auto; }
        .question-input-card { margin-bottom: 3rem; padding: 2rem; border: 1px solid rgba(16, 185, 129, 0.2); }
        .question-card { margin-bottom: 2rem; padding: 2rem; }
        .author-info { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1rem; }
        .author-avatar { width: 32px; height: 32px; border-radius: 50%; background: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.8rem; }
        .author-name { font-weight: 600; color: var(--text-primary); font-size: 0.95rem; }
        .post-date { color: var(--text-secondary); font-size: 0.8rem; }
        .question-content { font-size: 1.1rem; line-height: 1.6; color: var(--text-primary); margin-bottom: 1.5rem; }
        
        .answer-section { margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border); }
        .answer-item { margin-bottom: 1.25rem; padding-left: 1rem; border-left: 2px solid rgba(16, 185, 129, 0.3); }
        .answer-content { font-size: 0.95rem; line-height: 1.5; color: var(--text-secondary); }
        
        .reply-box { margin-top: 1rem; display: flex; gap: 0.75rem; }
        .reply-input { flex: 1; background: rgba(255, 255, 255, 0.05); border: 1px solid var(--border); border-radius: 0.5rem; padding: 0.6rem 1rem; color: white; transition: 0.3s; }
        .reply-input:focus { outline: none; border-color: var(--primary); background: rgba(255, 255, 255, 0.08); }
        
        textarea.form-control { min-height: 100px; resize: none; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />

        <div class="main-content">
            <div class="header animate-fade-in">
                <div>
                    <h1 style="margin:0; font-size: 2.2rem; font-weight: 700;">Social Awareness</h1>
                    <p style="color: var(--text-secondary); margin: 0.5rem 0 0; font-size: 1.1rem;">Learn and grow together through shared questions.</p>
                </div>
            </div>

        <div class="forum-container">
            <div class="glass-card question-input-card delay-100 animate-fade-in">
                <h3 style="margin-top: 0; margin-bottom: 1rem;">Ask a New Question</h3>
                <textarea id="questionContent" class="form-control" placeholder="What's on your mind?"></textarea>
                <div style="display: flex; justify-content: flex-end;">
                    <button id="postQuestionBtn" class="btn-primary" style="width: auto; padding: 0.7rem 2rem;">Post Question</button>
                </div>
            </div>

            <div id="questionsList">
                <!-- Questions will be loaded here -->
            </div>
        </div>
    </div>

    <script src="js/api.js"></script>
    <script>
        let currentUser = null;

        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }

            currentUser = JSON.parse(localStorage.getItem('user'));
            if (!currentUser) {
                window.location.href = 'login.jsp';
                return;
            }

        async function loadQuestions() {
            try {
                const questions = await api.get('/education/questions');
                const list = document.getElementById('questionsList');
                list.innerHTML = '';

                questions.forEach((q, index) => {
                    const card = document.createElement('div');
                    card.className = `glass-card question-card animate-fade-in`;
                    card.style.animationDelay = `\${(index + 2) * 100}ms`;
                    
                    const answersHtml = q.answers.map(a => `
                        <div class="answer-item">
                            <div class="author-info" style="margin-bottom: 0.5rem;">
                                <div class="author-avatar" style="width: 24px; height: 24px; font-size: 0.7rem; background: var(--secondary); font-weight: 700; display: flex; align-items: center; justify-content: center; color: white; border-radius: 50%;">\${a.user.fullName[0].toUpperCase()}</div>
                                <span class="author-name" style="font-size: 0.85rem;">\${a.user.fullName}</span>
                                <span class="post-date">\${new Date(a.createdAt).toLocaleDateString()}</span>
                            </div>
                            <div class="answer-content">\${a.content}</div>
                        </div>
                    `).join('');

                    card.innerHTML = `
                        <div class="author-info">
                            <div class="author-avatar" style="width: 32px; height: 32px; border-radius: 50%; background: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.8rem; color: white;">\${q.user.fullName[0].toUpperCase()}</div>
                            <div>
                                <div class="author-name">\${q.user.fullName}</div>
                                <div class="post-date">\${new Date(q.createdAt).toLocaleString()}</div>
                            </div>
                        </div>
                        <div class="question-content">\${q.content}</div>
                        <div class="answer-section">
                            <h4 style="margin-top: 0; margin-bottom: 1rem; font-size: 0.9rem; color: var(--primary);">Answers</h4>
                            \${answersHtml || '<p style="color: var(--text-secondary); font-size: 0.9rem; font-style: italic;">No answers yet. Be the first to help!</p>'}
                            
                            <div class="reply-box">
                                <input type="text" class="reply-input" placeholder="Write an answer..." id="reply-\${q.questionId}">
                                <button class="btn-primary" style="width: auto; padding: 0.5rem 1.2rem; font-size: 0.85rem;" onclick="postAnswer(\${q.questionId})">Reply</button>
                            </div>
                        </div>
                    `;
                    list.appendChild(card);
                });
            } catch (error) {
                console.error("Failed to load questions:", error);
            }
        }

        window.postAnswer = async (questionId) => {
            const input = document.getElementById(`reply-\${questionId}`);
            const content = input.value.trim();
            if (!content) return;

            try {
                await api.post(`/education/questions/\${questionId}/answers`, { userId: currentUser.userId, content });
                input.value = '';
                loadQuestions();
            } catch (error) {
                alert("Failed to post answer: " + error.message);
            }
        };

        document.getElementById('postQuestionBtn').addEventListener('click', async () => {
            const content = document.getElementById('questionContent').value.trim();
            if (!content) return;

            try {
                await api.post('/education/questions', { userId: currentUser.userId, content });
                document.getElementById('questionContent').value = '';
                loadQuestions();
            } catch (error) {
                alert("Failed to post question: " + error.message);
            }
        });

        loadQuestions();
    });
</script>
</body>
</html>
