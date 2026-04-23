package com.family.api.model;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "User_Challenge")
@IdClass(UserChallengeId.class)
public class UserChallenge {

    public UserChallenge() {}

    public UserChallenge(User user, Challenge challenge, String status, LocalDateTime joinedAt) {
        this.user = user;
        this.challenge = challenge;
        this.status = status;
        this.joinedAt = joinedAt;
    }

    // Getters and Setters
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Challenge getChallenge() { return challenge; }
    public void setChallenge(Challenge challenge) { this.challenge = challenge; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getJoinedAt() { return joinedAt; }
    public void setJoinedAt(LocalDateTime joinedAt) { this.joinedAt = joinedAt; }

    @Id
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password", "family"})
    private User user;

    @Id
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "challenge_id")
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Challenge challenge;

    @Column(length = 50)
    private String status = "IN_PROGRESS"; // COMPLETED, IN_PROGRESS

    @CreationTimestamp
    @Column(name = "joined_at", updatable = false)
    private LocalDateTime joinedAt;
}

class UserChallengeId implements Serializable {
    private Integer user;
    private Integer challenge;

    public UserChallengeId() {}

    public UserChallengeId(Integer user, Integer challenge) {
        this.user = user;
        this.challenge = challenge;
    }

    // Getters and Setters
    public Integer getUser() { return user; }
    public void setUser(Integer user) { this.user = user; }

    public Integer getChallenge() { return challenge; }
    public void setChallenge(Integer challenge) { this.challenge = challenge; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserChallengeId that = (UserChallengeId) o;
        return java.util.Objects.equals(user, that.user) && java.util.Objects.equals(challenge, that.challenge);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(user, challenge);
    }
}
