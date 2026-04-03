package com.family.api.controller;

import com.family.api.dto.ChallengeActionRequest;
import com.family.api.dto.CreateChallengeRequest;
import com.family.api.model.Challenge;
import com.family.api.model.UserChallenge;
import com.family.api.service.ChallengeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/challenges")
@CrossOrigin(origins = "*")
public class ChallengeController {

    @Autowired
    private ChallengeService challengeService;

    @PostMapping
    public ResponseEntity<Challenge> createChallenge(@Valid @RequestBody CreateChallengeRequest request) {
        Challenge challenge = challengeService.createChallenge(
                request.createdByUserId(),
                request.title(),
                request.description()
        );
        return new ResponseEntity<>(challenge, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getChallenges(
            @RequestParam Integer userId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Integer createdByUserId
    ) {
        return new ResponseEntity<>(
                challengeService.getAllChallengesWithUserStatus(userId, status, search, createdByUserId),
                HttpStatus.OK
        );
    }

    @PostMapping("/{challengeId}/join")
    public ResponseEntity<Map<String, Object>> joinChallenge(
            @PathVariable Integer challengeId,
            @Valid @RequestBody ChallengeActionRequest request
    ) {
        UserChallenge result = challengeService.joinChallenge(request.userId(), challengeId);
        return new ResponseEntity<>(
                Map.<String, Object>of("message", "Successfully joined the challenge", "status", result.getStatus()),
                HttpStatus.OK
        );
    }

    @PostMapping("/{challengeId}/complete")
    public ResponseEntity<Map<String, Object>> completeChallenge(
            @PathVariable Integer challengeId,
            @Valid @RequestBody ChallengeActionRequest request
    ) {
        UserChallenge result = challengeService.completeChallenge(request.userId(), challengeId);
        return new ResponseEntity<>(Map.<String, Object>of("message", "Challenge completed", "status", result.getStatus()), HttpStatus.OK);
    }

    @PostMapping("/{challengeId}/abandon")
    public ResponseEntity<Map<String, Object>> abandonChallenge(
            @PathVariable Integer challengeId,
            @Valid @RequestBody ChallengeActionRequest request
    ) {
        UserChallenge result = challengeService.abandonChallenge(request.userId(), challengeId);
        return new ResponseEntity<>(Map.<String, Object>of("message", "Challenge abandoned", "status", result.getStatus()), HttpStatus.OK);
    }

    @GetMapping("/summary/{userId}")
    public ResponseEntity<Map<String, Object>> getUserChallengeSummary(@PathVariable Integer userId) {
        return new ResponseEntity<>(challengeService.getUserChallengeSummary(userId), HttpStatus.OK);
    }

    @GetMapping("/leaderboard/family/{familyId}")
    public ResponseEntity<List<Map<String, Object>>> getFamilyLeaderboard(@PathVariable Integer familyId) {
        return new ResponseEntity<>(challengeService.getFamilyLeaderboard(familyId), HttpStatus.OK);
    }
}
