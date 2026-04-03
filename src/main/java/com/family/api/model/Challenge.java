package com.family.api.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "Challenge")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Challenge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "challenge_id")
    private Integer challengeId;

    @Column(nullable = false, length = 150)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "created_by")
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password", "family"})
    private User createdBy;
}
