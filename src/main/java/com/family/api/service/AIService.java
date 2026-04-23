package com.family.api.service;

import com.family.api.model.*;
import com.family.api.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AIService {

    @Autowired
    private ChallengeRepository challengeRepository;

    @Autowired
    private UserRepository userRepository;

    public String getFamilyAdvice(Family family) {
        List<User> familyMembers = userRepository.findByFamily_FamilyId(family.getFamilyId());
        
        StringBuilder advice = new StringBuilder("Hello \n" + family.getFamilyName() + " family! 🤖 Here is your AI update:\n\n");

        advice.append("✨ It's a great day to bond! Check out the Chartboard for new updates.\n");

        // Suggest a challenge
        List<Challenge> challenges = challengeRepository.findAll();
        if (!challenges.isEmpty()) {
            advice.append("\n💡 Recommendation: Why not try the '" + challenges.get(0).getTitle() + "' challenge today?\n");
        }

        // Leaderboard shoutout
        List<User> sortedMembers = familyMembers.stream()
                .sorted((a, b) -> b.getPoints().compareTo(a.getPoints()))
                .collect(Collectors.toList());
        
        if (!sortedMembers.isEmpty()) {
            advice.append("\n🏆 Kudos to " + sortedMembers.get(0).getFullName() + " for leading the leaderboard with " + sortedMembers.get(0).getPoints() + " points!");
        }

        return advice.toString();
    }
}
