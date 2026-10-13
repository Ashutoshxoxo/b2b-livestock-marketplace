package com.b2bmarketplace.livestock.auth.service;


import com.b2bmarketplace.livestock.auth.dto.AuthResponse;
import com.b2bmarketplace.livestock.auth.dto.RegisterRequest;
import com.b2bmarketplace.livestock.user.entity.RoleEntity;
import com.b2bmarketplace.livestock.user.entity.UserEntity;
import com.b2bmarketplace.livestock.user.entity.UserStatus;
import com.b2bmarketplace.livestock.user.repository.RoleRepository;
import com.b2bmarketplace.livestock.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.nio.charset.StandardCharsets;
import java.util.Locale;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class AuthService {

    private static final Set<String> ALLOWED_ROLES = Set.of("BUYER","SUPPLIER", "LOGISTIC");

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public AuthResponse register(RegisterRequest request) {

        String email = request.email().trim().toLowerCase(Locale.ROOT);
        String phone = request.phone().trim();
        String firstName = request.firstName().trim();
        String lastName = request.lastName() ==null ? null : request.lastName().trim();

        if (lastName != null && lastName.isEmpty()) {
            lastName = null;
        }

        if (request.password().getBytes(StandardCharsets.UTF_8).length >72) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Password must not exceed 72 Bytes");
        }

        if(userRepository.existsByEmail(email)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,"Email is already registered");
        }

        if (userRepository.existsByPhone(phone)) {
            throw  new ResponseStatusException(HttpStatus.CONFLICT,"Phone number is already registered");
        }

        String roleName= request.role().trim().toUpperCase(Locale.ROOT);

        RoleEntity role = roleRepository.findByName(roleName).orElseThrow(() -> new IllegalStateException("Required Role is not Present in the Database :" + roleName ));

        UserEntity user = UserEntity.createNewUser();
        user.setEmail(email);
        user.setPhone(phone);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setStatus(UserStatus.PENDING);
        user.addRole(role);

        UserEntity savedUser = userRepository.saveAndFlush(user);

        return new AuthResponse(
                savedUser.getId(),
                savedUser.getEmail(),
                savedUser.getPhone(),
                savedUser.getFirstName(),
                savedUser.getLastName(),
                savedUser.getStatus().name(),
                role.getName()
        );

    }
}
