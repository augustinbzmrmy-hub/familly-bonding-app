package com.family.api.service;

import com.family.api.exception.BadRequestException;
import com.family.api.exception.ResourceNotFoundException;
import com.family.api.model.Family;
import com.family.api.model.User;
import com.family.api.model.UserChallenge;
import com.family.api.repository.FamilyRepository;
import com.family.api.repository.UserChallengeRepository;
import com.family.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FamilyService {

    @Autowired
    private FamilyRepository familyRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserChallengeRepository userChallengeRepository;

    public Family createFamily(String familyName, Integer userId) {
        String normalizedName = normalizeFamilyName(familyName);
        if (familyRepository.findByFamilyName(normalizedName).isPresent()) {
            throw new BadRequestException("Family name already exists");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        if (user.getFamily() != null) {
            throw new BadRequestException("User already belongs to a family");
        }

        Family family = new Family();
        family.setFamilyName(normalizedName);
        Family savedFamily = familyRepository.save(family);

        user.setFamily(savedFamily);
        user.setRole("FAMILY_ADMIN");
        userRepository.save(user);

        return savedFamily;
    }

    public Family joinFamily(Integer familyId, Integer userId) {
        Family family = familyRepository.findById(familyId)
                .orElseThrow(() -> new ResourceNotFoundException("Family not found"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        if (user.getFamily() != null) {
            throw new BadRequestException("User already belongs to a family");
        }

        user.setFamily(family);
        if (user.getRole() == null || user.getRole().isBlank()) {
            user.setRole("FAMILY_MEMBER");
        }
        userRepository.save(user);

        return family;
    }

    public List<Family> getAllFamilies() {
        return familyRepository.findAll();
    }

    public Family getFamilyById(Integer familyId) {
        return familyRepository.findById(familyId)
                .orElseThrow(() -> new ResourceNotFoundException("Family not found"));
    }

    public Map<String, Object> getFamilySummary(Integer familyId) {
        Family family = getFamilyById(familyId);
        List<User> members = userRepository.findByFamily_FamilyId(familyId);
        List<UserChallenge> familyChallenges = userChallengeRepository.findByUser_Family_FamilyId(familyId);

        long completed = familyChallenges.stream().filter(uc -> "COMPLETED".equals(uc.getStatus())).count();
        long inProgress = familyChallenges.stream().filter(uc -> "IN_PROGRESS".equals(uc.getStatus())).count();
        long abandoned = familyChallenges.stream().filter(uc -> "ABANDONED".equals(uc.getStatus())).count();
        long engagedMembers = members.stream()
                .filter(member -> familyChallenges.stream().anyMatch(uc -> uc.getUser().getUserId().equals(member.getUserId())))
                .count();

        Map<String, Object> summary = new HashMap<>();
        summary.put("familyId", family.getFamilyId());
        summary.put("familyName", family.getFamilyName());
        summary.put("memberCount", members.size());
        summary.put("engagedMembers", engagedMembers);
        summary.put("completedChallenges", completed);
        summary.put("inProgressChallenges", inProgress);
        summary.put("abandonedChallenges", abandoned);
        summary.put("engagementRate", members.isEmpty() ? 0.0 : (engagedMembers * 100.0) / members.size());
        return summary;
    }

    private String normalizeFamilyName(String familyName) {
        if (familyName == null || familyName.trim().isEmpty()) {
            throw new BadRequestException("Family name is required");
        }
        return familyName.trim();
    }
}
