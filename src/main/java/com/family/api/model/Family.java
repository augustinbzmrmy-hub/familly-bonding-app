package com.family.api.model;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.List;

@Entity
@Table(name = "Family")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "members"}) // Prevent infinite serialization loops
public class Family {

    public Family() {}

    public Family(Integer familyId, String familyName, List<User> members) {
        this.familyId = familyId;
        this.familyName = familyName;
        this.members = members;
    }

    // Getters and Setters
    public Integer getFamilyId() { return familyId; }
    public void setFamilyId(Integer familyId) { this.familyId = familyId; }

    public String getFamilyName() { return familyName; }
    public void setFamilyName(String familyName) { this.familyName = familyName; }

    public List<User> getMembers() { return members; }
    public void setMembers(List<User> members) { this.members = members; }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "family_id")
    private Integer familyId;

    @Column(name = "family_name", nullable = false, length = 100)
    private String familyName;

    @OneToMany(mappedBy = "family", fetch = FetchType.EAGER)
    private List<User> members;
}
