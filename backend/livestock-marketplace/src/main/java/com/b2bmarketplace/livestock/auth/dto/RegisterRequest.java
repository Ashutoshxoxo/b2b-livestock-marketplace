
package com.b2bmarketplace.livestock.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(

        @NotBlank
        @Email
        @Size(max = 255)
        String email,

        @NotBlank
        @Pattern(
                regexp = "^\\+?[0-9]{10,19}$",
                message = "Phone must contain 10 to 19 digits, optionally starting with +"
        )
        String phone,

        @NotBlank
        @Size(min = 8, max = 72)
        String password,

        @NotBlank
        @Size(max = 100)
        @Pattern(regexp = ".*\\S.*", message = "First name cannot be blank")
        String firstName,

        @Size(max = 100)
        String lastName,

        @NotBlank
        @Pattern(
                regexp = "BUYER|SUPPLIER|LOGISTICS",
                message = "Role must be BUYER, SUPPLIER or LOGISTICS"
        )
        String role
) {
}