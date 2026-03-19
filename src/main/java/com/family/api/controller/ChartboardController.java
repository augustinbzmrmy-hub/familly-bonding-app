package com.family.api.controller;

import com.family.api.model.ChartboardPost;
import com.family.api.model.Comment;
import com.family.api.service.ChartboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/posts")
@CrossOrigin(origins = "*")
public class ChartboardController {

    @Autowired
    private ChartboardService chartboardService;

    @PostMapping
    public ResponseEntity<?> createPost(@RequestBody Map<String, Object> request) {
        try {
            Integer userId = (Integer) request.get("userId");
            String content = (String) request.get("content");
            if (userId == null || content == null) {
                return new ResponseEntity<>(Map.of("error", "userId and content are required"), HttpStatus.BAD_REQUEST);
            }
            ChartboardPost post = chartboardService.createPost(userId, content);
            return new ResponseEntity<>(post, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/family/{familyId}")
    public ResponseEntity<List<ChartboardPost>> getFamilyPosts(@PathVariable Integer familyId) {
        return new ResponseEntity<>(chartboardService.getFamilyPosts(familyId), HttpStatus.OK);
    }

    @GetMapping("/family/{familyId}/search")
    public ResponseEntity<List<ChartboardPost>> searchPosts(@PathVariable Integer familyId, @RequestParam String keyword) {
        return new ResponseEntity<>(chartboardService.searchPosts(familyId, keyword), HttpStatus.OK);
    }

    @DeleteMapping("/{postId}")
    public ResponseEntity<?> deletePost(@PathVariable Integer postId, @RequestParam Integer userId) {
        try {
            chartboardService.deletePost(postId, userId);
            return new ResponseEntity<>(Map.of("message", "Post deleted successfully"), HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/{postId}/comments")
    public ResponseEntity<?> addComment(@PathVariable Integer postId, @RequestBody Map<String, Object> request) {
        try {
            Integer userId = (Integer) request.get("userId");
            String content = (String) request.get("content");
            if (userId == null || content == null) {
                return new ResponseEntity<>(Map.of("error", "userId and content are required"), HttpStatus.BAD_REQUEST);
            }
            Comment comment = chartboardService.addComment(postId, userId, content);
            return new ResponseEntity<>(comment, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }
}
