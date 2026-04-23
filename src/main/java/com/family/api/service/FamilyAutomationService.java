package com.family.api.service;

import com.family.api.model.ChartboardPost;
import com.family.api.model.Family;
import com.family.api.model.User;
import com.family.api.repository.ChartboardPostRepository;
import com.family.api.repository.FamilyRepository;
import com.family.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

@Service
public class FamilyAutomationService {

    @Autowired
    private ChartboardPostRepository postRepository;

    @Autowired
    private FamilyRepository familyRepository;

    @Autowired
    private UserRepository userRepository;

    private final String[] DAILY_QUESTIONS = {
        "What is your favorite family memory from last year?",
        "If we could go anywhere on vacation tomorrow, where would it be?",
        "What is one thing you appreciate about the person to your left?",
        "What was the highlight of your week?",
        "What is a new skill you'd like the whole family to learn together?"
    };

    // Runs at 9:00 AM every day
    @Scheduled(cron = "0 0 9 * * ?")
    public void postDailyQuestion() {
        List<Family> families = familyRepository.findAll();
        String question = DAILY_QUESTIONS[new Random().nextInt(DAILY_QUESTIONS.length)];

        for (Family family : families) {
            // Find a system admin or a default user to post as, or create a "System" user
            User systemUser = userRepository.findAll().stream()
                    .filter(u -> u.getRole().equals("SYSTEM_ADMIN"))
                    .findFirst()
                    .orElse(null);

            if (systemUser != null) {
                ChartboardPost post = new ChartboardPost();
                post.setContent("🌟 DAILY FAMILY QUESTION: " + question);
                post.setUser(systemUser);
                postRepository.save(post);
            }
        }
    }

    public List<ChartboardPost> getMemoryLane(Integer familyId) {
        LocalDateTime yearAgoStart = LocalDateTime.now().minusYears(1).withHour(0).withMinute(0);
        LocalDateTime yearAgoEnd = LocalDateTime.now().minusYears(1).withHour(23).withMinute(59);
        
        // This would require a repository method to find posts by family and date range
        // For now, let's assume we add this logic to ChartboardService
        return postRepository.findAll(); // Placeholder
    }
}
