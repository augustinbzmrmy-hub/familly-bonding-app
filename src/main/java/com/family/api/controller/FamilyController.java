package com.family.api.controller;

import com.family.api.model.Family;
import com.family.api.service.FamilyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/families")
@CrossOrigin(origins = "*")
public class FamilyController {

    @Autowired
    private FamilyService familyService;

    @PostMapping("/create")
    public ResponseEntity<?> createFamily(@RequestBody Map<String, Object> request) {
        try {
            String familyName = (String) request.get("familyName");
            Integer userId = (Integer) request.get("userId");
            if (familyName == null || userId == null) {
                return new ResponseEntity<>(Map.of("error", "familyName and userId are required"), HttpStatus.BAD_REQUEST);
            }
            Family newFamily = familyService.createFamily(familyName, userId);
            return new ResponseEntity<>(newFamily, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/{familyId}/join")
    public ResponseEntity<?> joinFamily(@PathVariable Integer familyId, @RequestBody Map<String, Integer> request) {
        try {
            Integer userId = request.get("userId");
            if (userId == null) {
                 return new ResponseEntity<>(Map.of("error", "userId is required"), HttpStatus.BAD_REQUEST);
            }
            Family family = familyService.joinFamily(familyId, userId);
            return new ResponseEntity<>(family, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping
    public ResponseEntity<List<Family>> getAllFamilies() {
        return new ResponseEntity<>(familyService.getAllFamilies(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getFamilyById(@PathVariable Integer id) {
        try {
            Family family = familyService.getFamilyById(id);
            return new ResponseEntity<>(family, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.NOT_FOUND);
        }
    }
}
