package com.family.api.controller;

import com.family.api.dto.CreateFamilyRequest;
import com.family.api.dto.UserIdRequest;
import com.family.api.model.Family;
import com.family.api.service.FamilyService;
import jakarta.validation.Valid;
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
    public ResponseEntity<Family> createFamily(@Valid @RequestBody CreateFamilyRequest request) {
        Family newFamily = familyService.createFamily(request.familyName(), request.userId());
        return new ResponseEntity<>(newFamily, HttpStatus.CREATED);
    }

    @PostMapping("/{familyId}/join")
    public ResponseEntity<Family> joinFamily(@PathVariable Integer familyId, @Valid @RequestBody UserIdRequest request) {
        Family family = familyService.joinFamily(familyId, request.userId());
        return new ResponseEntity<>(family, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<Family>> getAllFamilies() {
        return new ResponseEntity<>(familyService.getAllFamilies(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Family> getFamilyById(@PathVariable Integer id) {
        Family family = familyService.getFamilyById(id);
        return new ResponseEntity<>(family, HttpStatus.OK);
    }

    @GetMapping("/{id}/summary")
    public ResponseEntity<Map<String, Object>> getFamilySummary(@PathVariable Integer id) {
        return new ResponseEntity<>(familyService.getFamilySummary(id), HttpStatus.OK);
    }
}
