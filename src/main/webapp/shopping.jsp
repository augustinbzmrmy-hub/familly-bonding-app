<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping List - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        body { display: flex; margin: 0; height: 100vh; overflow: hidden; }
        .shopping-list { display: flex; flex-direction: column; gap: 0.75rem; margin-top: 1.5rem; }
        .item-card { display: flex; justify-content: space-between; align-items: center; padding: 1rem 1.5rem; }
        .bought { opacity: 0.5; }
        .bought span { text-decoration: line-through; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%; height: 100%;" class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />
        
        <div class="main-content">
            <div class="header animate-fade-in">
                <div>
                    <h1 class="text-gradient">Shopping List</h1>
                    <p style="color: var(--text-secondary);">Collaborate on household needs.</p>
                </div>
                <div style="display: flex; gap: 0.5rem;">
                    <input type="text" id="newItemName" placeholder="Add item..." style="padding: 0.75rem; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1); background: rgba(0,0,0,0.2); color: white;">
                    <button class="btn-primary" onclick="addItem()" style="width: auto;">Add</button>
                </div>
            </div>

            <div id="shoppingList" class="shopping-list delay-200 animate-fade-in">
                <!-- Items loaded here -->
            </div>
        </div>
    </div>

    <script src="js/api.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }
            loadShoppingList();
        });

        async function loadShoppingList() {
            try {
                const items = await api.get('/shopping');
                const listDiv = document.getElementById('shoppingList');
                
                if (items.length === 0) {
                    listDiv.innerHTML = '<div class="glass-card" style="padding: 2rem; text-align: center;">List is empty. Need milk? 🥛</div>';
                } else {
                    listDiv.innerHTML = items.map(item => `
                        <div class="glass-card item-card \${item.bought ? 'bought' : ''}">
                            <div style="display: flex; align-items: center; gap: 1rem;">
                                <input type="checkbox" \${item.bought ? 'checked' : ''} onclick="toggleItem(\${item.itemId})" style="width: 20px; height: 20px; cursor: pointer;">
                                <span style="font-size: 1.1rem;">\${item.name}</span>
                            </div>
                            <button onclick="deleteItem(\${item.itemId})" style="background: none; border: none; color: var(--error); cursor: pointer; font-size: 1.2rem;">&times;</button>
                        </div>
                    `).join('');
                }
                
                document.getElementById('app').style.display = 'flex';
            } catch (error) {
                console.error("Error loading shopping list:", error);
            }
        }

        async function addItem() {
            const input = document.getElementById('newItemName');
            if (!input.value) return;
            
            try {
                await api.post('/shopping', { name: input.value });
                input.value = '';
                loadShoppingList();
            } catch (error) {
                api.showToast("Failed to add item.", "error");
            }
        }

        async function toggleItem(id) {
            try {
                await api.patch(`/shopping/\${id}/toggle`);
                loadShoppingList();
            } catch (error) {
                api.showToast("Failed to update item.", "error");
            }
        }

        async function deleteItem(id) {
            if (!confirm("Remove this item?")) return;
            try {
                await api.delete(`/shopping/\${id}`);
                loadShoppingList();
            } catch (error) {
                api.showToast("Failed to delete item.", "error");
            }
        }
    </script>
</body>
</html>
