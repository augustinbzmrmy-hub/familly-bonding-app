package com.family.api.repository;

import com.family.api.model.ChartboardPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChartboardPostRepository extends JpaRepository<ChartboardPost, Integer> {
    
    @Query("SELECT p FROM ChartboardPost p WHERE p.user.family.familyId = :familyId ORDER BY p.createdAt DESC")
    List<ChartboardPost> findByFamilyIdOrderByCreatedAtDesc(@Param("familyId") Integer familyId);
}
