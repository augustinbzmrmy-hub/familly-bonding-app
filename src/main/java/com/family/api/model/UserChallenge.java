package com.family.api.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "User_Challenge")
@Data
@NoArgsConstructor
@AllArgsConstructor
@IdClass(UserChallengeId.class)
public class UserChallenge {

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

@Data
@NoArgsConstructor
@AllArgsConstructor
class UserChallengeId implements Serializable {
    private Integer user;
    private Integer challenge;
}
