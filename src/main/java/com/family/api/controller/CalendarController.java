package com.family.api.controller;

import com.family.api.model.CalendarEvent;
import com.family.api.model.User;
import com.family.api.service.CalendarService;
import com.family.api.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/calendar")
public class CalendarController {

    @Autowired
    private CalendarService calendarService;

    @Autowired
    private UserService userService;

    @GetMapping
    public ResponseEntity<List<CalendarEvent>> getEvents(@AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.getUserByEmail(userDetails.getUsername());
        return ResponseEntity.ok(calendarService.getFamilyEvents(user.getFamily()));
    }

    @PostMapping
    public ResponseEntity<CalendarEvent> addEvent(@RequestBody CalendarEvent event, @AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.getUserByEmail(userDetails.getUsername());
        event.setFamily(user.getFamily());
        event.setCreatedBy(user);
        return ResponseEntity.ok(calendarService.saveEvent(event));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEvent(@PathVariable Integer id) {
        calendarService.deleteEvent(id);
        return ResponseEntity.noContent().build();
    }
}
