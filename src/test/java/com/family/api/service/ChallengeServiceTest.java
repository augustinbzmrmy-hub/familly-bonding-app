package com.family.api.service;

import com.family.api.exception.BadRequestException;
import com.family.api.model.Challenge;
import com.family.api.model.Family;
import com.family.api.model.User;
import com.family.api.model.UserChallenge;
import com.family.api.repository.ChallengeRepository;
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
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

class ChallengeServiceTest {

    @Mock
    private ChallengeRepository challengeRepository;

    @Mock
    private UserChallengeRepository userChallengeRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private ChallengeService challengeService;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void joinChallenge_requiresFamilyMembership() {
        User user = new User();
        user.setUserId(1);

        Challenge challenge = new Challenge();
        challenge.setChallengeId(2);

        when(userRepository.findById(1)).thenReturn(Optional.of(user));
        when(challengeRepository.findById(2)).thenReturn(Optional.of(challenge));

        assertThrows(BadRequestException.class, () -> challengeService.joinChallenge(1, 2));
    }

    @Test
    void completeChallenge_rejectsAbandonedChallenge() {
        UserChallenge userChallenge = new UserChallenge();
        userChallenge.setStatus("ABANDONED");

        when(userChallengeRepository.findByUser_UserIdAndChallenge_ChallengeId(1, 2))
                .thenReturn(Optional.of(userChallenge));

        assertThrows(BadRequestException.class, () -> challengeService.completeChallenge(1, 2));
    }

    @Test
    void getFamilyLeaderboard_ordersByScore() {
        Family family = new Family();
        family.setFamilyId(10);

        User alice = new User();
        alice.setUserId(1);
        alice.setFullName("Alice");
        alice.setFamily(family);

        User bob = new User();
        bob.setUserId(2);
        bob.setFullName("Bob");
        bob.setFamily(family);

        UserChallenge aliceCompleted = new UserChallenge();
        aliceCompleted.setUser(alice);
        aliceCompleted.setStatus("COMPLETED");

        UserChallenge bobInProgress = new UserChallenge();
        bobInProgress.setUser(bob);
        bobInProgress.setStatus("IN_PROGRESS");

        when(userRepository.findByFamily_FamilyId(10)).thenReturn(List.of(alice, bob));
        when(userChallengeRepository.findByUser_Family_FamilyId(10)).thenReturn(List.of(aliceCompleted, bobInProgress));

        List<Map<String, Object>> leaderboard = challengeService.getFamilyLeaderboard(10);

        assertEquals(2, leaderboard.size());
        assertEquals("Alice", leaderboard.get(0).get("fullName"));
        assertEquals(10L, leaderboard.get(0).get("score"));
        assertEquals("Bob", leaderboard.get(1).get("fullName"));
        assertEquals(2L, leaderboard.get(1).get("score"));
    }
}
