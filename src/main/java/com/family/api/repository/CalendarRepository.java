package com.family.api.repository;

import com.family.api.model.CalendarEvent;
import com.family.api.model.Family;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CalendarRepository extends JpaRepository<CalendarEvent, Integer> {
    List<CalendarEvent> findByFamily(Family family);
}
