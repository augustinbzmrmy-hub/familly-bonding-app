package com.family.api.repository;

import com.family.api.model.UserChallenge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserChallengeRepository extends JpaRepository<UserChallenge, Object> {
    Optional<UserChallenge> findByUser_UserIdAndChallenge_ChallengeId(Integer userId, Integer challengeId);
    List<UserChallenge> findByUser_UserId(Integer userId);
}
