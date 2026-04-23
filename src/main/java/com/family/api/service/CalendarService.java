package com.family.api.service;

import com.family.api.model.CalendarEvent;
import com.family.api.model.Family;
import com.family.api.repository.CalendarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CalendarService {

    @Autowired
    private CalendarRepository calendarRepository;

    public List<CalendarEvent> getFamilyEvents(Family family) {
        return calendarRepository.findByFamily(family);
    }

    public CalendarEvent saveEvent(CalendarEvent event) {
        return calendarRepository.save(event);
    }

    public void deleteEvent(Integer eventId) {
        calendarRepository.deleteById(eventId);
    }
}
