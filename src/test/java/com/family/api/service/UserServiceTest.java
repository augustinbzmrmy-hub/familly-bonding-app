package com.family.api.service;

import com.family.api.exception.BadRequestException;
import com.family.api.model.User;
import com.family.api.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testRegisterUser_Success() {
        User user = new User();
        user.setEmail("test@test.com");
        user.setPassword("password");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.empty());
        when(passwordEncoder.encode("password")).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        User registeredUser = userService.registerUser(user);

        assertNotNull(registeredUser);
        assertEquals("encodedPassword", registeredUser.getPassword());
        assertEquals("FAMILY_MEMBER", registeredUser.getRole());
        verify(userRepository, times(1)).save(user);
    }

    @Test
    public void testRegisterUser_EmailAlreadyExists() {
        User user = new User();
        user.setEmail("test@test.com");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));

        assertThrows(BadRequestException.class, () -> userService.registerUser(user));
        verify(userRepository, never()).save(any(User.class));
    }
}
