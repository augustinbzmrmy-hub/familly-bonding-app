package com.family.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateFamilyRequest(
        @NotBlank(message = "familyName is required")
        String familyName,
        @NotNull(message = "userId is required")
        Integer userId
) {
}
