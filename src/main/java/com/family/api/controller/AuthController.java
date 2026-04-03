package com.family.api.controller;

import com.family.api.model.User;
import com.family.api.security.JwtUtil;
import com.family.api.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        try {
            String email = credentials.get("email");
            String password = credentials.get("password");

            // Authenticate with Spring Security
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(email, password)
            );

            // Fetch full user details locally
            User loggedInUser = userService.getUserByEmail(email); 
            String token = jwtUtil.generateToken(email);

            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("user", loggedInUser);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return new ResponseEntity<>(Map.of("error", "Invalid email or password"), HttpStatus.UNAUTHORIZED);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        try {
            User registeredUser = userService.registerUser(user);
            String token = jwtUtil.generateToken(registeredUser.getEmail());

            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("user", registeredUser);

            return new ResponseEntity<>(response, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }
}
