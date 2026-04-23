package com.family.api.controller;

import com.family.api.model.User;
import com.family.api.service.AIService;
import com.family.api.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AIController {

    @Autowired
    private AIService aiService;

    @Autowired
    private UserService userService;

    @GetMapping("/advice")
    public ResponseEntity<Map<String, String>> getAdvice(@AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.getUserByEmail(userDetails.getUsername());
        if (user.getFamily() == null) {
            return ResponseEntity.ok(Map.of("message", "Join a family to get AI advice!"));
        }
        String advice = aiService.getFamilyAdvice(user.getFamily());
        return ResponseEntity.ok(Map.of("message", advice));
    }
}
