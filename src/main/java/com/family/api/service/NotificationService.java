package com.family.api.service;

import com.family.api.model.Notification;
import com.family.api.model.User;
import com.family.api.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    public List<Notification> getUserNotifications(Integer userId) {
        return notificationRepository.findByUser_UserIdOrderByCreatedAtDesc(userId);
    }

    public void sendNotification(User user, String message) {
        // Save to DB
        Notification notification = new Notification();
        notification.setUser(user);
        notification.setMessage(message);
        notification.setRead(false);
        notificationRepository.save(notification);

        // Send real-time WebSocket message
        messagingTemplate.convertAndSendToUser(
            user.getEmail(), 
            "/topic/notifications", 
            notification
        );
    }

    public void broadcastToFamily(Integer familyId, String message, Integer excludeUserId) {
        // This would require fetching all family members
        // For simplicity, we can send to a family-specific topic
        messagingTemplate.convertAndSend("/topic/family/" + familyId, message);
    }
}
