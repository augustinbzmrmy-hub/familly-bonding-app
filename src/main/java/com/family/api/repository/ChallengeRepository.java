package com.family.api.repository;

import com.family.api.model.Challenge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ChallengeRepository extends JpaRepository<Challenge, Integer> {
    Optional<Challenge> findByTitleIgnoreCase(String title);
}
