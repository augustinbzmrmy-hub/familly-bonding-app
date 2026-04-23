package com.family.api.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Shopping_Item")
public class ShoppingItem {

    public ShoppingItem() {}

    public ShoppingItem(Integer itemId, String name, String quantity, boolean isBought, User addedBy, Family family) {
        this.itemId = itemId;
        this.name = name;
        this.quantity = quantity;
        this.isBought = isBought;
        this.addedBy = addedBy;
        this.family = family;
    }

    // Getters and Setters
    public Integer getItemId() { return itemId; }
    public void setItemId(Integer itemId) { this.itemId = itemId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getQuantity() { return quantity; }
    public void setQuantity(String quantity) { this.quantity = quantity; }

    public boolean isBought() { return isBought; }
    public void setBought(boolean bought) { isBought = bought; }

    public User getAddedBy() { return addedBy; }
    public void setAddedBy(User addedBy) { this.addedBy = addedBy; }

    public Family getFamily() { return family; }
    public void setFamily(Family family) { this.family = family; }

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
