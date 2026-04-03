package com.family.api.dto;

import jakarta.validation.constraints.NotNull;

public record UserIdRequest(
        @NotNull(message = "userId is required")
        Integer userId
) {
}
