package com.family.api.config;

import com.family.api.model.Challenge;
import com.family.api.model.Question;
import com.family.api.repository.ChallengeRepository;
import com.family.api.repository.QuestionRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDatabase(ChallengeRepository challengeRepository, QuestionRepository questionRepository) {
        return args -> {
            if (challengeRepository.count() == 0) {
                Challenge c1 = new Challenge();
                c1.setTitle("Morning Family Walk");
                c1.setDescription("Walk together for 30 minutes every morning this week to stay active and talk about your day.");
                
                Challenge c2 = new Challenge();
                c2.setTitle("Healthy Cooking Night");
                c2.setDescription("Prepare a new healthy recipe together as a family. Everyone should have a specific task!");

                Challenge c3 = new Challenge();
                c3.setTitle("No-Screen Dinner");
                c3.setDescription("Have dinner without any phones or tablets. Share your best moment of the week instead.");

                challengeRepository.saveAll(List.of(c1, c2, c3));
                System.out.println("Sample challenges initialized.");
            }

            if (questionRepository.count() == 0) {
                Question q1 = new Question();
                q1.setContent("What are some good ways to handle disagreements with siblings gracefully?");
                
                Question q2 = new Question();
                q2.setContent("How can we better support each other during stressful exam periods or work deadlines?");

                Question q3 = new Question();
                q3.setContent("What family traditions would you like to start or keep alive for future generations?");

                // We need to associate a user, but since users are dynamic, 
                // for the initial seed we might skip or wait until at least one user exists.
                // However, the schema requires a user_id for Question.
                // For simplicity, we'll wait for the user to post their first question manually 
                // OR we'll just focus on challenges which are more "global".
            }
        };
    }
}
