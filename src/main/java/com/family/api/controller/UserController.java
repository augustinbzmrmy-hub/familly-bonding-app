package com.family.api.controller;

import com.family.api.model.User;
import com.family.api.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Allows testing from anywhere
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private com.family.api.service.FileStorageService fileStorageService;

    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        return new ResponseEntity<>(userService.getAllUsers(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Integer id) {
        try {
            User user = userService.getUserById(id);
            return new ResponseEntity<>(user, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.NOT_FOUND);
        }
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Integer id, @RequestBody User user) {
        try {
            User updatedUser = userService.updateUser(id, user);
            return new ResponseEntity<>(updatedUser, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/leaderboard")
    public ResponseEntity<List<User>> getLeaderboard(@org.springframework.security.core.annotation.AuthenticationPrincipal org.springframework.security.core.userdetails.UserDetails userDetails) {
        User user = userService.getUserByEmail(userDetails.getUsername());
        if (user.getFamily() == null) {
            return new ResponseEntity<>(List.of(user), HttpStatus.OK);
        }
        return new ResponseEntity<>(userService.getLeaderboard(user.getFamily().getFamilyId()), HttpStatus.OK);
    }

    @PostMapping(value = "/profile", consumes = {"multipart/form-data"})
    public ResponseEntity<?> updateProfile(
            @RequestParam("fullName") String fullName,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam(value = "image", required = false) org.springframework.web.multipart.MultipartFile image,
            @org.springframework.security.core.annotation.AuthenticationPrincipal org.springframework.security.core.userdetails.UserDetails userDetails) {
        try {
            User user = userService.getUserByEmail(userDetails.getUsername());
            String imageUrl = user.getProfilePictureUrl();
            
            if (image != null && !image.isEmpty()) {
                imageUrl = fileStorageService.storeFile(image);
            }
            
            user.setFullName(fullName);
            user.setPhoneNumber(phoneNumber);
            user.setProfilePictureUrl(imageUrl);
            
            User updatedUser = userService.updateUser(user.getUserId(), user);
            return new ResponseEntity<>(updatedUser, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }
}
