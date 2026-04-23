package com.family.api.repository;

import com.family.api.model.ShoppingItem;
import com.family.api.model.Family;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ShoppingItemRepository extends JpaRepository<ShoppingItem, Integer> {
    List<ShoppingItem> findByFamily(Family family);
}
