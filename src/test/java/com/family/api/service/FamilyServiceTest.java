package com.family.api.service;

import com.family.api.model.Family;
import com.family.api.model.User;
import com.family.api.model.UserChallenge;
import com.family.api.repository.FamilyRepository;
import com.family.api.repository.UserChallengeRepository;
import com.family.api.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

class FamilyServiceTest {

    @Mock
    private FamilyRepository familyRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserChallengeRepository userChallengeRepository;

    @InjectMocks
    private FamilyService familyService;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void getFamilySummary_calculatesEngagementAndProgress() {
        Family family = new Family();
        family.setFamilyId(5);
        family.setFamilyName("The Smiths");

        User engaged = new User();
        engaged.setUserId(1);
        engaged.setFullName("Engaged Member");

        User inactive = new User();
        inactive.setUserId(2);
        inactive.setFullName("Inactive Member");

        UserChallenge completed = new UserChallenge();
        completed.setUser(engaged);
        completed.setStatus("COMPLETED");

        UserChallenge inProgress = new UserChallenge();
        inProgress.setUser(engaged);
        inProgress.setStatus("IN_PROGRESS");

        when(familyRepository.findById(5)).thenReturn(Optional.of(family));
        when(userRepository.findByFamily_FamilyId(5)).thenReturn(List.of(engaged, inactive));
        when(userChallengeRepository.findByUser_Family_FamilyId(5)).thenReturn(List.of(completed, inProgress));

        Map<String, Object> summary = familyService.getFamilySummary(5);

        assertEquals("The Smiths", summary.get("familyName"));
        assertEquals(2, summary.get("memberCount"));
        assertEquals(1L, summary.get("engagedMembers"));
        assertEquals(1L, summary.get("completedChallenges"));
        assertEquals(1L, summary.get("inProgressChallenges"));
        assertEquals(50.0, summary.get("engagementRate"));
    }
}
