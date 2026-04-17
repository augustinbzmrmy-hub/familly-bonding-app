package com.family.api.controller;

import com.family.api.dto.ChallengeActionRequest;
import com.family.api.model.UserChallenge;
import com.family.api.service.ChallengeService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class ChallengeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ChallengeService challengeService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void joinChallenge_returnsSuccess() throws Exception {
        UserChallenge userChallenge = new UserChallenge();
        userChallenge.setStatus("IN_PROGRESS");

        when(challengeService.joinChallenge(anyInt(), anyInt())).thenReturn(userChallenge);

        ChallengeActionRequest request = new ChallengeActionRequest(1);

        mockMvc.perform(post("/api/challenges/1/join")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Successfully joined the challenge"))
                .andExpect(jsonPath("$.status").value("IN_PROGRESS"));
    }

    @Test
    void joinChallenge_failsOnMissingUserId() throws Exception {
        // Empty body or missing userId in ChallengeActionRequest
        String json = "{}";

        mockMvc.perform(post("/api/challenges/1/join")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
                .andExpect(status().isBadRequest());
    }
}
