package com.family.api.repository;

import com.family.api.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByEmail(String email);
    Optional<User> findByEmailAndPassword(String email, String password);
    List<User> findByFamily_FamilyId(Integer familyId);
}
