package com.family.api.service;

import com.family.api.model.ShoppingItem;
import com.family.api.model.Family;
import com.family.api.repository.ShoppingItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ShoppingService {

    @Autowired
    private ShoppingItemRepository shoppingItemRepository;

    public List<ShoppingItem> getFamilyShoppingList(Family family) {
        return shoppingItemRepository.findByFamily(family);
    }

    public ShoppingItem saveItem(ShoppingItem item) {
        return shoppingItemRepository.save(item);
    }

    public void deleteItem(Integer itemId) {
        shoppingItemRepository.deleteById(itemId);
    }

    public ShoppingItem toggleBought(Integer itemId) {
        ShoppingItem item = shoppingItemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));
        item.setBought(!item.isBought());
        return shoppingItemRepository.save(item);
    }
}
