package com.family.api.service;

import com.family.api.model.Family;
import com.family.api.model.User;
import com.family.api.repository.FamilyRepository;
import com.family.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FamilyService {

    @Autowired
    private FamilyRepository familyRepository;

    @Autowired
    private UserRepository userRepository;

    public Family createFamily(String familyName, Integer userId) {
        if (familyRepository.findByFamilyName(familyName).isPresent()) {
            throw new RuntimeException("Family name already exists");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (user.getFamily() != null) {
            throw new RuntimeException("User already belongs to a family");
        }

        Family family = new Family();
        family.setFamilyName(familyName);
        Family savedFamily = familyRepository.save(family);

        user.setFamily(savedFamily);
        user.setRole("FAMILY_ADMIN");
        userRepository.save(user);

        return savedFamily;
    }

    public Family joinFamily(Integer familyId, Integer userId) {
        Family family = familyRepository.findById(familyId)
                .orElseThrow(() -> new RuntimeException("Family not found"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (user.getFamily() != null) {
            throw new RuntimeException("User already belongs to a family");
        }

        user.setFamily(family);
        userRepository.save(user);

        return family;
    }

    public List<Family> getAllFamilies() {
        return familyRepository.findAll();
    }

    public Family getFamilyById(Integer familyId) {
        return familyRepository.findById(familyId)
                .orElseThrow(() -> new RuntimeException("Family not found"));
    }
}
