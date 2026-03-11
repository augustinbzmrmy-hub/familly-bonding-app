package com.family.api.controller;

import com.family.api.model.Challenge;
import com.family.api.model.UserChallenge;
import com.family.api.service.ChallengeService;
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
    public ResponseEntity<?> createChallenge(@RequestBody Map<String, Object> request) {
        try {
            Integer createdBy = (Integer) request.get("createdByUserId"); // optional
            String title = (String) request.get("title");
            String description = (String) request.get("description");

            if (title == null || description == null) {
                return new ResponseEntity<>(Map.of("error", "title and description are required"), HttpStatus.BAD_REQUEST);
            }

            Challenge challenge = challengeService.createChallenge(createdBy, title, description);
            return new ResponseEntity<>(challenge, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getChallenges(@RequestParam Integer userId) {
        return new ResponseEntity<>(challengeService.getAllChallengesWithUserStatus(userId), HttpStatus.OK);
    }

    @PostMapping("/{challengeId}/join")
    public ResponseEntity<?> joinChallenge(@PathVariable Integer challengeId, @RequestBody Map<String, Integer> request) {
        try {
            Integer userId = request.get("userId");
            if (userId == null) {
                return new ResponseEntity<>(Map.of("error", "userId is required"), HttpStatus.BAD_REQUEST);
            }
            UserChallenge result = challengeService.joinChallenge(userId, challengeId);
            return new ResponseEntity<>(Map.of("message", "Successfully joined the challenge", "status", result.getStatus()), HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/{challengeId}/complete")
    public ResponseEntity<?> completeChallenge(@PathVariable Integer challengeId, @RequestBody Map<String, Integer> request) {
        try {
            Integer userId = request.get("userId");
            if (userId == null) {
                return new ResponseEntity<>(Map.of("error", "userId is required"), HttpStatus.BAD_REQUEST);
            }
            UserChallenge result = challengeService.completeChallenge(userId, challengeId);
            return new ResponseEntity<>(Map.of("message", "Challenge completed", "status", result.getStatus()), HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }
}
