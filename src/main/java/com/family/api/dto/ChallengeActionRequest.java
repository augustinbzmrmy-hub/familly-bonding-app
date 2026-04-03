package com.family.api.dto;

import jakarta.validation.constraints.NotNull;

public record ChallengeActionRequest(
        @NotNull(message = "userId is required")
        Integer userId
) {
}
