
package com.b2bmarketplace.livestock.auth.dto;

import java.util.UUID;

public record AuthResponse(
        UUID id,
        String email,
        String phone,
        String firstName,
        String lastName,
        String status,
        String role
) {
}