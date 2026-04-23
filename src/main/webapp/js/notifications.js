let stompClient = null;

const notifications = {
    connect: (user, onMessageReceived) => {
        const socket = new SockJS('/ws-family');
        stompClient = Stomp.over(socket);
        // Disable logging in console
        stompClient.debug = null;

        stompClient.connect({}, (frame) => {
            console.log('Connected to WebSocket');
            
            // Subscribe to personal notifications
            stompClient.subscribe('/user/topic/notifications', (notification) => {
                const data = JSON.parse(notification.body);
                api.showToast(data.message, 'info');
                if (onMessageReceived) onMessageReceived(data);
            });

            // Subscribe to family broadcast
            if (user.family && user.family.familyId) {
                stompClient.subscribe('/topic/family/' + user.family.familyId, (message) => {
                    api.showToast(message.body, 'info');
                    if (options && options.onFamilyMessage) options.onFamilyMessage(message.body);
                });
            }
        }, (error) => {
            console.error('WebSocket connection error:', error);
            // Try to reconnect after 5 seconds
            setTimeout(() => notifications.connect(user, onMessageReceived), 5000);
        });
    }
};
