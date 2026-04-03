package com.family.api.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateChallengeRequest(
        Integer createdByUserId,
        @NotBlank(message = "title is required")
        String title,
        @NotBlank(message = "description is required")
        String description
) {
}
