package com.family.api.controller;

import com.family.api.model.Question;
import com.family.api.model.Answer;
import com.family.api.service.EducationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/education")
@CrossOrigin(origins = "*")
public class EducationController {

    @Autowired
    private EducationService educationService;

    @PostMapping("/questions")
    public ResponseEntity<?> askQuestion(@RequestBody Map<String, Object> request) {
        try {
            Integer userId = (Integer) request.get("userId");
            String content = (String) request.get("content");
            if (userId == null || content == null) {
                return new ResponseEntity<>(Map.of("error", "userId and content are required"), HttpStatus.BAD_REQUEST);
            }
            Question question = educationService.askQuestion(userId, content);
            return new ResponseEntity<>(question, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/questions")
    public ResponseEntity<List<Question>> getAllQuestions() {
        return new ResponseEntity<>(educationService.getAllQuestions(), HttpStatus.OK);
    }

    @PostMapping("/questions/{questionId}/answers")
    public ResponseEntity<?> answerQuestion(@PathVariable Integer questionId, @RequestBody Map<String, Object> request) {
        try {
            Integer userId = (Integer) request.get("userId");
            String content = (String) request.get("content");
            if (userId == null || content == null) {
                return new ResponseEntity<>(Map.of("error", "userId and content are required"), HttpStatus.BAD_REQUEST);
            }
            Answer answer = educationService.answerQuestion(questionId, userId, content);
            return new ResponseEntity<>(answer, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/questions/{questionId}")
    public ResponseEntity<?> deleteQuestion(@PathVariable Integer questionId, @RequestParam Integer userId) {
        try {
            educationService.deleteQuestion(questionId, userId);
            return new ResponseEntity<>(Map.of("message", "Question deleted successfully"), HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(Map.of("error", e.getMessage()), HttpStatus.BAD_REQUEST);
        }
    }
}
