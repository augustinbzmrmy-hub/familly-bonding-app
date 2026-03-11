package com.family.api.service;

import com.family.api.model.Challenge;
import com.family.api.model.User;
import com.family.api.model.UserChallenge;
import com.family.api.repository.ChallengeRepository;
import com.family.api.repository.UserChallengeRepository;
import com.family.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ChallengeService {

    @Autowired
    private ChallengeRepository challengeRepository;

    @Autowired
    private UserChallengeRepository userChallengeRepository;

    @Autowired
    private UserRepository userRepository;

    public Challenge createChallenge(Integer createdByUserId, String title, String description) {
        User user = null;
        if (createdByUserId != null) {
            user = userRepository.findById(createdByUserId)
                    .orElseThrow(() -> new RuntimeException("Creator user not found"));
        }
        
        Challenge challenge = new Challenge();
        challenge.setTitle(title);
        challenge.setDescription(description);
        challenge.setCreatedBy(user);
        
        return challengeRepository.save(challenge);
    }

    public List<Map<String, Object>> getAllChallengesWithUserStatus(Integer userId) {
        List<Challenge> challenges = challengeRepository.findAll();
        List<UserChallenge> userChallenges = userChallengeRepository.findByUser_UserId(userId);
        
        Map<Integer, String> statusMap = new HashMap<>();
        for (UserChallenge uc : userChallenges) {
            statusMap.put(uc.getChallenge().getChallengeId(), uc.getStatus());
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Challenge c : challenges) {
            Map<String, Object> challengeMap = new HashMap<>();
            challengeMap.put("challengeId", c.getChallengeId());
            challengeMap.put("title", c.getTitle());
            challengeMap.put("description", c.getDescription());
            challengeMap.put("status", statusMap.getOrDefault(c.getChallengeId(), "NOT_JOINED"));
            result.add(challengeMap);
        }
        return result;
    }

    public UserChallenge joinChallenge(Integer userId, Integer challengeId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
                
        Challenge challenge = challengeRepository.findById(challengeId)
                .orElseThrow(() -> new RuntimeException("Challenge not found"));

        Optional<UserChallenge> existing = userChallengeRepository.findByUser_UserIdAndChallenge_ChallengeId(userId, challengeId);
        if (existing.isPresent()) {
            return existing.get();
        }

        UserChallenge uc = new UserChallenge();
        uc.setUser(user);
        uc.setChallenge(challenge);
        uc.setStatus("IN_PROGRESS");
        
        return userChallengeRepository.save(uc);
    }

    public UserChallenge completeChallenge(Integer userId, Integer challengeId) {
        UserChallenge uc = userChallengeRepository.findByUser_UserIdAndChallenge_ChallengeId(userId, challengeId)
                .orElseThrow(() -> new RuntimeException("User has not joined this challenge"));
                
        uc.setStatus("COMPLETED");
        return userChallengeRepository.save(uc);
    }
}
