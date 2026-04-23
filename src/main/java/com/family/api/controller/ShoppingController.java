package com.family.api.controller;

import com.family.api.model.ShoppingItem;
import com.family.api.model.User;
import com.family.api.service.ShoppingService;
import com.family.api.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/shopping")
public class ShoppingController {

    @Autowired
    private ShoppingService shoppingService;

    @Autowired
    private UserService userService;

    @GetMapping
    public ResponseEntity<List<ShoppingItem>> getShoppingList(@AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.getUserByEmail(userDetails.getUsername());
        return ResponseEntity.ok(shoppingService.getFamilyShoppingList(user.getFamily()));
    }

    @PostMapping
    public ResponseEntity<ShoppingItem> addItem(@RequestBody ShoppingItem item, @AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.getUserByEmail(userDetails.getUsername());
        item.setFamily(user.getFamily());
        item.setAddedBy(user);
        return ResponseEntity.ok(shoppingService.saveItem(item));
    }

    @PatchMapping("/{id}/toggle")
    public ResponseEntity<ShoppingItem> toggleItem(@PathVariable Integer id) {
        return ResponseEntity.ok(shoppingService.toggleBought(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteItem(@PathVariable Integer id) {
        shoppingService.deleteItem(id);
        return ResponseEntity.noContent().build();
    }
}
