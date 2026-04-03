package com.family.api.service;

import com.family.api.exception.BadRequestException;
import com.family.api.exception.ResourceNotFoundException;
import com.family.api.model.Challenge;
import com.family.api.model.User;
import com.family.api.model.UserChallenge;
import com.family.api.repository.ChallengeRepository;
import com.family.api.repository.UserChallengeRepository;
import com.family.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ChallengeService {

    private static final String STATUS_NOT_JOINED = "NOT_JOINED";
    private static final String STATUS_IN_PROGRESS = "IN_PROGRESS";
    private static final String STATUS_COMPLETED = "COMPLETED";
    private static final String STATUS_ABANDONED = "ABANDONED";

    @Autowired
    private ChallengeRepository challengeRepository;

    @Autowired
    private UserChallengeRepository userChallengeRepository;

    @Autowired
    private UserRepository userRepository;

    public Challenge createChallenge(Integer createdByUserId, String title, String description) {
        String normalizedTitle = normalizeText(title, "title");
        String normalizedDescription = normalizeText(description, "description");

        challengeRepository.findByTitleIgnoreCase(normalizedTitle)
                .ifPresent(existing -> {
                    throw new BadRequestException("A challenge with this title already exists");
                });

        User user = null;
        if (createdByUserId != null) {
            user = userRepository.findById(createdByUserId)
                    .orElseThrow(() -> new ResourceNotFoundException("Creator user not found"));
        }

        Challenge challenge = new Challenge();
        challenge.setTitle(normalizedTitle);
        challenge.setDescription(normalizedDescription);
        challenge.setCreatedBy(user);

        return challengeRepository.save(challenge);
    }

    public List<Map<String, Object>> getAllChallengesWithUserStatus(Integer userId, String status, String search, Integer createdByUserId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        List<Challenge> challenges = challengeRepository.findAll();
        List<UserChallenge> userChallenges = userChallengeRepository.findByUser_UserId(userId);

        Map<Integer, String> statusMap = new HashMap<>();
        for (UserChallenge uc : userChallenges) {
            statusMap.put(uc.getChallenge().getChallengeId(), uc.getStatus());
        }

        String normalizedStatus = status == null ? null : status.trim().toUpperCase();
        String normalizedSearch = search == null ? null : search.trim().toLowerCase();

        List<Map<String, Object>> result = new ArrayList<>();
        for (Challenge c : challenges) {
            String challengeStatus = statusMap.getOrDefault(c.getChallengeId(), STATUS_NOT_JOINED);
            if (normalizedStatus != null && !normalizedStatus.isBlank() && !challengeStatus.equalsIgnoreCase(normalizedStatus)) {
                continue;
            }
            if (normalizedSearch != null && !normalizedSearch.isBlank()) {
                String haystack = (c.getTitle() + " " + c.getDescription()).toLowerCase();
                if (!haystack.contains(normalizedSearch)) {
                    continue;
                }
            }
            if (createdByUserId != null) {
                Integer creatorId = c.getCreatedBy() == null ? null : c.getCreatedBy().getUserId();
                if (!createdByUserId.equals(creatorId)) {
                    continue;
                }
            }

            Map<String, Object> challengeMap = new HashMap<>();
            challengeMap.put("challengeId", c.getChallengeId());
            challengeMap.put("title", c.getTitle());
            challengeMap.put("description", c.getDescription());
            challengeMap.put("status", challengeStatus);
            challengeMap.put("createdByUserId", c.getCreatedBy() == null ? null : c.getCreatedBy().getUserId());
            challengeMap.put("availableToFamily", user.getFamily() != null);
            result.add(challengeMap);
        }
        return result;
    }

    public UserChallenge joinChallenge(Integer userId, Integer challengeId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        if (user.getFamily() == null) {
            throw new BadRequestException("User must belong to a family before joining challenges");
        }

        Challenge challenge = challengeRepository.findById(challengeId)
                .orElseThrow(() -> new ResourceNotFoundException("Challenge not found"));

        Optional<UserChallenge> existing = userChallengeRepository.findByUser_UserIdAndChallenge_ChallengeId(userId, challengeId);
        if (existing.isPresent()) {
            UserChallenge userChallenge = existing.get();
            if (STATUS_COMPLETED.equals(userChallenge.getStatus())) {
                throw new BadRequestException("Completed challenges cannot be joined again");
            }
            userChallenge.setStatus(STATUS_IN_PROGRESS);
            return userChallengeRepository.save(userChallenge);
        }

        UserChallenge uc = new UserChallenge();
        uc.setUser(user);
        uc.setChallenge(challenge);
        uc.setStatus(STATUS_IN_PROGRESS);

        return userChallengeRepository.save(uc);
    }

    public UserChallenge completeChallenge(Integer userId, Integer challengeId) {
        UserChallenge uc = userChallengeRepository.findByUser_UserIdAndChallenge_ChallengeId(userId, challengeId)
                .orElseThrow(() -> new BadRequestException("User has not joined this challenge"));

        if (STATUS_COMPLETED.equals(uc.getStatus())) {
            throw new BadRequestException("Challenge is already completed");
        }
        if (STATUS_ABANDONED.equals(uc.getStatus())) {
            throw new BadRequestException("Rejoin the challenge before marking it as completed");
        }

        uc.setStatus(STATUS_COMPLETED);
        return userChallengeRepository.save(uc);
    }

    public UserChallenge abandonChallenge(Integer userId, Integer challengeId) {
        UserChallenge uc = userChallengeRepository.findByUser_UserIdAndChallenge_ChallengeId(userId, challengeId)
                .orElseThrow(() -> new BadRequestException("User has not joined this challenge"));

        if (STATUS_COMPLETED.equals(uc.getStatus())) {
            throw new BadRequestException("Completed challenges cannot be abandoned");
        }

        uc.setStatus(STATUS_ABANDONED);
        return userChallengeRepository.save(uc);
    }

    public Map<String, Object> getUserChallengeSummary(Integer userId) {
        userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<UserChallenge> userChallenges = userChallengeRepository.findByUser_UserId(userId);
        long completed = userChallenges.stream().filter(uc -> STATUS_COMPLETED.equals(uc.getStatus())).count();
        long inProgress = userChallenges.stream().filter(uc -> STATUS_IN_PROGRESS.equals(uc.getStatus())).count();
        long abandoned = userChallenges.stream().filter(uc -> STATUS_ABANDONED.equals(uc.getStatus())).count();

        Map<String, Object> summary = new HashMap<>();
        summary.put("userId", userId);
        summary.put("joinedChallenges", userChallenges.size());
        summary.put("completedChallenges", completed);
        summary.put("inProgressChallenges", inProgress);
        summary.put("abandonedChallenges", abandoned);
        summary.put("completionRate", userChallenges.isEmpty() ? 0.0 : (completed * 100.0) / userChallenges.size());
        return summary;
    }

    public List<Map<String, Object>> getFamilyLeaderboard(Integer familyId) {
        List<User> familyMembers = userRepository.findByFamily_FamilyId(familyId);
        if (familyMembers.isEmpty()) {
            return List.of();
        }

        Map<Integer, List<UserChallenge>> groupedByUser = userChallengeRepository.findByUser_Family_FamilyId(familyId).stream()
                .collect(Collectors.groupingBy(uc -> uc.getUser().getUserId()));

        return familyMembers.stream()
                .map(user -> {
                    List<UserChallenge> memberChallenges = groupedByUser.getOrDefault(user.getUserId(), List.of());
                    long completed = memberChallenges.stream().filter(uc -> STATUS_COMPLETED.equals(uc.getStatus())).count();
                    long inProgress = memberChallenges.stream().filter(uc -> STATUS_IN_PROGRESS.equals(uc.getStatus())).count();

                    Map<String, Object> memberSummary = new HashMap<>();
                    memberSummary.put("userId", user.getUserId());
                    memberSummary.put("fullName", user.getFullName());
                    memberSummary.put("completedChallenges", completed);
                    memberSummary.put("inProgressChallenges", inProgress);
                    memberSummary.put("score", completed * 10 + inProgress * 2);
                    return memberSummary;
                })
                .sorted(Comparator
                        .comparing((Map<String, Object> row) -> ((Number) row.get("score")).intValue())
                        .reversed()
                        .thenComparing(row -> String.valueOf(row.get("fullName"))))
                .collect(Collectors.toList());
    }

    private String normalizeText(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new BadRequestException(fieldName + " is required");
        }
        return value.trim();
    }
}
