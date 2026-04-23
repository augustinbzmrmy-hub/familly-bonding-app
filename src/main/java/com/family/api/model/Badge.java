package com.family.api.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "Badge")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Badge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "badge_id")
    private Integer badgeId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(name = "icon_url")
    private String iconUrl;

    @Column(columnDefinition = "TEXT")
    private String description;
}
