package com.family.api.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "Shopping_Item")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShoppingItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "item_id")
    private Integer itemId;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(length = 50)
    private String quantity;

    @Column(name = "is_bought")
    private boolean isBought = false;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "added_by")
    private User addedBy;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "family_id", nullable = false)
    private Family family;
}
