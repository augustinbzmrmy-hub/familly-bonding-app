<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendar - Family Bonding</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animations.css">
    <style>
        body { display: flex; margin: 0; height: 100vh; overflow: hidden; }
        .event-list { display: flex; flex-direction: column; gap: 1rem; margin-top: 1.5rem; }
        .event-card { display: flex; gap: 1.5rem; padding: 1.5rem; }
        .event-date { display: flex; flex-direction: column; align-items: center; justify-content: center; background: var(--accent-primary); color: white; border-radius: 12px; min-width: 80px; padding: 0.75rem; }
        .event-date .day { font-size: 1.8rem; font-weight: bold; }
        .event-date .month { font-size: 0.9rem; text-transform: uppercase; }
        .event-info h4 { margin: 0; font-size: 1.2rem; color: white; }
        .event-info p { margin: 0.5rem 0; color: var(--text-secondary); }
        .event-info .meta { font-size: 0.85rem; color: var(--accent-primary); display: flex; gap: 1rem; }
    </style>
</head>
<body>
    <div id="app" style="display: none; width: 100%; height: 100%;" class="app-container">
        <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />
        
        <div class="main-content">
            <div class="header animate-fade-in">
                <div>
                    <h1 class="text-gradient">Family Calendar</h1>
                    <p style="color: var(--text-secondary);">Important dates for the whole family.</p>
                </div>
                <button class="btn-primary" onclick="showAddEventModal()" style="width: auto;">+ New Event</button>
            </div>

            <div id="eventList" class="event-list delay-200 animate-fade-in">
                <!-- Events loaded here -->
            </div>
        </div>
    </div>

    <script src="js/api.js"></script>
    <script>
        const MONTHS = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

        document.addEventListener('DOMContentLoaded', async () => {
            // Show the app shell immediately so the sidebar is visible
            document.getElementById('app').style.display = 'flex';
            
            if (!api.getToken()) {
                window.location.href = 'login.jsp';
                return;
            }
            loadEvents();
        });

        async function loadEvents() {
            try {
                const listDiv = document.getElementById('eventList');
                listDiv.innerHTML = '<div class="loading">Loading events...</div>';

                const events = await api.get('/calendar');
                
                if (!events || events.length === 0) {
                    listDiv.innerHTML = '<div class="glass-card" style="padding: 2rem; text-align: center;">No upcoming events. Time to plan something! 🎈</div>';
                } else {
                    // Sort by date
                    events.sort((a, b) => new Date(a.eventDate) - new Date(b.eventDate));
                    
                    listDiv.innerHTML = events.map(event => {
                        const date = new Date(event.eventDate);
                        return `
                            <div class="glass-card event-card">
                                <div class="event-date">
                                    <span class="day">\${date.getDate()}</span>
                                    <span class="month">\${MONTHS[date.getMonth()]}</span>
                                </div>
                                <div class="event-info" style="flex: 1;">
                                    <h4>\${event.title}</h4>
                                    <p>\${event.description || 'No description provided.'}</p>
                                    <div class="meta">
                                        <span>📍 \${event.location || 'No location'}</span>
                                        <span>⏰ \${date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
                                    </div>
                                </div>
                                <button onclick="deleteEvent(\${event.eventId})" style="background: none; border: none; color: var(--error); cursor: pointer; align-self: flex-start; font-size: 1.2rem;">&times;</button>
                            </div>
                        `;
                    }).join('');
                }
                
            } catch (error) {
                console.error("Error loading events:", error);
                document.getElementById('eventList').innerHTML = `
                    <div class="glass-card" style="padding: 2rem; text-align: center; border: 1px solid var(--error);">
                        <p style="color: var(--error);">Failed to load calendar events.</p>
                        <p style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 0.5rem;">
                            If you haven't restarted the server after Phase 2, please do so now to create the database tables.
                        </p>
                    </div>
                `;
            }
        }

        async function deleteEvent(id) {
            if (!confirm("Delete this event?")) return;
            try {
                await api.delete(`/calendar/\${id}`);
                loadEvents();
            } catch (error) {
                api.showToast("Failed to delete event.", "error");
            }
        }

        function showAddEventModal() {
            const title = prompt("Event Title:");
            if (!title) return;
            const dateStr = prompt("Date (YYYY-MM-DD HH:MM):", new Date().toISOString().slice(0, 16).replace('T', ' '));
            if (!dateStr) return;
            const location = prompt("Location:");
            
            api.post('/calendar', {
                title: title,
                eventDate: dateStr.replace(' ', 'T'), // Convert to ISO-ish
                location: location
            }).then(() => {
                api.showToast("Event added!", "success");
                loadEvents();
            }).catch(err => {
                api.showToast("Invalid date format. Use YYYY-MM-DD HH:MM", "error");
            });
        }
    </script>
</body>
</html>
