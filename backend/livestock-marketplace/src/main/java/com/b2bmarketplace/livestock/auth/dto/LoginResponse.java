package com.b2bmarketplace.livestock.auth.dto;


public record LoginResponse(
        String accessToken,
        String tokenType,
        long expiresIn,
        AuthResponse user
) { }