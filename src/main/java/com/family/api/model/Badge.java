package com.family.api.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Badge")
public class Badge {

    public Badge() {}

    public Badge(Integer badgeId, String name, String iconUrl, String description) {
        this.badgeId = badgeId;
        this.name = name;
        this.iconUrl = iconUrl;
        this.description = description;
    }

    // Getters and Setters
    public Integer getBadgeId() { return badgeId; }
    public void setBadgeId(Integer badgeId) { this.badgeId = badgeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIconUrl() { return iconUrl; }
    public void setIconUrl(String iconUrl) { this.iconUrl = iconUrl; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

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
