package com.family.api.service;

import com.family.api.model.User;
import com.family.api.repository.UserRepository;
import com.family.api.exception.BadRequestException;
import com.family.api.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    public User registerUser(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new BadRequestException("Email already exists");
        }
        if(user.getRole() == null || user.getRole().isEmpty()) {
            user.setRole("FAMILY_MEMBER");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Integer id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
    
    public User updateUser(Integer id, User userDetails) {
        User user = getUserById(id);
        user.setFullName(userDetails.getFullName());
        user.setRole(userDetails.getRole());
        return userRepository.save(user);
    }
}
