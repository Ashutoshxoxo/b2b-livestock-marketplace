package com.b2bmarketplace.livestock.user.repository;

import com.b2bmarketplace.livestock.user.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface  UserRepository extends JpaRepository<UserEntity, UUID> {

    boolean existsByEmail(String email);
    boolean existsByPhone(String phone);

    Optional<UserEntity> findByEmail(String email);

}
