package com.family.api.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Challenge")
public class Challenge {

    public Challenge() {}

    public Challenge(Integer challengeId, String title, String description, Integer pointsValue, User createdBy) {
        this.challengeId = challengeId;
        this.title = title;
        this.description = description;
        this.pointsValue = pointsValue;
        this.createdBy = createdBy;
    }

    // Getters and Setters
    public Integer getChallengeId() { return challengeId; }
    public void setChallengeId(Integer challengeId) { this.challengeId = challengeId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getPointsValue() { return pointsValue; }
    public void setPointsValue(Integer pointsValue) { this.pointsValue = pointsValue; }

    public User getCreatedBy() { return createdBy; }
    public void setCreatedBy(User createdBy) { this.createdBy = createdBy; }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "challenge_id")
    private Integer challengeId;

    @Column(nullable = false, length = 150)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "points_value", nullable = false)
    private Integer pointsValue = 50;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "created_by")
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password", "family"})
    private User createdBy;
}
